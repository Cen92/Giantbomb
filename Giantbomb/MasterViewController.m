//
//  MasterViewController.m
//  Giantbomb
//
//  Created by Cionnat Breathnach on 28/03/2014.
//  Copyright (c) 2014 Cionnat Breathnach. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "AFNetworking.h"

@interface MasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation MasterViewController

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(400, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _mySearchBar.delegate = self;
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    self.view.backgroundColor = [UIColor colorWithRed:(51/255.0) green:(51/255.0) blue:(51/255.0) alpha:1];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]}];
    
}
/**
 Method used for making the initial networking call to get names of games
 */

-(void)makeJSONRequest:(NSString *)searchTerm{
    NSMutableString *searchURL = [NSMutableString stringWithString:@"http://www.giantbomb.com/api/search/?api_key=db83ace1ea2b58b18cbf4ac7696df4a5508120c6&format=json&query="];
    [searchURL appendString:searchTerm];
    NSString *queryItems = @"&field_list=name,id,image&resources=game";
    [searchURL appendString:queryItems]; //concatenating strings to build URL
    NSURL *url = [NSURL URLWithString:searchURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIActivityIndicatorView  *av = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    av.color = [UIColor redColor];
    av.frame = CGRectMake(round((self.view.frame.size.width - 70) / 2), round((self.view.frame.size.height) / 2), 70, 70);
    av.tag  = 1;
    [self.view addSubview:av];
    [av startAnimating]; //spin large white activity indicator and add to subview
    
    //AFNetworking asynchronous url request
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self->_objects = [responseObject objectForKey:@"results"]; //parsing response object
        UIActivityIndicatorView *tmpimg = (UIActivityIndicatorView *)[self.view viewWithTag:1];
        [tmpimg removeFromSuperview]; //remove spinner results have been returned
        
        NSSortDescriptor *sortDescriptor;
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name"
                                                     ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        NSArray *sortedArray;
        sortedArray = [_objects sortedArrayUsingDescriptors:sortDescriptors];
        _objects = [sortedArray copy]; //sorting array alphabetically
        [self.tableView reloadData];
        if(![self->_objects count]){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No games found"
                                                                message:@"Are you sure it is spelled correctly?"
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show]; //throw up an alert if no games have been found
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving List"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show]; //display an alert for an error in human readable format (No internet connection)
        
    }];
    [operation start]; //start AFNetworkingReq
    
    
}
/**
 Method used for making the 2nd networking call to get details of game
 */

-(void) makeDetailJSONReq:(NSString *)uniqueID{
    NSMutableString *searchURL = [NSMutableString stringWithString:@"http://www.giantbomb.com/api/game/"];
    [searchURL appendString:uniqueID];
    NSString *queryItems = @"/?api_key=db83ace1ea2b58b18cbf4ac7696df4a5508120c6&format=json";
    [searchURL appendString:queryItems];
    
    NSURL *url = [NSURL URLWithString:searchURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //AFNetworking asynchronous url request
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.detailedGameInfo = [responseObject objectForKey:@"results"];
        [self.detailViewController setGameInfo:self.detailedGameInfo]; //set dictionary in detail vc to results from networking call. Hide current tablevc from there
        
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving List"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        
        
    }];
    
    [operation start];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell setBackgroundColor:[UIColor colorWithRed:(51/255.0) green:(51/255.0) blue:(51/255.0) alpha:1]]; //set cells to GB grey
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSDictionary *tempDictionary= [self->_objects objectAtIndex:indexPath.row];
    cell.textLabel.text = [tempDictionary objectForKey:@"name"];
    [cell setBackgroundColor:[UIColor colorWithRed:(51/255.0) green:(51/255.0) blue:(51/255.0) alpha:1]];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    return cell;
}
/**
 Search bar delegate method
 **/

-(void)searchBarSearchButtonClicked:(UISearchBar *)mySearchBar{
    [_mySearchBar resignFirstResponder];
    NSString *textToSearch = mySearchBar.text;
    NSString *newString = [textToSearch stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    [self makeJSONRequest:newString];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        UIActivityIndicatorView *cellSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        cellSpinner.frame = CGRectMake(0, 0, 24, 24);
        cellSpinner.tag = 2;
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryView = cellSpinner;
        [cellSpinner startAnimating];
        NSDictionary *object = _objects[indexPath.row];
        NSString *gameID = [object objectForKey:@"id"];
        [self makeDetailJSONReq:[NSString stringWithFormat:@"%@",gameID]];//get game details
        UIActivityIndicatorView *tmpimg = (UIActivityIndicatorView *)[cellSpinner viewWithTag:2];
        [tmpimg removeFromSuperview];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDictionary *object = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

@end
