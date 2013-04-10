//
//  SCDatePicker.h
//  SalesCaseAlpha
//
//  Created by Sundeep Gupta on 13-03-23.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCDatePickerDelegate.h"

@interface SCDatePicker : UIViewController

@property (strong, nonatomic) UIPopoverController *myPC;
@property (weak, nonatomic) id <SCDatePickerDelegate> delegate;

@end
