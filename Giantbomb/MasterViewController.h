//
//  MasterViewController.h
//  Giantbomb
//
//  Created by Cionnat Breathnach on 28/03/2014.
//  Copyright (c) 2014 Cionnat Breathnach. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController <UISearchBarDelegate, UITableViewDelegate>

@property IBOutlet UISearchBar *mySearchBar;
@property NSMutableDictionary *detailedGameInfo;
@property (strong, nonatomic) DetailViewController *detailViewController;

@end
