//
//  SCConfirmDeleteVC.m
//  SalesCaseAlpha
//
//  Created by Sundeep Gupta on 13-03-22.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "SCConfirmDeleteVC.h"
#import "SCGlobal.h"
#import "SCOrderMasterVC.h"
#import "SCDataObject.h"

@interface SCConfirmDeleteVC ()

@property (strong, nonatomic) SCGlobal *global;


@end

@implementation SCConfirmDeleteVC

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
    
    [SCDesignHelpers addBackgroundToView:self.view];
    [SCDesignHelpers addTopShadowToView:self.view];

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
    [sender setTitle:@"Deleting" forState:UIControlStateNormal];
    [self.delegate passConfirmDeleteButtonPress];
}


- (void)viewDidUnload {
    [self setTextView:nil];
    [super viewDidUnload];
}
@end
