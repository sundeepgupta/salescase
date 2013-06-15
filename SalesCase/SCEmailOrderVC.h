//
//  SCEmailOrderVC.h
//  SalesCaseAlpha
//
//  Created by Sundeep Gupta on 13-03-22.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCEmailOrderVCDelegate.h"

@interface SCEmailOrderVC : UIViewController

@property (weak, nonatomic) id <SCEmailOrderVCDelegate> delegate;

@end
