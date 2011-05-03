//
//  ButtonCell.m
//  SDI
//
//  Created by Jong Pil Park on 11. 5. 3..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import "ButtonCell.h"


@implementation ButtonCell

@synthesize button;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self addSubview:button];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [button release];
    [super dealloc];
}

@end
