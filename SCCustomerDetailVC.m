//
//  SCCustomerDetailVC.m
//  SalesCase
//
//  Created by Sundeep Gupta on 13-04-15.
//  Copyright (c) 2013 EnhanceTrade. All rights reserved.
//

#import "SCCustomerDetailVC.h"
#import "SCCustomer.h"
#import "SCPopoverCell.h"
#import "SCTextCell.h"
#import "SCSalesRep.h"
#import "SCAddress.h"
#import "SCSalesTerm.h"
#import "SCGlobal.h"
#import "SCDataObject.h"
#import "SCPopoverTableVC.h"
#import "SCOrderMasterVC.h"
#import "SCOrder.h"
#import "SCCustomersVC.h"
#import "SCLookMasterVC.h"


@interface SCCustomerDetailVC ()
@property (strong, nonatomic) SCGlobal *global;
@property (strong, nonatomic) SCDataObject *dataObject;
@property (strong, nonatomic) UIPopoverController *popoverTablePC;
@property (strong, nonatomic) UITableViewCell *activeCell;

//IB
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *dbaNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *lastNameTextField;

@property (strong, nonatomic) IBOutlet UITextField *phoneTextField;
@property (strong, nonatomic) IBOutlet UITextField *faxTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;

@property (strong, nonatomic) IBOutlet UITextField *billTo1TextField;
@property (strong, nonatomic) IBOutlet UITextField *billTo2TextField;
@property (strong, nonatomic) IBOutlet UITextField *billTo3TextField;
@property (strong, nonatomic) IBOutlet UITextField *billToCountryTextField;
@property (strong, nonatomic) IBOutlet UITextField *billToStateTextField;
@property (strong, nonatomic) IBOutlet UITextField *billToCityTextField;
@property (strong, nonatomic) IBOutlet UITextField *billToPostalTextField;

@property (strong, nonatomic) IBOutlet UITextField *shipTo1TextField;
@property (strong, nonatomic) IBOutlet UITextField *shipTo2TextField;
@property (strong, nonatomic) IBOutlet UITextField *shipTo3TextField;
@property (strong, nonatomic) IBOutlet UITextField *shipToCountryTextField;
@property (strong, nonatomic) IBOutlet UITextField *shipToStateTextField;
@property (strong, nonatomic) IBOutlet UITextField *shipToCityTextField;
@property (strong, nonatomic) IBOutlet UITextField *shipToPostalTextField;

@property (strong, nonatomic) IBOutlet UILabel *repLabel;
@property (strong, nonatomic) IBOutlet UILabel *termsLabel;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *addOrderButton;
@property (strong, nonatomic) IBOutlet UIButton *captureImageButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *nextButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *selectCustomerButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *spacer1;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *spacer2;

@property (strong, nonatomic) IBOutlet UITableViewCell *repCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *termsCell;

@end

@implementation SCCustomerDetailVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
    
    [self registerForKeyboardNotifications];
}

- (void)viewWillAppear:(BOOL)animated
{
//    NSMutableArray *topBarItems = [[NSMutableArray alloc] init];
    NSMutableArray *toolbarItems = [[NSMutableArray alloc] init];
    
    if (self.dataObject.openOrder) {
        
        self.navigationItem.rightBarButtonItem = nil;
        toolbarItems.array = [NSArray arrayWithObjects:self.editButton, self.spacer1, self.selectCustomerButton, self.spacer2, self.nextButton, nil]; 
        
        //get titles
        UINavigationController *masterNC = self.splitViewController.viewControllers[0];
        SCOrderMasterVC *masterVC = (SCOrderMasterVC *)masterNC.topViewController;
        self.title = [masterVC menuItemLabelForVC:self];
        
        self.customer = self.dataObject.openOrder.customer;
        if (!self.customer) { //if no customers has been loaded, bring up the modal so they can choose
            [self presentCustomerList];
        }
    } else {
        if (self.dataObject.openCustomer) {
            self.title = @"New Customer";
            self.customer = self.dataObject.openCustomer;
            
//            self.navigationItem.rightBarButtonItem = nil;
            toolbarItems.array = [NSArray arrayWithObjects:self.cancelButton, self.spacer1, self.saveButton, nil];
            
        } else {
            self.title = self.customer.dbaName;
            toolbarItems.array = [NSArray arrayWithObjects:self.editButton, nil];
            
        }
    }
    
    self.toolbarItems = toolbarItems;
    [self loadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    if (self.dataObject.openOrder) {
        //Highlight OrderMasterVC cell if order mode
        UINavigationController *masterNC = self.splitViewController.viewControllers[0];
        SCOrderMasterVC *masterVC = (SCOrderMasterVC *)masterNC.topViewController;
        [masterVC processAppearedDetailVC:self];
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
    [self setCaptureImageButton:nil];
    [self setNextButton:nil];
    [self setSelectCustomerButton:nil];
    [self setEditButton:nil];
    [self setSpacer1:nil];
    [self setSaveButton:nil];
    [self setCancelButton:nil];
    [self setAddOrderButton:nil];
    [self setNextButton:nil];
    [self setSpacer2:nil];
    [self setNameTextField:nil];
    [self setRepCell:nil];
    [self setTermsCell:nil];
    [super viewDidUnload];
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell isEqual:self.repCell] || [cell isEqual:self.termsCell]) {
        NSString *objectType;
        
        if ([cell isEqual:self.repCell]) objectType = ENTITY_SCSALESREP;
        else objectType = ENTITY_SCSALESTERM;

        NSArray *dataArray = [self.dataObject fetchAllObjectsOfType:objectType];
        [self showPopoverTableWithArray:dataArray withObjectType:objectType fromCell:cell];
    }
}

#pragma mark - TextField Delegates
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //only one textField so no need to check
//    [self.notesTextView becomeFirstResponder];
    
    //don't allow ":"
    
    
    return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeCell = (UITableViewCell*) [textField.superview superview];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField isEqual:self.nameTextField]) {
        //validate uniqueness, and if empty
        
        self.customer.name = textField.text;
    }
    if ([textField isEqual:self.dbaNameTextField]) self.customer.dbaName = textField.text;
    if ([textField isEqual:self.firstNameTextField]) self.customer.givenName = textField.text;
    if ([textField isEqual:self.lastNameTextField]) self.customer.familyName = textField.text;
    
    if ([textField isEqual:self.phoneTextField]) [self.dataObject savePhoneNumber:textField.text withTag:MAIN_PHONE_TAG forCustomer:self.customer];
    if ([textField isEqual:self.faxTextField]) [self.dataObject savePhoneNumber:textField.text withTag:FAX_PHONE_TAG forCustomer:self.customer];
    
    if ([textField isEqual:self.billTo1TextField]) self.customer.primaryBillingAddress.line1 = textField.text;

    
    
    [self.dataObject saveContext];
    self.activeCell = nil;
    
    
}

#pragma mark - Protocol methods
- (void)passObject:(id)object withObjectType:(NSString *)objectType
{    
    if ([objectType isEqualToString:ENTITY_SCSALESREP]) {
        if ([object isKindOfClass:[NSString class]]) { //means the "empty" rep selected
            self.repLabel.text = object;
            self.customer.salesRep = nil;
        } else {
            SCSalesRep *castedObject = (SCSalesRep *)object;
            self.repLabel.text = castedObject.name;
            self.customer.salesRep = object;
        }
    } else if ([objectType isEqualToString:ENTITY_SCSALESTERM]) {
        if ([object isKindOfClass:[NSString class]]) { //means the "empty" rep selected
            self.termsLabel.text = object;
            self.customer.salesTerms = nil;
        } else {
            SCSalesTerm *castedObject = (SCSalesTerm *)object;
            self.termsLabel.text = castedObject.name;
            self.customer.salesTerms = object;
        }
    } else {
        NSLog(@"Object type passed back from the table is not being handled for in passObject method.");
    }
    [self.popoverTablePC dismissPopoverAnimated:YES];
    [self.dataObject saveContext];
}

- (void)passCustomer:(SCCustomer *)customer
{ //this only gets called in order mode
    
    if (self.customer && self.customer != customer) { //user changed the customer that was previously set
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Customer Changed"
                                                        message:@"This order's rep and terms will now match this customer's default rep and terms."
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"Ok, got it!", nil];
        [alert show];
    }
    self.customer = customer;
    self.dataObject.openOrder.customer = customer;
    self.dataObject.openOrder.salesRep = customer.salesRep;
    self.dataObject.openOrder.salesTerm = customer.salesTerms;
    [self.dataObject saveOrder:self.dataObject.openOrder];
    [self loadData];
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
//    for (NSInteger sectionNumber = 0; sectionNumber < self.sections.count; sectionNumber++) {
//        NSArray *sectionRows = self.sections[sectionNumber][SECTION_ROWS];
//        for (NSInteger rowNumber = 0; rowNumber < sectionRows.count; rowNumber++) {
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowNumber inSection:sectionNumber];
//            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
//        }
//    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //get and save the image
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [self.captureImageButton setImage:image forState:UIControlStateNormal];
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    self.customer.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Custom Methods
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification*)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGFloat insetsHeight = keyboardSize.width; //Good for iPad landscape always mode.  Otherwise need to check orientations and get the height accordingly.
    if (self.navigationController.toolbar) { //adjust for the toolbar because keyboard overlays it
        CGFloat toolbarHeight = self.navigationController.toolbar.frame.size.height;
        insetsHeight = insetsHeight - toolbarHeight;
    }
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0,0,insetsHeight,0);
    self.tableView.contentInset = edgeInsets;
    self.tableView.scrollIndicatorInsets = edgeInsets;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:self.activeCell];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
    
}

- (void)keyboardWillBeHidden:(NSNotification*)notification
{
    NSTimeInterval duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        self.tableView.contentInset = UIEdgeInsetsZero;
        self.tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
    }];
}

- (void)loadData
{
    self.nameTextField.text = self.customer.name;
    self.dbaNameTextField.text = self.customer.dbaName;
    self.firstNameTextField.text = self.customer.givenName;
    self.lastNameTextField.text = self.customer.familyName;

    self.phoneTextField.text = [self.customer phoneForTag:MAIN_PHONE_TAG];
    self.faxTextField.text = [self.customer phoneForTag:FAX_PHONE_TAG];
    self.emailTextField.text = [self.customer mainEmail];
    
    self.repLabel.text = self.customer.salesRep.name;
    self.termsLabel.text = self.customer.salesTerms.name;
    

    
    
    
    
//    [self.tableView reloadData];
}

- (void)showPopoverTableWithArray:(NSArray *)dataArray withObjectType:(NSString *)objectType fromCell:(UITableViewCell *)cell
{
    SCPopoverTableVC *vC = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([SCPopoverTableVC class])];
    vC.dataArray = dataArray;
    vC.objectType = objectType;
    vC.delegate = self;
//    vC.parentCell = cell;
    
    self.popoverTablePC = [[UIPopoverController alloc] initWithContentViewController:vC];
    self.popoverTablePC.delegate = self;
    [self.popoverTablePC presentPopoverFromRect:cell.bounds inView:cell permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

+ (void)loadAddressDataFromLines:(NSArray *)lines toLabels:(NSArray *)labels
{
    for (NSInteger i = 0; i < 5; i++) {
        UILabel *label = labels[i];
        if (i < lines.count) {
            label.text = lines[i];
        } else {
            label.text = @"";
        }
    }
}

- (void)presentCustomerList
{
    UINavigationController *customersNC = [self.storyboard instantiateViewControllerWithIdentifier:@"CustomersNC"];
    SCCustomersVC *customersVC = (SCCustomersVC *)customersNC.topViewController;
    customersVC.delegate = self;
    [self presentViewController:customersNC animated:YES completion:nil];
}


- (void)captureImage
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = self;
//        imagePicker.allowsEditing = YES; 
        
        
        [self presentViewController:imagePicker animated:YES completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Camera Unavailable" message:@"You're camera seems to be unavailable." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark - IB Methods
- (IBAction)captureButtonPress:(UIButton *)sender {
    [self captureImage];
}

- (IBAction)nextButtonPress:(UIBarButtonItem *)sender {
    UIViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SCItemCartVC"];
    [self.navigationController pushViewController:nextVC animated:YES];
}

- (IBAction)addOrderButtonPress:(UIBarButtonItem *)sender {
    UINavigationController *masterNC = self.splitViewController.viewControllers[0];
    SCLookMasterVC *masterVC = (SCLookMasterVC *)masterNC.topViewController;
    [masterVC startOrderModeWithCustomer:self.customer];
}

- (IBAction)selectCustomerButtonPress:(UIBarButtonItem *)sender {
    [self presentCustomerList];
}

- (IBAction)cancelButtonPress:(UIBarButtonItem *)sender {
    [self.dataObject deleteObject:self.dataObject.openCustomer];
    self.dataObject.openCustomer = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveButtonPress:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)editButtonPress:(UIBarButtonItem *)sender {
}
@end
