//
//  SCMasterCell.m
//  SalesCase
//
//  Created by Sundeep Gupta on 13-06-18.
//  Copyright (c) 2013 EnhanceTrade. All rights reserved.
//

#import "SCMasterCell.h"

@implementation SCMasterCell

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
        [SCDesignHelpers customizeSelectedCellBackgroundImageView:self.imageView];

        [SCDesignHelpers customizeSelectedCellLabel:self.label];
        
    }
    else
    {
        [SCDesignHelpers customizeUnSelectedCellBackgroundImageView:self.imageView];

        [SCDesignHelpers customizeUnSelectedCellLabel:self.label];
        
    }

    
    
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
