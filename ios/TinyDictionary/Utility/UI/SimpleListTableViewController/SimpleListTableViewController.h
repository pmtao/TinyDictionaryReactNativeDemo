//
//  SimpleListTableViewController.h
//  TinyDictionary
//
//  Created by Meler Paine on 2019/1/15.
//  Copyright © 2019 Sinking Soul. All rights reserved.
//

#ifndef SimpleListTableViewController_h
#define SimpleListTableViewController_h


#endif /* SimpleListTableViewController_h */
#import <UIKit/UIKit.h>
#import "SimpleListViewModel.h"

@interface SimpleListTableViewController : UITableViewController

@property (strong, nonatomic) SimpleListViewModel *viewModel;
@property (strong, nonatomic) NSMutableArray<void (^)(void)> * _Nullable cellSelectingEvents;


- (id)initWithTitle:(NSMutableArray<NSString *> *)titles icons:(nullable NSMutableArray<UIImage *> *)icons selectingEvents:(nullable NSMutableArray<void (^)(void)> *)events;
- (void)setupRightBarButtonWithTitle:(NSString *)title event:(void (^)(void))event;


@end
