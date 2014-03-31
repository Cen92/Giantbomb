//
//  DetailViewController.h
//  Giantbomb
//
//  Created by Cionnat Breathnach on 28/03/2014.
//  Copyright (c) 2014 Cionnat Breathnach. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) NSDictionary *gameInfo;
@property (weak, nonatomic) IBOutlet UILabel *aboutGame;
@property (strong, nonatomic) IBOutlet UILabel *gameDescription;
@property (strong, nonatomic) IBOutlet UIImage *gameImage;


@end
