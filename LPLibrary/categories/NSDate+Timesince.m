//
//  NSDate+Timesince.m
//  SDI
//
//  Created by Jong Pil Park on 11. 4. 13..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import "NSDate+Timesince.h"


@implementation NSDate (NSDate_Timesince)

- (NSString *)timesince 
{	
	return [self timesinceWithDepth:2];
}

- (NSString *)timesinceWithDepth:(int)depth 
{
	NSArray *keys = [NSArray arrayWithObjects:@"year", @"month", @"week", @"day", @"hour", @"minute", @"second", nil];
	NSArray *values = [NSArray arrayWithObjects:[NSNumber numberWithInt:31556926],[NSNumber numberWithInt:2629744],[NSNumber numberWithInt:604800],\
                       [NSNumber numberWithInt:86400],[NSNumber numberWithInt:3600],[NSNumber numberWithInt:60],[NSNumber numberWithInt:1],nil];
    
	int delta = -(int)[self timeIntervalSinceNow];
    
	if ( delta <= 60 ) 
    {
		return [NSString stringWithFormat:@"0 %@s", [keys objectAtIndex:5]];
	}
    
	NSString *s = [NSString string];
    
	for (int i=0; i < [keys count]; i++) 
    {
		NSString *unitString = [keys objectAtIndex:i];
		int unit = [[values objectAtIndex:i] intValue];
		int v = (int)(delta/unit);
        
		delta = delta % unit;
        
		if ( (v == 0) || (depth == 0) ) 
        {
			// do nothing
		} 
        else 
        {
			NSString *suffix = (v==1) ? @"" : @"s";
			s = [s length] ? [NSString stringWithFormat:@"%@%@", s, @", "] : s;
			s = [NSString stringWithFormat:@"%@%i %@%@", s, v, unitString, suffix];
			depth--;
		}
	}
    
	return s;
}

@end
