//
//  EventTypeViewFactory.m
//  UIvWorker
//
//  Created by Lion User on 22/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EventTypeViewFactory.h"
#import "EventTypesAll.h"
#import "ContentTypesAll.h"
#import "IContentType.h"
#import "DataManager.h"
#import "User.h"

@implementation EventTypeViewFactory

-(void)initWithNibName:(NSString*)Name
{
    customCellsNib = [UINib nibWithNibName:@"ContentTypeCells" bundle:nil];
    dataManager = [[DataManager alloc] init];
    
}

-(UITableViewCell*)GenerateCellForEventType:(EventTypeBase*)EventType CellNumber:(int)Number
{
    
    NSString* className = NSStringFromClass([[EventType.aContentTypes objectAtIndex:Number] class]);
    SEL s = NSSelectorFromString([NSString stringWithFormat:@"generateCellFor%@:", className] );
    return [self performSelector:s withObject: [EventType.aContentTypes objectAtIndex:Number]];
   
}

-(CGFloat)GetHeightOfCellForEventType:(EventTypeBase*)EventType WithCell:(UITableViewCell*)Cell andNumber:(int)Number
{
    CGSize size;
    
    if ([EventType isKindOfClass:[EventTypeBiography class]] && Number == 0)
    {
        ContentTypeBiography* ctb = [((EventTypeBiography*)EventType).aContentTypes objectAtIndex:0];
        size = [ctb.Biography sizeWithFont:[UIFont systemFontOfSize:17.0f] constrainedToSize:CGSizeMake(303, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
 
    }
    else if ([EventType isKindOfClass:[EventTypeSong class]] && Number == 0)
    {
        ContentTypeSong* cts = [((EventTypeSong*)EventType).aContentTypes objectAtIndex:0];
        size = [cts.Lyrics sizeWithFont:[UIFont systemFontOfSize:17.0f] constrainedToSize:CGSizeMake(303, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
        
    }
    else if ([EventType isKindOfClass:[EventTypeIntroduction class]] && Number == 0)
    {
        ContentTypeGeneral* cts = [((EventTypeIntroduction*)EventType).aContentTypes objectAtIndex:0];
        size = [cts.Description sizeWithFont:[UIFont systemFontOfSize:17.0f] constrainedToSize:CGSizeMake(303, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
    }
    
    if (size.height > 36)
    {
        return Cell.bounds.size.height - 36 + size.height;
    }
    return Cell.bounds.size.height;
}

-(int)GetNumberOfCellsForEventType:(EventTypeBase*)EventType
{
    return EventType.aContentTypes.count;
}

-(NSString*) GetCellIdentifierForEventType:(EventTypeBase*)EventType CellNumber:(int)Number
{
    id <IContentType> Ic = (id <IContentType>)[EventType.aContentTypes objectAtIndex:Number];
    return [[Ic class]  GetCellIdentifier];
}


- (UITableViewCell*) generateCellForContentTypeGeneral:(ContentTypeGeneral <IContentType>*)general
{
    UITableViewCell* cell = nil;
    NSArray *topLevelItems = [customCellsNib instantiateWithOwner:nil options:nil];
    NSUInteger idx = [topLevelItems indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop)
                      {
                          UITableViewCell *cell = (UITableViewCell *)obj;
                          return [cell isKindOfClass:[UITableViewCell class]] && [cell.reuseIdentifier isEqualToString:[ContentTypeGeneral GetCellIdentifier]];
                      } ];
    assert(idx != NSNotFound);
    cell = [topLevelItems objectAtIndex:idx];
    
    
    UILabel* lblTitle = (UILabel*)[cell viewWithTag:1];
    //lbl1 = [[UILabel alloc] init];
    lblTitle.text = general.Title;
    UIImageView* img = (UIImageView*)[cell viewWithTag:2];
    img.image = general.Picture;
    UILabel* lblDescription = (UILabel*)[cell viewWithTag:3];
    [lblDescription sizeToFit];
    //lbl2 = [[UILabel alloc] init];
    lblDescription.text = general.Description;
    UILabel* lblcast = (UILabel*)[cell viewWithTag:4];
    lblcast.text = general.Cast;
    return cell;
}


- (UITableViewCell*) generateCellForContentTypeCoupon:(ContentTypeCoupon<IContentType>*)coupon
{
    UITableViewCell* cell = nil;
    
    NSArray *topLevelItems = [customCellsNib instantiateWithOwner:nil options:nil];
    NSUInteger idx = [topLevelItems indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop)
                      {
                          UITableViewCell *cell = (UITableViewCell *)obj;
                          return [cell isKindOfClass:[UITableViewCell class]] && [cell.reuseIdentifier isEqualToString:[ContentTypeCoupon GetCellIdentifier]];
                      } ];
    assert(idx != NSNotFound);
    cell = [topLevelItems objectAtIndex:idx];
    
    
    UILabel* lblTitle = (UILabel*)[cell viewWithTag:2];
    //lbl1 = [[UILabel alloc] init];
    lblTitle.text = coupon.Description;
    UIImageView* img = (UIImageView*)[cell viewWithTag:1];
    img.image = coupon.Picture;
    
    lblTitle.font = [UIFont fontWithName:@"STHeitiSC-Light" size:15];
    
    
    return cell;
    
}

- (UITableViewCell*) generateCellForContentTypeFriend:(ContentTypeFriend<IContentType>*)friends
{
    UITableViewCell *cell = nil;
    NSArray *topLevelItems = [customCellsNib instantiateWithOwner:nil options:nil];
    NSUInteger idx = [topLevelItems indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop)
                      {
                          UITableViewCell *cell = (UITableViewCell *)obj;
                          return [cell isKindOfClass:[UITableViewCell class]] && [cell.reuseIdentifier isEqualToString:[ContentTypeFriend GetCellIdentifier]];
                      } ];
    assert(idx != NSNotFound);
    cell = [topLevelItems objectAtIndex:idx];
    int xCoordinate = 30;
    int yCoordinate = 35;
    NSMutableArray* aWatching = [dataManager GetAllWatchingUserIdByContentId:@"1"];
    
    for (int i = 0; i< aWatching.count; i++)
    {
        User* u = [aWatching objectAtIndex:i];
        CGRect ivrect = CGRectMake(xCoordinate, yCoordinate, 40, 40);
        CGRect lblrect = CGRectMake(xCoordinate, yCoordinate + 40, 40, 10);
        
        UILabel* lbl = [[UILabel alloc] initWithFrame:lblrect];
        UIImageView* iv = [[UIImageView alloc] initWithFrame:ivrect];
        iv.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DefaultFacebookProfile" ofType: @"jpg"]];
        [lbl setBackgroundColor:[UIColor clearColor]];
        lbl.textAlignment = UITextAlignmentCenter;
        lbl.font = [UIFont fontWithName:@"STHeitiSC-Light" size:9];
        lbl.textColor = [UIColor whiteColor];
        lbl.numberOfLines = 2;
        lbl.text = u.FullName;
        lbl.lineBreakMode = UILineBreakModeWordWrap;
        
        iv.tag = 10 + i;
        [cell addSubview:iv];
        [cell addSubview:lbl];
        xCoordinate += 47;
    }
    
    
    UILabel* lblTitle = (UILabel*)[cell viewWithTag:1];
    
    //lbl1 = [[UILabel alloc] init];
    lblTitle.text = [NSString stringWithFormat:@"%d מחבריך צופים כרגע ", aWatching.count ];
    
    
    [self performSelectorInBackground:@selector(LoadUsersWatchingImagesAsync:) withObject:cell];
    
    return cell;
}

-(void)LoadUsersWatchingImagesAsync:(UITableViewCell*)cell
{
     NSMutableArray* usersWatchingArray = [dataManager GetAllWatchingUserIdByContentId:@"1"];
    for (int i = 0; i< usersWatchingArray.count; i++)
    {
        User* user = (User*)[usersWatchingArray objectAtIndex:i];
        
        UIImage* img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:user.PictureURL]]];
        //labels begin from index 1
        UIImageView* iv = (UIImageView*)[cell viewWithTag:(10 + i)];
        //UIImageView* iv = (UIImageView*)[[(UILabel*)[[cell subviews] objectAtIndex:i+1] subviews] objectAtIndex:0];
        iv.image = img;
    }
}


- (UITableViewCell*) generateCellForContentTypeVideo:(ContentTypeVideo<IContentType>*)video
{
    
    UITableViewCell *cell = nil;
    NSArray *topLevelItems = [customCellsNib instantiateWithOwner:nil options:nil];
    NSUInteger idx = [topLevelItems indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop)
                      {
                          UITableViewCell *cell = (UITableViewCell *)obj;
                          return [cell isKindOfClass:[UITableViewCell class]] && [cell.reuseIdentifier isEqualToString:[ContentTypeVideo GetCellIdentifier]];
                      } ];
    assert(idx != NSNotFound);
    cell = [topLevelItems objectAtIndex:idx];
    //query the datamanager for number of videos.
    
    
    UILabel* lblTitle = (UILabel*)[cell viewWithTag:1];
    //lbl1 = [[UILabel alloc] init];
    //lblTitle.text = [NSString stringWithFormat:@"ישנם %d קליפים הקשורים לתוכן     ", aVideos.count];
    UIImageView* img = (UIImageView*)[cell viewWithTag:2];
    img.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:video.URLToThumbnail]]]; //[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"videoIcon-2" ofType: @"png"]];
    
    lblTitle.font = [UIFont fontWithName:@"STHeitiSC-Light" size:15];
    lblTitle.text = video.Name;
    return cell;
}

- (UITableViewCell*) generateCellForContentTypeBiography:(ContentTypeBiography<IContentType>*)bio
{
    
    UITableViewCell *cell = nil;
    NSArray *topLevelItems = [customCellsNib instantiateWithOwner:nil options:nil];
    NSUInteger idx = [topLevelItems indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop)
                      {
                          UITableViewCell *cell = (UITableViewCell *)obj;
                          return [cell isKindOfClass:[UITableViewCell class]] && [cell.reuseIdentifier isEqualToString:[ContentTypeBiography GetCellIdentifier]];
                      } ];
    assert(idx != NSNotFound);
    cell = [topLevelItems objectAtIndex:idx];
    
    //lbl1 = [[UILabel alloc] init];
    UIImageView* ivPic = (UIImageView*)[cell viewWithTag:4];
    UILabel* lblSummary = (UILabel*)[cell viewWithTag:2];
    UILabel* lblFullName = (UILabel*)[cell viewWithTag:1];
    UILabel* lblBio = (UILabel*)[cell viewWithTag:3];
    

    ivPic.image = bio.Picture; //[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DefaultFacebookProfile" ofType: @"jpg"]];
    //Async load user picture.
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
//    
//    dispatch_async(queue, ^{
//        UIImage *image = bio.Picture;        
//        dispatch_sync(dispatch_get_main_queue(), ^{
//            ivPic.image = image;
//        });
//    });
    
   
    lblFullName.text = bio.FullName;
    lblSummary.text = bio.Summary;
    lblBio.text = bio.Biography;
    [lblBio sizeToFit];
    return cell;
}

- (UITableViewCell*) generateCellForContentTypeSong:(ContentTypeSong<IContentType>*)song
{
    
    UITableViewCell *cell = nil;
    NSArray *topLevelItems = [customCellsNib instantiateWithOwner:nil options:nil];
    NSUInteger idx = [topLevelItems indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop)
                      {
                          UITableViewCell *cell = (UITableViewCell *)obj;
                          return [cell isKindOfClass:[UITableViewCell class]] && [cell.reuseIdentifier isEqualToString:[ContentTypeSong GetCellIdentifier]];
                      } ];
    assert(idx != NSNotFound);
    cell = [topLevelItems objectAtIndex:idx];
    
    //lbl1 = [[UILabel alloc] init];
    UIImageView* ivArtistPic = (UIImageView*)[cell viewWithTag:1];
    UIImageView* ivAlbum = (UIImageView*)[cell viewWithTag:5];
    UILabel* lblAlbumAndSongName = (UILabel*)[cell viewWithTag:2];
    UILabel* lblLyrics = (UILabel*)[cell viewWithTag:3];
    UILabel* lblDownloadLink = (UILabel*)[cell viewWithTag:4];
    //Async load user picture.
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    
    dispatch_async(queue, ^{
            
        dispatch_sync(dispatch_get_main_queue(), ^{
            ivArtistPic.image = song.ArtistPicture;
            ivAlbum.image = song.AlbumPicture;
        });
    });
    
    ivArtistPic.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DefaultFacebookProfile" ofType: @"jpg"]];
    ivAlbum.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DefaultFacebookProfile" ofType: @"jpg"]];
    lblAlbumAndSongName.text = [NSString stringWithFormat:@"%@ \n %@", song.SongName, song.AlbumName];
    lblLyrics.text = song.Lyrics;
    
    [lblLyrics sizeToFit];
    return cell;
}



@end
