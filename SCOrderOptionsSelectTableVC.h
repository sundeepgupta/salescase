//
//  SCOrderOptionsSelectTableVC.h
//  SalesCaseAlpha
//
//  Created by Sundeep Gupta on 13-03-22.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCOrderOptionsSelectTableDelegate.h"

@interface SCOrderOptionsSelectTableVC : UITableViewController

@property (strong, nonatomic) UIPopoverController *myPC;
@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) NSString *buttonObjectType;
@property (strong, nonatomic) NSString *emptySelctionString;
 
//Don't need this property right now, because its always "name"
//@property (strong, nonatomic) NSString *classPropertyForCellLabel;


@property (weak, nonatomic) id <SCOrderOptionsSelectTableDelegate> delegate;






@end
