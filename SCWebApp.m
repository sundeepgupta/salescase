//
//  SCWebApp.m
//  SalesCase2
//
//  Created by Devon DuVernet on 13-01-29.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SCWebApp.h"
#import "UIDevice+IdentifierAddition.h"



@interface SCWebApp()

@end

@implementation SCWebApp

#pragma mark - Sundeep;s Methods
- (BOOL)isOnline:(NSError **)error
{
    NSString *URLString =[NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.google.com"] encoding:NSASCIIStringEncoding error:error];
    if (!URLString) {
        NSLog(@"Error connecting to internet: %@", *error);
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)canConnectToSalesCaseWebApp:(NSError **)error
{
    NSString *URLString =[NSString stringWithContentsOfURL:[NSURL URLWithString:WEB_APP_URL] encoding:NSUTF8StringEncoding error:error];
    if (!URLString) {
        NSLog(@"Error connecting to SalesCase servers: %@", *error);
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)oAuthTokenIsValid:(NSError **)error responseError:(NSDictionary **)responseError
{
    NSDictionary *responseDict = [self dictionaryFromUrlExtension:VALIDATE_TENANT_URL_EXT error:error];
    NSString *resultString = [responseDict valueForKey:@"result"];
    if (![resultString isEqualToString:@"Success"]) {
        *responseError = responseDict;
        NSLog(@"Error validating OAuth token: %@, \n%@", *error, *responseError);
        return NO;
    }
    return YES;
}

- (NSURLRequest *)requestFromUrlExtension:(NSString *)urlExtension withPageNumber:(NSInteger)pageNumber
{
    NSString *tenant = [self getTenant];
    NSString *urlstring = [NSString stringWithFormat:@"%@%@?tenant=%@", WEB_APP_URL, urlExtension, tenant];
    
    if (pageNumber != -1) {
        urlstring = [urlstring stringByAppendingString:[NSString stringWithFormat:@"&page=%d", pageNumber]];
    }
    
    NSURL *url = [NSURL URLWithString:urlstring ];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:240];
    [request setHTTPMethod:@"POST"];
    return request;
}

- (NSDictionary *)dictionaryFromUrlExtension:(NSString *)urlExtension error:(NSError **)error
{
    NSURLRequest *request = [self requestFromUrlExtension:urlExtension withPageNumber:-1];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:error];
    if (!responseData) {
        return nil;
    }
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:error];
    if (!dict) {
        return nil;
    }
    return dict;
}

- (NSArray *)arrayFromUrlExtension:(NSString *)urlExtension withPageNumber:(NSInteger)pageNumber error:(NSError **)error responseError:(NSDictionary **)responseError
{
    NSURLRequest *request = [self requestFromUrlExtension:urlExtension withPageNumber:pageNumber];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:error];
    if (!responseData) {
        return nil;
    }
    
    NSArray *array = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:error];
    if (!array) {
        return nil;
    }
    if ([array isKindOfClass:[NSDictionary class]]) {
        *responseError = (NSDictionary *)array;
        return nil;
    }
    
    return array;
}

- (NSArray *)arrayFromUrlExtension:(NSString *)urlExtension withPageNumber:(NSInteger)pageNumber error:(NSError **)error
{
    NSURLRequest *request = [self requestFromUrlExtension:urlExtension withPageNumber:pageNumber];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:error];
    if (!responseData) {
        return nil;
    }
    if ([responseData isKindOfClass:[NSDictionary class]]) {
        
    }
    
    NSArray *array = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:error];
    if (!array) {
        return nil;
    }
    return array;
}


#pragma mark - Al's Methods
-(NSString *)getTenant 
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"tenant"];
}
-(void)setTenant 
{
    NSString *tenant = [[UIDevice currentDevice] uniqueDeviceIdentifier];
    [[NSUserDefaults standardUserDefaults] setValue:tenant forKey:@"tenant"];
}
-(void)setSynced
{
    [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"Synced"];
}
-(void)setUnSynced
{
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"Synced"];
}

-(BOOL)isSynced
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"Synced"] != nil;
}
// End of private methods

@end
