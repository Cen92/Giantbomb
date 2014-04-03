//
//  VideoPlayerViewController.m
//  Giantbomb
//
//  Created by Cionnat Breathnach on 01/04/2014.
//  Copyright (c) 2014 Cionnat Breathnach. All rights reserved.
//

#import "VideoPlayerViewController.h"

@interface VideoPlayerViewController ()

@end

@implementation VideoPlayerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prefersStatusBarHidden];
    [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    
    NSURL *stringURL = [[NSURL alloc]initWithString:self.videoURL];
    _moviePlayer = [[MPMoviePlayerController alloc]initWithContentURL:stringURL];
    _moviePlayer.controlStyle = MPMovieControlStyleFullscreen;
    _moviePlayer.view.transform = CGAffineTransformConcat(_moviePlayer.view.transform, CGAffineTransformMakeRotation(M_PI_2));
    [_moviePlayer.view setFrame: self.view.bounds];
    [self.view addSubview: _moviePlayer.view];
    [_moviePlayer play];
   }

-(void) setVideoURL:(NSString *)videoURL{
    if(_videoURL != videoURL){
        _videoURL = videoURL;
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
