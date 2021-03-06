//
//  SCDesignHelpers.h
//  SalesCase
//
//  Created by Sundeep Gupta on 13-06-18.
//  Copyright (c) 2013 EnhanceTrade. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCDesignHelpers : NSObject

+ (void)customizeiPadTheme;

+ (void)customizeTableView:(UITableView *)tableView;
+ (void)addBackgroundToView:(UIView *)view;
+ (void)addTopShadowToView:(UIView *)tableView;
+ (NSDictionary *)textAttributes;


+ (void)customizeBackgroundForSelectedCell:(UITableViewCell *)cell;
+ (void)customizeBackgroundForUnSelectedCell:(UITableViewCell *)cell;
+ (void)customizeSelectedCellLabel:(UILabel *)label;
+ (void)customizeUnSelectedCellLabel:(UILabel *)label;

+ (void)customizeTextColorForLabel:(UILabel *)label;
+ (void)customizeTextColorForTextField:(UITextField *)textField;
+ (void)customizeTextColorForTextView:(UITextView *)textView;




@end
