//
//  RNTSlideCardsManager.m
//  TinyDictionary
//
//  Created by Meler Paine on 2019/3/29.
//  Copyright © 2019 Sinking Soul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <React/RCTViewManager.h>
#import "RNTSlideCardsManager.h"
#import "RNTSlideCards.h"

@implementation RNTSlideCardsManager

RCT_EXPORT_MODULE(RNTSlideCards)

// 导出参数供 RN 使用
RCT_EXPORT_VIEW_PROPERTY(term, NSString) // 待查询的单词
//RCT_EXPORT_VIEW_PROPERTY(viewController, UIViewController) // 视图所在的 ViewController


- (UIView *)view
{
    UIView *view = [[RNTSlideCards alloc] init];
//    [[RNTSlideCards alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    view.backgroundColor = UIColor.whiteColor;
    return view;
}

@end
