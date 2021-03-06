//
//  DetailViewController.h
//  Giantbomb
//
//  Created by Cionnat Breathnach on 28/03/2014.
//  Copyright (c) 2014 Cionnat Breathnach. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VideosTableViewController;

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) NSDictionary *gameInfo;
@property (strong, nonatomic) IBOutlet UIScrollView *scroller;
@property (strong, nonatomic) NSDictionary *videoDictionary;
@property (strong, nonatomic) VideosTableViewController *videoTableViewController;

@end
