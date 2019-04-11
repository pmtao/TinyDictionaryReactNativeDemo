//
//  SimpleListTableViewController.m
//  TinyDictionary
//
//  Created by Meler Paine on 2019/1/15.
//  Copyright © 2019 Sinking Soul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimpleListTableViewController.h"

@interface SimpleListTableViewController ()


@end

@implementation SimpleListTableViewController {
    void (^rightBarButtonAction)(void);
}

@synthesize viewModel, cellSelectingEvents;

- (id)initWithTitle:(NSMutableArray<NSString *> *)titles icons:(nullable NSMutableArray<UIImage *> *)icons selectingEvents:(nullable NSMutableArray<void (^)(void)> *)events {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        viewModel = [SimpleListViewModel new];
        viewModel.titles = titles;
        viewModel.icons = icons;
        cellSelectingEvents = events;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setupRightBarButtonWithTitle:(NSString *)title event:(void (^)(void))event {
    rightBarButtonAction = event;
    UIBarButtonItem *doneBarButttonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStyleDone target:self action:@selector(doneTapped:)];
    self.navigationItem.rightBarButtonItem = doneBarButttonItem;
}

- (void)doneTapped:(id)sender
{
    rightBarButtonAction();
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return viewModel.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [viewModel.titles objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (viewModel.icons != nil) {
        cell.imageView.image = [viewModel.icons objectAtIndex:indexPath.row];
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    void (^event)(void) = ^() {};
    if (cellSelectingEvents != nil) {
        event = [cellSelectingEvents objectAtIndex:indexPath.row];
        event();
    }
}

@end
