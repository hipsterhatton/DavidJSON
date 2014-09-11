//
//  AppDelegate.m
//  DavidJSON
//
//  Created by Stephen Hatton on 11/09/2014.
//  Copyright (c) 2014 Stephen Hatton. All rights reserved.
//

#import "AppDelegate.h"
#import "DavidJSON.h"
#import "AFNetworking/AFNetworking.h" // This has been manually downloaded from GitHub and copied into the project ... only used for testing!

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    DavidJSON *json = [[DavidJSON alloc] init];
    NSDictionary *dataWeWant = [self _dataWeWant];
    
    
    // Some sample code to retrieve some JSON...
    
    NSURL *url = [NSURL URLWithString:@"https://api.github.com/users/hipsterhatton/repos"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setResponseSerializer:[AFJSONResponseSerializer new]];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [json getData:responseObject[0] :dataWeWant]; // Test the parser here!
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
    }];
    
    [operation start];
    
}

- (NSDictionary *)_dataWeWant
{
    return @{
             
             //     @"example_name"       : @"path / to / the / data" --- each "/" represents another level in the JSON
             
             @"id"                 : @"owner/id",
             @"login_name"         : @"owner/login",
             @"avatar_image"       : @"owner/avatar_url"
             
             };
}

@end