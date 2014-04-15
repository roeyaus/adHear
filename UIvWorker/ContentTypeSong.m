//
//  ContentTypeSong.m
//  UIvWorker
//
//  Created by Lion User on 30/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ContentTypeSong.h"

@implementation ContentTypeSong

@synthesize AlbumName, AlbumPicture, ArtistPicture, Lyrics, SongName, PerformerName;

+(id<IContentType>)GenerateByID:(NSString *)Id
{
    ContentTypeSong* cts = [[ContentTypeSong alloc] init];
    cts.AlbumName = @"Album 1";
    cts.SongName = @"song 1";
    cts.PerformerName = @"artist 1";
    cts.Lyrics =  @"רוצי שמוליק \n    אריאל זילבר \n    מילים ולחן: שמוליק צ'יזיק \n     קיים ביצוע נוסף לשיר זה \n    אקורדים  \n    כשאת קמה בבוקר ומתלבשת \n    והשמש לך שולחת דרישת שלום, \n    את שותה כוס קפה ונזכרת \n    איך בלילה הוא הופיע בחלום. \n   במהרה במדרגות את יורדת \n    מספיקה לתפוס ת'אוטו האחרון, \n    מגיעה למשרד ונזכרת \n    איך בלילה הוא הופיע בחלום. \n    רוצי, שמוליק קורא לך \n    ושולח אלף נשיקות. \n    רוצי, שמוליק מחכה לך \n    כמה זמן עוד תתני לו לחכות. \n    כך עובר כל היום, את לא יודעת \n    אם זו סתם מציאות, או דמיון. \n    את שותה עוד כוס קפה ונזכרת \n    איך בלילה הוא הופיע בחלום. \n    דוין דוין דוין... \n    ובערב כשאת חוזרת הביתה \n    מעיפה מבט חטוף מן החלון \n    הוא עומד שם בפינה ומחכה לך \n    כן, הלילה לא צריך יותר לחלום. \n    רוצי, שמוליק קורא לך \n    ושולח אלף נשיקות. \n    רוצי, שמוליק מחכה לך \n    כמה זמן עוד תתני לו לחכות.\n";
  
    cts.ArtistPicture = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DefaultFacebookProfile" ofType: @"jpg"]];
    return cts;
}

+(NSString*) GetCellIdentifier
{
    return @"SongCell";
}

@end
