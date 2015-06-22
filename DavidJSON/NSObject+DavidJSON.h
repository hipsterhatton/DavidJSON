//
//  NSObject+DavidJSON.h
//  Cassette
//
//  Created by Stephen Hatton on 09/04/2015.
//  Copyright (c) 2015 Stephen Hatton. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (DavidJSON)

+ (id)createViaJSON:(NSDictionary *)rawJSON :(NSDictionary *)data;
- (void)updateViaJSON:(NSDictionary *)rawJSON :(NSDictionary *)dictionary;
+ (id)getViaJSON:(NSDictionary *)rawJSON :(NSDictionary *)dictionary;

+ (NSArray *)createArrayViaJSON:(NSDictionary *)rawJSON :(NSString *)pathToArrayWeWant;
+ (NSArray *)createArrayObjectsViaJSON:(NSDictionary *)rawJSON :(NSString *)pathToArrayWeWant :(NSDictionary *)dataWeWant :(id)objectToCreate;

@end
