//
//  AppConfig.m
//  TinyDictionary
//
//  Created by Meler Paine on 2019/1/14.
//  Copyright © 2019 Sinking Soul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppConfig.h"

//UIColor *const NavBarBackgroundColor = [UIColor colorWithRed:0.23 green:0.67 blue:1.00 alpha:1.00];

@implementation UIColor (TinyDictionary)

+ (UIColor *)navBarBackgroundColor {
    return [UIColor colorWithRed:0.23 green:0.67 blue:1.00 alpha:1.00];
}

+ (UIColor *)navBarTintColor {
    return [UIColor colorWithRed:0.04 green:0.36 blue:0.91 alpha:1.00];//[UIColor colorWithRed:0.02 green:0.09 blue:0.64 alpha:1.00];
}

+ (UIColor *)pageControlTintColor {
    return [UIColor colorWithRed:0.73 green:0.88 blue:1.00 alpha:1.00];
}

@end
