//
//  DavidJSON.h
//  DavidJSON
//
//  Created by Stephen Hatton on 11/09/2014.
//  Copyright (c) 2014 Stephen Hatton. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DavidJSON : NSObject

- (NSDictionary *)getData:(NSDictionary *)rawJSON :(NSDictionary *)dataWeWant;
- (NSMutableArray *)getArrayOfData:(NSDictionary *)rawJSON :(NSString *)pathToArrayWeWant;
- (NSObject *)getObject:(NSDictionary *)rawJSON :(NSDictionary *)dataWeWant :(id)objectToCreate;
- (NSArray *)getArrayOfObjects:(NSDictionary *)rawJSON :(NSString *)pathToArrayWeWant :(NSDictionary *)dataWeWant :(id)objectToCreate;

@end
