//
//  SCCustomersVC.m
//  SalesCaseAlpha
//
//  Created by Sundeep Gupta on 13-03-05.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "SCCustomersVC.h"
#import "SCGlobal.h"
#import "SCCustomerDetailVC.h"
#import "SCCustomerTableCell.h"
#import "SCDataObject.h"
#import "SCCustomer.h"
#import "SCLookMasterVC.h"
#import "SCCustomerDetailVC.h"

@interface SCCustomersVC ()

@property (strong, nonatomic) SCGlobal *global;
@property (nonatomic, strong) NSArray *customers;
@property (strong) NSMutableArray *filteredCells;
@property BOOL isFiltered;

@property (strong, nonatomic) NSMutableArray *sections;

//IB stuff
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *closeModalButton;

@end

@implementation SCCustomersVC

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
        
    [SCDesignHelpers customizeTableView:self.tableView];

}

- (void)viewWillAppear:(BOOL)animated
{
    self.customers = [self.global.dataObject fetchCustomersInContext];
    
    
    //Making an index list.  Come back to this as we need to think about UI with search bar.  See Apple's Contacts app.  http://developer.apple.com/library/ios/#documentation/UserExperience/Conceptual/TableView_iPhone/CreateConfigureTableView/CreateConfigureTableView.html
//    NSArray *indexTitles = [SCGlobal alphabetIndex];
//    self.sections = [[NSMutableArray alloc] init];
//    for (NSInteger i = 0; i < indexTitles.count; i++) {
//        //create and fill the child array with all the customers beginning with the same letter
//        NSMutableArray *rows = [[NSMutableArray alloc] init];
//        for (SCCustomer *customer in self.customers) {
//            NSString *customerFirstChar = [customer.dbaName substringToIndex:1];
//            if ([customerFirstChar isEqualToString:indexTitles[i]]) {
//                [rows addObject:customer];
//            }
//        }
//        [self.sections addObject:rows];
//    }

    
    
    [self.tableView reloadData];
    
    if (self.global.dataObject.openOrder) {
        self.title = @"Select Customer";
        self.navigationItem.rightBarButtonItem = nil;
    } else {
        //get titles
        UINavigationController *masterNC = self.splitViewController.viewControllers[0];
        SCLookMasterVC *masterVC = (SCLookMasterVC *)masterNC.topViewController;
        self.title = [masterVC menuItemLabelForVC:self]; 
        
        //Hide the close button used for modal in order mode.
        self.navigationItem.leftBarButtonItem = nil;
    }
    
    //Workaround to get the tableView to be the same width as the VC in modal view.
//    int vcWidth = self.view.frame.size.width;
//    int vcHeight = self.view.frame.size.height;
//    self.tableView.frame = CGRectMake(0, 0, vcWidth, vcHeight);
    //Don't need this!  Can use storyboard in the size inspector, autosizing.
    
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
    [self setTableView:nil];
    [self setSearchBar:nil];
    [self setCloseModalButton:nil];
    [super viewDidUnload];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
//    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isFiltered)
        return [self.filteredCells count];
    else
        return [self.customers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCCustomer *customer = [self customerAtIndexPath:indexPath];
    static NSString *CellIdentifier = @"SCCustomerTableCell";
    
    SCCustomerTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //don't need to alloc init the labels since they're built in IB and have outlets to the class.
    cell.statusLabel.text = [SCGlobal singleCharacterStringForStatus:customer.status];
    cell.companyLabel.text = customer.dbaName;
    cell.customerLabel.text = customer.name;
    cell.phoneLabel.text = [customer phoneForTag:MAIN_PHONE_TAG]; 
    
    [SCDesignHelpers customizeBackgroundForSelectedCell:cell];
    for (UILabel *label in cell.labels) {
        [SCDesignHelpers customizeSelectedCellLabel:label];
    }
    
    [SCDesignHelpers customizeBackgroundForUnSelectedCell:cell];
    for (UILabel *label in cell.labels) {
        [SCDesignHelpers customizeUnSelectedCellLabel:label];
    }

    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCCustomer *customer = [self customerAtIndexPath:indexPath];
    
    if (self.global.dataObject.openOrder) {
        [self.delegate passCustomer:customer];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        SCCustomerDetailVC *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SCCustomerDetailVC"];
        detailVC.customer = customer;
        detailVC.viewState = READ_VIEW_STATE;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

#pragma mark - Search bar delegate
-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    if(text.length == 0)
    {
        self.isFiltered = false;
    }
    else
    {
        self.isFiltered = true;
        self.filteredCells = [[NSMutableArray alloc] init];
        
        for (SCCustomer* customer in self.customers)
        {
            NSRange nameRange = [customer.dbaName rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange billCityRange = [customer.primaryBillingAddress.city rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange zipRange = [customer.primaryBillingAddress.postalCode rangeOfString:text options:NSCaseInsensitiveSearch];
            // can have multiple
            if(  (customer.dbaName && [customer.dbaName length] > 0 && (nameRange.location != NSNotFound))
               ||(customer.primaryBillingAddress.city && [customer.primaryBillingAddress.city length] > 0 && (billCityRange.location != NSNotFound))
               ||(customer.primaryBillingAddress.postalCode && [customer.primaryBillingAddress.postalCode length] >0 && (zipRange.location != NSNotFound))
               )
            {
                [self.filteredCells addObject:customer];
            }
        }
    }
    [self.tableView reloadData];
}

#pragma mark - Custom methods
- (SCCustomer *)customerAtIndexPath:(NSIndexPath *)indexPath;
{
    SCCustomer *customer;
    if(self.isFiltered)
        customer = [self.filteredCells objectAtIndex:indexPath.row];
    else
        customer = [self.customers objectAtIndex:indexPath.row];
    return customer;
}

#pragma mark - Protocol methods
- (void)passSavedCustomer:(SCCustomer *)customer
{ //only getting called when creating a new customer that started from this view
    [self dismissViewControllerAnimated:YES completion:^{
        [self viewWillAppear:YES];
        NSInteger customerRow = 0;
        for (NSInteger i = 0; i < self.customers.count; i++) {
            SCCustomer *iCustomer = self.customers[i];
            if ([customer isEqual:iCustomer]) {
                customerRow = i;
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:customerRow inSection:0];
                [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
                break;
            }
        }
    }];
}

- (void)passAddOrderWithCustomer:(SCCustomer *)customer
{
    [self dismissViewControllerAnimated:YES completion:^{
        UINavigationController *masterNC = self.splitViewController.viewControllers[0];
        SCLookMasterVC *masterVC = (SCLookMasterVC *)masterNC.topViewController;
        [masterVC startOrderModeWithCustomer:customer];
    }];
}

#pragma mark - IB methods
- (IBAction)closeModalButtonPress:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)newCustomerButtonPress:(UIBarButtonItem *)sender {
//    SCCustomer *customer = [self.global.dataObject newCustomer];
//    self.global.dataObject.openCustomer = customer;
    
    UINavigationController *nc = [self.storyboard instantiateViewControllerWithIdentifier:@"CustomerDetailNC"];
    SCCustomerDetailVC *vc = (SCCustomerDetailVC *)nc.topViewController;
    
    vc.customer = [self.global.dataObject newCustomer];
    vc.viewState = CREATE_VIEW_STATE;
    
    vc.delegate = self;
    [self presentViewController:nc animated:YES completion:nil];
}
@end
