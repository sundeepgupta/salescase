//
//  SCItemTableCell.m
//  SalesCaseAlpha
//
//  Created by Sundeep Gupta on 13-03-19.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "SCItemTableCell.h"

@implementation SCItemTableCell

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
