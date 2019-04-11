//
//  UIView+Extension.m
//  TinyDictionary
//
//  Created by Meler Paine on 2019/4/2.
//  Copyright © 2019 Sinking Soul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Extension.h"

@implementation UIView (TinyDictionary)

- (UIViewController *)parentViewController {
    UIResponder *parentResponder = self;
    while (parentResponder != nil) {
        parentResponder = parentResponder.nextResponder;
        if ( parentResponder != nil && [parentResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)parentResponder;
        }
    }
    return nil;
}

@end
