//
//  SCCustomerTableCell.h
//  SalesCase2
//
//  Created by Devon DuVernet on 13-01-23.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCCustomerTableCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *companyLabel;
@property (strong, nonatomic) IBOutlet UILabel *cityLabel;
@property (strong, nonatomic) IBOutlet UILabel *zipLabel;

@end
