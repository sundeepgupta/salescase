//
//  SCConfirmDeleteVC.h
//  SalesCaseAlpha
//
//  Created by Sundeep Gupta on 13-03-22.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCConfirmDeleteVCDelegate.h"

@interface SCConfirmDeleteVC : UIViewController

@property (weak, nonatomic) id <SCConfirmDeleteVCDelegate> delegate;

@end
