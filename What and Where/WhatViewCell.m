//
//  WhatViewCell.m
//  What and Where
//
//  Created by Arnaud Boudou on 02/09/12.
//
//

#import "WhatViewCell.h"

@implementation WhatViewCell

@synthesize image, what, bestPrice;

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

@end
