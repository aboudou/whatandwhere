//
//  WhatViewCell.h
//  What and Where
//
//  Created by Arnaud Boudou on 02/09/12.
//
//

#import <UIKit/UIKit.h>

@interface WhatViewCell : UITableViewCell {
    
}

@property (nonatomic, weak) IBOutlet UIImageView *image;
@property (nonatomic, weak) IBOutlet UILabel *what;
@property (nonatomic, weak) IBOutlet UILabel *bestPrice;

@end
