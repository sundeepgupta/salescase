//
//  SCGlobal.h
//  SalesCaseAlpha
//
//  Created by Sundeep Gupta on 13-03-24.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//
// From http://www.galloway.me.uk/tutorials/singleton-classes/ and http://stackoverflow.com/questions/5448476/objective-c-singleton-objects-and-global-variables

#import <Foundation/Foundation.h>

@class SCDataObject, SCWebApp, SCOpenOrderC;

@interface SCGlobal : NSObject

@property (strong, nonatomic) SCDataObject *dataObject;
@property (strong, nonatomic) SCWebApp *webApp;
@property (strong, nonatomic) SCOpenOrderC *openOrderC;
//@property BOOL isOrderMode;

+ (id)sharedGlobal;

- (NSIndexPath *)indexPathForDetailVC:(UIViewController *)vC fromArray:(NSArray *)array withKey:(NSString *)key;
+ (NSString *)stringFromDate:(NSDate *)date;

@end
