//
//  SCOrderPDFVC.h
//  SalesCaseAlpha
//
//  Created by Sundeep Gupta on 13-03-31.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "SCDeleteOrderVCDelegate.h"
#import "SCEmailOrderVCDelegate.h"


@class SCOrder;

@interface SCOrderPDFVC : UIViewController <MFMailComposeViewControllerDelegate, SCDeleteOrderVCDelegate, SCEmailOrderVCDelegate>

@property (strong, nonatomic) SCOrder *order;

@end
 