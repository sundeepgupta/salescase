//
//  SCOrdersVC.m
//  SalesCaseAlpha
//
//  Created by Sundeep Gupta on 13-03-05.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "SCOrdersVC.h"
#import "SCGlobal.h"
#import "SCDataObject.h"
#import "SCLookMasterVC.h"
#import "SCOrderTableCell.h"
#import "SCOrder.h"
#import "SCCustomer.h"
#import "SCOrderPDFVC.h"
#import "SCOrderMasterVC.h"
#import "SCDesignHelpers.h"


@interface SCOrdersVC ()
@property (strong, nonatomic) SCGlobal *global;
@property (nonatomic, strong) NSArray *orders;
@property (strong) NSMutableArray *filteredCells;
@property BOOL isFiltered;

//IB stuff
@property (strong, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation SCOrdersVC

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
    NSError *error = nil;
    self.orders = [self.global.dataObject fetchOrdersInContext:&error];
    
    if (!self.orders) {
        NSLog(@"%@: Error fetching orders: %@", self.class, error);
    }
    
    if (self.searchBarText.length > 0) {
        self.searchBar.text = self.searchBarText;
    }
    
    [self searchBar:self.searchBar selectedScopeButtonIndexDidChange:self.searchBar.selectedScopeButtonIndex]; //this method reloads the data too.
//    [self.tableView reloadData];
    
    
    //get titles
    UINavigationController *masterNC = self.splitViewController.viewControllers[0];
    SCLookMasterVC *masterVC = (SCLookMasterVC *)masterNC.topViewController;
    self.title = [masterVC menuItemLabelForVC:self]; 
    
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
    [super viewDidUnload];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isFiltered)
        return [self.filteredCells count];
    else
        return [self.orders count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCOrder *order = [self orderAtIndexPath:indexPath];
    static NSString *CellIdentifier = @"SCOrderTableCell";
    SCOrderTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //don't need to alloc init the labels since they're built in IB and have outlets to the class.
    cell.orderId.text = [NSString stringWithFormat:@"%@", [order.scOrderId stringValue]];
    cell.status.text = [SCGlobal singleCharacterStringForStatus:order.status];
    cell.companyName.text = order.customer.dbaName;
    cell.total.text = [SCGlobal stringFromDollarAmount:[order totalAmount]];

    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCOrder *order = [self orderAtIndexPath:indexPath];
    SCOrderPDFVC *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SCOrderPDFVC"];
    detailVC.order = order;
    [self.navigationController pushViewController:detailVC animated:YES];
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
        
        for (SCOrder* order in self.orders)
        {
            NSRange orderIdRange = [[order.scOrderId stringValue] rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange companyNameRange = [order.customer.dbaName rangeOfString:text options:NSCaseInsensitiveSearch];
            
            // can have multiple
            if(
               (order.scOrderId && [[order.scOrderId stringValue] length] > 0 && (orderIdRange.location != NSNotFound))
               ||(order.customer.dbaName && [order.customer.dbaName length] > 0 && (companyNameRange.location != NSNotFound))
               )
            {
                [self.filteredCells addObject:order];
            }
        }
    }
    [self.tableView reloadData];
}


- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    NSError *error = nil;
    if (selectedScope == 0) {
        self.orders = [self.global.dataObject fetchOrdersInContext:&error];
    } else if (selectedScope == 1) { //draft orders
        self.orders = [self.global.dataObject objectsOfType:ENTITY_SCORDER withStatus:DRAFT_STATUS withError:&error];
    } else if (selectedScope == 2) { //confirmed orders
        self.orders = [self.global.dataObject objectsOfType:ENTITY_SCORDER withStatus:CONFIRMED_STATUS withError:&error];
    } else if (selectedScope == 3) { //synced orders
        self.orders = [self.global.dataObject objectsOfType:ENTITY_SCORDER withStatus:SYNCED_STATUS withError:&error];
    }
    
    //after scoping, need to call filter again
    [self searchBar:self.searchBar textDidChange:self.searchBar.text];
    
    [self.tableView reloadData];
}

#pragma mark - Custom methods
- (SCOrder *)orderAtIndexPath:(NSIndexPath *)indexPath;
{
    SCOrder *order;
    if(self.isFiltered)
        order = [self.filteredCells objectAtIndex:indexPath.row];
    else
        order = [self.orders objectAtIndex:indexPath.row];
    return order;
}


#pragma mark - IB Methods
//- (IBAction)newOrderButtonPress:(UIBarButtonItem *)sender { //must be in look mode
//    UINavigationController *masterNC = self.splitViewController.viewControllers[0];
//    SCLookMasterVC *masterVC = (SCLookMasterVC *)masterNC.topViewController;
//}


@end
