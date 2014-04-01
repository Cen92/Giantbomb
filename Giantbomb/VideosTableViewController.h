//
//  VideosTableViewController.h
//  Giantbomb
//
//  Created by Cionnat Breathnach on 01/04/2014.
//  Copyright (c) 2014 Cionnat Breathnach. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VideoPlayerViewController;


@interface VideosTableViewController : UITableViewController

@property (strong, nonatomic) NSMutableDictionary *videoList;
@property (strong, nonatomic) NSMutableArray *videoArray;
@property (strong, nonatomic) NSString *url;


@property (strong, nonatomic) VideoPlayerViewController *videoPlayerViewController;

@end
