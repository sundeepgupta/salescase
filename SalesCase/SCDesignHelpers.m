//
//  SCDesignHelpers.m
//  SalesCase
//
//  Created by Sundeep Gupta on 13-06-18.
//  Copyright (c) 2013 EnhanceTrade. All rights reserved.
//

#import "SCDesignHelpers.h"
#import <QuartzCore/QuartzCore.h>


@implementation SCDesignHelpers


+ (void)customizeiPadTheme
{
    [SCDesignHelpers customizeBars];
    [SCDesignHelpers customizeBarButtons];
}

+ (void)customizeBars {
    //TODO - Need to fix image for full width views (like login page)
    UIImage *image = [UIImage imageNamed:@"ipad-menubar-right.png"];
    
    [SCDesignHelpers customizeViewClass:[UINavigationBar class] withImage:image];
    [SCDesignHelpers customizeTextForViewClass:[UINavigationBar class]];
    
    [SCDesignHelpers customizeViewClass:[UIToolbar class] withImage:image];
}




+ (void)customizeViewClass:(Class)viewClass withImage:(UIImage *)image {
    if (viewClass == [UINavigationBar class]) {
        [[UINavigationBar appearance] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    } else if (viewClass == [UIToolbar class]) {
        [[UIToolbar appearance] setBackgroundImage:image forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    }    
}

+ (void)customizeTextForViewClass:(Class)viewClass  {
    NSDictionary *textAttributes = [SCDesignHelpers textAttributes];
    
    if (viewClass == [UINavigationBar class]) {
        [[UINavigationBar appearance] setTitleTextAttributes:textAttributes];
    } 
}

+ (NSDictionary *)textAttributes {
    UIColor *textColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
    UIColor *shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    NSValue *shadowOffset = [NSValue valueWithUIOffset:UIOffsetMake(0, -1)];
    
    return [NSDictionary dictionaryWithObjectsAndKeys: textColor, UITextAttributeTextColor, shadowColor, UITextAttributeTextShadowColor, shadowOffset, UITextAttributeTextShadowOffset, nil];
}

+ (void)customizeBarButtons {
    UIImage *barItemImage = [[UIImage imageNamed:@"ipad-menubar-button.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    [[UIBarButtonItem appearance] setBackgroundImage:barItemImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    UIImage *backButton = [[UIImage imageNamed:@"back.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 14, 0, 4)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButton forState:UIControlStateNormal
                                                    barMetrics:UIBarMetricsDefault];
}



+ (void)customizeTableView:(UITableView *)tableView {
    [SCDesignHelpers addTopShadowToView:tableView];
    [SCDesignHelpers addBackgroundToView:tableView];
}

+ (void)addTopShadowToView:(UIView *)view {
    CGRect shadowFrame = [SCDesignHelpers shadowFrameFromView:view];
    CALayer *shadow = [SCDesignHelpers shadowFromFrame:shadowFrame];
    [view.layer addSublayer:shadow];
}

+ (CGRect)shadowFrameFromView:(UIView *)view {
    CGFloat frameWidth;
    
    if (view.frame.size.height == 1024) { //LoginVC is using the wrong orientation
        frameWidth = view.frame.size.height;
    } else {
        frameWidth = view.frame.size.width;
    }
    CGFloat frameHeight = 5;
    return CGRectMake(0, 0, frameWidth, frameHeight);
}

+ (CALayer *)shadowFromFrame:(CGRect)frame
{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = frame;
    
    UIColor* lightColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    UIColor* darkColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    
    gradient.colors = [NSArray arrayWithObjects:(id)darkColor.CGColor, (id)lightColor.CGColor, nil];
    
    return gradient;
}

+ (void)addBackgroundToView:(UIView *)view {
    UIColor* bgColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad-BG-pattern.png"]];
    view.backgroundColor = bgColor;
    
    if ([view isKindOfClass:[UITableView class]]) {
        [SCDesignHelpers removeBackgroundViewFromTableView:(UITableView *)view];
    }
}

+ (void)removeBackgroundViewFromTableView:(UITableView *)tableView {
    tableView.backgroundView = nil;
}

@end
