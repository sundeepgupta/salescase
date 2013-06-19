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
#import "SCPopoverTableVC.h"
#import "SCDatePicker.h"
#import "SCCustomer.h"
#import "SCOrder.h"
#import "KSCustomPopoverBackgroundView.h"


@interface SCOrderOptionsVC ()

@property (strong, nonatomic) SCGlobal *global;
@property (strong, nonatomic) SCDataObject *dataObject;


//Popover Controllers
@property (strong, nonatomic) UIPopoverController *popoverTablePC;
@property (strong, nonatomic) UIPopoverController *datePickerPC;

//IB
//Values
@property (strong, nonatomic) IBOutlet UILabel *repLabel;
@property (strong, nonatomic) IBOutlet UILabel *termsLabel;
@property (strong, nonatomic) IBOutlet UILabel *shipViaLabel;
@property (strong, nonatomic) IBOutlet UILabel *shipDateLabel;
@property (strong, nonatomic) IBOutlet UITextField *poNumberTextField;
@property (strong, nonatomic) IBOutlet UITextView *notesTextView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *statusControl;

//Cells
@property (strong, nonatomic) IBOutlet UITableViewCell *repCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *termsCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *shipViaCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *shipDateCell;

//Collections
@property (nonatomic, strong) IBOutletCollection(UITableViewCell) NSArray *popoverCells;

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
    
    [SCDesignHelpers customizeTableView:self.tableView];
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
    
    [self loadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    //Highlight menu cell
    UINavigationController *masterNC = self.splitViewController.viewControllers[0];
    SCOrderMasterVC *masterVC = (SCOrderMasterVC *)masterNC.topViewController;
    [masterVC processAppearedDetailVC:self]; 
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
    [super viewDidUnload];
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell isEqual:self.repCell] || [cell isEqual:self.termsCell] || [cell isEqual:self.shipViaCell]) {
        //dismiss keyboard
        [self.view endEditing:YES];
        
        NSString *objectType;
        
        if ([cell isEqual:self.repCell]) objectType = ENTITY_SCSALESREP;
        else if ([cell isEqual:self.termsCell]) objectType = ENTITY_SCSALESTERM;
        else objectType = ENTITY_SCSHIPMETHOD;
        
        NSArray *dataArray = [self.dataObject fetchAllObjectsOfType:objectType];
        [self showPopoverTableWithArray:dataArray withObjectType:objectType fromCell:cell];
        
    } else if ([cell isEqual:self.shipDateCell]) {
        SCDatePicker *vC = [self.storyboard instantiateViewControllerWithIdentifier:@"SCDatePicker"];
        self.datePickerPC = [[UIPopoverController alloc] initWithContentViewController:vC];
        self.datePickerPC.popoverBackgroundViewClass = [KSCustomPopoverBackgroundView class];

        self.datePickerPC.delegate = self;
        vC.myPC = self.datePickerPC;
        vC.delegate = self;
        [self.datePickerPC presentPopoverFromRect:cell.bounds inView:cell permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
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

- (void)showPopoverTableWithArray:(NSArray *)dataArray withObjectType:(NSString *)objectType fromCell:(UITableViewCell *)cell
{
    SCPopoverTableVC *vC = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([SCPopoverTableVC class])]; 
    vC.dataArray = dataArray;
    vC.objectType = objectType;
    vC.delegate = self;
    
    self.popoverTablePC = [[UIPopoverController alloc] initWithContentViewController:vC];
    self.popoverTablePC.popoverBackgroundViewClass = [KSCustomPopoverBackgroundView class];

    self.popoverTablePC.delegate = self;
    [self.popoverTablePC presentPopoverFromRect:cell.bounds inView:cell permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

#pragma mark - Protocol methods
- (void)passObject:(id)object withObjectType:(NSString *)objectType
{
    if (objectType == ENTITY_SCSALESREP) {
        if ([object isKindOfClass:[NSString class]]) {
            self.repLabel.text = object;
            self.dataObject.openOrder.salesRep = nil;
        } else {
            SCSalesRep *castedObject = (SCSalesRep *)object;
            self.repLabel.text = castedObject.name;
            self.dataObject.openOrder.salesRep = object;
        }
     } else if (objectType == ENTITY_SCSALESTERM) {
         if ([object isKindOfClass:[NSString class]]) {
             self.termsLabel.text = object;
             self.dataObject.openOrder.salesTerm = nil;
         } else {
            SCSalesTerm *castedObject = (SCSalesTerm *)object;
            self.termsLabel.text = castedObject.name;
             self.dataObject.openOrder.salesTerm = object;
         }
    } else if (objectType == ENTITY_SCSHIPMETHOD) {
        if ([object isKindOfClass:[NSString class]]) {
            self.shipViaLabel.text = object;
            self.dataObject.openOrder.shipMethod = nil;
        } else {
            SCShipMethod *castedObject = (SCShipMethod *)object;
            self.shipViaLabel.text = castedObject.name;
            self.dataObject.openOrder.shipMethod = object;
        }
    } else {
        NSLog(@"Button object type passed back from the table is not being handled for in passObject method.");
    }
    [self.dataObject saveOrder:self.dataObject.openOrder];
    [self.popoverTablePC dismissPopoverAnimated:YES];
    
    [self deselectSelectedRow];
}

- (void)passDate:(NSDate *)date
{
    if (date) {
        self.shipDateLabel.text = [SCGlobal stringFromDate:date];
    } else {
        self.shipDateLabel.text = EMPTY_SELECTION_STRING;
    }
    self.dataObject.openOrder.shipDate = date;
    [self.dataObject saveOrder:self.dataObject.openOrder];
    
    [self deselectSelectedRow];
}

#pragma mark - Custom methods
- (void)loadData
{
    if (self.dataObject.openOrder.salesRep) self.repLabel.text = self.dataObject.openOrder.salesRep.name;
    if (self.dataObject.openOrder.salesTerm)
        self.termsLabel.text = self.dataObject.openOrder.salesTerm.name;
    if (self.dataObject.openOrder.shipDate)
        self.shipDateLabel.text = [SCGlobal stringFromDate:self.dataObject.openOrder.shipDate];
    if (self.dataObject.openOrder.shipMethod)
        self.shipViaLabel.text = self.dataObject.openOrder.shipMethod.name;
    if (self.dataObject.openOrder.poNumber)
        self.poNumberTextField.text = self.dataObject.openOrder.poNumber;
    if (self.dataObject.openOrder.orderDescription)
        self.notesTextView.text = self.dataObject.openOrder.orderDescription;
    if ([self.dataObject.openOrder.status isEqualToString:CONFIRMED_STATUS])
        self.statusControl.selectedSegmentIndex = 1;
    else //no need to check for synced status, as we can't edit it
        self.statusControl.selectedSegmentIndex = 0;
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    //deselect the cell
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)deselectSelectedRow
{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

#pragma mark - IB methods
- (IBAction)nextButtonPress:(UIBarButtonItem *)sender {
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
        

        self.dataObject.openOrder.status = CONFIRMED_STATUS;
    } else {
        self.dataObject.openOrder.status = DRAFT_STATUS;
    }
    [self.dataObject saveOrder:self.dataObject.openOrder];
    
    //Set title on masterVC because it has the status
    UINavigationController *masterNC = self.splitViewController.viewControllers[0];
    UIViewController *masterVC = masterNC.topViewController;
    masterVC.title = [SCOrderMasterVC masterVCTitleFromOrder:self.dataObject.openOrder];
}



@end
