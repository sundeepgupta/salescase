//
//  SCIntuitLoginPopoverVC.m
//  SalesCaseAlpha
//
//  Created by Sundeep Gupta on 13-03-20.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "SCIntuitLoginPopoverVC.h"

@interface SCIntuitLoginPopoverVC ()

@end

@implementation SCIntuitLoginPopoverVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.title = @"Error Connecting";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

@end
