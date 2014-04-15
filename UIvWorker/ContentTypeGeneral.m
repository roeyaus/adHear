//
//  ContentTypeGeneral.m
//  UIvWorker
//
//  Created by user on 2/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ContentTypeGeneral.h"


@implementation ContentTypeGeneral 

@synthesize Id;
@synthesize Title;
@synthesize Description;
@synthesize Picture;
@synthesize Cast;

+(id<IContentType>)GenerateByID:(NSString *)Id
{
      ContentTypeGeneral* ctg = [[ContentTypeGeneral alloc] init];
    
    if ([Id isEqualToString:@"1"])
    {
    ctg.Id = Id;
    ctg.Title = @"המרוץ למיליון עונה 2";
        ctg.Description = @"מירוץ למיליון היא הגרסה הישראלית לתוכנית המציאות האמריקאית The Amazing Race. התוכנית שודרה לראשונה בערוץ 2 על ידי הזכיינית רשת החל מה-5 בפברואר 2009. בתוכנית מתחרים עשרה או אחד עשר זוגות בעלי מאפיינים שונים, על פרס בסך מיליון שקלים חדשים.";
    ctg.Picture = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AmazingRaceFullTeams" ofType:@"jpg"]]; 
    ctg.Cast = @"";  
    }
    
    if ([Id isEqualToString:@"2"])
    {
        ctg.Id = Id;
        ctg.Title = @"הפרסומת של בזוקה ג'ו";
        ctg.Description = @"בזוקה ג'ו - המסטיק הכי מגניב שיש. פרסומת מבית באומן בר ריבנאי.";
        ctg.Picture = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Bazooka-Joe-Logo" ofType:@"jpg"]]; 
        ctg.Cast = @"";  
    }
    if ([Id isEqualToString:@"3"])
    {
        ctg.Id = Id;
        ctg.Title = @"מאסטר שף ילדים ";
        ctg.Description = @"מאסטר שף ילדים - תוכנית הבישול הכי מרגשת בטללוויזיה";
        ctg.Picture = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"MasterChefKids-Logo" ofType:@"png"]]; 
        ctg.Cast = @"משתתפים - אייל שני, חיים כהן, יונתן רושפלד ומיכל אנסקי";  
    }
    return (id<IContentType>)ctg;
    
    
}

+(NSString*) GetCellIdentifier
{
    return @"GeneralCell";
}

@end
