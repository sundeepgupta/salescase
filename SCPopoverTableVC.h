//
//  SCPopoverTableVC.h
//  SalesCase
//
//  Created by Sundeep Gupta on 13-04-16.
//  Copyright (c) 2013 EnhanceTrade. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCPopoverTableDelegate.h"

@interface SCPopoverTableVC : UITableViewController

@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) NSString *objectType;
@property (strong, nonatomic) NSIndexPath *parentIndexPath;

@property (weak, nonatomic) id <SCPopoverTableDelegate> delegate;

@end
