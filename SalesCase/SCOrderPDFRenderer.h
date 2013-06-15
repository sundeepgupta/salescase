//
//  SCOrderPDFRenderer.h
//  SalesCaseAlpha
//
//  Created by Sundeep Gupta on 13-04-03.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCOrder;

@interface SCOrderPDFRenderer : UIViewController

@property (strong, nonatomic) SCOrder *order;

- (void)createPDF;

@end
