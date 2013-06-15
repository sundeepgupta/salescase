//
//  SCKeepOrderVC.h
//  SalesCaseAlpha
//
//  Created by Sundeep Gupta on 13-03-31.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCConfirmDeleteVCDelegate.h"

@interface SCKeepOrderVC : UIViewController

@property (weak, nonatomic) id <SCConfirmDeleteVCDelegate> delegate;

@property (strong, nonatomic) IBOutlet UITextView *textView;
@end
