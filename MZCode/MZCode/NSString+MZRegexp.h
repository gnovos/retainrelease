//
//  NSString+MZRegexp.h
//  MZCore
//
//  Created by Mason Glaves on 4/15/12.
//  Copyright (c) 2012 Masonsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MZRegexp)

- (BOOL) matches:(NSString*)pattern;
- (NSString*) match:(NSString*)pattern;
- (NSArray*) capture:(NSString*)pattern;

@end
