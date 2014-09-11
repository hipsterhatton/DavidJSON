//
//  DavidJSON.m
//  DavidJSON
//
//  Created by Stephen Hatton on 11/09/2014.
//  Copyright (c) 2014 Stephen Hatton. All rights reserved.
//

#import "DavidJSON.h"

@implementation DavidJSON

// Put simply: this library is designed to: take raw JSON + a dictionary (containing paths to pieces of data we need inside the raw JSON)
//      eg: @{ PostCode : Customer Details > Address > Postcode }
// and returns the same dictionary, with all the paths replaced with the JSON data they point to
//      eg: @{ PostCode : AB1 2CD }
// Why? Because dictionaries are easy to work with :D



#pragma Get Data From JSON

- (NSDictionary *)getData
{
    return @{};
}

- (NSDictionary *)getArrayOfData
{
    return @{};
}



#pragma Get NSObject From JSON

- (NSDictionary *)getObject
{
    return @{};
}

- (NSDictionary *)getArrayOfObjects
{
    return @{};
}

@end