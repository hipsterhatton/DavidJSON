//
//  NSObject+DavidJSON.m
//  Cassette
//
//  Created by Stephen Hatton on 09/04/2015.
//  Copyright (c) 2015 Stephen Hatton. All rights reserved.
//

#import "NSObject+DavidJSON.h"

BOOL const PRINT_RAW_JSON =         NO;
BOOL const PRINT_COMPLETED_JSON =   NO;

static NSString * const kSTRING_SPLITTER = @"/";

@implementation NSObject (DavidJSON)



#pragma mark - Object Init/Update

+ (id)createViaJSON:(NSDictionary *)rawJSON :(NSDictionary *)dictionary
{
    NSObject *object = [self new];
    
    NSDictionary *d = [self _getData:rawJSON :dictionary];
    
    for (NSString *key in [d allKeys]) {
        if (d[key] != nil && d[key] != [NSNull null]) {
            [object setValue:d[key] forKey:key];
        }
    }

    return object;
}

- (void)updateViaJSON:(NSDictionary *)rawJSON :(NSDictionary *)dictionary
{
    NSDictionary *d = [[self class] _getData:rawJSON :dictionary];
    
    for (NSString *key in [d allKeys]) {
        if (d[key] != nil && d[key] != [NSNull null]) {
            [self setValue:d[key] forKey:key];
        }
    }
}

+ (id)getViaJSON:(NSDictionary *)rawJSON :(NSDictionary *)dictionary
{
    NSDictionary *d = [self _getData:rawJSON :dictionary];
    return d[[d allKeys][0]];
}



#pragma mark - Array Init/Update

+ (NSArray *)createArrayViaJSON:(NSDictionary *)rawJSON :(NSString *)pathToArrayWeWant
{
    if (![self _checkData:rawJSON :@{ @"path_to_array" : pathToArrayWeWant }]) {
        return NULL;
    }
    
    NSArray *pathToJSONData = [self _getPath:pathToArrayWeWant];
    NSMutableArray *arrayOfDataFound;
    
    for (int a = 0; a < [pathToJSONData count]; a++) {
        
        if (a == [pathToJSONData count]-1) {
            arrayOfDataFound = [rawJSON objectForKey:pathToJSONData[a]];
        }
        
        if ([rawJSON valueForKey:pathToJSONData[a]] != NULL) {
            
            rawJSON = [rawJSON objectForKey:pathToJSONData[a]];
            
        } else {
            
            NSLog(@"Parse Error: \"%@\" has an incorrect path!", pathToArrayWeWant);
            return NULL;
        }
    }
    
    if (PRINT_COMPLETED_JSON) {
        NSLog(@"Parsed (Array) JSON: %@", arrayOfDataFound);
    }
    
    return arrayOfDataFound;
}

+ (NSArray *)createArrayObjectsViaJSON:(NSDictionary *)rawJSON :(NSString *)pathToArrayWeWant :(NSDictionary *)dataWeWant :(id)objectToCreate
{
    NSArray *arrayOfJSONData = [[self class] createArrayViaJSON:rawJSON :pathToArrayWeWant];
    NSMutableArray *arrayOfObjects = [[NSMutableArray alloc] init];
    
    if ([arrayOfJSONData isKindOfClass:[NSArray class]]) {
        
        for (int a = 0; a < [arrayOfJSONData count]; a++) {
            [arrayOfObjects addObject: [objectToCreate createViaJSON:arrayOfJSONData[a] :dataWeWant]];
        }
        
        if (PRINT_COMPLETED_JSON) {
            NSLog(@"Array of Objects: %@", arrayOfObjects);
        }
        
    } else {
        
        NSLog(@"Error - Data is NOT an array");
        return NULL;
    }
    
    return arrayOfObjects;
}



# pragma mark - Private Methods

+ (NSDictionary *)_getData:(NSDictionary *)rawJSON :(NSDictionary *)dataWeWant
{
    if (![self _checkData:rawJSON :dataWeWant]) {
        return NULL;
    }
    
    NSArray *listOfKeys = [dataWeWant allKeys];
    NSMutableDictionary *dictionaryOfDataFound = [[NSMutableDictionary alloc] init];
    
    for (NSString *key in listOfKeys) {
        
        NSArray *pathToJSONData = [self _getPath:[dataWeWant valueForKey:key]];
        
        // Make a copy of the raw JSON ... we will be "chopping" away at the raw JSON until we have reached the value we want!
        NSDictionary *rawJSONCopy = rawJSON;
        
        for (int a = 0; a < [pathToJSONData count]; a++) {
            
            if ([rawJSONCopy valueForKey:pathToJSONData[a]] != NULL) {
                
                rawJSONCopy = [rawJSONCopy objectForKey:pathToJSONData[a]];
                
                if (a == [pathToJSONData count]-1) {
                    
                    [dictionaryOfDataFound setObject:rawJSONCopy forKey:key];
                }
                
            } else {
                
                NSLog(@"Parse Error: \"%@\" has an incorrect path!", key);
                
            }
        }
    }
    
    if (PRINT_COMPLETED_JSON) {
        NSLog(@"Parsed (Dictionary) JSON: %@", dictionaryOfDataFound);
    }
    
    return dictionaryOfDataFound;
}

+ (BOOL)_checkData:(NSDictionary *)rawJSON :(NSDictionary *)dataWeWant
{
    if (!rawJSON || [[rawJSON allKeys] count] == 0) {
        NSLog(@"Raw JSON was NULL!");
        return false;
    }
    
    if (!dataWeWant || [[dataWeWant allKeys] count] == 0) {
        NSLog(@"Data We Want was NULL!");
        return false;
    }
    
    if (PRINT_RAW_JSON) {
        NSLog(@"Raw JSON: %@", rawJSON);
        NSLog(@" "); NSLog(@" "); NSLog(@" ");
    }
    
    return true;
}

+ (NSArray *)_getPath:(NSString *)pathToData
{
    if ([pathToData rangeOfString:kSTRING_SPLITTER].location == NSNotFound) {
        return @[ pathToData ]; // Root level
    } else {
        return [pathToData componentsSeparatedByString:kSTRING_SPLITTER]; // Multiple levels
    }
}

@end
