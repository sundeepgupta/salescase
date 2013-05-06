//
//  SCOrderDetailVC.m
//  SalesCaseAlpha
//
//  Created by Sundeep Gupta on 13-03-19.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "SCOrderDetailVC.h"
#import "SCGlobal.h"
#import "SCOrderMasterVC.h"
#import "SCConfirmDeleteVC.h"
#import "SCEmailOrderVC.h"
#import "SCDataObject.h"
#import "SCOrder.h"
#import "SCCustomerDetailVC.h"
#import "SCCustomer.h"
#import "SCShipMethod.h"
#import "SCSalesRep.h"
#import "SCSalesTerm.h"
#import "SCLookMasterVC.h"
#import "SCOrderDetailTableCell.h"
#import "SCItemCartVC.h"
#import <QuartzCore/QuartzCore.h>
#import "SCOrderPDFVC.h"


@interface SCOrderDetailVC ()

@property (strong, nonatomic) SCGlobal *global;
@property (strong, nonatomic) SCDataObject *dataObject;
@property (strong, nonatomic) UIPopoverController *deleteOrderPC;
@property (strong, nonatomic) UIPopoverController *emailOrderPC;
@property (strong, nonatomic) NSArray *lines;

//IB Stuff
@property (strong, nonatomic) IBOutlet UIButton *editButton;
@property (strong, nonatomic) IBOutlet UILabel *customerNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *companyNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *repLabel;
@property (strong, nonatomic) IBOutlet UILabel *shipDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *shipViaLabel;
@property (strong, nonatomic) IBOutlet UILabel *termsLabel;
@property (strong, nonatomic) IBOutlet UILabel *poNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *contactNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *orderDateLabel;
@property (strong, nonatomic) IBOutlet UITextView *notesTextView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *orderTotalLabel;

@end

@implementation SCOrderDetailVC

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
    
    //Apply a border around the table view
    self.tableView.layer.borderWidth = 1.0;
    self.tableView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.tableView.layer.cornerRadius = 10;
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.global.dataObject.openOrder) {
        self.editButton.hidden = YES;
        self.order = self.dataObject.openOrder;

        //get titles
        UINavigationController *masterNC = self.splitViewController.viewControllers[0];
        SCOrderMasterVC *masterVC = (SCOrderMasterVC *)masterNC.topViewController;
        self.title = [masterVC menuItemLabelForVC:self];
        
    } else {
        self.title = [self titleString];
        if ([self.order.status isEqualToString:SYNCED_STATUS]) {
            self.editButton.hidden = YES;
        }
    }
    
    self.lines = self.order.lines.allObjects;
    [self loadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    if (self.global.dataObject.openOrder) {
        UINavigationController *masterNC = self.splitViewController.viewControllers[0];
        SCOrderMasterVC *masterVC = (SCOrderMasterVC *)masterNC.topViewController;
        [masterVC processAppearedDetailVC:self];
    }
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
    [self setEditButton:nil];
    [self setCustomerNameLabel:nil];
    [self setCompanyNameLabel:nil];
    [self setRepLabel:nil];
    [self setShipDateLabel:nil];
    [self setShipViaLabel:nil];
    [self setTermsLabel:nil];
    [self setPoNumberLabel:nil];
    [self setContactNameLabel:nil];
    [self setOrderDateLabel:nil];
    [self setNotesTextView:nil];
    [self setOrderTotalLabel:nil];
    [super viewDidUnload];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.lines.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCLine *line = [self.lines objectAtIndex:indexPath.row];
    static NSString *CellIdentifier = @"SCOrderDetailTableCell";
    SCOrderDetailTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.nameLabel.text = line.item.name;
    cell.descriptionLabel.text = line.item.itemDescription;
    cell.quantityLabel.text = [line.quantity stringValue];
    cell.priceLabel.text = [SCGlobal stringFromDollarAmount:[line.price floatValue]];
    cell.amountLabel.text = [SCGlobal stringFromDollarAmount:[line amount]];

    return cell;
}


#pragma mark - Custom Methods
- (NSString *)titleString
{
    NSString *status = [self.order fullStatus];
    return [NSString stringWithFormat:@"Order #%@ (%@)", self.order.scOrderId, status];
}

-(NSString *)formatString:(NSString *)stringToFormat
{
    if (stringToFormat)
    {
        return stringToFormat;
    }
    else
    {
        return @"";
    }
}


- (void)loadData
{
    self.customerNameLabel.text = [self formatString:self.order.customer.name];
    self.companyNameLabel.text = [self formatString:self.order.customer.dbaName ];
    self.contactNameLabel.text = [NSString stringWithFormat:@"%@ %@ %@%@", [self formatString:self.order.customer.title], [self formatString:self.order.customer.givenName ], self.order.customer.middleName ? [NSString stringWithFormat:@"%@ ", self.order.customer.middleName] : @"", [self formatString:self.order.customer.familyName]];
    self.orderDateLabel.text = [self formatString:[SCGlobal stringFromDate:self.order.createDate]];
    self.shipDateLabel.text = [self formatString:[SCGlobal stringFromDate:self.order.shipDate] ];
    self.shipViaLabel.text = [self formatString:self.order.shipMethod.name];
    self.repLabel.text = [self formatString:self.order.salesRep.name];
    self.poNumberLabel.text = [self formatString:self.order.poNumber];
    self.termsLabel.text = [self formatString:self.order.salesTerm.name];
    self.notesTextView.text = [self formatString:self.order.orderDescription];
    self.orderTotalLabel.text = [NSString stringWithFormat:@"Total $%.2f", [self.order totalAmount]];
    [self.tableView reloadData];
}

#pragma mark - DeleteOrder delegate
- (void)passConfirmDeleteButtonPress
{
    [self.dataObject deleteObject:self.order];
    //Go back to Look Mode, or pop back to OrdersVC
    if (self.global.dataObject.openOrder) {        
        UINavigationController *masterNC = self.splitViewController.viewControllers[0];
        SCOrderMasterVC *masterVC = (SCOrderMasterVC *)masterNC.topViewController;
        [masterVC closeOrderMode];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    [self.deleteOrderPC dismissPopoverAnimated:YES];
}

#pragma mark - IB Methods
- (IBAction)deleteButtonPress:(UIButton *)sender {
    SCConfirmDeleteVC *deleteOrderVC = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([SCConfirmDeleteVC class])];
    self.deleteOrderPC = [[UIPopoverController alloc] initWithContentViewController:deleteOrderVC];
    deleteOrderVC.delegate = self;
    [self.deleteOrderPC presentPopoverFromRect:sender.bounds inView:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)editButtonPress:(UIButton *)sender {
    //only visible in look mode and when not synced
    UINavigationController *masterNC = self.splitViewController.viewControllers[0];
    SCLookMasterVC *masterVC = (SCLookMasterVC *)masterNC.topViewController;
    [masterVC startOrderModeWithOrder:self.order];
}

- (IBAction)emailButtonPress:(UIButton *)sender {
    SCEmailOrderVC *emailOrderVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SCEmailOrderVC"];
    self.emailOrderPC = [[UIPopoverController alloc] initWithContentViewController:emailOrderVC];
//    emailOrderVC.myPC = self.emailOrderPC;
//    emailOrderVC.order = self.order;
    [self.emailOrderPC presentPopoverFromRect:sender.bounds inView:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)printButtonPress:(UIButton *)sender {
    SCOrderPDFVC *vC = [self.storyboard instantiateViewControllerWithIdentifier:@"SCOrderPDFVC"];
    vC.order = self.order;
    [self.navigationController pushViewController:vC animated:YES];
}



@end
