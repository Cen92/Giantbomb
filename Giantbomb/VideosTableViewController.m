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
        // Update the view.
        //NSLog(@"%@", _videoArray);
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
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
    NSLog(@"%@", tempDictionary);
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
        _url = [self.videoList objectForKey:@"high_url"];
        [self performSegueWithIdentifier:@"PlayVideo" sender:self];

        
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    NSLog(@"prepareForSegue: %@", segue.identifier);
    if([segue.identifier isEqualToString:@"PlayVideo"])
    {   VideoPlayerViewController *controller = (VideoPlayerViewController *)segue.destinationViewController;
        NSLog(@"%@", self.url);
        [controller setVideoURL:self.url];
        
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
