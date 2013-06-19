//
//  SCOrderTableCell.m
//  SalesCaseAlpha
//
//  Created by Sundeep Gupta on 13-03-26.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "SCOrderTableCell.h"

@implementation SCOrderTableCell

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
    if(selected)
    {
        [SCDesignHelpers customizeSelectedCellBackgroundImageView:self.backgroundImageView];
        for (UILabel *label in self.labels) {
            [SCDesignHelpers customizeSelectedCellLabel:label];
        }
    }
    else
    {
        [SCDesignHelpers customizeUnSelectedCellBackgroundImageView:self.backgroundImageView];
        for (UILabel *label in self.labels) {
            [SCDesignHelpers customizeUnSelectedCellLabel:label];
        }
    }
    

    [super setSelected:selected animated:animated];
}

@end
