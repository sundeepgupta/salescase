//
//  SCItemDetailVCVC.m
//  SalesCaseAlpha
//
//  Created by Sundeep Gupta on 13-03-07.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "SCItemDetailVC.h"
#import "SCGlobal.h"
#import "SCDataObject.h"
#import "SCItem.h"
#import "SCLine.h"
#import "SCLookMasterVC.h"
#import "SCOrder.h"
#import "SCOrderMasterVC.h"

@interface SCItemDetailVC ()

@property (strong, nonatomic) SCGlobal *global;
@property (strong, nonatomic) SCDataObject *dataObject;

//IB Stuff
@property (strong, nonatomic) IBOutlet UITextField *nameLabel;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (strong, nonatomic) IBOutlet UITextField *priceTextField;
@property (strong, nonatomic) IBOutlet UITextField *quantityOnHandLabel;

@property (strong, nonatomic) IBOutlet UITextField *quantityOrderedTextField;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *startOrderButton;
@property (strong, nonatomic) IBOutlet UITableViewCell *quantityOrderedCell;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelButton;

@end

@implementation SCItemDetailVC

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
    //workaround to change height of text field.
//    self.quantityOrderedTextField.borderStyle = UITextBorderStyleRoundedRect;
    
    if (self.global.dataObject.openOrder) {
        self.title = @"Enter Quantity";
        self.navigationItem.rightBarButtonItem = nil; //hide the new order button

        [self.quantityOrderedTextField selectAll:self.quantityOrderedTextField]; //not actually selecting the text, dont' know whats wrong. Its not crucial.
        
        //Disable the save to order button if textField is empty
//        if (self.quantityOrderedTextField.text.length == 0) {
//            self.saveToOrderButton.enabled = NO;
//            self.saveToOrderButton.alpha = UI_DISABLED_ALPHA;
//        }
        
        if (self.isEditLineMode) {
            self.title = @"Edit Line Item";
            [self.saveToOrderButton setTitle:@"Save" forState:UIControlStateNormal];
            
            self.quantityOrderedTextField.returnKeyType = UIReturnKeyDone;
            
            //create and add left bar button item
            UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self.delegate action:@selector(dismissModal)];
            self.navigationItem.leftBarButtonItem = cancelButton;
            
            
        } else { //normally adding to cart so hide delete button
            self.deleteButton.hidden = YES;

        }
    } else {
        //don't disable user interaction on description and price fields
        self.descriptionTextView.editable = NO;
        self.priceTextField.userInteractionEnabled = NO;
    }
    
    [self loadData];
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
    [self setNameLabel:nil];
    [self setDescriptionTextView:nil];
    [self setPriceTextField:nil];
    [self setQuantityOrderedTextField:nil];
    [self setSaveToOrderButton:nil];
    [self setQuantityOnHandLabel:nil];
    [self setDeleteButton:nil];
    [self setStartOrderButton:nil];
    [self setQuantityOrderedCell:nil];
    [self setCancelButton:nil];
    [super viewDidUnload];
}

#pragma mark - TableView Datasource delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{ //implementing to remove the order quantity cell.  Be aware, the space for the header remains.
    if (!self.dataObject.openOrder && section == 0) return 0;
    else return [super tableView:tableView numberOfRowsInSection:section];
}

#pragma mark - TextField Delegates
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //The argument 'string' in this method is actually the string iOS wants to append to the existing textField.text (the keyboard button the user pressed, or what the user pasted).  Returning YES lets it, NO doesn't let it.  So check if string is valid or not.
    
    BOOL allowChange = NO;
    
    //Prevent non-numbers for price and quantity fields
    NSCharacterSet *validCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@".0123456789"];
    NSCharacterSet *invalidCharacterSet = validCharacterSet.invertedSet;
    NSArray *separatedString = [string componentsSeparatedByCharactersInSet:invalidCharacterSet];
    NSString *validatedString = [separatedString componentsJoinedByString:@""];
    if ([string isEqualToString:validatedString]) {
        allowChange = YES;
    } else {
        allowChange = NO;
    }
    
    //Prevent leading 0's for price and quantity fields.
    if (textField.text.length == 0 && [string isEqualToString:@"0"]) {
        allowChange = NO;
    }
    
    //Enable/disable the save button.  string.length == 0 means Backspace key pressed.  Only for the quanity field.
//    if ([textField isEqual:self.quantityOrderedTextField]) {
//        if (allowChange) {
//            if (textField.text.length <= 1) {
//                if (string.length == 0) {
//                    self.saveToOrderButton.enabled = NO;
//                    self.saveToOrderButton.alpha = UI_DISABLED_ALPHA;
//                } else {
//                    self.saveToOrderButton.enabled = YES;
//                    self.saveToOrderButton.alpha = 1;
//                }
//            } else {
//                self.saveToOrderButton.enabled = YES;
//                self.saveToOrderButton.alpha = 1;
//            }
//        } else {
//            if (textField.text.length == 0) {
//                self.saveToOrderButton.enabled = NO;
//                self.saveToOrderButton.alpha = UI_DISABLED_ALPHA;
//            } else {
//                self.saveToOrderButton.enabled = YES;
//                self.saveToOrderButton.alpha = 1;
//            }
//        }
//    }
    
    return allowChange;
}

//- (BOOL)textFieldShouldClear:(UITextField *)textField
//{ //disable the save button 
//    self.saveToOrderButton.enabled = NO;
//    self.saveToOrderButton.alpha = UI_DISABLED_ALPHA;
//    return YES;
//}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //This is the handler for the "return" key on the keyboard.  Remember to make this work, you need UITextFieldDelegate via code or connecting via storyboard.
    [textField resignFirstResponder]; //dismisses the keyboard.
    [self saveLine];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    //only one textView so no need to check
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];        
        [self saveLine];
        return NO;
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{ //no need to check, only one of them right now
    if (textView.text.length == 0) {
        if (self.isEditLineMode) {
            textView.text = self.line.item.itemDescription;
        } else {
            textView.text = self.item.itemDescription;
        }
    }
    //THis is not enough, because if user taps "save", this method doesn't fire.  So, need to check on save also.
}

#pragma mark - Custom Methods
- (void)loadData
{
    if (self.isEditLineMode) {
        self.nameLabel.text = self.line.item.name;
        self.descriptionTextView.text = self.line.lineDescription;
        self.priceTextField.text = [NSString stringWithFormat:@"%.2f", self.line.price.floatValue];
        self.quantityOnHandLabel.text = [NSString stringWithFormat:@"%@", [self.line.item.quantityOnHand stringValue]];
        self.quantityOrderedTextField.text = [self.line.quantity stringValue];
    } else { // either in look mode or a new line item in order mode so get everything from the item
        self.nameLabel.text = self.item.name;
        self.descriptionTextView.text = self.item.itemDescription;
        self.priceTextField.text = [NSString stringWithFormat:@"%.2f", self.item.price.floatValue];
        self.quantityOnHandLabel.text = [NSString stringWithFormat:@"%@", [self.item.quantityOnHand stringValue]];
    }
}

- (void)saveLine
{ //self.line here is an existing line, where line is a new line
    if (self.isEditLineMode) {
        [self assignLineValuesForLine:self.line];
        [self.delegate dismissModal];
    } else {
        SCLine *line = [self.dataObject newLineWithItem:self.item];
        [self assignLineValuesForLine:line];
        line.order = self.dataObject.openOrder;
        [self.navigationController popViewControllerAnimated:YES];
    }
    [self.dataObject saveOrder:self.dataObject.openOrder];
}

- (void)assignLineValuesForLine:(SCLine *)line
{    
    if (self.descriptionTextView.text.length == 0) {
        if (self.isEditLineMode) {
            line.lineDescription = self.line.item.itemDescription;
        } else {
            line.lineDescription = self.item.itemDescription;
        }
    } else {
        line.lineDescription = self.descriptionTextView.text;
    }
    
    if (self.priceTextField.text.length == 0) {
        line.price = 0;
    } else {
        line.price = [NSNumber numberWithFloat:self.priceTextField.text.floatValue];
    }
    
    
    line.quantity = [NSNumber numberWithFloat:self.quantityOrderedTextField.text.floatValue];
}

- (void)deleteLine
{
    [self.dataObject deleteObject:self.line]; //self.line set in isEditLineMode
    [self.delegate dismissModal];

    //handle the order status if no more lines and change title of masterVC
    if (self.dataObject.openOrder.lines.count == 0 && [self.dataObject.openOrder.status isEqualToString:CONFIRMED_STATUS]) {
        self.dataObject.openOrder.status = DRAFT_STATUS;
        [SCOrderMasterVC masterVCTitleFromOrder:self.dataObject.openOrder];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Order Status Changed" message:@"The order now has 'draft' status since there are no items in the order." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
}

#pragma mark - IB methods
- (IBAction)saveToOrderButtonPress:(UIButton *)sender {
    [self saveLine];
}

- (IBAction)cancelEditLineButtonPress:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)deleteButtonPress:(UIButton *)sender {
    [self deleteLine];
}

- (IBAction)startOrderButtonPress:(UIButton *)sender {
    UINavigationController *masterNC = self.splitViewController.viewControllers[0];
    SCLookMasterVC *masterVC = (SCLookMasterVC *)masterNC.topViewController;
    [masterVC startOrderModeWithItem:self.item];
}


//Moved code in here to textField:shouldChangeCharactersInRange:replacementString due to iOS5 bug.
//- (IBAction)quantityOrderedEditingChanged:(UITextField *)sender {
//    //As soon as keyboard button pressed, this method is called.  Using to remove non-valid characters
//    NSCharacterSet *validCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
//    NSCharacterSet *invalidCharacterSet = validCharacterSet.invertedSet;
//    NSArray *senderStringSeparated = [sender.text componentsSeparatedByCharactersInSet:invalidCharacterSet];
//    NSString *validatedString = [senderStringSeparated componentsJoinedByString:@""];
//    self.quantityOrderedTextField.text = validatedString;
//}
@end
