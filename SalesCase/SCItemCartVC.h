//
//  SCItemCartVC.h
//  SalesCaseAlpha
//
//  Created by Sundeep Gupta on 13-03-10.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCItemCartModalDelegate.h"

@class SCLine;

@interface SCItemCartVC : UIViewController <UITableViewDataSource, UITableViewDataSource, UISearchBarDelegate, SCItemCartModalDelegate>
 


- (void)dismissModal;
- (void)presentEditLineVCFromVC:(SCItemCartVC *)vC forLine:(SCLine *)line;

@end

