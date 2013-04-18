//
//  SCDevVC.m
//  SalesCase
//
//  Created by Sundeep Gupta on 13-04-18.
//  Copyright (c) 2013 EnhanceTrade. All rights reserved.
//

#import "SCDevVC.h"
#import "SCGlobal.h"
#import "SCDataObject.h"
#import "SCWebApp.h"

@interface SCDevVC ()
@property (strong, nonatomic) SCGlobal *global;
@property (strong, nonatomic) SCDataObject *dataObject;
@property (strong, nonatomic) SCWebApp *webApp;
@property (strong, nonatomic) IBOutlet UITextView *message;
@end

@implementation SCDevVC

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
    self.global = [SCGlobal sharedGlobal];
    self.dataObject = self.global.dataObject;
    self.webApp = self.global.webApp;
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

#pragma mark - IB methods
- (IBAction)deleteDataButtonPress:(UIButton *)sender {
    //FROM http://stackoverflow.com/questions/1077810/delete-reset-all-entries-in-core-data Note it does not delete external storage files.
    NSManagedObjectContext *moc = self.global.dataObject.managedObjectContext;
    NSPersistentStoreCoordinator *psc = moc.persistentStoreCoordinator;
    NSPersistentStore *store = psc.persistentStores.lastObject;
    NSError *error = nil;
    NSURL *storeURL = store.URL;
    [moc lock];
    [moc reset]; //drop pending changes
    if ([psc removePersistentStore:store error:&error]) {
        [[NSFileManager defaultManager] removeItemAtURL:storeURL error:&error];
        [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
        self.message.text = @"Data deleted successfully.";
    } else {
        self.message.text = @"Error deleting data.";
    }
    [moc unlock];
}

- (IBAction)disconnectButtonPress:(UIButton *)sender {
    NSError *error = nil;
    NSMutableDictionary *responseError;
    if ([self.webApp disconnectOAuth:&error responseError:&responseError] ) {
        self.message.text = @"Disconnected successfully.";
    } else {
        self.message.text = @"Disconnect error, or you're alredy disconnected.";
    }
}

- (IBAction)connectButtonPress:(UIButton *)sender {
    UINavigationController *loginNC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginNC"];
    [self presentViewController:loginNC animated:NO completion:nil];
}

- (IBAction)closeButtonPress:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidUnload {
    [self setMessage:nil];
    [super viewDidUnload];
}
@end
