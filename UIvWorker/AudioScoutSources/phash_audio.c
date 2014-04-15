/*
    Audio Scout - audio content indexing software
    Copyright (C) 2010  D. Grant Starkweather & Evan Klinger
    
    Audio Scout is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

    D. Grant Starkweather - dstarkweather@phash.org
    Evan Klinger          - eklinger@phash.org
*/

#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <dirent.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include "fft.h"
#include "phash_audio.h"

#ifdef unix
#include <stdio.h>
#endif

#define FILENAME_MAX 20


static
void sort_barkdiffs(double *barkdiffs,uint8_t *bits,unsigned int length){

    int i,j;
    for (i=0;i<length;i++){
	int min = i;
	for (j=i+1;j<length;j++){
	    if (barkdiffs[j] < barkdiffs[min])
		min = j;
	}
	if (i != min){
	    double tmpd = barkdiffs[i];

	    barkdiffs[i] = barkdiffs[min];
	    barkdiffs[min] = tmpd;

	    uint8_t tmpb = bits[i];
	    bits[i] = bits[min];
	    bits[min] = tmpb;
	}
    }
}


static const unsigned int nfilts = 33;


static const double barkwidth = 1.06;

static const double barkfreqs[33] = { 50.0, 100.0,  150.0, 200.0, 250.0,\
                                          300.0, 350.0, 400.0, 450.0, 470.0, 510.0, 570.0,\
                                          635.0, 700.0, 770.0, 840.0, 920.0, 1000.0,\
                                          1085.0, 1170.0, 1270.0, 1370.0, 1485.0,\
                                          1600.0, 1725.0, 1850.0, 2000.0, 2150.0,\
				      2325.0, 2500.0, 2700.0, 2900.0, 3000.0 }; 



PHASH_EXPORT
int audiohash(float *buf, uint32_t **phash, double ***coeffs, uint8_t ***bit_toggles,\
              unsigned int *nbcoeffs, unsigned int *nbframes, double *minB, double *maxB,\
              unsigned int buflen, unsigned int P, int sr, AudioHashStInfo *hash_st){

  unsigned int i, j;

  if (buf == NULL || phash == NULL || nbframes == NULL || hash_st == NULL) return -1;

  if (sr != hash_st->sr){ 
    const double maxfreq = 3000;

    unsigned int ideal_fl = (unsigned int)(0.4*sr);
    int msbpos = 0;
    while (ideal_fl >> msbpos++);
    unsigned int upper_fl = 1 << (msbpos-1);
    unsigned int lower_fl = 1 << (msbpos-2);
    hash_st->framelength = (upper_fl - lower_fl) < (ideal_fl - lower_fl) ? upper_fl :lower_fl;

    hash_st->sr = sr;
    hash_st->window = (double*)malloc((hash_st->framelength)*sizeof(double));
    if (hash_st->window == NULL) return -1;

    for (i = 0;i<hash_st->framelength;i++){
      /*hamming window*/
      hash_st->window[i] = 0.54 - 0.46*cos(2*PI*i/(hash_st->framelength-1));
    }

    unsigned int nfft_half = hash_st->framelength/2;
    double *binbarks = (double*)malloc(nfft_half*sizeof(double));
    if (binbarks == NULL) return -1;

    double temp;
    for (i=0; i < nfft_half;i++){
      temp = i*maxfreq/nfft_half/600.0;
      binbarks[i] = 6*log(temp + sqrt(temp*temp + 1.0));
    }
    
    double lof, hif;
    hash_st->wts = (double**)malloc(nfilts*sizeof(double*));
    for (i=0;i < nfilts;i++){
      hash_st->wts[i] = (double*)malloc(nfft_half*sizeof(double));
      /*calculate wts for each filter */
      double f_bark_mid = barkfreqs[i]/600.0;
      f_bark_mid = 6*log(f_bark_mid + sqrt(f_bark_mid*f_bark_mid + 1.0));
      for (j=0;j < nfft_half ;j++){
	double barkdiff = binbarks[j] - f_bark_mid;
	lof = -2.5*(barkdiff/barkwidth - 0.5);
	hif = barkdiff/barkwidth + 0.5;
	double m = lof < hif ? lof : hif;
	m = (m < 0) ? m : 0; 
	m = pow(10,m);
	hash_st->wts[i][j] = m;
      }
    } 
    free(binbarks);
  }

  unsigned int N = buflen; 
  unsigned int framelength = hash_st->framelength;
  unsigned int nfft = framelength;
  unsigned int nfft_half = (hash_st->framelength)/2;
  unsigned int start = 0;
  unsigned int end = start + hash_st->framelength - 1;
  unsigned int overlap = 31*(hash_st->framelength)/32;
  unsigned int advance = hash_st->framelength - overlap;

  *nbframes = floor(N/advance) - floor(framelength/advance) + 1;
  
  double *window = hash_st->window;
  double **wts = hash_st->wts;

  double *frame = (double*)malloc((framelength)*sizeof(double));
  Complex *pF = (Complex*)malloc(sizeof(Complex)*(nfft));
  double *magnF = (double*)malloc((nfft_half)*sizeof(double));


  if (coeffs && nbcoeffs) *nbcoeffs = nfilts;

  double *barkdiffs = (double*)malloc((nfilts-1)*sizeof(double));
  uint8_t *tmptoggles = (uint8_t*)malloc((nfilts-1)*sizeof(uint8_t));
  if (P > 0 && bit_toggles){
    *bit_toggles = (uint8_t**)malloc((*nbframes)*sizeof(uint8_t*));
    for (j=0;j < *nbframes;j++){
      (*bit_toggles)[j] = (uint8_t*)malloc(P*sizeof(uint8_t));
    }
  }

  double **barkcoeffs = (double**)malloc((*nbframes)*sizeof(double*));
  for (i=0;i < *nbframes;i++){
    barkcoeffs[i] = (double*)malloc((nfilts)*sizeof(double));
  }
  if (coeffs && nbcoeffs) *coeffs = barkcoeffs;

   int index = 0;
   double max_bark = 0.0;
   double min_bark = 100000000.0;
   double maxF = 0.0;
   while (end < N){
       maxF = 0.0;
       for (i = 0;i<framelength;i++){
           float t1 = buf[start + i];
           double t2 = window[i];
           double t3 = frame[i];
           //NSLog("%f %f %f", t1, t2, t3);
	   frame[i] = window[i]*buf[start+i];
       }
       if (fft(frame, framelength, pF) < 0){
	   return -1;
       }
       for (i=0; i < nfft_half;i++){
           magnF[i] = complex_abs(pF[i]);
	   if (magnF[i] > maxF){
	       maxF = magnF[i];
	   }
       }

       for (i=0;i<nfilts;i++){

	   barkcoeffs[index][i] = 0.0;
	   for (j=0;j < nfft_half;j++){
	       barkcoeffs[index][i] += wts[i][j]*magnF[j];
	   }
           if (barkcoeffs[index][i] > max_bark){
	       max_bark = barkcoeffs[index][i];
	   }
	   if (barkcoeffs[index][i] < min_bark){
	       min_bark = barkcoeffs[index][i];
	   }
       }
       index += 1;
       start += advance;
       end   += advance;
   }

   if (minB) *minB = min_bark;
   if (maxB) *maxB = max_bark;

    uint32_t *hash = (uint32_t*)malloc((*nbframes)*sizeof(uint32_t));
    *phash = hash;
    for (i=0;i < *nbframes;i++){
	uint32_t hashtmp = 0;
	unsigned int m;

	for (m=0;m < nfilts-1;m++){
           double H;

	   if (i > 0){
	       H = barkcoeffs[i][m] - barkcoeffs[i][m+1] - \
                                      (barkcoeffs[i-1][m] - barkcoeffs[i-1][m+1]);
	   } else {
	       H = barkcoeffs[i][m] - barkcoeffs[i][m+1];
	   }
	   barkdiffs[m] = H;
	   tmptoggles[m] = m;

	   hashtmp <<= 1;
	   if (H > 0){
	       hashtmp |= 0x00000001;
	   }
	}

        if (bit_toggles){
	    sort_barkdiffs(barkdiffs,tmptoggles,nfilts-1);
	    for (m=0;m<P;m++){
		(*bit_toggles)[i][m] = tmptoggles[m];
	    }
	}
	hash[i] = hashtmp;
   }

    if (coeffs == NULL){
	for (i=0;i < *nbframes; i++){
	    free(barkcoeffs[i]);
	}
	free(barkcoeffs);
    }

    free(tmptoggles);
    free(barkdiffs);
    free(frame);
    free(magnF);
    free(pF);

    return 0;
}

