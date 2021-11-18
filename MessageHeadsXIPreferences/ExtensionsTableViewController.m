//
//  ExtensionsTableViewController.m
//  MessageHeadsXIPreferences
//
//  Created by Will Smillie on 4/10/19.
//

#import "ExtensionsTableViewController.h"

@interface ExtensionsTableViewController (){
    NSMutableArray *availableItems;
}

@end

@implementation ExtensionsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Available Extensions";
    self.navigationItem.prompt = @"Tap an Extension to View it in Cydia";
    
    UIBarButtonItem *close = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleDone target:self action:@selector(close:)];
    [self.navigationItem setRightBarButtonItem:close];

    
    [self refresh];
}

-(void)refresh{
    availableItems = [[NSMutableArray alloc] init];
    [self sendRequest:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return availableItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
//    if (cell == nil) {
      UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
//    }

    NSDictionary *item = availableItems[indexPath.row];
    cell.textLabel.text = item[@"title"];//[[ALApplicationList sharedApplicationList] valueForKeyPath:@"displayName" forDisplayIdentifier:item[@"app"]];
    cell.detailTextLabel.text = item[@"repo"];
    cell.imageView.image = [[ALApplicationList sharedApplicationList] iconOfSize:ALApplicationIconSizeSmall forDisplayIdentifier:item[@"app"]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *item = availableItems[indexPath.row];
    if ([self schemeAvailable:@"sileo://"]) {
        NSString *urlString = [NSString stringWithFormat:@"sileo://package/%@", availableItems[indexPath.row][@"extension"]];
        NSString* encodedUrl = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:encodedUrl] options:@{} completionHandler:nil];
    }else{
        NSString *urlString = [NSString stringWithFormat:@"cydia://package/%@", availableItems[indexPath.row][@"extension"]];
        NSString* encodedUrl = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:encodedUrl] options:@{} completionHandler:nil];
    }
    
}

- (BOOL)schemeAvailable:(NSString *)scheme {
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:scheme];
    return [application canOpenURL:URL];
}





- (void)sendRequest:(id)sender
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfig.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    NSURLSession* session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];
    
    NSURL* URL = [NSURL URLWithString:@"https://c1d3r.com/chatheadsextensions.json"];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"GET";
    
    request.HTTPBody = [NSStringFromQueryParameters(@{}) dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });

        if (error == nil) {
            availableItems = [NSJSONSerialization JSONObjectWithData:data options:nil error:nil];
            NSLog(@"Got items: %@", availableItems);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
        else {
            NSLog(@"URL Session Task Failed: %@", [error localizedDescription]);
        }
    }];
    [task resume];
    [session finishTasksAndInvalidate];
}




static NSString* NSStringFromQueryParameters(NSDictionary* queryParameters)
{
    NSMutableArray* parts = [NSMutableArray array];
    [queryParameters enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        NSString *part = [NSString stringWithFormat: @"%@=%@",
                          [key stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding],
                          [value stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]
                          ];
        [parts addObject:part];
    }];
    return [parts componentsJoinedByString: @"&"];
}

static NSURL* NSURLByAppendingQueryParameters(NSURL* URL, NSDictionary* queryParameters)
{
    NSString* URLString = [NSString stringWithFormat:@"%@?%@",
                           [URL absoluteString],
                           NSStringFromQueryParameters(queryParameters)
                           ];
    return [NSURL URLWithString:URLString];
}


-(void)close:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
