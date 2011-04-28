//
//  CustomHeader.h
//  SDI
//
//  Created by Jong Pil Park on 11. 4. 28..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomHeader : UIView 
{
    int selectImage;
}

@property (nonatomic, retain) NSString *imageName;

- (void)changeImage;

@end
