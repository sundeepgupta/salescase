//
//  SCSyncVC.h
//  SalesCaseAlpha
//
//  Created by Sundeep Gupta on 13-03-21.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCSyncVCDelegate.h"
#import <MessageUI/MessageUI.h>

@interface SCSyncVC : UIViewController <MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) id <SCSyncVCDelegate> delegate;









@end
