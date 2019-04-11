//
//  AppDelegate.m
//  TinyDictionary
//
//  Created by Meler Paine on 2019/1/13.
//  Copyright © 2019 Sinking Soul. All rights reserved.
//

#import "AppDelegate.h"
#import "WordSearchViewController.h"
#import "CrashReport.h"
#import "AppConfig.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UIColor *tintColor = [UIColor navBarTintColor];
    [[UINavigationBar appearance] setTintColor:tintColor];
    UIColor *barTintColor = [UIColor navBarBackgroundColor];
    [[UINavigationBar appearance] setBarTintColor:barTintColor];
    [[UISearchBar appearance] setTintColor:tintColor];
    
    WordSearchViewController *mainViewController = [[WordSearchViewController alloc] init];
    mainViewController->suggestedWords = [NSMutableArray array];

    UINavigationController *mainNavigationController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
    
    self.window.rootViewController = mainNavigationController;
    
    [self.window makeKeyAndVisible];
    [self catchCrashLogs];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {

}

- (void)applicationDidEnterBackground:(UIApplication *)application {

}

- (void)applicationWillEnterForeground:(UIApplication *)application {

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

#pragma mark - Save crash log


- (void)catchCrashLogs {
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
}


void UncaughtExceptionHandler(NSException *exception) {
    if (exception ==nil)return;
    NSArray *array = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name  = [exception name];
    NSDictionary *dict = @{@"appException":@{@"exceptioncallStachSymbols":array,@"exceptionreason":reason,@"exceptionname":name}};
    if([CrashReport writeCrashFileOnDocumentsException:dict]){
        NSLog(@"Crash logs write ok!");
    }
}

@end
