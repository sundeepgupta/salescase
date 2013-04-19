//
//  SCCustomerDetailVC.h
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

static NSString *const ROW_TITLE = @"FieldTitle";
static NSString *const ROW_OBJECT = @"FieldValue";
static NSString *const SECTION_TITLE = @"SectionTitle";
static NSString *const SECTION_ROWS = @"SectionRows";
static NSString *const CELL_ID = @"CellId";
static NSString *const POPOVER_CELL = @"SCPopoverCell";
static NSString *const TEXT_CELL = @"SCTextCell";

@interface SCCustomerDetailVC ()
@property (strong, nonatomic) SCGlobal *global;
@property (strong, nonatomic) SCDataObject *dataObject;
@property (strong, nonatomic) NSMutableArray *sections;
@property (strong, nonatomic) UIPopoverController *popoverTablePC;
@property (strong, nonatomic) UITableViewCell *activeCell;

//IB
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addOrderButton;
@property (strong, nonatomic) IBOutlet UIButton *captureImageButton;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *nextButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *selectCustomerButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *spacer1;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *spacer2;

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
            
            self.navigationItem.rightBarButtonItem = nil;
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
    [super viewDidUnload];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *theSection = self.sections[section];
    NSArray *theRows = theSection[SECTION_ROWS];
    return theRows.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *theSection = self.sections[section];
    if ([theSection[SECTION_TITLE] length] != 0)
        return theSection[SECTION_TITLE];
    else
        return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *row = [self rowAtIndexPath:indexPath];
    NSString *CellIdentifier = row[CELL_ID];
    
    if ([CellIdentifier isEqualToString:POPOVER_CELL]) {
        SCPopoverCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.title.text = row[ROW_TITLE];
        id rowObject = row[ROW_OBJECT];
        
        if ([rowObject isKindOfClass:[SCSalesRep class]]) {
            SCSalesRep *castedRowObject = (SCSalesRep *)rowObject;
            cell.value.text = castedRowObject.name;
        } else if ([rowObject isKindOfClass:[SCSalesTerm class]]) {
            SCSalesTerm *castedRowObject = (SCSalesTerm *)rowObject;
            cell.value.text = castedRowObject.name;
        }
        
        if (self.dataObject.openCustomer) {
            cell.userInteractionEnabled = YES;
        }
        
        return cell;
    } else { //must be a text cell
        SCTextCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.title.text = row[ROW_TITLE];
        cell.value.text = row[ROW_OBJECT];
        
        if (self.dataObject.openCustomer) {
            cell.userInteractionEnabled = YES;
        }
        return cell;
    }
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *row = [self rowAtIndexPath:indexPath];
    
    if ([row[CELL_ID] isEqualToString:POPOVER_CELL]) {
        NSString *objectType = nil;
        NSMutableArray *dataArray = [[NSMutableArray alloc] init];
        if ([row[ROW_OBJECT] isKindOfClass:[SCSalesRep class]]) {
            dataArray.array = [self.dataObject fetchAllObjectsOfType:ENTITY_SCSALESREP];
            objectType = ENTITY_SCSALESREP;
        } else { //it must be SalesTerm
            dataArray.array = [self.dataObject fetchAllObjectsOfType:ENTITY_SCSALESTERM];
            objectType = ENTITY_SCSALESTERM;
        }
        [self showPopoverTableWithArray:dataArray withObjectType:objectType fromIndexPath:indexPath];
    } else { //must be a text cell
        
    }
//    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - TextField Delegates
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //only one textField so no need to check
//    [self.notesTextView becomeFirstResponder];
    return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeCell = (UITableViewCell*) [textField.superview superview];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.activeCell = nil;
}

#pragma mark - Protocol methods
- (void)passObject:(id)object withObjectType:(NSString *)objectType withIndexPath:(NSIndexPath *)indexPath
{
    SCPopoverCell *cell = (SCPopoverCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    if ([objectType isEqualToString:ENTITY_SCSALESREP]) {
        if ([object isKindOfClass:[NSString class]]) { //means the "empty" rep selected
            cell.value.text = object;
            self.customer.salesRep = nil;
        } else {
            SCSalesRep *castedObject = (SCSalesRep *)object;
            cell.value.text = castedObject.name;
            self.customer.salesRep = object;
        }
    } else if ([objectType isEqualToString:ENTITY_SCSALESTERM]) {
        if ([object isKindOfClass:[NSString class]]) { //means the "empty" rep selected
            cell.value.text = object;
            self.customer.salesTerms = nil;
        } else {
            SCSalesTerm *castedObject = (SCSalesTerm *)object;
            cell.value.text = castedObject.name;
            self.customer.salesTerms = object;
        }
    } else {
        NSLog(@"Object type passed back from the table is not being handled for in passObject method.");
    }
    [self.popoverTablePC dismissPopoverAnimated:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    for (NSInteger sectionNumber = 0; sectionNumber < self.sections.count; sectionNumber++) {
        NSArray *sectionRows = self.sections[sectionNumber][SECTION_ROWS];
        for (NSInteger rowNumber = 0; rowNumber < sectionRows.count; rowNumber++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowNumber inSection:sectionNumber];
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    }
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
    self.sections = [[NSMutableArray alloc] init];
    //Build the sections array
    //Section 0
    NSMutableDictionary *row00 = [NSMutableDictionary dictionaryWithObjectsAndKeys:TEXT_CELL, CELL_ID, @"Customer Name", ROW_TITLE, self.customer.name, ROW_OBJECT, nil];
    NSMutableDictionary *row01 = [NSMutableDictionary dictionaryWithObjectsAndKeys:TEXT_CELL, CELL_ID, @"Company Name", ROW_TITLE, self.customer.dbaName, ROW_OBJECT, nil];
    NSMutableDictionary *row02 = [NSMutableDictionary dictionaryWithObjectsAndKeys:TEXT_CELL, CELL_ID, @"First Name", ROW_TITLE, self.customer.givenName, ROW_OBJECT, nil];
    NSMutableDictionary *row03 = [NSMutableDictionary dictionaryWithObjectsAndKeys:TEXT_CELL, CELL_ID, @"Last Name", ROW_TITLE, self.customer.familyName, ROW_OBJECT, nil];
    NSArray *rows0 = [NSArray arrayWithObjects:row00, row01, row02, row03, nil];
    NSMutableDictionary *section0 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"", SECTION_TITLE, rows0, SECTION_ROWS, nil];
    [self.sections addObject:section0];
    
    //Section 1
    NSMutableDictionary *row10 = [NSMutableDictionary dictionaryWithObjectsAndKeys:TEXT_CELL, CELL_ID, @"Phone", ROW_TITLE, [self.customer phoneForTag:MAIN_PHONE_TAG] , ROW_OBJECT, nil];
    NSMutableDictionary *row11 = [NSMutableDictionary dictionaryWithObjectsAndKeys:TEXT_CELL, CELL_ID, @"Fax", ROW_TITLE, [self.customer phoneForTag:FAX_PHONE_TAG], ROW_OBJECT, nil];
    NSMutableDictionary *row12 = [NSMutableDictionary dictionaryWithObjectsAndKeys:TEXT_CELL, CELL_ID, @"Email", ROW_TITLE, [self.customer mainEmail], ROW_OBJECT, nil];
    NSArray *rows1 = [NSArray arrayWithObjects:row10, row11, row12, nil];
    NSMutableDictionary *section1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"", SECTION_TITLE, rows1, SECTION_ROWS, nil];
    [self.sections addObject:section1];
    
    //Secion 2
    NSMutableDictionary *row20 = [NSMutableDictionary dictionaryWithObjectsAndKeys:POPOVER_CELL, CELL_ID, @"Rep", ROW_TITLE, self.customer.salesRep, ROW_OBJECT, nil];
    NSMutableDictionary *row21 = [NSMutableDictionary dictionaryWithObjectsAndKeys:POPOVER_CELL, CELL_ID, @"Terms", ROW_TITLE, self.customer.salesTerms, ROW_OBJECT, nil];
    NSArray *rows2 = [NSArray arrayWithObjects:row20, row21, nil];
    NSMutableDictionary *section2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"", SECTION_TITLE, rows2, SECTION_ROWS, nil];
    [self.sections addObject:section2];
    
    //Section 3
    if (self.dataObject.openCustomer) {
        NSMutableDictionary *rowBillTo1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:TEXT_CELL, CELL_ID, @"Line 1", ROW_TITLE, self.dataObject.openCustomer.primaryBillingAddress.line1, ROW_OBJECT, nil];
        NSMutableDictionary *rowBillTo2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:TEXT_CELL, CELL_ID, @"Line 2", ROW_TITLE, self.dataObject.openCustomer.primaryBillingAddress.line2, ROW_OBJECT, nil];
        NSMutableDictionary *rowBillTo3 = [NSMutableDictionary dictionaryWithObjectsAndKeys:TEXT_CELL, CELL_ID, @"Line 3", ROW_TITLE, self.dataObject.openCustomer.primaryBillingAddress.line3, ROW_OBJECT, nil];
        NSMutableDictionary *rowBillToCity = [NSMutableDictionary dictionaryWithObjectsAndKeys:TEXT_CELL, CELL_ID, @"City", ROW_TITLE, self.dataObject.openCustomer.primaryBillingAddress.city, ROW_OBJECT, nil];
        NSMutableDictionary *rowBillToState = [NSMutableDictionary dictionaryWithObjectsAndKeys:TEXT_CELL, CELL_ID, @"State/Province", ROW_TITLE, self.dataObject.openCustomer.primaryBillingAddress.countrySubDivisionCode, ROW_OBJECT, nil];
        NSMutableDictionary *rowBillToPostal = [NSMutableDictionary dictionaryWithObjectsAndKeys:TEXT_CELL, CELL_ID, @"Zip/Postal Code", ROW_TITLE, self.dataObject.openCustomer.primaryBillingAddress.postalCode, ROW_OBJECT, nil];
        NSMutableDictionary *rowBillToCountry = [NSMutableDictionary dictionaryWithObjectsAndKeys:TEXT_CELL, CELL_ID, @"Country", ROW_TITLE, self.dataObject.openCustomer.primaryBillingAddress.country, ROW_OBJECT, nil];
        NSArray *rowsBillTo = [NSArray arrayWithObjects:rowBillTo1, rowBillTo2, rowBillTo3, rowBillToCity, rowBillToState, rowBillToPostal, rowBillToCountry, nil];
        NSMutableDictionary *sectionBillTo = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Bill To", SECTION_TITLE, rowsBillTo, SECTION_ROWS, nil];
        [self.sections addObject:sectionBillTo];
    } else {
        NSArray *billToLines = [self.customer.primaryBillingAddress addressBlock];
        NSMutableArray *rows3 = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < billToLines.count; i++) {
            NSMutableDictionary *line = [NSMutableDictionary dictionaryWithObjectsAndKeys:TEXT_CELL, CELL_ID, @"", ROW_TITLE, billToLines[i], ROW_OBJECT, nil];
            [rows3 addObject:line];
        }
        NSMutableDictionary *section3 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Bill To", SECTION_TITLE, rows3, SECTION_ROWS, nil];
        [self.sections addObject:section3];
    }
    
    //Section 4
    if (self.dataObject.openCustomer) {
        NSMutableDictionary *rowShipTo1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:TEXT_CELL, CELL_ID, @"Line 1", ROW_TITLE, self.dataObject.openCustomer.primaryShippingAddress.line1, ROW_OBJECT, nil];
        NSMutableDictionary *rowShipTo2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:TEXT_CELL, CELL_ID, @"Line 2", ROW_TITLE, self.dataObject.openCustomer.primaryShippingAddress.line2, ROW_OBJECT, nil];
        NSMutableDictionary *rowShipTo3 = [NSMutableDictionary dictionaryWithObjectsAndKeys:TEXT_CELL, CELL_ID, @"Line 3", ROW_TITLE, self.dataObject.openCustomer.primaryShippingAddress.line3, ROW_OBJECT, nil];
        NSMutableDictionary *rowShipToCity = [NSMutableDictionary dictionaryWithObjectsAndKeys:TEXT_CELL, CELL_ID, @"City", ROW_TITLE, self.dataObject.openCustomer.primaryShippingAddress.city, ROW_OBJECT, nil];
        NSMutableDictionary *rowShipToState = [NSMutableDictionary dictionaryWithObjectsAndKeys:TEXT_CELL, CELL_ID, @"State/Province", ROW_TITLE, self.dataObject.openCustomer.primaryShippingAddress.countrySubDivisionCode, ROW_OBJECT, nil];
        NSMutableDictionary *rowShipToPostal = [NSMutableDictionary dictionaryWithObjectsAndKeys:TEXT_CELL, CELL_ID, @"Zip/Postal Code", ROW_TITLE, self.dataObject.openCustomer.primaryShippingAddress.postalCode, ROW_OBJECT, nil];
        NSMutableDictionary *rowShipToCountry = [NSMutableDictionary dictionaryWithObjectsAndKeys:TEXT_CELL, CELL_ID, @"Country", ROW_TITLE, self.dataObject.openCustomer.primaryShippingAddress.country, ROW_OBJECT, nil];
        NSArray *rowsShipTo = [NSArray arrayWithObjects:rowShipTo1, rowShipTo2, rowShipTo3, rowShipToCity, rowShipToState, rowShipToPostal, rowShipToCountry, nil];
        NSMutableDictionary *sectionShipTo = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Ship To", SECTION_TITLE, rowsShipTo, SECTION_ROWS, nil];
        [self.sections addObject:sectionShipTo];
    } else {
        NSArray *shipToLines = [self.customer.primaryShippingAddress addressBlock];
        if (shipToLines.count != 0) {
            NSMutableArray *rows4 = [[NSMutableArray alloc] init];
            for (NSInteger i = 0; i < shipToLines.count; i++) {
                NSMutableDictionary *line = [NSMutableDictionary dictionaryWithObjectsAndKeys:TEXT_CELL, CELL_ID, @"", ROW_TITLE, shipToLines[i], ROW_OBJECT, nil];
                [rows4 addObject:line];
            }
            NSMutableDictionary *section4 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Ship To", SECTION_TITLE, rows4, SECTION_ROWS, nil];
            [self.sections addObject:section4];
        }
    }
    
    [self.tableView reloadData];
}



- (void)showPopoverTableWithArray:(NSArray *)dataArray withObjectType:(NSString *)objectType fromIndexPath:(NSIndexPath *)indexPath
{
    SCPopoverTableVC *vC = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([SCPopoverTableVC class])];
    self.popoverTablePC = [[UIPopoverController alloc] initWithContentViewController:vC];
    self.popoverTablePC.delegate = self;
    vC.dataArray = dataArray;
    vC.objectType = objectType;
    vC.delegate = self;
    vC.parentIndexPath = indexPath;
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
//    CGRect *cellBounds = cell.bounds;
    [self.popoverTablePC presentPopoverFromRect:cell.bounds inView:cell permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (NSDictionary *)rowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *section = self.sections[indexPath.section];
    NSArray *rows = section[SECTION_ROWS];
    return rows[indexPath.row];
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
    self.dataObject.openCustomer = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveButtonPress:(UIBarButtonItem *)sender {

    
    
    
    
    
    
    
    
}

- (IBAction)editButtonPress:(UIBarButtonItem *)sender {
}
@end
