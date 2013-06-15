//
//  SCKeepOrderVC.m
//  SalesCaseAlpha
//
//  Created by Sundeep Gupta on 13-03-31.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "SCKeepOrderVC.h"

@interface SCKeepOrderVC ()

@end

@implementation SCKeepOrderVC

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
- (IBAction)deleteButtonPress:(UIButton *)sender {
    [sender setTitle:@"Deleted" forState:UIControlStateNormal];
    [self.delegate passConfirmDeleteButtonPress];
}
- (IBAction)keepButtonPress:(UIButton *)sender {
    [self.delegate passKeepButtonPress];
}

- (void)viewDidUnload {
    [self setTextView:nil];
    [super viewDidUnload];
}
@end
