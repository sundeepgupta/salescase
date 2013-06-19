//
//  SCItemCartVC.m
//  SalesCaseAlpha
//
//  Created by Sundeep Gupta on 13-03-10.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "SCItemCartVC.h"
#import "SCGlobal.h"
#import "SCOrderMasterVC.h"
#import "SCDataObject.h"
#import "SCOrder.h"
#import "SCItemCartTableCell.h"
#import "SCItemsVC.h"
#import "SCItemDetailVC.h"

@interface SCItemCartVC ()

@property (strong, nonatomic) SCGlobal *global;
@property (strong, nonatomic) SCDataObject *dataObject;
@property (strong, nonatomic) NSArray *lines;
@property (strong) NSMutableArray *filteredCells;
@property BOOL isFiltered;

//IB Stuff
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *orderTotal;

@end

@implementation SCItemCartVC

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
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnviewDidAppear = NO;
    self.global = [SCGlobal sharedGlobal];
    self.dataObject = self.global.dataObject;
    
    [SCDesignHelpers customizeTableView:self.tableView];
    NSDictionary *textAttributes = [SCDesignHelpers textAttributes];
    [self.orderTotal setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated
{    
    //get titles
    UINavigationController *masterNC = self.splitViewController.viewControllers[0];
    SCOrderMasterVC *masterVC = (SCOrderMasterVC *)masterNC.topViewController;
    self.title = [masterVC menuItemLabelForVC:self];
    
    //bring up item list if no items in cart
    if (self.dataObject.openOrder.lines.count == 0) {
        [self presentItemList];
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
    [super viewDidUnload];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isFiltered)
        return [self.filteredCells count];
    else
        return [self.lines count];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCLine *line = [self lineAtIndexPath:indexPath];
    static NSString *CellIdentifier = @"SCItemCartTableCell";
    SCItemCartTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.nameLabel.text = line.item.name;
    cell.descriptionLabel.text = line.lineDescription;
    cell.quantityLabel.text = [line.quantity stringValue];
    cell.priceLabel.text = [SCGlobal stringFromDollarAmount:[line.price floatValue]];
    cell.amountLabel.text = [SCGlobal stringFromDollarAmount:[line amount]];

    return cell; 
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCLine *line = [self lineAtIndexPath:indexPath];
    [self presentEditLineVCFromVC:self forLine:line];
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
        
        for (SCLine* line in self.lines)
        {
            NSRange nameRange = [line.item.name rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange descriptionRange = [line.lineDescription rangeOfString:text options:NSCaseInsensitiveSearch];
            
            // can have multiple
            if(
               (line.item.name && [line.item.name length] > 0 && (nameRange.location != NSNotFound))
               ||(line.item.description && [line.lineDescription length] > 0 && (descriptionRange.location != NSNotFound))
               )
            {
                [self.filteredCells addObject:line];
            }
        }
    }
    [self.tableView reloadData];
}

#pragma mark - Custom methods
- (SCLine *)lineAtIndexPath:(NSIndexPath *)indexPath;
{
    SCLine *line;
    if(self.isFiltered)
        line = [self.filteredCells objectAtIndex:indexPath.row];
    else
        line = [self.lines objectAtIndex:indexPath.row];
    return line;
}

- (void)loadData
{
    //fetch lines for openOrder and reload table
    self.lines = [self.dataObject linesSortedByIdForOrder:self.dataObject.openOrder];
    [self.tableView reloadData];
    
    NSString *orderTotalString = [NSString stringWithFormat:@"Total %@", [SCGlobal stringFromDollarAmount:[self.dataObject.openOrder totalAmount]]];
    [self.orderTotal setTitle:orderTotalString];
    
}

- (void)presentItemList
{
    UINavigationController *itemsNC = [self.storyboard instantiateViewControllerWithIdentifier:@"ItemsNC"];
    SCItemsVC *itemsVC = (SCItemsVC *)itemsNC.topViewController;
    itemsVC.delegate = self;
    [self presentViewController:itemsNC animated:YES completion:nil];
}

- (void)presentEditLineVCFromVC:(SCItemCartVC *)vC forLine:(SCLine *)line
{
    UINavigationController *itemsNC = [self.storyboard instantiateViewControllerWithIdentifier:@"ItemsNC"];
    SCItemDetailVC *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SCItemDetailVC"];
    detailVC.line = line;
    detailVC.title = @"Edit Line Item";
    detailVC.isEditLineMode = YES;
    detailVC.delegate = vC;
    NSArray *vCArray = [NSArray arrayWithObject:detailVC];
    [itemsNC setViewControllers:vCArray];
    [vC presentViewController:itemsNC animated:YES completion:nil];
}


#pragma mark - Delegate methods
- (void)dismissModal
{
    [self loadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - IB Methods
- (IBAction)addItemsButtonPress:(UIButton *)sender {
    [self presentItemList];
}

- (IBAction)nextButtonPress:(UIButton *)sender {
    UIViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SCOrderOptionsVC"];
    [self.navigationController pushViewController:nextVC animated:YES];
}

@end
