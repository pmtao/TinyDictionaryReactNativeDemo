//
//  NavigationAnimator.h
//  TinyDictionary
//
//  Created by Meler Paine on 2019/4/3.
//  Copyright © 2019 Sinking Soul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavigationAnimator : NSObject<UIViewControllerAnimatedTransitioning>

- (instancetype)initWith:(UINavigationControllerOperation)type;

@end
