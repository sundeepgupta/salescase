//
//  SCDatePicker.m
//  SalesCaseAlpha
//
//  Created by Sundeep Gupta on 13-03-23.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "SCDatePicker.h"

@interface SCDatePicker ()
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation SCDatePicker

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

- (void)viewDidUnload {
    [self setDatePicker:nil];
    [super viewDidUnload];
}


- (IBAction)datePickerValueChanged:(UIDatePicker *)sender {
    [self.delegate passDate:sender.date];
}

- (IBAction)clearShipDateButtonPress:(UIButton *)sender {
    [self.delegate passDate:nil];
    [self.myPC dismissPopoverAnimated:YES];
}







@end
