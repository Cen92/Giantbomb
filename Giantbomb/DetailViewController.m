//
//  DetailViewController.m
//  Giantbomb
//
//  Created by Cionnat Breathnach on 28/03/2014.
//  Copyright (c) 2014 Cionnat Breathnach. All rights reserved.
//

#import "DetailViewController.h"
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
    // Update the user interface for the detail item.

//    if (self.detailItem) {
//        self.detailDescriptionLabel.text = [self.detailItem description];
//    }

    if(self.gameInfo) {
        for (UIView *subView in self.view.subviews)
        {
            if (subView.tag == 99)
            {
                [subView removeFromSuperview];
            }
        }
        
        self.navigationItem.title = [self.gameInfo objectForKey:@"name"];
        self.aboutGame.text = [self.gameInfo objectForKey:@"deck"];
        self.gameDescription.text = [self stringByStrippingHTML:[self.gameInfo objectForKey:@"description"]];
        //NSLog(@"%@", self.gameDescription.text);
    }
   else{
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
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
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

@end
