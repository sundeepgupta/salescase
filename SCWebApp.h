//
//  SCWebApp.h
//  SalesCase2
//
//  Created by Devon DuVernet on 13-01-29.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCDataObject;

@interface SCWebApp : NSObject

@property (strong, nonatomic) SCDataObject *dataObject;

//SKG
- (BOOL)isOnline:(NSError **)error;
- (BOOL)canConnectToSalesCaseWebApp:(NSError **)error;
- (BOOL)oAuthTokenIsValid:(NSError **)error responseError:(NSDictionary **)responseError;

- (NSURLRequest *)requestFromUrlExtension:(NSString *)urlExtension withPageNumber:(NSInteger)pageNumber;
- (NSDictionary *)dictionaryFromUrlExtension:(NSString *)urlExtension error:(NSError **)error;
- (NSArray *)arrayFromUrlExtension:(NSString *)urlExtension withPageNumber:(NSInteger)pageNumber error:(NSError **)error; 



-(void)setSynced;
-(BOOL)isSynced;
-(NSString *)getTenant;
-(void)setTenant;


@end
