//
//  SCOrderMasterVC.m
//  SalesCaseAlpha
//
//  Created by Sundeep Gupta on 13-03-07.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "SCOrderMasterVC.h"
#import "SCGlobal.h"
#import "SCOrder.h"
#import "SCDataObject.h"
#import "SCOrderPDFVC.h"
#import "SCKeepOrderVC.h"
#import "SCLookMasterVC.h"

@interface SCOrderMasterVC ()
@property (strong, nonatomic) SCGlobal *global;
@property (strong, nonatomic) SCDataObject *dataObject;
@property (strong, nonatomic) UINavigationController *detailNC;
@property (strong, nonatomic) NSArray *menu;
@property (strong, nonatomic) NSString *menuItemLabel;
@property (strong, nonatomic) NSString *menuItemRootVC;
@property (strong, nonatomic) UIPopoverController *keepOrderPC;



@end

@implementation SCOrderMasterVC

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
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    self.global = [SCGlobal sharedGlobal];
    self.dataObject = self.global.dataObject;

    self.navigationItem.hidesBackButton = YES;
    self.detailNC = self.splitViewController.viewControllers.lastObject;
    
    //Instantiate and build the menu
    self.menuItemLabel = @"label";
    self.menuItemRootVC = @"rootVC";
    NSMutableDictionary *menu0 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                  @"Customer", self.menuItemLabel,
                                  @"SCCustomerDetailVC", self.menuItemRootVC,
                                  nil];
    NSMutableDictionary *menu1 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                  @"Item Cart", self.menuItemLabel,
                                  @"SCItemCartVC", self.menuItemRootVC,
                                  nil];
    NSMutableDictionary *menu2 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                  @"Order Options", self.menuItemLabel,
                                  @"SCOrderOptionsVC", self.menuItemRootVC,
                                  nil];
    NSMutableDictionary *menu3 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                  @"Review Order", self.menuItemLabel,
                                  @"SCOrderPDFVC", self.menuItemRootVC,
                                  nil];
    self.menu = [[NSArray alloc] initWithObjects:menu0, menu1, menu2, menu3, nil];
}

- (void)viewWillAppear:(BOOL)animated
{
//    self.global.dataObject.openOrder = YES;
    //get stack and count when this view first loads
//    self.numberOfLookModeViews = [self.detailNC.viewControllers count] - 1; // the "-1" is for the CustomerDetailVC in order mode
}

- (void)viewDidAppear:(BOOL)animated
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

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.menu.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"OrderMasterTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSDictionary *dictAtIndex = self.menu[indexPath.row];
    cell.textLabel.text = [dictAtIndex objectForKey:self.menuItemLabel];
    return cell;
}

#pragma mark - Table View Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //check the current detail view and get the real stack index (including views from look mode), then deduct the number of views from look mode
    int currentViewIndex = self.detailNC.viewControllers.count - 1; // -1 because index is 0-based count
    int orderModeViewIndex = currentViewIndex - self.numberOfLookModeViews;
        
    BOOL shouldAnimate;

    if (indexPath.row <= orderModeViewIndex) { //user wants to go back so get the VC and indexPath and pop to it
        UIViewController *viewControllerAtIndexPath = self.detailNC.viewControllers[indexPath.row + self.numberOfLookModeViews];
        [self.detailNC popToViewController:viewControllerAtIndexPath animated:YES];
    } else { //user wants to go forward so instantiate the new VCs and push
        for (int i = orderModeViewIndex + 1; i <= indexPath.row; i++) {
            if (i == indexPath.row) { //only animate the top of the stack or will produce errors.
                shouldAnimate = YES;
            } else {
                shouldAnimate = NO;
            }
            //get storyboard ID of VC you need push onto stack and push it
            NSMutableDictionary *selectedMenuDict = self.menu[i];
            NSString *storyboardId = [selectedMenuDict objectForKey:self.menuItemRootVC];
            UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:storyboardId];
            viewController.title = [selectedMenuDict objectForKey:self.menuItemLabel]; //need this to get the correct back button text
            [self.detailNC pushViewController:viewController animated:shouldAnimate];
        }
    }
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}

#pragma mark - SCConfirmDeleteVCDelegate Methods
- (void)passConfirmDeleteButtonPress
{
    [self.dataObject deleteObject:self.dataObject.openOrder];
    [self.keepOrderPC dismissPopoverAnimated:YES];
    [self closeOrderMode];
}

- (void)passKeepButtonPress
{
    [self.keepOrderPC dismissPopoverAnimated:YES];
    [self closeOrderMode];
}

#pragma mark - Custom Methods
- (void)processAppearedDetailVC:(UIViewController *)vC
{
    NSIndexPath *menuIndexPathForVc = [self.global indexPathForDetailVC:vC fromArray:self.menu withKey:self.menuItemRootVC];
    [self tableView:self.tableView didHighlightRowAtIndexPath:menuIndexPathForVc];
}

- (NSString *)menuItemLabelForVC:(UIViewController *)vC
{
    NSIndexPath *menuIndexPathForVc = [self.global indexPathForDetailVC:vC fromArray:self.menu withKey:self.menuItemRootVC];
    return [self.menu[menuIndexPathForVc.row] objectForKey:self.menuItemLabel];
}

+ (NSString *)masterVCTitleFromOrder:(SCOrder *)order
{
    if (order) {
        NSString *status = [SCGlobal singleCharacterStringForStatus:order.status];
        return [NSString stringWithFormat:@"Order #%@ (%@)", order.scOrderId, status];
    } else {
        return @"New Order";
    }
}


- (void)closeOrderMode
{
    //nil the openOrder
    self.dataObject.openOrder = nil;
    
    //Master view go back to look mode master view
    [UIView beginAnimations:@"animation" context:nil];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
    [self.navigationController popViewControllerAnimated:NO];
    [UIView commitAnimations];
    
    //Detail view go back to detail nav stack, and
    int lookModeDetailViewIndex = self.numberOfLookModeViews - 1;
    UIViewController *lookModeDetailView = self.detailNC.viewControllers[lookModeDetailViewIndex];
    
    //if lookModeDetailView is OrderDetail, and we just deleted its order, remove that view from stack
    if ([lookModeDetailView isKindOfClass:SCOrderPDFVC.class]) {
        SCOrderPDFVC *orderDetailVC = (SCOrderPDFVC *)lookModeDetailView;
        if (!orderDetailVC.order.scOrderId) {
            lookModeDetailView = self.detailNC.viewControllers[lookModeDetailViewIndex - 1];
        }
    }
    
    
    [UIView beginAnimations:@"animation" context:nil];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.detailNC.view cache:NO];
    [self.detailNC popToViewController:lookModeDetailView animated:NO];
    [UIView commitAnimations];
}

#pragma mark - IB Methods
- (IBAction)closeOrderButtonPress:(UIBarButtonItem *)sender {
    // if no customer set, or no items in cart, //ask user to if they want to delete the order.
    if (!self.dataObject.openOrder.customer || self.dataObject.openOrder.lines.count == 0) {
        SCKeepOrderVC *vC = [self.storyboard instantiateViewControllerWithIdentifier:@"SCKeepOrderVC"];
        self.keepOrderPC = [[UIPopoverController alloc] initWithContentViewController:vC];
        vC.delegate = self;
        if (!self.dataObject.openOrder.customer && self.dataObject.openOrder.lines.count == 0) {
            vC.textView.text = @"No customer or items saved for this order.";
        } else if (!self.dataObject.openOrder.customer && self.dataObject.openOrder.lines.count > 0) {
            vC.textView.text = @"No customer saved for this order.";
        } else if (self.dataObject.openOrder.customer && self.dataObject.openOrder.lines.count == 0) {
            vC.textView.text = @"No items saved for this order.";
        }
        [self.keepOrderPC presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    } else {
        [self closeOrderMode];
    }
}

- (IBAction)bugButtonPress:(UIBarButtonItem *)sender {
    SCLookMasterVC *lookMasterVC = self.navigationController.viewControllers[0];
    [lookMasterVC emailSupport];
}

@end
