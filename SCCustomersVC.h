//
//  SCCustomersVC.h
//  SalesCaseAlpha
//
//  Created by Sundeep Gupta on 13-03-05.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCCustomersVCDelegate.h"


@interface SCCustomersVC : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) id <SCCustomersVCDelegate> delegate;


@end