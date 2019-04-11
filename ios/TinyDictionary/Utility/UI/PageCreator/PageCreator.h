//
//  PageCreator.h
//  TinyDictionary
//
//  Created by Meler Paine on 2019/1/15.
//  Copyright © 2019 Sinking Soul. All rights reserved.
//

#ifndef PageCreator_h
#define PageCreator_h


#endif /* PageCreator_h */
#import "SimpleListTableViewController.h"
#import "CardsViewController.h"

@interface PageCreator : NSObject

+ (SimpleListTableViewController *)initialAppConfigViewController;
+ (SimpleListTableViewController *)initialUserAnalysisViewController;
+ (SimpleListTableViewController *)initialCrashReportViewController;
+ (CardsViewController *)initialCrashReportDetailViewController;
+ (SimpleListTableViewController *)initialAppPerformanceViewController;

@end
