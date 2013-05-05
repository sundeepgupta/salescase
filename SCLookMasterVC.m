//
//  SCLookMasterVC.m
//  SalesCaseAlpha
//
//  Created by Sundeep Gupta on 13-03-05.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "SCLookMasterVC.h"
#import "SCGlobal.h"
#import "SCDataObject.h"
#import "SCWebApp.h"
#import "SCCustomersVC.h"
#import "SCItemsVC.h"
#import "SCOrdersVC.h"
#import "SCIntuitLoginVC.h"
#import "SCSyncVC.h"
#import "SCOrderMasterVC.h"
#import "SCOrder.h"
#import "SCCustomerDetailVC.h"
#import "SCItemCartVC.h"
#import "SCCustomer.h"
#import "SCSelectSyncVC.h"

@interface SCLookMasterVC ()
@property (strong, nonatomic) SCGlobal *global;

@property (strong, nonatomic) NSString *menuItemLabel;


@property (strong, nonatomic) UINavigationController *detailNC;
@property (strong, nonatomic) UIPopoverController *syncPopoverController;
@property (strong, nonatomic) SCItemCartVC *itemCartVC;
@end

@implementation SCLookMasterVC

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
    self.title = @"SalesCase";
    
    self.global = [SCGlobal sharedGlobal];
    self.detailNC = self.splitViewController.viewControllers.lastObject;
    
    //Instantiate and build the menu
    self.menuItemLabel = @"label";
    self.menuItemRootVC = @"rootVC";
    self.menuItemPreviousStack = @"previousStack";
    NSMutableDictionary *menu0 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                @"Orders", self.menuItemLabel,
                                @"SCOrdersVC", self.menuItemRootVC,
                                nil, self.menuItemPreviousStack,
                                nil];
    NSMutableDictionary *menu1 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                  @"Customers", self.menuItemLabel,
                                  @"SCCustomersVC", self.menuItemRootVC,
                                  nil, self.menuItemPreviousStack,
                                  nil];
    NSMutableDictionary *menu2 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                  @"Items", self.menuItemLabel,
                                  @"SCItemsVC", self.menuItemRootVC,
                                  nil, self.menuItemPreviousStack,
                                  nil];
    self.menu = [[NSArray alloc] initWithObjects:menu0, menu1, menu2, nil];

    //Have login screen up before anything else only if first launch.
    if (![self.global.webApp isSynced]) {
        UINavigationController *loginNC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginNC"];
        [self presentViewController:loginNC animated:NO completion:nil];
    }
    

}

- (void)viewWillAppear:(BOOL)animated
{
    //Highlight appropriate row in the table to reflect the detail view showing when returning from order mode.  We look at the root view only because the views are linearly stacked like a tab bar controller.
    UIViewController *appearingRootVC = self.detailNC.viewControllers[0];
    NSIndexPath *menuIndexPathForVc = [self.global indexPathForDetailVC:appearingRootVC fromArray:self.menu withKey:self.menuItemRootVC];
    [self.tableView selectRowAtIndexPath:menuIndexPathForVc animated:NO scrollPosition:UITableViewScrollPositionNone];
    }

- (void)viewDidAppear:(BOOL)animated
{
    //Handle first launch events
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL viewedFirstLaunchVC = (BOOL)[defaults objectForKey:@"viewedFirstLaunchVC"];
    if (!viewedFirstLaunchVC) {
        UINavigationController *nC = [self.storyboard instantiateViewControllerWithIdentifier:@"FirstLaunchNC"];
        [self presentViewController:nC animated:YES completion:nil];
        [defaults setBool:YES forKey:@"viewedFirstLaunchVC"];
        [defaults synchronize];
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
    static NSString *CellIdentifier = @"LookMasterTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSDictionary *dictAtIndex = self.menu[indexPath.row];
    cell.textLabel.text = [dictAtIndex objectForKey:self.menuItemLabel];  
    return cell;
}

#pragma mark - TableView Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{ // Make the menu behave similar to a tab bar controller
 
    //Get root VC for current detail stack
    UIViewController *currentRootVC = self.detailNC.viewControllers[0];
    NSString *currentRootVCClass = NSStringFromClass(currentRootVC.class);
    
    //get new detail root VC
    NSDictionary *newDict = self.menu[indexPath.row];
    NSString *newRootVCClass = [newDict objectForKey:self.menuItemRootVC];

    if ([currentRootVCClass isEqualToString:newRootVCClass]) {
        [self.detailNC popToRootViewControllerAnimated:NO];
    } else {
        //save the current detail stack
        for (NSMutableDictionary *dict in self.menu) {
            NSString *menuItemRootVC = [dict objectForKey:self.menuItemRootVC];
            if ([currentRootVCClass isEqualToString:menuItemRootVC]) {
                [dict setObject:self.detailNC.viewControllers forKey:self.menuItemPreviousStack];
            }
        }
        
        //load the new detail stack (if doesn't exist, instantiate root and load it)
        NSArray *previousStackForNewDict = [newDict objectForKey:self.menuItemPreviousStack];
        if (previousStackForNewDict.count > 0) { //stack for thie menu already exists.
            [self.detailNC setViewControllers:previousStackForNewDict];
        } else { //first time user clicked on this menue, so instantiate and push
            UIViewController *vC = [self.storyboard instantiateViewControllerWithIdentifier:[newDict objectForKey:self.menuItemRootVC]];
            NSArray *stack = [[NSArray alloc] initWithObjects:vC, nil];
            [self.detailNC setViewControllers:stack animated:NO];
        }
    }
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}

#pragma mark - Custom methods
- (BOOL)dataExists
{
    NSArray *customerIds = [self.global.dataObject fetchCustomersInContextIdOnly];
    NSArray *itemIds = [self.global.dataObject fetchItemsInContextIdOnly];
    return (customerIds.count != 0 || itemIds.count != 0);
}


- (void)startOrderMode
{    
    if (self.global.dataObject.openOrder) {
        NSLog(@"Error as openOrder already exists. SCLookMasterVC, startOrderModeWithCustomer:");
        return;
    }

    self.global.dataObject.openOrder = [self.global.dataObject newOrder];
    [self transitionVCsToOrderModeWithTargetDetailVC:nil];
}

- (void)startOrderModeWithOrder:(SCOrder *)order
{
    if (self.global.dataObject.openOrder) {
        NSLog(@"Error as openOrder already exists. SCLookMasterVC, startOrderModeWithCustomer:");
        return;
    }
    
    self.global.dataObject.openOrder = order;
    [self transitionVCsToOrderModeWithTargetDetailVC:nil];
}

- (void)startOrderModeWithCustomer:(SCCustomer *)customer
{
    if (self.global.dataObject.openOrder) {
        NSLog(@"Error as openOrder already exists. SCLookMasterVC, startOrderMode");
        return;
    }
    self.global.dataObject.openOrder = [self.global.dataObject newOrder];
    self.global.dataObject.openOrder.customer = customer;
    self.global.dataObject.openOrder.salesRep = customer.salesRep;
    self.global.dataObject.openOrder.salesTerm = customer.salesTerms;
    
    SCItemCartVC *itemCartVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SCItemCartVC"];
    [self transitionVCsToOrderModeWithTargetDetailVC:itemCartVC];
}

- (void)startOrderModeWithItem:(SCItem *)item
{
    if (self.global.dataObject.openOrder) {
        NSLog(@"Error as openOrder already exists. SCLookMasterVC, startOrderMode");
        return;
    }
    self.global.dataObject.openOrder = [self.global.dataObject newOrder];
    
    //create a line with 0 quantity
    SCLine *line = (SCLine *)[self.global.dataObject newObject:@"SCLine"];
    line.item = item;
    line.quantity = 0;
    line.order = self.global.dataObject.openOrder;
    [self.global.dataObject saveOrder:self.global.dataObject.openOrder];
    
    //transition to order mode
    SCItemCartVC *itemCartVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SCItemCartVC"];
    [self transitionVCsToOrderModeWithTargetDetailVC:itemCartVC];
    
    //bring up edit line modal
    [itemCartVC presentEditLineVCFromVC:itemCartVC forLine:line];
    
}

- (void)transitionVCsToOrderModeWithTargetDetailVC:(UIViewController *)vC
{
    //Setup masterVC
    SCOrderMasterVC *masterVC =  [self.storyboard instantiateViewControllerWithIdentifier:@"SCOrderMasterVC"];
    masterVC.numberOfLookModeViews = self.detailNC.viewControllers.count; //need to do this now to give accurate count.
    masterVC.title = [SCOrderMasterVC masterVCTitleFromOrder:self.global.dataObject.openOrder];
    
    //Setup detailVCs
    //This will need to change to be a loop if the target vCId can be OrderOptions or OrderDetail
    //only casting to set the view state for SCCustomerDEtailVC
    SCCustomerDetailVC *customerDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SCCustomerDetailVC"];
    customerDetailVC.viewState = READ_VIEW_STATE;
    //uncast it
    UIViewController *detailVC = (UIViewController *)customerDetailVC;
    
    if (vC) {
        [self.detailNC pushViewController:detailVC animated:NO];
        detailVC = vC;
    }
    
    //Transition vCs
    [self transitionVC:detailVC inNC:self.detailNC];
    [self transitionVC:masterVC inNC:self.navigationController];
}

- (void)transitionVC:(UIViewController *)vC inNC:(UINavigationController *)nC
{
    [UIView beginAnimations:@"animation" context:nil];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:nC.view cache:NO];
    [nC pushViewController:vC animated:NO];
    [UIView commitAnimations];
}

- (void)presentNoDataVC
{
    UINavigationController *contentNC = [self.storyboard instantiateViewControllerWithIdentifier:@"NoDataNC"];
    [self presentViewController:contentNC animated:YES completion:nil];
}

- (NSString *)menuItemLabelForVC:(UIViewController *)vC
{
    NSIndexPath *menuIndexPathForVc = [self.global indexPathForDetailVC:vC fromArray:self.menu withKey:self.menuItemRootVC];
    return [self.menu[menuIndexPathForVc.row] objectForKey:self.menuItemLabel];
}

- (void)emailSupport
{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        [mailer setSubject:@"SalesCase Bug"];
        NSArray *toRecipients = [NSArray arrayWithObjects:@"sgupta@enhancetrade.com", nil];
        [mailer setToRecipients:toRecipients];
        [self presentViewController:mailer animated:YES completion:nil];
        
        [self setMFMailFieldAsFirstResponder:mailer.view mfMailField:@"MFComposeTextContentView"];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Can't Email"
                                                        message:@"Looks like your device isn't setup to send emails."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (BOOL) setMFMailFieldAsFirstResponder:(UIView*)view mfMailField:(NSString*)field
{// from http://stackoverflow.com/questions/1690279/set-first-responder-in-mfmailcomposeviewcontroller
    //Returns true if the ToAddress field was found any of the sub views and made first responder
    //passing in @"MFComposeSubjectView"     as the value for field makes the subject become first responder
    //passing in @"MFComposeTextContentView" as the value for field makes the body become first responder
    //passing in @"RecipientTextField"       as the value for field makes the to address field become first responder
    //NOTE: Does not work in iOS 6
    
    for (UIView *subview in view.subviews) {
        
        NSString *className = [NSString stringWithFormat:@"%@", [subview class]];
        if ([className isEqualToString:field])
        {
            //Found the sub view we need to set as first responder
            [subview becomeFirstResponder];
            return YES;
        }
        
        if ([subview.subviews count] > 0) {
            if ([self setMFMailFieldAsFirstResponder:subview mfMailField:field]){
                //Field was found and made first responder in a subview
                return YES;
            }
        }
    }
    
    //field not found in this view.
    return NO;
}

#pragma mark - MFMailComposerViewController Delegate Methods
- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - SyncVCDelegate Methods
- (void)passCloseSyncButtonPress
{
    [self.detailNC.topViewController viewWillAppear:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - IB methods
- (IBAction)syncButtonPress:(UIBarButtonItem *)sender {
    UINavigationController *nc = [self.storyboard instantiateViewControllerWithIdentifier:@"SyncNC"];
    [self presentViewController:nc animated:YES completion:nil];
    SCSelectSyncVC *vc = (SCSelectSyncVC *)nc.topViewController;
    vc.syncVCDelegate = self;

    //still need to give the delegate to SyncVC
//    SCSyncVC *vC = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([SCSyncVC class])];
//    vC.delegate = self;

}

- (IBAction)newOrderButtonPress:(UIBarButtonItem *)sender {
    [self startOrderMode];
}

- (IBAction)bugButtonPress:(UIBarButtonItem *)sender {
    [self emailSupport];
}

- (IBAction)devButtonPress:(UIBarButtonItem *)sender {
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SCDevVC"];
    [self presentViewController:vc animated:YES completion:nil];
}

@end
