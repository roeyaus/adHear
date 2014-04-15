//
//  Coupon.m
//  UIvWorker
//
//  Created by Roey L on 1/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ContentTypeCoupon.h"

@implementation ContentTypeCoupon
@synthesize Id;
@synthesize Title;
@synthesize Description;
@synthesize Price;
@synthesize IssueDate;
@synthesize ExpirationDate;
@synthesize Picture;
@synthesize PercentOff;
@synthesize NumberOfBuyers;
@synthesize ActualCoupon;

+(id<IContentType>) GenerateByID:(NSString*) Id
{
    //placeholders for actual ID values.
    if ([Id isEqualToString:@"1"])
    {
        ContentTypeCoupon* coupon = [[ContentTypeCoupon alloc] init];
        coupon.Id = Id;
        coupon.Title = @"מארח כריות נוגט - חינם!";
        coupon.Description = @"כריות נוגט, דגני הבוקר הטעימים בישראל. בואו לחנות עם קופון זה וקבלו מארז של שתי אריזות - חינם!";
        coupon.Price = 0;
        coupon.PercentOff = 100;
        NSDateFormatter *ndf = [[NSDateFormatter alloc] init]; 
        ndf.timeStyle = NSDateFormatterNoStyle; 
        ndf.dateFormat = @"dd/MM/yyyy HH:mm"; 
        coupon.IssueDate = [ndf dateFromString:@"01/04/2012 22:00"]; 
        coupon.ExpirationDate = [ndf dateFromString:@"11/04/2012 22:00"];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Cariot-Coupon" ofType:@"jpg"]; 
        coupon.Picture = [UIImage imageWithContentsOfFile:path]; 
        coupon.NumberOfBuyers = 0;
        NSString *path2 = [[NSBundle mainBundle] pathForResource:@"coupon-cariot" ofType:@"jpg"]; 
        coupon.ActualCoupon = [UIImage imageWithContentsOfFile:path2]; 
        return coupon;
    }
    
    if ([Id isEqualToString:@"2"])
    {
        ContentTypeCoupon* coupon = [[ContentTypeCoupon alloc] init];
        coupon.Id = Id;
        coupon.Title = @"מארז בזוקה ג'ו - חינם!";
        coupon.Description = @"כנסו לחנויות המשתתפות, וקבלו מארז בזוקה ג'ו - חינם!";
        coupon.Price = 30.50;
        coupon.PercentOff = 100;
        NSDateFormatter *mmddccyy = [[NSDateFormatter alloc] init]; 
        mmddccyy.timeStyle = NSDateFormatterNoStyle; 
        mmddccyy.dateFormat = @"dd/MM/yyyy HH:mm"; 
        coupon.IssueDate = [mmddccyy dateFromString:@"01/04/2012 22:00"]; 
        coupon.ExpirationDate = [mmddccyy dateFromString:@"20/04/2012 22:00"];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"babushka_bazuka_over" ofType:@"jpg"]; 
        coupon.Picture = [UIImage imageWithContentsOfFile:path]; 
        coupon.NumberOfBuyers = 0;
        NSString *path2 = [[NSBundle mainBundle] pathForResource:@"coupon-bazooka" ofType:@"jpg"]; 
        coupon.ActualCoupon = [UIImage imageWithContentsOfFile:path2]; 
        return coupon;
    }
    
    if ([Id isEqualToString:@"3"])
    {
        ContentTypeCoupon* coupon = [[ContentTypeCoupon alloc] init];
        coupon.Id = @"Mccann - Opticana.mp3";
        coupon.Title = @"Buy 1 Pair of glasses, get one pair free! ";
        coupon.Description = @"Buy 1 Pair of glasses, get one pair free! ";
        coupon.Price = 299.99;
        coupon.PercentOff = 100;
        NSDateFormatter *mmddccyy = [[NSDateFormatter alloc] init]; 
        mmddccyy.timeStyle = NSDateFormatterNoStyle; 
        mmddccyy.dateFormat = @"dd/MM/yyyy HH:mm"; 
        coupon.IssueDate = [mmddccyy dateFromString:@"01/04/2012 22:00"]; 
        coupon.ExpirationDate = [mmddccyy dateFromString:@"20/04/2012 22:00"];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"opticana" ofType:@"jpg"]; 
        
        coupon.NumberOfBuyers = 0;
        coupon.Picture = [UIImage imageWithContentsOfFile:path]; 
        return coupon;
    }
    return nil;
}

+(NSString*) GetCellIdentifier
{
    return @"CouponCell";
}
@end
