//
//  STViewController.m
//  CLLocationSamples
//
//  Created by EIMEI on 2013/07/29.
//  Copyright (c) 2013 stack3. All rights reserved.
//

#import "STViewController.h"
#import "STGetLocationViewController.h"
#import "STGetLocation2ViewController.h"
#import "STNavigateLocationViewController.h"

#define _STCellId @"CellId"

typedef enum {
    _STMenuItemGetLocation,
    _STMenuItemGetLocation2,
    _STMenuItemNavigateLocation,
} _STMenuItems;

@implementation STViewController {
    __strong NSMutableArray *_items;
    IBOutlet __weak UITableView *_tableView;
}

- (id)init
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.title = @"Menu";
        
        _items = [NSMutableArray arrayWithCapacity:10];
        
        [_items addObject:@"Get Location"];
        [_items addObject:@"Get Location 2"];
        [_items addObject:@"Navigate Location"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:_STCellId];
    _tableView.dataSource = self;
    _tableView.delegate = self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:_STCellId forIndexPath:indexPath];
    
    NSString *item = [_items objectAtIndex:indexPath.row];
    cell.textLabel.text = item;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _STMenuItemGetLocation) {
        STGetLocationViewController *con = [[STGetLocationViewController alloc] init];
        [self.navigationController pushViewController:con animated:YES];
    } else if (indexPath.row == _STMenuItemGetLocation2) {
        STGetLocation2ViewController *con = [[STGetLocation2ViewController alloc] init];
        [self.navigationController pushViewController:con animated:YES];
    } else if (indexPath.row == _STMenuItemNavigateLocation) {
        STNavigateLocationViewController *con = [[STNavigateLocationViewController alloc] init];
        [self.navigationController pushViewController:con animated:YES];
    }
}

@end
