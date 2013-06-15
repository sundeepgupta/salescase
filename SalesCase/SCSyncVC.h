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

@property (strong, nonatomic) id <SCSyncVCDelegate> delegate;
@property eSyncMethod syncMethod;




- (void)syncEverything;
- (void)syncCompanyInfo;


@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@end
