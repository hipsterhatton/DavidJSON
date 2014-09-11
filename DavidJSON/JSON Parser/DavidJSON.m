//
//  DavidJSON.m
//  DavidJSON
//
//  Created by Stephen Hatton on 11/09/2014.
//  Copyright (c) 2014 Stephen Hatton. All rights reserved.
//

#import "DavidJSON.h"

#define print_raw_json          false
#define print_completed_json    false
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
    if (![self _checkData:rawJSON :dataWeWant])
        return NULL;
    
    NSArray *listOfKeys = [dataWeWant allKeys];
    NSMutableDictionary *dictionaryOfDataFound = [[NSMutableDictionary alloc] init];
    
    for (NSString *key in listOfKeys) {
        
        NSLog(@"Key: %@", key);
        
        NSArray *pathToJSONData = [self _getPath:[dataWeWant valueForKey:key]];
        
        NSLog(@"Getting Past Here!");
        
        NSLog(@"Path To Data: %@", pathToJSONData);
        NSLog(@" "); NSLog(@" "); NSLog(@" ");
        
        // Make a copy of the raw JSON ... we will be "chopping" away at the raw JSON until we have reached the value we want!
        NSDictionary *rawJSONCopy = rawJSON;
        
        for (int a = 0; a < [pathToJSONData count]; a++) {
            
            if ([rawJSONCopy valueForKey:pathToJSONData[a]] != NULL) {
                rawJSONCopy = [rawJSONCopy objectForKey:pathToJSONData[a]];
                
                if (a == [pathToJSONData count]-1)
                    [dictionaryOfDataFound setObject:rawJSONCopy forKey:key];
            } else {
                NSLog(@"Parse Error: \"%@\" has an incorrect path!", key);
                return NULL;
            }
        }
    }
    
    NSLog(@"Parsing Complete! :D");
    NSLog(@" ");
    
    if (print_completed_json)
        NSLog(@"Parsed (Dictionary) JSON: %@", dictionaryOfDataFound);
    
    return dictionaryOfDataFound;
}

- (NSArray *)getArrayOfData:(NSDictionary *)rawJSON :(NSString *)pathToArrayWeWant
{
    if (![self _checkData:rawJSON :@{ @"path_to_array" : pathToArrayWeWant }])
        return NULL;
    
    NSArray *pathToJSONData = [self _getPath:pathToArrayWeWant];
    NSArray *arrayOfDataFound;
    
    NSLog(@"Path To Data: %@", pathToJSONData);
    NSLog(@" "); NSLog(@" "); NSLog(@" ");
    
    for (int a = 0; a < [pathToJSONData count]; a++) {
        
        if (a == [pathToJSONData count]-1)
            arrayOfDataFound = [rawJSON objectForKey:pathToJSONData[a]];
        
        if ([rawJSON valueForKey:pathToJSONData[a]] != NULL) {
            rawJSON = [rawJSON objectForKey:pathToJSONData[a]];
        } else {
            NSLog(@"Parse Error: \"%@\" has an incorrect path!", pathToArrayWeWant);
            return NULL;
        }
    }
    
    NSLog(@"Parsing Complete! :D");
    NSLog(@" ");
    
    if (print_completed_json)
        NSLog(@"Parsed (Array) JSON: %@", arrayOfDataFound);
    
    return arrayOfDataFound;
}



#pragma Get NSObject From JSON

- (NSObject *)getObject:(NSDictionary *)rawJSON :(NSDictionary *)dataWeWant :(id)objectToCreate
{
    dataWeWant = [self getData:rawJSON :dataWeWant];
    return [[[objectToCreate class] alloc] initWithDictionary:dataWeWant];
}

- (NSArray *)getArrayOfObjects:(NSDictionary *)rawJSON :(NSString *)pathToArrayWeWant :(NSDictionary *)dataWeWant :(id)objectToCreate
{
    NSArray *arrayOfJSONData = [self getArrayOfData:rawJSON :pathToArrayWeWant];
    NSMutableArray *arrayOfObjects = [[NSMutableArray alloc] init];
    
    if ([arrayOfJSONData isKindOfClass:[NSArray class]]) {
        NSLog(@"It's an array!");
        
        for (int a = 0; a < [arrayOfJSONData count]; a++)
            [arrayOfObjects addObject: [self getObject:arrayOfJSONData[a] :dataWeWant :objectToCreate]];
        
        NSLog(@"Array of Objects: %@", arrayOfObjects);
        
    } else {
        NSLog(@"It's NOT an array!");
        return NULL;
    }
    
    return arrayOfObjects;
}



#pragma Private Functions

- (BOOL)_checkData:(NSDictionary *)rawJSON :(NSDictionary *)dataWeWant
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

- (NSArray *)_getPath:(NSString *)pathToData
{
    NSLog(@"Path to data: %@", pathToData);
    if ([pathToData rangeOfString:string_splitter].location == NSNotFound) {
        return @[ pathToData ]; // Root level
    } else {
        return [pathToData componentsSeparatedByString:string_splitter]; // Multiple levels
    }
}

@end


