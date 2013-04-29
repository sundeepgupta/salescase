//
//  SCItemDetailVCVC.h
//  SalesCaseAlpha
//
//  Created by Sundeep Gupta on 13-03-07.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCItemCartModalDelegate.h"

@class SCItem, SCLine;

@interface SCItemDetailVC : UITableViewController

@property (strong, nonatomic) SCItem *item;
@property (strong, nonatomic) SCLine *line;
@property BOOL isEditLineMode;

@property (weak, nonatomic) id <SCItemCartModalDelegate> delegate;
  

@property (strong, nonatomic) IBOutlet UIButton *saveToOrderButton;

@end
