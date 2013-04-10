//
//  SCOrderOptionsSelectTableVC.m
//  SalesCaseAlpha
//
//  Created by Sundeep Gupta on 13-03-22.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "SCOrderOptionsSelectTableVC.h"
#import "SCOrderOptionsSelectTableCell.h"
#import "SCSalesRep.h"
#import "SCSalesTerm.h"
#import "SCShipMethod.h"


@interface SCOrderOptionsSelectTableVC ()
@property (strong, nonatomic) NSMutableArray *dataArrayCopy;

@end

@implementation SCOrderOptionsSelectTableVC

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
    self.emptySelctionString = @"-";
}

- (void)viewWillAppear:(BOOL)animated
{
    self.dataArrayCopy = [NSMutableArray arrayWithObjects:self.emptySelctionString, nil];
    [self.dataArrayCopy addObjectsFromArray:self.dataArray];
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
    return self.dataArrayCopy.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SCOrderOptionsSelectTableCell";    
    SCOrderOptionsSelectTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    id objectAtIndexPath = [self.dataArrayCopy objectAtIndex:indexPath.row];
    
    if ([objectAtIndexPath isKindOfClass:[NSString class]]) {
        cell.nameLabel.text = self.emptySelctionString;
        return cell;
    } else {
        if (self.buttonObjectType == ENTITY_SCSALESREP) {
            SCSalesRep *object = (SCSalesRep *)objectAtIndexPath;
            cell.nameLabel.text = object.name;
        } else if (self.buttonObjectType == ENTITY_SCSALESTERM) {
            SCSalesTerm *object = (SCSalesTerm *)objectAtIndexPath;
            cell.nameLabel.text = object.name;
        } else if (self.buttonObjectType == ENTITY_SCSHIPMETHOD) {
            SCShipMethod *object = (SCShipMethod *)objectAtIndexPath;
            cell.nameLabel.text = object.name;
        } else {
            cell.nameLabel.text = @"Error - see log";
            NSLog(@"Object's class type at the row selected is not being handled for in cellForRowAtIndexPath method.");
        }
        return cell;
    }
   
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id objectAtIndexPath = [self.dataArrayCopy objectAtIndex:indexPath.row];
    [self.delegate passObject:objectAtIndexPath withButtonObjectType:self.buttonObjectType];
    [self.myPC dismissPopoverAnimated:YES]; 
}

@end
