//
//  SCDeleteOrderVC.m
//  SalesCaseAlpha
//
//  Created by Sundeep Gupta on 13-03-22.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "SCDeleteOrderVC.h"
#import "SCGlobal.h"
#import "SCOrderMasterVC.h"
#import "SCDataObject.h"

@interface SCDeleteOrderVC ()

@property (strong, nonatomic) SCGlobal *global;


@end

@implementation SCDeleteOrderVC

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
    self.title = @"Delete Order";
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



#pragma mark - IB Methods
- (IBAction)confirmDeleteButtonPress:(UIButton *)sender {
    [sender setTitle:@"Order Deleted" forState:UIControlStateNormal];
    [self.delegate passConfirmDeleteButtonPress];
}


@end
