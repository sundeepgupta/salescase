//
//  SCItemsVC.m
//  SalesCaseAlpha
//
//  Created by Sundeep Gupta on 13-03-07.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "SCItemsVC.h"
#import "SCGlobal.h"
#import "SCDataObject.h"
#import "SCItemTableCell.h"
#import "SCItemDetailVC.h"

@interface SCItemsVC ()

@property (strong, nonatomic) SCGlobal *global;
@property (nonatomic, strong) NSArray *items;
@property (strong) NSMutableArray *filteredCells;
@property BOOL isFiltered;

//IB Stuff
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *closeModalButton;

@end

@implementation SCItemsVC

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

}

- (void)viewWillAppear:(BOOL)animated
{
    self.items = [self.global.dataObject fetchItemsInContext];
    [self.tableView reloadData];
    
    if (self.global.dataObject.openOrder) {
        self.title = @"Select Item To Add";
    } else {
        self.title = @"Items";
        //Hide the close button used for modal in order mode.
        self.navigationItem.leftBarButtonItem = nil;
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
    [self setTableView:nil];
    [self setSearchBar:nil];
    [self setCloseModalButton:nil];
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
        return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCItem *item = [self itemAtIndexPath:indexPath];
    static NSString *CellIdentifier = @"SCItemTableCell";
    
    //    [self.customersTable registerClass:[SCCustomerTableCell class] forCellReuseIdentifier:CellIdentifier];  Don't need this because the custom cell is made in IB.  And it can be put in viewDidLoad so its only called once.
    
    SCItemTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //don't need to alloc init the labels since they're built in IB and have outlets to the class.
    cell.nameLabel.text = item.name;
    cell.descriptionLabel.text = item.itemDescription;
    cell.priceLabel.text = [SCGlobal stringFromDollarAmount:item.price.floatValue];
    cell.quantityOnHandLabel.text = [NSString stringWithFormat:@"%@", item.quantityOnHand.stringValue];
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCItem *item = [self itemAtIndexPath:indexPath];
    SCItemDetailVC *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SCItemDetailVC"];
    detailVC.item = item;
    
    
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
        
        for (SCItem* item in self.items)
        {
            NSRange nameRange = [item.name rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange descriptionRange = [item.itemDescription rangeOfString:text options:NSCaseInsensitiveSearch];

            // can have multiple
            if(
               (item.name && [item.name length] > 0 && (nameRange.location != NSNotFound))
               ||(item.description && [item.itemDescription length] > 0 && (descriptionRange.location != NSNotFound))
               )
            {
                [self.filteredCells addObject:item];
            }
        }
    }
    [self.tableView reloadData];
}

#pragma mark - Custom Methods
- (SCItem *)itemAtIndexPath:(NSIndexPath *)indexPath;
{
    SCItem *item;
    if(self.isFiltered)
        item = [self.filteredCells objectAtIndex:indexPath.row];
    else
        item = [self.items objectAtIndex:indexPath.row];
    return item;
}

#pragma mark - IB methods
- (IBAction)closeModalButtonPress:(UIBarButtonItem *)sender {
    [self.delegate dismissModal];
}




@end
