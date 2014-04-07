//
//  VideosTableViewController.m
//  Giantbomb
//
//  Created by Cionnat Breathnach on 01/04/2014.
//  Copyright (c) 2014 Cionnat Breathnach. All rights reserved.
//

#import "VideosTableViewController.h"
#import "AFNetworking.h"
#import "VideoPlayerViewController.h"

@interface VideosTableViewController ()

@end

@implementation VideosTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)setVideoArray:(NSMutableArray *)videoArray{
    if (_videoArray != videoArray) {
        _videoArray = videoArray;
        NSLog(@"%@", _videoArray);
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    } else {
        // iOS 6
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
    
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_videoArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"videoCell" forIndexPath:indexPath];
    
    NSDictionary *tempDictionary= [self.videoArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [tempDictionary objectForKey:@"name"];
    return cell;
    
}

-(void)makeVideoJSONReq:(NSString *)videoID{
    NSMutableString *searchURL = [NSMutableString stringWithString:@"http://www.giantbomb.com/api/video/"];
    [searchURL appendString:videoID];
    NSString *queryItems = @"/?api_key=db83ace1ea2b58b18cbf4ac7696df4a5508120c6&format=json";
    [searchURL appendString:queryItems];
    
    NSURL *url = [NSURL URLWithString:searchURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //AFNetworking asynchronous url request
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.videoList = [responseObject objectForKey:@"results"];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//        _url = [self.videoList objectForKey:@"high_url"];
        self.videoURL = [self.videoList objectForKey:@"high_url"];
        [self playMovie];
       // [self performSegueWithIdentifier:@"PlayVideo" sender:self];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Request Failed: %@, %@", error, error.userInfo);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
    }];
    
    [operation start];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        NSDictionary *object = _videoArray[indexPath.row];
        NSString *videoID = [object objectForKey:@"id"];
        [self makeVideoJSONReq:[NSString stringWithFormat:@"%@",videoID]];
        
    }
   // return indexPath;
}

-(void)playMovie{
    
    NSURL *stringURL = [[NSURL alloc]initWithString:self.videoURL];
    _moviePlayer =  [[MPMoviePlayerController alloc]
                     initWithContentURL:stringURL];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:_moviePlayer];
    
    _moviePlayer.controlStyle = MPMovieControlStyleFullscreen;
    _moviePlayer.shouldAutoplay = YES;
    _moviePlayer.view.transform = CGAffineTransformConcat(_moviePlayer.view.transform, CGAffineTransformMakeRotation(M_PI_2));

    [self.view addSubview:_moviePlayer.view];
    [_moviePlayer setFullscreen:YES animated:YES];
//    _moviePlayer = [[MPMoviePlayerController alloc]initWithContentURL:stringURL];
//    _moviePlayer.controlStyle = MPMovieControlStyleFullscreen;
//    _moviePlayer.view.transform = CGAffineTransformConcat(_moviePlayer.view.transform, CGAffineTransformMakeRotation(M_PI_2));
//    [_moviePlayer.view setFrame: self.view.bounds];
//    //[self.view addSubview: _moviePlayer.view];
//    [_moviePlayer play];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self.view.subviews
//                                             selector:@selector(doneButtonClick:)
//                                                 name:MPMoviePlayerWillExitFullscreenNotification
//                                               object:nil];

}
- (void) moviePlayBackDidFinish:(NSNotification*)notification {
    MPMoviePlayerController *player = [notification object];
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:MPMoviePlayerPlaybackDidFinishNotification
     object:player];
    
    if ([player
         respondsToSelector:@selector(setFullscreen:animated:)])
    {
        [player.view removeFromSuperview];
    }
}


@end
