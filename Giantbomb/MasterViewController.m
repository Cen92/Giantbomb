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
}

-(void)makeJSONRequest:(NSString *)searchTerm{ //put this into thread so phone stays reponsive //maybe not needed using AFNetworking
    NSMutableString *searchURL = [NSMutableString stringWithString:@"http://www.giantbomb.com/api/search/?api_key=db83ace1ea2b58b18cbf4ac7696df4a5508120c6&format=json&query="];
    [searchURL appendString:searchTerm];
    NSString *queryItems = @"&field_list=name,id,image&resources=game";
    [searchURL appendString:queryItems];
  
    NSURL *url = [NSURL URLWithString:searchURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]init];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

        dispatch_async(dispatch_get_main_queue(), ^{
            
            [spinner startAnimating];
        });
    //AFNetworking asynchronous url request
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self->_objects = [responseObject objectForKey:@"results"];
        
        
        [self.tableView reloadData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [spinner stopAnimating];
        });
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
 
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Request Failed: %@, %@", error, error.userInfo);
        
    }];
        [operation start];
    });
    
    
}

-(void) makeDetailJSONReq:(NSString *)uniqueID{
    NSMutableString *searchURL = [NSMutableString stringWithString:@"http://www.giantbomb.com/api/game/"];
    [searchURL appendString:uniqueID];
    NSString *queryItems = @"/?api_key=db83ace1ea2b58b18cbf4ac7696df4a5508120c6&format=json";
    [searchURL appendString:queryItems];
    
    NSURL *url = [NSURL URLWithString:searchURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //AFNetworking asynchronous url request
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.detailedGameInfo = [responseObject objectForKey:@"results"];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self.detailViewController setGameInfo:self.detailedGameInfo];


    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Request Failed: %@, %@", error, error.userInfo);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSDictionary *tempDictionary= [self->_objects objectAtIndex:indexPath.row];
    cell.textLabel.text = [tempDictionary objectForKey:@"name"];
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    return cell;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)mySearchBar{
    [_mySearchBar resignFirstResponder];
    NSString *textToSearch = mySearchBar.text;
    NSString *newString = [textToSearch stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    [self makeJSONRequest:newString];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        NSDictionary *object = _objects[indexPath.row];
        NSString *gameID = [object objectForKey:@"id"];
        [self makeDetailJSONReq:[NSString stringWithFormat:@"%@",gameID]];
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
