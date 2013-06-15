//
//  SCEmailOrderVC.m
//  SalesCaseAlpha
//
//  Created by Sundeep Gupta on 13-03-22.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "SCEmailOrderVC.h"

@interface SCEmailOrderVC ()
//IB
@property (strong, nonatomic) IBOutlet UISegmentedControl *sendToCustomer;
@property (strong, nonatomic) IBOutlet UISegmentedControl *sendToOffice;
@property (strong, nonatomic) IBOutlet UISegmentedControl *sendToMe;
@end

@implementation SCEmailOrderVC

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

- (void)viewWillAppear:(BOOL)animated
{
    self.sendToMe.enabled = NO; //doing this only via storyboard doesn't work in iOS 5
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *companyInfo = [defaults objectForKey:USER_COMPANY_INFO];
    if ([companyInfo objectForKey:USER_COMPANY_EMAIL]) {
        
    } else {
        self.sendToOffice.enabled = NO;
        self.sendToOffice.alpha = UI_DISABLED_ALPHA;
    }        
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

- (void)viewDidUnload {
    [self setSendToCustomer:nil];
    [self setSendToOffice:nil];
    [self setSendToMe:nil];
    [super viewDidUnload];
}

#pragma mark - IB Methods
- (IBAction)emailOrderButtonPress:(UIButton *)sender {
    NSMutableArray *recipients = [[NSMutableArray alloc] init];
    if (self.sendToCustomer.selectedSegmentIndex == 0)
        [recipients addObject:@"Customer"];
    if (self.sendToOffice.selectedSegmentIndex == 0)
        [recipients addObject:@"Office"];
    if (self.sendToMe.selectedSegmentIndex == 0)
        [recipients addObject:@"Me"];
    [self.delegate passRecipients:recipients];
}


@end
