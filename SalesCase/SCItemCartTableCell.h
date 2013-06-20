//
//  SCItemCartTableCell.h
//  SalesCaseAlpha
//
//  Created by Sundeep Gupta on 13-03-28.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCItemCartTableCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *quantityLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *amountLabel;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labels;


@end
