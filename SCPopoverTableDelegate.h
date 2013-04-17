//
//  SCPopoverTableDelegate.h
//  SalesCase
//
//  Created by Sundeep Gupta on 13-04-16.
//  Copyright (c) 2013 EnhanceTrade. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SCPopoverTableDelegate <NSObject>
@optional
- (void)passObject:(id)object withObjectType:(NSString *)objectType withIndexPath:(NSIndexPath *)indexPath;
@end
