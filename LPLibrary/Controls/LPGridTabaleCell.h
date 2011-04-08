//
//  LPGridTabaleCell.h
//  SDI
//
//  Created by Jong Pil Park on 11. 4. 8..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LPGridTabaleCell : UITableViewCell 
{
    NSMutableArray *columns;
}

- (void)addColumn:(CGFloat)position;

@end
