//
//  NSString+LPCategory.h
//  LPLibrary
//
//  Created by Jong Pil Park on 10. 7. 23..
//  Copyright 2010 Lilac Studio. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (LPCategory)

- (void)drawCenteredInRect:(CGRect)rect withFont:(UIFont *)font;
- (CGSize)heightWithFont:(UIFont*)withFont width:(float)width linebreak:(UILineBreakMode)lineBreakMode;
- (NSString *)stringByUrlEncoding;
- (NSString *)stringByUrlDecoding;

@end
