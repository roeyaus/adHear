
#include <AudioToolbox/AudioToolbox.h>
#include "CAStreamBasicDescription.h"


extern "C" {

extern void NSLog(CFStringRef format, ...); 

float * GetPCMFromFile(char * filename, int lengthInSeconds, int sampleRate, int nChannels, int bitsPerChannel, int *bufLength) {
	CFURLRef audioFileURL = CFURLCreateFromFileSystemRepresentation(NULL,(const UInt8*)filename, strlen(filename), false);
	ExtAudioFileRef outExtAudioFile;
	int err = ExtAudioFileOpenURL(audioFileURL, &outExtAudioFile);
	if (err) {
		NSLog(CFSTR("open failed")); 
	}
    *bufLength = 0;
	
  

	CAStreamBasicDescription clientFormat;
	clientFormat.mSampleRate = sampleRate;
	clientFormat.mFormatID = kAudioFormatLinearPCM;
	clientFormat.mChannelsPerFrame = nChannels;
	clientFormat.mBitsPerChannel = bitsPerChannel;
	clientFormat.mBytesPerPacket = clientFormat.mBytesPerFrame = 4 * clientFormat.mChannelsPerFrame;
	clientFormat.mFramesPerPacket = 1;
	clientFormat.mFormatFlags =  kAudioFormatFlagsNativeFloatPacked;// | kAudioFormatFlagIsNonInterleaved;

	int size = sizeof(clientFormat);
	err = ExtAudioFileSetProperty(outExtAudioFile, kExtAudioFileProperty_ClientDataFormat, size, &clientFormat);
	if (err) 
		NSLog(CFSTR("err on set format %d"), err);
	AudioBufferList fillBufList;
    fillBufList.mNumberBuffers = 1;
    UInt32 bufferByteSize = sampleRate * clientFormat.mBytesPerFrame * lengthInSeconds; // all audio
    float* srcBuffer = (float*)malloc(bufferByteSize);
    UInt32 numFrames = clientFormat.BytesToFrames(bufferByteSize); // (bufferByteSize / clientFormat.mBytesPerFrame);
    
    fillBufList.mBuffers[0].mNumberChannels = clientFormat.NumberChannels();
    fillBufList.mBuffers[0].mDataByteSize = bufferByteSize;
    fillBufList.mBuffers[0].mData = srcBuffer;
    err = ExtAudioFileRead(outExtAudioFile, &numFrames, &fillBufList);
	*bufLength = clientFormat.FramesToBytes(numFrames);
    return (float*)srcBuffer;
    
    
    /*
	int seconds_to_decode =  lengthInSeconds;
	int bytes_for_bigbuf = sizeof(float)*sampleRate*seconds_to_decode;
	float *bigBuf = (float*) malloc(bytes_for_bigbuf);
	if(bigBuf == NULL) {
		NSLog(CFSTR("Error mallocing bigbuf"));
        return bigBuf;
	}
    *bufLength = bytes_for_bigbuf;
	int totalFrames = 0;
	while (1) {
		AudioBufferList fillBufList;
		fillBufList.mNumberBuffers = 1;
		UInt32 bufferByteSize = sampleRate * 4 * nChannels; // 1s of audio
		char srcBuffer[bufferByteSize];
		UInt32 numFrames = clientFormat.BytesToFrames(bufferByteSize); // (bufferByteSize / clientFormat.mBytesPerFrame);

		fillBufList.mBuffers[0].mNumberChannels = clientFormat.NumberChannels();
		fillBufList.mBuffers[0].mDataByteSize = bufferByteSize;
		fillBufList.mBuffers[0].mData = srcBuffer;
		err = ExtAudioFileRead(outExtAudioFile, &numFrames, &fillBufList);	
		if (err) { 
			NSLog(CFSTR("err on read %d"), err);
			totalFrames = 0;
			break;
		}
		if (!numFrames)
			break;
		
		float mono_version[numFrames];
		float* float_buf = (float*) fillBufList.mBuffers[0].mData;
		for(int i=0;i<numFrames;i++) //redundant operation
			mono_version[i] = float_buf[i];//(float_buf[i*2] + float_buf[i*2 + 1]) / 2.0;
		
		int bytesLeftInBuffer = bytes_for_bigbuf - (totalFrames * sizeof(float));
		
		if (numFrames * sizeof(float) > bytesLeftInBuffer) {
			memcpy(bigBuf + totalFrames, mono_version, bytesLeftInBuffer);
			totalFrames = totalFrames + (bytesLeftInBuffer/4);
			break;
		} else {
			memcpy(bigBuf + totalFrames, mono_version, numFrames * sizeof(float));
			totalFrames = totalFrames + numFrames;
		}
	}

	return bigBuf;*/
}

//    bool getpeaks16(float* mins, float* maxs)
//    {
//        
//    }
//    
//    float* normalizeAudioSample(float* bufSample)
//    {
//        
//        (!getpeaks16(&mins, &maxs))
//        
//        float* table16 = NULL;
//        
//        table16 = (float*) malloc(131072);
//        
//		if (table16 == NULL) {
//            
//        }
//		make_table16();
//		ndata = amplify16();
//		VirtualFree(table16, 0, MEM_RELEASE);
//
//    }

}