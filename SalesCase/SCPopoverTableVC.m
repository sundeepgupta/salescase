//
//  SCPopoverTableVC.m
//  SalesCase
//
//  Created by Sundeep Gupta on 13-04-16.
//  Copyright (c) 2013 EnhanceTrade. All rights reserved.
//

#import "SCPopoverTableVC.h"
#import "SCPopoverTableCell.h"
#import "SCSalesRep.h"
#import "SCSalesTerm.h"
#import "SCShipMethod.h"

@interface SCPopoverTableVC ()
@property (strong, nonatomic) NSMutableArray *dataArrayCopy;
@end

@implementation SCPopoverTableVC

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
    
    [SCDesignHelpers customizeTableView:self.tableView];

}

- (void)viewWillAppear:(BOOL)animated
{
    self.dataArrayCopy = [NSMutableArray arrayWithObjects:EMPTY_SELECTION_STRING, nil];
    [self.dataArrayCopy addObjectsFromArray:self.dataArray];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    NSString *CellIdentifier = NSStringFromClass([SCPopoverTableCell class]);
    SCPopoverTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    id objectAtIndexPath = [self.dataArrayCopy objectAtIndex:indexPath.row];
    
    if ([objectAtIndexPath isKindOfClass:[NSString class]]) {
        cell.label.text = EMPTY_SELECTION_STRING;
        return cell;
    } else {
        if (self.objectType == ENTITY_SCSALESREP) {
            SCSalesRep *object = (SCSalesRep *)objectAtIndexPath;
            cell.label.text = object.name;
        } else if (self.objectType == ENTITY_SCSALESTERM) {
            SCSalesTerm *object = (SCSalesTerm *)objectAtIndexPath;
            cell.label.text = object.name;
        } else if (self.objectType == ENTITY_SCSHIPMETHOD) {
            SCShipMethod *object = (SCShipMethod *)objectAtIndexPath;
            cell.label.text = object.name;
        } else {
            cell.label.text = @"Error - see log";
            NSLog(@"Object's class type at the row selected is not being handled for in cellForRowAtIndexPath method.");
        }
        return cell;
    }

}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id objectAtIndexPath = [self.dataArrayCopy objectAtIndex:indexPath.row];
    [self.delegate passObject:objectAtIndexPath withObjectType:self.objectType];
}  

@end
