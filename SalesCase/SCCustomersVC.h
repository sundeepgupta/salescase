//
//  SCCustomersVC.h
//  SalesCaseAlpha
//
//  Created by Sundeep Gupta on 13-03-05.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCCustomersVCDelegate.h"
#import "SCCustomerDetailVCDelegate.h"


@interface SCCustomersVC : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, SCCustomerDetailVCDelegate>

@property (weak, nonatomic) id <SCCustomersVCDelegate> delegate;


@end