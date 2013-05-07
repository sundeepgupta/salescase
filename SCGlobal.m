//
//  SCGlobal.m
//  SalesCaseAlpha
//
//  Created by Sundeep Gupta on 13-03-24.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "SCGlobal.h"
#import "SCDataObject.h"
#import "SCWebApp.h"


@implementation SCGlobal


+ (id)sharedGlobal {
    static SCGlobal *sharedGlobal = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedGlobal = [[self alloc] init];
    });
    return sharedGlobal;
}

- (id)init {
    if (self = [super init]) {
        self.dataObject = [[SCDataObject alloc] init];
        self.webApp = [[SCWebApp alloc] init];
        self.webApp.dataObject = self.dataObject;
        self.dataObject.global = self;
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

- (NSIndexPath *)indexPathForDetailVC:(UIViewController *)vC fromArray:(NSArray *)array withKey:(NSString *)key
{
    NSString *vCClass = NSStringFromClass(vC.class);
    for (int i = 0; i < array.count; i++) {
        NSMutableDictionary *dict = array[i];
        NSString *menuItemRootVC = [dict objectForKey:key];
        if ([menuItemRootVC isEqualToString:vCClass]) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            return indexPath;
        }
    }
    return nil;
}

+ (NSString *)stringFromDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter stringFromDate:date];
}

+(BOOL) stringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

+(NSString *)stringFromDollarAmount:(CGFloat)amount
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    NSString *amountString = [formatter stringFromNumber:[NSNumber numberWithFloat:amount]];
    return amountString;
}

+(NSArray *)labels:(NSArray *)labels fromArrayOfStrings:(NSArray *)array
{ //This is working eventhough the labels is containing textfields.  
    for (NSInteger i = 0; i < MIN(array.count, labels.count) ; i++) {
        UILabel *label = labels[i];
        label.text = array[i];
    }
    return labels;
}


@end
