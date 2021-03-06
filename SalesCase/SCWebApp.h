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

- (BOOL)isOnline:(NSError **)error;
- (BOOL)canConnectToSalesCaseWebApp:(NSError **)error;
- (BOOL)oAuthTokenIsValid:(NSError **)error responseError:(NSDictionary **)responseError;
- (BOOL)disconnectOAuth:(NSError **)error responseError:(NSDictionary **)responseError;

- (NSURL *)urlFromUrlExtension:(NSString *)urlExtension;
- (NSURLRequest *)requestFromUrl:(NSURL *)url withPostString:(NSString *)postString;

- (NSURLRequest *)requestFromUrlExtension:(NSString *)urlExtension withPageNumber:(NSInteger)pageNumber;
- (NSDictionary *)dictionaryFromUrlExtension:(NSString *)urlExtension error:(NSError **)error;

- (NSDictionary *)dictionaryFromRequest:(NSURLRequest *)request error:(NSError **)error;

- (NSArray *)arrayFromUrlExtension:(NSString *)urlExtension withPageNumber:(NSInteger)pageNumber error:(NSError **)error responseError:(NSDictionary **)responseError;
- (NSArray *)arrayFromUrlExtension:(NSString *)urlExtension withPageNumber:(NSInteger)pageNumber error:(NSError **)error;


-(void)setSynced;
-(BOOL)isSynced;
-(NSString *)getTenant;
-(void)setTenant;


@end
