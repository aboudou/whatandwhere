//
//  WhatListTableViewCell.m
//  What and Where
//
//  Created by Boudou Arnaud on 11/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WhatListTableViewCell.h"

@implementation WhatListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.imageView setFrame:CGRectMake(0,0,43,43)];
    [self.imageView setContentMode:UIViewContentModeScaleAspectFill];
}

@end
