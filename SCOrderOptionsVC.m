//
//  SCOrderOptionsVC.m
//  SalesCaseAlpha
//
//  Created by Sundeep Gupta on 13-03-21.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "SCOrderOptionsVC.h"
#import "SCGlobal.h"
#import "SCDataObject.h"
#import "SCOrderMasterVC.h"
#import <QuartzCore/QuartzCore.h>
#import "SCOrderOptionsSelectTableVC.h"
#import "SCDatePicker.h"

#import "SCCustomer.h"
#import "SCOrder.h"


@interface SCOrderOptionsVC ()

@property (strong, nonatomic) SCGlobal *global;
@property (strong, nonatomic) SCDataObject *dataObject;

@property (strong, nonatomic) NSArray *controlMap;
@property (strong, nonatomic) NSString *controlName;
@property (strong, nonatomic) NSString *controlValue;
@property (strong, nonatomic) NSString *orderProperty;
@property (strong, nonatomic) NSString *orderPropertyValue;
@property (strong, nonatomic) NSString *emptySelctionString;

//Popover Controllers
@property (strong, nonatomic) UIPopoverController *selectTablePC;
@property (strong, nonatomic) UIPopoverController *datePickerPC;

//IB Stuff
@property (strong, nonatomic) IBOutlet UIButton *repButton;
@property (strong, nonatomic) IBOutlet UIButton *termsButton;
@property (strong, nonatomic) IBOutlet UIButton *shipViaButton;
@property (strong, nonatomic) IBOutlet UIButton *shipDateButton;
@property (strong, nonatomic) IBOutlet UITextField *poNumberTextField;
@property (strong, nonatomic) IBOutlet UITextView *notesTextView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *statusControl;
@end

@implementation SCOrderOptionsVC

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
    self.global = [SCGlobal sharedGlobal];
    self.dataObject = self.global.dataObject;
    
    //Apply a border around the notes field, otherwise can't see it.
    self.notesTextView.layer.borderWidth = 1.0;
    self.notesTextView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.notesTextView.layer.cornerRadius = 10;
    
    self.emptySelctionString = @"-";
}

- (void)viewWillAppear:(BOOL)animated
{
    //get titles
    UINavigationController *masterNC = self.splitViewController.viewControllers[0];
    SCOrderMasterVC *masterVC = (SCOrderMasterVC *)masterNC.topViewController;
    self.title = [masterVC menuItemLabelForVC:self];
    
    //Disable the status control if no items or no customer set
    if (!self.dataObject.openOrder.customer || self.dataObject.openOrder.lines.count == 0) {
        self.statusControl.enabled = NO;
        self.statusControl.alpha = UI_DISABLED_ALPHA;
    }
    
    //Load view data based on existing open order.
    if (self.dataObject.openOrder.salesRep)
        [self.repButton setTitle:self.dataObject.openOrder.salesRep.name forState:UIControlStateNormal];
    if (self.dataObject.openOrder.salesTerm)
        [self.termsButton setTitle:self.dataObject.openOrder.salesTerm.name forState:UIControlStateNormal];
    if (self.dataObject.openOrder.shipDate)
        [self.shipDateButton setTitle:[SCGlobal stringFromDate:self.dataObject.openOrder.shipDate] forState:UIControlStateNormal];
    if (self.dataObject.openOrder.shipMethod)
        [self.shipViaButton setTitle:self.dataObject.openOrder.shipMethod.name forState:UIControlStateNormal];
    if (self.dataObject.openOrder.poNumber)
        self.poNumberTextField.text = self.dataObject.openOrder.poNumber;
    if (self.dataObject.openOrder.orderDescription)
        self.notesTextView.text = self.dataObject.openOrder.orderDescription;
    if (self.dataObject.openOrder.confirmed)
        self.statusControl.selectedSegmentIndex = 1;
    else
        self.statusControl.selectedSegmentIndex = 0;
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    //Highlight menu cell
    UINavigationController *masterNC = self.splitViewController.viewControllers[0];
    SCOrderMasterVC *masterVC = (SCOrderMasterVC *)masterNC.topViewController;
    [masterVC processAppearedDetailVC:self]; 
}

- (void)viewWillDisappear:(BOOL)animated
{
    
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
    [self setPoNumberTextField:nil];
    [self setNotesTextView:nil];
    [self setRepButton:nil];
    [self setTermsButton:nil];
    [self setShipViaButton:nil];
    [self setShipDateButton:nil];

    [super viewDidUnload];
}


#pragma mark - TextField delegates
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //only one textField so no need to check    
    [self.notesTextView becomeFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.dataObject.openOrder.poNumber = textField.text;
    [self.dataObject saveOrder:self.dataObject.openOrder];
}

#pragma mark - TextView delegates
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    //only one textView so no need to check    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.dataObject.openOrder.orderDescription = textView.text;
    [self.dataObject saveOrder:self.dataObject.openOrder];
}

- (void)showSelectTableWithDataArray:(NSArray *)dataArray andButtonObjectType:(NSString *)buttonObjectType  fromButton:(UIButton *)button
{
    SCOrderOptionsSelectTableVC *vC = [self.storyboard instantiateViewControllerWithIdentifier:@"SCOrderOptionsSelectTableVC"];
    self.selectTablePC = [[UIPopoverController alloc] initWithContentViewController:vC];
    vC.myPC = self.selectTablePC;
    vC.dataArray = dataArray;
    vC.buttonObjectType = buttonObjectType;
    vC.emptySelctionString = self.emptySelctionString;
    vC.delegate = self;
    [self.selectTablePC presentPopoverFromRect:button.bounds inView:button permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

#pragma mark - IB methods
- (IBAction)salesRepButtonPress:(UIButton *)sender {
    NSArray *dataArray = [self.global.dataObject fetchAllObjectsOfType:ENTITY_SCSALESREP];
    [self showSelectTableWithDataArray:dataArray andButtonObjectType:ENTITY_SCSALESREP  fromButton:sender];
}

- (IBAction)termsButtonPress:(UIButton *)sender {
    NSArray *dataArray = [self.global.dataObject fetchAllObjectsOfType:ENTITY_SCSALESTERM];
    [self showSelectTableWithDataArray:dataArray andButtonObjectType:ENTITY_SCSALESTERM  fromButton:sender];
}

- (IBAction)shipViaButtonPress:(UIButton *)sender {
    NSArray *dataArray = [self.global.dataObject fetchAllObjectsOfType:ENTITY_SCSHIPMETHOD];
    [self showSelectTableWithDataArray:dataArray andButtonObjectType:ENTITY_SCSHIPMETHOD  fromButton:sender];
}

- (IBAction)shipDateButtonPress:(UIButton *)sender {
    SCDatePicker *vC = [self.storyboard instantiateViewControllerWithIdentifier:@"SCDatePicker"];
    self.datePickerPC = [[UIPopoverController alloc] initWithContentViewController:vC];
    vC.myPC = self.datePickerPC;
    vC.delegate = self;
    [self.datePickerPC presentPopoverFromRect:sender.bounds inView:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)nextButtonPress:(UIButton *)sender {
    UIViewController *vC = [self.storyboard instantiateViewControllerWithIdentifier:@"SCOrderPDFVC"];
    [self.navigationController pushViewController:vC animated:YES];
}

- (IBAction)statusControlValueChanged:(UISegmentedControl *)sender {
    if (self.statusControl.selectedSegmentIndex == 1) {
        
        //Validate if order ok to mark confirmed (need customer and at least 1 line).  Don't need to anymore, its being disabled in ViewWillAppear.  Just saving this code in case we need it later.
//        if (!self.dataObject.openOrder.customer || self.dataObject.openOrder.lines.count == 0) {
//            self.statusControl.selectedSegmentIndex = 0;
//            if (!self.dataObject.openOrder.customer && self.dataObject.openOrder.lines.count == 0) {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Customer Or Items" message:@"Please add a customer and items to this order before changing the status." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
//                [alert show];
//            } else if (!self.dataObject.openOrder.customer) {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Customer" message:@"Please add a customer to this order before changing the status." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
//                [alert show];
//            } else if (self.dataObject.openOrder.lines.count == 0) {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Items" message:@"Please add items to this order before changing the status." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
//                [alert show];
//            }
//            return;
        

        self.dataObject.openOrder.confirmed = @YES;
    } else {
        self.dataObject.openOrder.confirmed = nil;
    }
    [self.dataObject saveOrder:self.dataObject.openOrder];
    
    //Set title on masterVC because it has the status
    UINavigationController *masterNC = self.splitViewController.viewControllers[0];
    UIViewController *masterVC = masterNC.topViewController;
    masterVC.title = [SCOrderMasterVC masterVCTitleFromOrder:self.dataObject.openOrder];
}

#pragma mark - Protocol methods
- (void)passObject:(id)object withButtonObjectType:(NSString *)buttonObjectType
{
    if (buttonObjectType == ENTITY_SCSALESREP) {
        if ([object isKindOfClass:[NSString class]]) {
            [self.repButton setTitle:object forState:UIControlStateNormal];
            self.dataObject.openOrder.salesRep = nil;
        } else {
            SCSalesRep *castedObject = (SCSalesRep *)object;
            [self.repButton setTitle:castedObject.name forState:UIControlStateNormal];
            self.dataObject.openOrder.salesRep = object;
        }
     } else if (buttonObjectType == ENTITY_SCSALESTERM) {
         if ([object isKindOfClass:[NSString class]]) {
             [self.termsButton setTitle:object forState:UIControlStateNormal];
             self.dataObject.openOrder.salesTerm = nil;
         } else {
            SCSalesTerm *castedObject = (SCSalesTerm *)object;
            [self.termsButton setTitle:castedObject.name forState:UIControlStateNormal];
             self.dataObject.openOrder.salesTerm = object;
         }
    } else if (buttonObjectType == ENTITY_SCSHIPMETHOD) {
        if ([object isKindOfClass:[NSString class]]) {
            [self.shipViaButton setTitle:object forState:UIControlStateNormal];
            self.dataObject.openOrder.shipMethod = nil;
        } else {
            SCShipMethod *castedObject = (SCShipMethod *)object;
            [self.shipViaButton setTitle:castedObject.name forState:UIControlStateNormal];
            self.dataObject.openOrder.shipMethod = object;
        }
    } else {
        NSLog(@"Button object type passed back from the table is not being handled for in passObject method.");
    }
    [self.dataObject saveOrder:self.dataObject.openOrder];
}

- (void)passDate:(NSDate *)date
{
    if (date) {
        [self.shipDateButton setTitle:[SCGlobal stringFromDate:date] forState:UIControlStateNormal];
    } else {
        [self.shipDateButton setTitle:self.emptySelctionString forState:UIControlStateNormal];
    }
    self.dataObject.openOrder.shipDate = date;
    [self.dataObject saveOrder:self.dataObject.openOrder];
}

@end
