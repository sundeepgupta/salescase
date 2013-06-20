//
//  SCItemTableCell.h
//  SalesCaseAlpha
//
//  Created by Sundeep Gupta on 13-03-19.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCItemTableCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *quantityOnHandLabel;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labels;


@end
