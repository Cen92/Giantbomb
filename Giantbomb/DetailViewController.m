//
//  DetailViewController.m
//  Giantbomb
//
//  Created by Cionnat Breathnach on 28/03/2014.
//  Copyright (c) 2014 Cionnat Breathnach. All rights reserved.
//
//video api call for game
//http://www.giantbomb.com/api/video/8367/?api_key=db83ace1ea2b58b18cbf4ac7696df4a5508120c6&format=json

#import "DetailViewController.h"
#import "VideosTableViewController.h"
#import "AFNetworking.h"
@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
}

- (void)setGameInfo:(NSDictionary *)newInfo
//-(void) setGameInfoArray:(NSMutableArray *)newInfo
{
    if (_gameInfo != newInfo) {
        _gameInfo = newInfo;
        // Update the view.
    }
    
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
    [self configureView];

}

-(NSString *) stringByStrippingHTML:(NSString *)htmlString {
    NSRange r;
    NSString *s = [htmlString copy];
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    //NSLog(@"%@", s);
    return s;
}
- (void)configureView
{
    if(self.gameInfo) {
        for (UIView *subView in self.view.subviews)
        {
            if (subView.tag == 99)
            {
                [subView removeFromSuperview]; //remove background image
            }
        }
        
        self.aboutGame.hidden = NO;
        self.gameDescription.hidden = NO;
      
        self.navigationItem.title = [self.gameInfo objectForKey:@"name"];
        self.navigationItem.rightBarButtonItem.enabled = YES;

        self.aboutGame.text = [self.gameInfo objectForKey:@"deck"];
        self.gameDescription.text = [self stringByStrippingHTML:[self.gameInfo objectForKey:@"description"]];
        NSDictionary *dict = [self.gameInfo objectForKey:@"image"];
        
        NSURL *imageURL = [NSURL URLWithString:[dict objectForKey:@"small_url"]];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        self.gameImage.image = [UIImage imageWithData:imageData];
        
        NSDictionary *videos = [self.gameInfo objectForKey:@"videos"];
        if(!videos){
            self.navigationItem.rightBarButtonItem.title = @"";
        }
    }
   else{
       self.aboutGame.hidden = YES;
       self.gameDescription.hidden = YES;
       self.navigationItem.rightBarButtonItem.enabled = NO;

       [self setBackgroundImage:@"background.png"];
   }
    
}

-(void) setBackgroundImage:(NSString *)imageName{
    UIImage *backgroundImage = [UIImage imageNamed:imageName];
    UIImageView *backgroundImageView=[[UIImageView alloc]initWithFrame:self.view.frame];
    backgroundImageView.image=backgroundImage;
    backgroundImageView.tag = 99;
    [self.view insertSubview:backgroundImageView atIndex:0];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [_scroller setScrollEnabled:YES];
    [_scroller setContentSize:CGSizeMake(703, 1200)];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    
    barButtonItem.title = NSLocalizedString(@"Search", @"Search");
   [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
     self.masterPopoverController = popoverController;
    [self configureView];
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}




-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
  
    //NSLog(@"prepareForSegue: %@", segue.identifier);
    if([segue.identifier isEqualToString:@"videoPopover"])
    {
        VideosTableViewController *controller = (VideosTableViewController *)segue.destinationViewController;
        [controller setVideoArray:[self.gameInfo objectForKey:@"videos"]];
    }
}

@end
