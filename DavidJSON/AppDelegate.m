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
#import "SampleModel.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    DavidJSON *json = [[DavidJSON alloc] init];
    NSDictionary *dataWeWant = [self _dataWeWant];
    
    
    // Some sample code to retrieve some JSON...
    
    //    NSURL *url = [NSURL URLWithString:@"https://api.github.com/users/hipsterhatton/repos"];
    NSURL *url = [NSURL URLWithString:@"http://8tracks.com/users/14/mixes.json"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setValue:@"API key goes here"    forHTTPHeaderField:@"X-Api-Key"];
    [request setValue:@"3"      forHTTPHeaderField:@"X-Api-Version"];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setResponseSerializer:[AFJSONResponseSerializer new]];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //        NSLog(@"Response: %@", responseObject);
        //        NSLog(@"Array: %@", [[responseObject objectForKey:@"mix_set"] objectForKey:@"mixes"][0]);
        
        //        [json getData:responseObject[0] :dataWeWant];
        //        [json getArrayOfData:responseObject[0] :@"owner/id"];
        
        //        SampleModel *test = (SampleModel *)[json getObject
        //                                            :responseObject[0]      // Raw JSON
        //                                            :dataWeWant             // Dictionary of Data we want
        //                                            :[SampleModel class]];  // Class of NSObject
        
        
        [json getArrayOfObjects
         :responseObject            // Raw JSON
         :@"mix_set/mixes"          // Path to Array of JSON Data
         :dataWeWant                // Dictionary of Data we want
         :[SampleModel class]];     // Class of NSObject
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
    }];
    
    [operation start];
    
}

- (NSDictionary *)_dataWeWant
{
    return @{
             
             //     @"example_name"       : @"path / to / the / data" --- each "/" represents another level in the JSON
             
             @"user_id"            : @"id",
             @"login_name"         : @"name",
             @"avatar_image"       : @"likes_count"
             
             };
}

@end
