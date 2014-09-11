//
//  DavidJSON.m
//  DavidJSON
//
//  Created by Stephen Hatton on 11/09/2014.
//  Copyright (c) 2014 Stephen Hatton. All rights reserved.
//

#import "DavidJSON.h"

#define print_raw_json          true
#define print_completed_json    true
#define string_splitter         @"/"

@implementation DavidJSON

// Put simply: this library is designed to: take raw JSON + a dictionary (containing paths to pieces of data we need inside the raw JSON)
//      eg: @{ PostCode : Customer Details > Address > Postcode }
// and returns the same dictionary, with all the paths replaced with the JSON data they point to
//      eg: @{ PostCode : AB1 2CD }
// Why? Because dictionaries are easy to work with :D and most of the time: we need large amounts of data from JSON, this
// makes it easier to get those large amounts + work with them :D



#pragma Get Data From JSON

- (NSDictionary *)getData:(NSDictionary *)rawJSON :(NSDictionary *)dataWeWant
{
    if (![self _checks:rawJSON :dataWeWant])
        return NULL;
    
    NSArray *listOfKeys = [dataWeWant allKeys];
    NSMutableDictionary *dataWeHaveFound = [[NSMutableDictionary alloc] init];
    
    for (NSString *key in listOfKeys) {
        
        NSLog(@"Key: %@", key);
        
        NSArray *pathToJSONData;
        
        // Check whether the path we need to take to get to the data we want, is multiple levels deep (indicated, by string splitters)
        //      eg: "Level One / Level Two / Level Three / Data!"
        // -OR-
        // Or the data is on the root level
        //      eg: "Data!"
        if ([[dataWeWant valueForKey:key] rangeOfString:string_splitter].location == NSNotFound) {
            pathToJSONData = @[ [dataWeWant valueForKey:key] ]; // Root level
        } else {
            pathToJSONData = [[dataWeWant valueForKey:key] componentsSeparatedByString:string_splitter]; // Multiple levels
        }
        
        NSLog(@"Path To Data: %@", pathToJSONData);
        NSLog(@" "); NSLog(@" "); NSLog(@" ");
        
        // Make a copy of the raw JSON ... we will be "chopping" away at the raw JSON until we have reached the value we want!
        NSDictionary *rawJSONCopy = rawJSON;
        
        for (int a = 0; a < [pathToJSONData count]; a++) {
            
            if ([rawJSONCopy valueForKey:pathToJSONData[a]] != NULL) {
                rawJSONCopy = [rawJSONCopy objectForKey:pathToJSONData[a]];
                
                if (a == [pathToJSONData count]-1)
                    [dataWeHaveFound setObject:rawJSONCopy forKey:key];
            } else {
                NSLog(@"Parse Error: \"%@\" has an incorrect path!", key);
                return NULL;
            }
        }
    }
    
    NSLog(@"Parsing Complete! :D");
    NSLog(@" ");
    
    if (print_completed_json)
        NSLog(@"Parsed JSON: %@", dataWeHaveFound);
    
    return dataWeHaveFound;
}











- (NSDictionary *)getArrayOfData:(NSDictionary *)rawJSON
{
    return @{};
}



#pragma Get NSObject From JSON

- (NSDictionary *)getObject:(NSDictionary *)rawJSON
{
    return @{};
}

- (NSDictionary *)getArrayOfObjects:(NSDictionary *)rawJSON
{
    return @{};
}




#pragma Basic Data Checks

- (BOOL)_checks:(NSDictionary *)rawJSON :(NSDictionary *)dataWeWant
{
    if (!rawJSON || [[rawJSON allKeys] count] == 0) {
        NSLog(@"Raw JSON was NULL!");
        return false;
    }
    
    if (!dataWeWant || [[dataWeWant allKeys] count] == 0) {
        NSLog(@"Data We Want was NULL!");
        return false;
    }
    
    if (print_raw_json) {
        NSLog(@"Raw JSON: %@", rawJSON);
        NSLog(@" "); NSLog(@" "); NSLog(@" ");
    }
    
    return true;
}

@end
