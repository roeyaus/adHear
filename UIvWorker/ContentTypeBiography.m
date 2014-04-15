//
//  ContentTypeBiography.m
//  UIvWorker
//
//  Created by Lion User on 24/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ContentTypeBiography.h"

@implementation ContentTypeBiography

@synthesize Picture, FullName, Summary, Biography;

+(id<IContentType>)GenerateByID:(NSString *)Id
{
    ContentTypeBiography* ctb = [[ContentTypeBiography alloc] init];
    
    if ([Id isEqualToString:@"1"])
    {
        
        ctb.FullName = @"אורן ואלון";
        ctb.Summary = @"זוג אחים";
        ctb.Biography = @"אורן בן 47, עו""ד   אלון בן 38, מנכ""ל זוג אחים שגדלו ב""בית פולני"" והגשימו את חלום האימא הפולניה – האחד עו""ד והשני מנכ""ל, אבל בדרך האחד שכח את השני. אורן, עו""ד מיושב, ""מורעל"" תכניות ריאליטי שמצהיר על כך בגלוי, עיניו מנצנצות כשמדבר על הז'אנר. הגיע בראש ובראשונה בכדי להגשים את הפנטזיה ואם ""על הדרך"" יצטרך לעשות את זה עם אחיו, אז המטרה מקדשת את האמצעים... להבדיל מאורן, אלון הגיע למירוץ בכדי לנסות לזכות באהבת אחיו, קבלתו כהומוסקסואל ואיחוד התא המשפחתי.מה יהיה איתם במירוץ? - מוחצנות, נפיצות ומיידיות של שני האינדיבידואליסטים האלו, מובילים למריבות בלתי פוסקות, הומור עצמי ,ציניות ו""סגירת"" חשבונות - כשמסתכלים מהצד לא מאמינים שזה אמיתי ולא פרק של סיינפלד. \n";
        ctb.Picture = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"orenAlon" ofType:@"jpg"]]; 
    }
    if ([Id isEqualToString:@"2"])
    {
        
        ctb.FullName = @"תאילנד";
        ctb.Summary = @"";
        ctb.Biography = @"ממלכת תאילנד (תאית: ราชอาณาจักรไทย פּרַאתֶ'ט תַ'אִי) היא מדינה בדרום מזרח אסיה. תאילנד ידועה גם בשמה הקודם, סיאם (היה זה שמה הרשמי עד 23 ביוני 1939 וגם מ-1945 עד 11 במאי 1949). תושבי תאילנד נקראים ""תאים"", והם מכנים את מדינתם ""פראטת תאי"" (פראטת=מדינה, תאי=חופשיים, כלומר מדינת האנשים החופשיים). תאילנד גובלת עם לאוס מצפון-מזרח, קמבודיה מדרום-מזרח, מלזיה מדרום ומיאנמר מצפון-מערב.\n";
        ctb.Picture = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Bangkok-City" ofType:@"jpg"]]; 
    }
    
   
    return (id<IContentType>)ctb;
    
    
}

+(NSString*) GetCellIdentifier
{
    return @"BiographyCell";
}

@end
