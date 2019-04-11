//
//  NavigationDelegate.h
//  TinyDictionary
//
//  Created by Meler Paine on 2019/4/3.
//  Copyright © 2019 Sinking Soul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavigationDelegate : NSObject<UINavigationControllerDelegate>


/**
 转场是否可交互
 */
@property (nonatomic, assign) BOOL interactable;
- (instancetype)init:(UINavigationController *)navigationController;

@end
