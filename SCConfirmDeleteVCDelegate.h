//
//  SCConfirmDeleteVCDelegate.h
//  SalesCaseAlpha
//
//  Created by Sundeep Gupta on 13-03-28.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SCConfirmDeleteVCDelegate <NSObject>
@required
- (void)passConfirmDeleteButtonPress;
@optional
- (void)passKeepButtonPress;
@end
