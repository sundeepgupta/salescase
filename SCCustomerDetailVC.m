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
@property (strong, nonatomic) NSArray *customerNames;
@property (strong, nonatomic) NSString *defaultName;
@property (strong, nonatomic) UIAlertView *validateCompanyNameAlert;

@property (strong, nonatomic) NSArray *billToTextFields;
@property (strong, nonatomic) NSArray *shipToTextFields;

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
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *deleteButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *spacer2;

//Cells
@property (strong, nonatomic) IBOutlet UITableViewCell *repCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *termsCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *billToPostalCell;

//Collections
@property (nonatomic, strong) IBOutletCollection(UILabel) NSArray *addressTitles;
@property (nonatomic, strong) IBOutletCollection(UITableViewCell) NSArray *cells;
@property (nonatomic, strong) IBOutletCollection(UITextField) NSArray *textFields;
@property (nonatomic, strong) IBOutletCollection(UITableViewCell) NSArray *popoverCells;

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
    
    self.billToTextFields = [NSArray arrayWithObjects:self.billTo1TextField, self.billTo2TextField, self.billTo3TextField, self.billToCityTextField, self.billToStateTextField, self.billToPostalTextField, self.billToCountryTextField, nil];
    self.shipToTextFields = [NSArray arrayWithObjects:self.shipTo1TextField, self.shipTo2TextField, self.shipTo3TextField, self.shipToCityTextField, self.shipToStateTextField, self.shipToPostalTextField, self.shipToCountryTextField, nil];
    
   
}

- (void)viewWillAppear:(BOOL)animated
{
    NSMutableArray *toolbarItems = [[NSMutableArray alloc] init];
    
    if (self.dataObject.openOrder) {
        
        self.navigationItem.rightBarButtonItem = nil;
        toolbarItems.array = [NSArray arrayWithObjects:self.editButton, self.spacer1, self.selectCustomerButton, self.spacer2, self.nextButton, nil]; 
        
        //get titles
        UINavigationController *masterNC = self.splitViewController.viewControllers[0];
        SCOrderMasterVC *masterVC = (SCOrderMasterVC *)masterNC.topViewController;
        self.title = [masterVC menuItemLabelForVC:self];
        
        [self readOnlyState];
        
        self.customer = self.dataObject.openOrder.customer;
        if (!self.customer) { //if no customers has been loaded, bring up the modal so they can choose
            [self presentCustomerList];
        }
    } else {
        if (self.dataObject.openCustomer) {
            self.title = @"New Customer";
            self.customer = self.dataObject.openCustomer;
            
            //fetch customers names once here, becuase we're saving context everytime user finishes editing.  This should happen before thd default customer name is saved to context. 
            NSError *error = nil;
            self.customerNames = [self.dataObject customerNames:&error];
            if (!self.customerNames) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Proceed With Caution" message:@"Error fetching customer names. Can't validate uniqueness of the Customer Name field." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
            
            //Setup the fallback customer.name and set it as the placeholder text
            NSDate *date = [NSDate date];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *dateString = [dateFormatter stringFromDate:date];
            self.defaultName = [dateString substringFromIndex:3];
            self.nameTextField.placeholder = self.defaultName;
            self.customer.name = self.defaultName;
            [self.dataObject saveContext];

            //Setup bar button items
//            self.navigationItem.rightBarButtonItem.enabled = NO;
//            self.doneButton.enabled = NO;
            toolbarItems.array = [NSArray arrayWithObjects:self.deleteButton, self.spacer1, self.doneButton, nil];
            
        } else {            
            self.title = [NSString stringWithFormat:@"%@ (%@)", self.customer.name, self.customer.status];
            toolbarItems.array = [NSArray arrayWithObjects:self.editButton, nil];

            [self readOnlyState];
        }
    }
    
    if ([self.customer.status isEqual:CUSTOMER_STATUS_SYNCED]) {
        //hide the address titles due to messed upness of QB addresses
        for (UIView *view in self.addressTitles) {
            view.hidden = YES;
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
    
    
    //put all of the textfields into an array (sorted in same way the cells are).  Not working for cells/fields that are non-visible.  
//    for (UITextField *textField in self.textFields) {
//        UIView *cell = textField.superview.superview;
//        CGPoint absolutePoint = [textField convertPoint:textField.bounds.origin toView:textField.superview.superview.superview];
//        CGFloat y = absolutePoint.y;
//        NSLog(@"%f", y);
//    }
    

    
    
    if (!self.dataObject.openCustomer) {
        
//        NSIndexPath *indexPath = [self.tableView indexPathForCell:self.billToPostalCell];
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:6 inSection:4];
//        NSArray *indexPaths = [NSArray arrayWithObjects:indexPath, nil];
//        self.billToPostalCell = nil;
//        [self.tableView beginUpdates];
//        [self loadData];
//        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
//        [self.tableView endUpdates];
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
    [self setDoneButton:nil];
    [self setDeleteButton:nil];
    [self setAddOrderButton:nil];
    [self setNextButton:nil];
    [self setSpacer2:nil];
    [self setNameTextField:nil];
    [self setRepCell:nil];
    [self setTermsCell:nil];
    [self setBillToPostalCell:nil];
    [super viewDidUnload];
}

#pragma mark - Methods to handle hiding of rows from http://stackoverflow.com/questions/8260267/uitableview-set-to-static-cells-is-it-possible-to-hide-some-of-the-cells-progra/9434849#comment23095022_9434849
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.customer.status isEqual:CUSTOMER_STATUS_SYNCED] && section > 2) {
        return [super tableView:tableView numberOfRowsInSection:section] - (self.billToTextFields.count - NUMBER_OF_QB_ADDRESS_LINES);
    } else {
        return [super tableView:tableView numberOfRowsInSection:section];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Recalculate indexPath based on hidden cells
    indexPath = [self offsetIndexPath:indexPath];
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (NSIndexPath*)offsetIndexPath:(NSIndexPath*)indexPath
{
    int offsetSection = indexPath.section; // Also offset section if you intend to hide whole sections
    if ([self.customer.status isEqual:CUSTOMER_STATUS_SYNCED] && offsetSection > 2) {
        int numberOfCellsHiddenAbove = 0; // Calculate how many cells are hidden above the given indexPath.row
        int offsetRow = indexPath.row + numberOfCellsHiddenAbove;
        return [NSIndexPath indexPathForRow:offsetRow inSection:offsetSection];
    } else {
        return indexPath;
    }
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

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //The argument 'string' in this method is actually the string iOS wants to append to the existing textField.text (the keyboard button the user pressed, or what the user pasted).  Returning YES lets it, NO doesn't let it.  So check if string is valid or not.
    
    BOOL allowChange = YES;
    
    if ([textField isEqual:self.nameTextField]) { //dont' allow for :
        
        if (textField.text.length + string.length - range.length > MAX_CUSTOMER_NAME_LENGTH) return NO;
        
        //check invalid characters
        NSCharacterSet *invalidCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@":"];
        NSArray *separatedString = [string componentsSeparatedByCharactersInSet:invalidCharacterSet];
        NSString *validatedString = [separatedString componentsJoinedByString:@""];
        if (![string isEqualToString:validatedString]) return NO;
    }
    
    
        
        
        
    
    return allowChange;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    BOOL returnValue = YES;
    
    //Validate name
    if ([textField isEqual:self.nameTextField]) {
        if (textField.text.length == 0) {
            self.customer.name = self.defaultName;
            [self.dataObject saveContext];
        } else {
            if ([self customerNameIsUnique:textField.text]) {
                self.customer.name = textField.text;
            } else {
                returnValue = NO;
            }
        }
    }
    
    //Validate email from http://stackoverflow.com/questions/3139619/check-that-an-email-address-is-valid-on-ios
    if ([textField isEqual:self.emailTextField]) {
        if (textField.text.length != 0 && ![SCGlobal stringIsValidEmail:textField.text]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email Doesn't Look Valid" message:@"Please check the email address to make sure it's valid." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            returnValue = NO;
        }
    }
    return returnValue;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //customer.name is saved in textFieldShouldEndEditing
    if ([textField isEqual:self.dbaNameTextField])  self.customer.dbaName = textField.text;
    if ([textField isEqual:self.firstNameTextField]) self.customer.givenName = textField.text;
    if ([textField isEqual:self.lastNameTextField]) self.customer.familyName = textField.text;
    
    if ([textField isEqual:self.phoneTextField]) [self.dataObject savePhoneNumber:textField.text withTag:MAIN_PHONE_TAG forCustomer:self.customer];
    if ([textField isEqual:self.faxTextField]) [self.dataObject savePhoneNumber:textField.text withTag:FAX_PHONE_TAG forCustomer:self.customer];
    if ([textField isEqual:self.emailTextField]) [self.dataObject saveEmail:textField.text forCustomer:self.customer];
    
    if ([textField isEqual:self.billTo1TextField]) self.customer.primaryBillingAddress.line1 = textField.text;
    if ([textField isEqual:self.billTo2TextField]) self.customer.primaryBillingAddress.line2 = textField.text;
    if ([textField isEqual:self.billTo3TextField]) self.customer.primaryBillingAddress.line3 = textField.text;
    if ([textField isEqual:self.billToCityTextField]) self.customer.primaryBillingAddress.city = textField.text;
    if ([textField isEqual:self.billToStateTextField]) self.customer.primaryBillingAddress.countrySubDivisionCode = textField.text;
    if ([textField isEqual:self.billToCountryTextField]) self.customer.primaryBillingAddress.country = textField.text;
    if ([textField isEqual:self.billToPostalTextField]) self.customer.primaryBillingAddress.postalCode = textField.text;
    
    if ([textField isEqual:self.shipTo1TextField]) self.customer.primaryShippingAddress.line1 = textField.text;
    if ([textField isEqual:self.shipTo2TextField]) self.customer.primaryShippingAddress.line2 = textField.text;
    if ([textField isEqual:self.shipTo3TextField]) self.customer.primaryShippingAddress.line3 = textField.text;
    if ([textField isEqual:self.shipToCityTextField]) self.customer.primaryShippingAddress.city = textField.text;
    if ([textField isEqual:self.shipToStateTextField]) self.customer.primaryShippingAddress.countrySubDivisionCode = textField.text;
    if ([textField isEqual:self.shipToCountryTextField]) self.customer.primaryShippingAddress.country = textField.text;
    if ([textField isEqual:self.shipToPostalTextField]) self.customer.primaryShippingAddress.postalCode = textField.text;
    
    [self.dataObject saveContext];
    self.activeCell = nil;
}

#pragma mark - UIAlertView Delegates
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ([alertView isEqual:self.validateCompanyNameAlert]) [self.dbaNameTextField becomeFirstResponder];
        
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
    
    CGFloat insetsPadding = 5; //some extra padding to lift the cell up a bit higher
    CGFloat insetsHeight = keyboardSize.width + insetsPadding; //Good for iPad landscape always mode.  Otherwise need to check orientations and get the height accordingly.
        
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
    if (!self.dataObject.openCustomer) self.nameTextField.text = self.customer.name;
    
    self.dbaNameTextField.text = self.customer.dbaName;
    self.firstNameTextField.text = self.customer.givenName;
    self.lastNameTextField.text = self.customer.familyName;

    self.phoneTextField.text = [self.customer phoneForTag:MAIN_PHONE_TAG];
    self.faxTextField.text = [self.customer phoneForTag:FAX_PHONE_TAG];
    self.emailTextField.text = [self.customer mainEmail];
    
    self.repLabel.text = self.customer.salesRep.name;
    self.termsLabel.text = self.customer.salesTerms.name;
    
    
    NSArray *customerBillToLines = [self.customer.primaryBillingAddress lines];
        
    NSInteger maxNumberOfLines = self.billToTextFields.count;
    if ([self.customer.status isEqual:CUSTOMER_STATUS_SYNCED]) maxNumberOfLines = NUMBER_OF_QB_ADDRESS_LINES;
        
    for (NSInteger i = 0; i < MIN(customerBillToLines.count, maxNumberOfLines) ; i++) {
        UILabel *label = self.billToTextFields[i];
        label.text = customerBillToLines[i];
    }
    NSArray *customerShipToLines = [self.customer.primaryShippingAddress lines];
    
    for (NSInteger i = 0; i < MIN(customerShipToLines.count, maxNumberOfLines); i++) {
        UILabel *label = self.shipToTextFields[i];
        label.text = customerShipToLines[i];
    }
    
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

- (void)readOnlyState
{
    //disable user interaction
    for (UITableViewCell *cell in self.cells) {
        cell.userInteractionEnabled = NO;
    }
    
    //disable clear button
    for (UITextField *textField in self.textFields) {
        textField.clearButtonMode = UITextFieldViewModeNever;
    }
    
    //disable detail indicators
    for (UITableViewCell *cell in self.popoverCells) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}

- (BOOL)customerNameIsUnique:(NSString *)name
{
    for (NSString *customerName in self.customerNames) {
        if ([name isEqualToString:customerName]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Duplicate Customer Name" message:@"Please use a unique customer name, or leave blank." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            return NO;
        }
    }
    return YES;
}

- (BOOL)isCompanyNameValid
{
    if (self.dbaNameTextField.text.length == 0) {
        self.validateCompanyNameAlert = [[UIAlertView alloc] initWithTitle:@"Company Name Needed" message:@"Please enter a company name before proceeding." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [self.validateCompanyNameAlert show];
        return NO;
    } else {
        return YES;
    }
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
    if (self.dataObject.openCustomer) {
        if ([self isCompanyNameValid]) {
            self.dataObject.openCustomer = nil;
            [self.delegate passAddOrderWithCustomer:self.customer];
        }
    } else {
        UINavigationController *masterNC = self.splitViewController.viewControllers[0];
        SCLookMasterVC *masterVC = (SCLookMasterVC *)masterNC.topViewController;
        [masterVC startOrderModeWithCustomer:self.customer];
    }
}

- (IBAction)selectCustomerButtonPress:(UIBarButtonItem *)sender {
    [self presentCustomerList];
}

- (IBAction)deleteButtonPress:(UIBarButtonItem *)sender {
    [self.dataObject deleteObject:self.dataObject.openCustomer];
    self.dataObject.openCustomer = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doneButtonPress:(UIBarButtonItem *)sender {
    if ([self isCompanyNameValid]) {
        self.dataObject.openCustomer = nil;
        [self.delegate passSavedCustomer:self.customer];
    }
    
    
}

- (IBAction)editButtonPress:(UIBarButtonItem *)sender {
}
@end
