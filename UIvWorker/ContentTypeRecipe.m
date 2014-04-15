//
//  ContentTypeRecipe.m
//  UIvWorker
//
//  Created by Lion User on 19/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ContentTypeRecipe.h"

@implementation ContentTypeRecipe

@synthesize ID, Name, Description, Picture, PreparationSteps, Ingredients;

+(id<IContentType>) GenerateByID:(NSString*) Id
{
    ContentTypeRecipe* ctv = [[ContentTypeRecipe alloc] init];
    ctv.ID = Id;
    ctv.Name = @"ריזוטו פטריות";
    ctv.Description = @"מתכון לתבשיל אורז עשיר עם פטריות ובצלי שאלוט. מנה טעימה וארומטית";
    ctv.Ingredients = @"רכים: \n אורז עגול (ריזוטו) \n     5-6 בצלי שאלוט, קצוצים דק \n     שמן זית \n     פטריות מכמה סוגים, חתוכות גס \n     חצי כוס יין לבן \n     ציר עוף \n     מלח ופלפל \n     מעט חמאה \n     מעט שמנת מתוקה \n     גבינת פרמזן מגוררת";
    
    return ctv;
}

+(NSString*) GetCellIdentifier
{
    return @"RecipeCell";
}


@end
