//
//  SCNewCustomerVC.m
//  SalesCase
//
//  Created by Sundeep Gupta on 13-04-15.
//  Copyright (c) 2013 EnhanceTrade. All rights reserved.
//

#import "SCNewCustomerVC.h"
#import "SCCustomer.h"
#import "SCPopoverCell.h"
#import "SCTextCell.h"
#import "SCSalesRep.h"
#import "SCSalesTerm.h"
#import "SCGlobal.h"
#import "SCDataObject.h"
#import "SCPopoverTableVC.h"

static NSString *const kRowTitle = @"FieldTitle";
static NSString *const kRowValue = @"FieldValue";
static NSString *const kSectionTitle = @"SectionTitle";
static NSString *const kSectionRows = @"SectionRows";
static NSString *const kCellId = @"CellId";
static NSString *const kPopoverCell = @"SCPopoverCell";
static NSString *const kTextCell = @"SCTextCell";

@interface SCNewCustomerVC ()
@property (strong, nonatomic) SCGlobal *global;
@property (strong, nonatomic) SCDataObject *dataObject;
@property (strong, nonatomic) NSArray *sections;
@property (strong, nonatomic) UIPopoverController *popoverTablePC;

//IB
@property (strong, nonatomic) IBOutlet UIButton *captureImageButton;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation SCNewCustomerVC

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
}

- (void)viewWillAppear:(BOOL)animated
{
    //Build the sections array
    //Section 0
    NSMutableDictionary *row00 = [NSMutableDictionary dictionaryWithObjectsAndKeys:kTextCell, kCellId, @"Customer Name", kRowTitle, self.customer.name, kRowValue, nil];
    NSMutableDictionary *row01 = [NSMutableDictionary dictionaryWithObjectsAndKeys:kTextCell, kCellId, @"Company Name", kRowTitle, self.customer.dbaName, kRowValue, nil];
    
    NSArray *rows0 = [NSArray arrayWithObjects:row00, row01, nil];
    
    NSMutableDictionary *section0 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"", kSectionTitle, rows0, kSectionRows, nil];
    
    
    //Section 1
    NSMutableDictionary *row10 = [NSMutableDictionary dictionaryWithObjectsAndKeys:kTextCell, kCellId, @"Salutation", kRowTitle, self.customer.title, kRowValue, nil];
    NSMutableDictionary *row11 = [NSMutableDictionary dictionaryWithObjectsAndKeys:kPopoverCell, kCellId, @"Rep", kRowTitle, self.customer.salesRep, kRowValue, nil];
    
    NSArray *rows1 = [NSArray arrayWithObjects:row10, row11, nil];
    
    NSMutableDictionary *section1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Contact", kSectionTitle, rows1, kSectionRows, nil];
    
    
    
    
    
    
    
    
    self.sections = [NSArray arrayWithObjects:section0, section1, nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *theSection = self.sections[section];
    NSArray *theRows = theSection[kSectionRows];
    return theRows.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *theSection = self.sections[section];
    if ([theSection[kSectionTitle] length] != 0)
        return theSection[kSectionTitle];
    else
        return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *row = [self rowAtIndexPath:indexPath];
    NSString *CellIdentifier = row[kCellId];
    
    if ([CellIdentifier isEqualToString:kPopoverCell]) {
        SCPopoverCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.title.text = row[kRowTitle];
        cell.value.text = row[kRowValue];
        return cell;
    } else if ([CellIdentifier isEqualToString:kTextCell]) {
        SCTextCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.title.text = row[kRowTitle];
        cell.value.text = row[kRowValue];
        return cell;
    } else {
        //error
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        return cell;
    }
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *row = [self rowAtIndexPath:indexPath];
    
    if ([row[kCellId] isEqualToString:kPopoverCell]) {
//        id rowValue = row[kRowValue];
        NSMutableArray *dataArray = nil;
        NSString *objectType = nil;
        if ([row[kRowValue] isKindOfClass:[SCSalesRep class]]) {
            [dataArray addObjectsFromArray:[self.dataObject fetchAllObjectsOfType:ENTITY_SCSALESREP]];
            objectType = ENTITY_SCSALESREP;
        }
        
        [self showPopoverTableWithArray:dataArray withObjectType:objectType fromIndexPath:indexPath];
        
        
    }
}

#pragma mark - Protocol methods
- (void)passObject:(id)object withObjectType:(NSString *)objectType withIndexPath:(NSIndexPath *)indexPath
{
    SCPopoverCell *cell = (SCPopoverCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    
    if (objectType == ENTITY_SCSALESREP) {
        if ([object isKindOfClass:[NSString class]]) {
            cell.value.text = object;
            self.customer.salesRep = nil;
        } else {
            SCSalesRep *castedObject = (SCSalesRep *)object;
            cell.value.text = castedObject.name;
            self.customer.salesRep = object;
        }
//    } else if (objectType == ENTITY_SCSALESTERM) {
//        if ([object isKindOfClass:[NSString class]]) {
//            [self.termsButton setTitle:object forState:UIControlStateNormal];
//            self.dataObject.openOrder.salesTerm = nil;
//        } else {
//            SCSalesTerm *castedObject = (SCSalesTerm *)object;
//            [self.termsButton setTitle:castedObject.name forState:UIControlStateNormal];
//            self.dataObject.openOrder.salesTerm = object;
//        }
//    } else if (objectType == ENTITY_SCSHIPMETHOD) {
//        if ([object isKindOfClass:[NSString class]]) {
//            [self.shipViaButton setTitle:object forState:UIControlStateNormal];
//            self.dataObject.openOrder.shipMethod = nil;
//        } else {
//            SCShipMethod *castedObject = (SCShipMethod *)object;
//            [self.shipViaButton setTitle:castedObject.name forState:UIControlStateNormal];
//            self.dataObject.openOrder.shipMethod = object;
//        }
//    } else {
//        NSLog(@"Button object type passed back from the table is not being handled for in passObject method.");
    }
//    [self.dataObject saveOrder:self.dataObject.openOrder];
}

#pragma mark - Custom Methods
- (void)showPopoverTableWithArray:(NSArray *)dataArray withObjectType:(NSString *)objectType fromIndexPath:(NSIndexPath *)indexPath
{
    SCPopoverTableVC *vC = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([SCPopoverTableVC class])];
    self.popoverTablePC = [[UIPopoverController alloc] initWithContentViewController:vC];
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
    NSArray *rows = section[kSectionRows];
    return rows[indexPath.row];
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

#pragma mark - Image Picker Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //get and save the image
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [self.captureImageButton setImage:image forState:UIControlStateNormal];
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    self.customer.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - IB Methods
- (IBAction)captureButtonPress:(UIButton *)sender {
    [self captureImage];
}
- (void)viewDidUnload {
    [self setCaptureImageButton:nil];
    [super viewDidUnload];
}
@end
