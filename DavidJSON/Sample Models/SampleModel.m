//
//  SampleModel.m
//  DavidJSON
//
//  Created by Stephen Hatton on 11/09/2014.
//  Copyright (c) 2014 Stephen Hatton. All rights reserved.
//

#import "SampleModel.h"

@implementation SampleModel

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    for (NSString *key in [dictionary allKeys])
        [self setValue:dictionary[key] forKey:key];
    
    NSLog(@"User ID: %@", _user_id);
    NSLog(@"Login Name: %@", _login_name);
    NSLog(@"Avatar: %@", _avatar_image);
    
    return self;
}

@end