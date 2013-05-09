//
//  SCSelectSyncVC.m
//  SalesCase
//
//  Created by Sundeep Gupta on 13-05-04.
//  Copyright (c) 2013 EnhanceTrade. All rights reserved.
//

#import "SCSelectSyncVC.h"
#import "SCSyncVC.h"
#import "SCGlobal.h"
#import "SCDataObject.h"
#import "SCCustomer.h"

@interface SCSelectSyncVC ()

@property (strong, nonatomic) SCDataObject *dataObject;

@end

@implementation SCSelectSyncVC

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
	// Do any additional setup after loading the view.
    self.title = @"Select Sync";
    SCGlobal *global = [SCGlobal sharedGlobal];
    self.dataObject = global.dataObject;
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

#pragma mark - Custom methods
- (void)pushSyncVCWithSyncMethod:(eSyncMethod)syncMethod {
    SCSyncVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([SCSyncVC class])];
    vc.delegate = self.syncVCDelegate;
    vc.syncMethod = syncMethod;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - IB Methods
- (IBAction)everythingButtonPress:(UIButton *)sender {
    [self pushSyncVCWithSyncMethod:EVERYTHING_SYNC];
}

- (IBAction)companyInfoButtonPress:(UIButton *)sender {
    [self pushSyncVCWithSyncMethod:COMPANY_INFO_SYNC];
}

- (IBAction)ordersButtonPress:(UIButton *)sender {
    
    //need to check first if any orders have cutoemrs with status "new"
//    NSError *error = nil;
//    NSArray *newCustomers = [self.dataObject objectsOfType:NSStringFromClass([SCCustomer class]) withStatus:NEW_STATUS withError:&error];
//    for (SCCustomer *customer in newCustomers) {
//        if (customer.orderList.count > 0) {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sync Customers First" message:@"There are orders for new customers, so please sync them first, or use the \"Everything\" sync." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alert show];
//            return;
//        }
//    }
    
    [self pushSyncVCWithSyncMethod:ORDERS_SYNC];
}

- (IBAction)customersButtonPress:(UIButton *)sender {
    [self pushSyncVCWithSyncMethod:CUSTOMERS_SYNC];
}

- (IBAction)itemsButtonPress:(UIButton *)sender {
    [self pushSyncVCWithSyncMethod:ITEMS_SYNC];
}

- (IBAction)cancelButtonPress:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
