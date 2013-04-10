//
//  SCEmailOrderVCDelegate.h
//  SalesCaseAlpha
//
//  Created by Sundeep Gupta on 13-04-04.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SCEmailOrderVCDelegate <NSObject>
@required
- (void)passRecipients:(NSArray *)recipients;
@end
 