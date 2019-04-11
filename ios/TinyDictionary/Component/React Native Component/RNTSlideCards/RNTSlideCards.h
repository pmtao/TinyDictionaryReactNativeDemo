//
//  RNTSlideCards.h
//  TinyDictionary
//
//  Created by Meler Paine on 2019/3/29.
//  Copyright © 2019 Sinking Soul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardsProtocol.h"

@interface RNTSlideCards : UIView

@property (nonatomic, copy) NSString *term;
//@property (nonatomic, weak) UIViewController *viewController;

- (instancetype)initWithFrame:(CGRect)frame;

@end
