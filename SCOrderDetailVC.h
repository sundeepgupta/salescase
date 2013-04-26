//
//  SCOrderDetailVC.h
//  SalesCaseAlpha
//
//  Created by Sundeep Gupta on 13-03-19.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCConfirmDeleteVCDelegate.h"

@class SCOrder;

@interface SCOrderDetailVC : UIViewController <SCConfirmDeleteVCDelegate>

@property (strong, nonatomic) SCOrder *order;


@end
