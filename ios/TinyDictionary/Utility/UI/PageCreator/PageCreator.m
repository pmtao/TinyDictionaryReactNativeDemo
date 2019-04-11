//
//  PageCreator.m
//  TinyDictionary
//
//  Created by Meler Paine on 2019/1/15.
//  Copyright © 2019 Sinking Soul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PageCreator.h"
#import "CrashReport.h"
#import "CrashReportDetail.h"

@implementation PageCreator


+ (SimpleListTableViewController *)initialAppConfigViewController {
    NSMutableArray<NSString *> *titles = [[NSMutableArray alloc] initWithArray:@[@"使用统计", @"崩溃日志", @"应用性能"]];
    NSMutableArray *icons = [NSMutableArray array];
    [icons addObject:[UIImage imageNamed:@"analysis"]];
    [icons addObject:[UIImage imageNamed:@"bugReport"]];
    [icons addObject:[UIImage imageNamed:@"speedometer"]];
    
    SimpleListTableViewController *appConfigVC = [[SimpleListTableViewController alloc] initWithTitle:titles icons:icons selectingEvents:nil];
    
    // setup navigation bar right bar button action
    [appConfigVC setupRightBarButtonWithTitle:@"关闭" event:^{
        [appConfigVC dismissViewControllerAnimated:YES completion:nil];
    }];
    
    // setup cell selection event
    NSMutableArray<void (^)(void)> *cellSelectingEvents = [NSMutableArray array];
    [cellSelectingEvents addObject:^() {
        SimpleListTableViewController *userAnalysisVC = [PageCreator initialUserAnalysisViewController];
        UINavigationController *navVC = appConfigVC.navigationController;
        [navVC pushViewController:userAnalysisVC animated:YES];
    }];
    [cellSelectingEvents addObject:^() {
        SimpleListTableViewController *crashReportVC = [PageCreator initialCrashReportViewController];
        UINavigationController *navVC = appConfigVC.navigationController;
        [navVC pushViewController:crashReportVC animated:YES];
    }];
    [cellSelectingEvents addObject:^() {
        SimpleListTableViewController *appPerformanceVC = [PageCreator initialAppPerformanceViewController];
        UINavigationController *navVC = appConfigVC.navigationController;
        [navVC pushViewController:appPerformanceVC animated:YES];
    }];
    appConfigVC.cellSelectingEvents = cellSelectingEvents;
    
    return appConfigVC;
}

+ (SimpleListTableViewController *)initialUserAnalysisViewController {
    NSMutableArray<NSString *> *titles = [[NSMutableArray alloc]
                                          initWithArray:@[@"App 打开次数",
                                                          @"单词搜索次数",
                                                          @"常见搜索单词",
                                                          @"查询无结果次数",
                                                          @"单词解释平均查看时长"]];
    
    SimpleListTableViewController *userAnalysisVC = [[SimpleListTableViewController alloc] initWithTitle:titles icons:nil selectingEvents:nil];
    return userAnalysisVC;
}


+ (SimpleListTableViewController *)initialCrashReportViewController {
    NSMutableArray<NSString *> *titles = [[NSMutableArray alloc] initWithArray:[CrashReport getCrashFileCreateTimes]];
    
    SimpleListTableViewController *crashReportVC = [[SimpleListTableViewController alloc] initWithTitle:titles icons:nil selectingEvents:nil];
    
    // setup navigation bar right bar button action
    [crashReportVC setupRightBarButtonWithTitle:@"清除日志" event:^{
        BOOL success = [CrashReport clearCrashLogs];
        
        UIWindow *newWindow = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
        UIViewController *rootViewController = [UIViewController new];
        newWindow.rootViewController = rootViewController;
        [newWindow makeKeyAndVisible];
        
        if (success) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"日志清除成功" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [newWindow resignKeyWindow];
                crashReportVC.viewModel.titles = nil;
                [crashReportVC.tableView reloadData];
            }];
            [alertController addAction:cancelAction];
            [rootViewController presentViewController:alertController animated:YES completion:nil];
        } else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"无日志需要清除" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [newWindow resignKeyWindow];
            }];
            [alertController addAction:cancelAction];
            [rootViewController presentViewController:alertController animated:YES completion:nil];
        }
    }];
    
    // setup cell selection event
    NSMutableArray<void (^)(void)> *cellSelectingEvents = [NSMutableArray array];
    for (NSInteger i = 0;i < titles.count; ++i) {
        [cellSelectingEvents addObject:^() {
            CardsViewController *crashReportDetailVC = [PageCreator initialCrashReportDetailViewControllerWithIndex:i];
            UINavigationController *navVC = crashReportVC.navigationController;
            [navVC pushViewController:crashReportDetailVC animated:YES];
        }];
    }
    crashReportVC.cellSelectingEvents = cellSelectingEvents;
    
    return crashReportVC;
}

+ (CardsViewController *)initialCrashReportDetailViewControllerWithIndex:(NSInteger)index {
    NSMutableArray<NSString *> *titles = [[NSMutableArray alloc] initWithArray:[CrashReport getCrashFileCreateTimes]];
    NSMutableArray<NSString *> *details = [[NSMutableArray alloc] initWithArray:[CrashReport getCrashLogs]];
    
    CrashReportDetail *detail = [[CrashReportDetail alloc] initWithTitle:titles[index] Detail:details[index]];
    CardsViewController *crashReportVC = [CardsViewController new:detail];
    crashReportVC.retainedDataSource = detail;
    crashReportVC.shouldShowRightNavBarButton = NO;
    return crashReportVC;
    
}


+ (SimpleListTableViewController *)initialAppPerformanceViewController {
    NSMutableArray<NSString *> *titles = [[NSMutableArray alloc]
                                          initWithArray:@[@"App 启动耗时",
                                                          @"搜索页面加载耗时",
                                                          @"单词解释加载耗时",
                                                          @"App 内存占用"]];
    
    SimpleListTableViewController *appPerformanceVC = [[SimpleListTableViewController alloc] initWithTitle:titles icons:nil selectingEvents:nil];
    return appPerformanceVC;
    
}

@end
