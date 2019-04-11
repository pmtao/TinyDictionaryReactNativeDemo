//
//  CardCell.m
//  TinyDictionary
//
//  Created by Meler Paine on 2019/1/13.
//  Copyright © 2019 Sinking Soul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "Masonry.h"

#import "CardCell.h"
#import "CardsProtocol.h"
#import "EasyReadWebView.h"
#import "AppConfig.h"

@interface CardCell ()

@property (strong, nonatomic) UIImageView *backgroundImageView;
@property (strong, nonatomic) UIView *backgroundShadowView;
@property (nonatomic, assign) CGRect latestCellBounds; // 只用于判断是否有 bounds 更新


@property (weak, nonatomic) IBOutlet UILabel *cardTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *webContainerView;
@property (strong, nonatomic) EasyReadWebView *webView;

@end

@implementation CardCell

@synthesize backgroundImageView, backgroundShadowView, latestCellBounds;
@synthesize cardTitleLabel, webContainerView, webView;

- (void)awakeFromNib {
    [super awakeFromNib];
    backgroundImageView = [UIImageView new];
    backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    backgroundImageView.clipsToBounds = YES;
    backgroundShadowView = [UIView new];
    
    [self addSubview:backgroundShadowView];
    [self addSubview:backgroundImageView];
    [self sendSubviewToBack:backgroundImageView];
    [self sendSubviewToBack:backgroundShadowView];
    self.clipsToBounds = NO;
    
    webView = [[EasyReadWebView alloc] initWithFrame:webContainerView.bounds];
    [webContainerView addSubview:webView];
    [webView makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self->webContainerView);
    }];
    
    cardTitleLabel.textColor = [UIColor navBarTintColor];
}

- (void)setBounds:(CGRect)rect {
    [super setBounds:rect];
    if (!CGRectEqualToRect(latestCellBounds, rect)) {
        latestCellBounds = rect;
        [self update];
    }
}

- (void)setup:(id<CardItem>)item {
//    backgroundImageView.image = item.cardBackgroundImage;
    cardTitleLabel.text = item.cardTitle;
    webContainerView.clipsToBounds = YES;
    webContainerView.backgroundColor = UIColor.clearColor;
    [webView loadHTMLString:item.htmlContent baseURL:nil];
}

- (void)update {
    backgroundImageView.frame = UIEdgeInsetsInsetRect(self.bounds, UIEdgeInsetsMake(0, 0, 0, 0));
    backgroundShadowView.frame = backgroundImageView.frame;
    backgroundShadowView.backgroundColor = UIColor.whiteColor;
    backgroundShadowView.layer.shadowColor = [UIColor navBarBackgroundColor].CGColor;
    backgroundShadowView.layer.shadowOpacity = 0.6;
    backgroundShadowView.layer.shadowOffset = CGSizeMake(0, 4);
    backgroundShadowView.layer.shadowRadius = 6;
    [self addRadius:NO];
}

- (void)addRadius:(BOOL)shouldAdd {
    backgroundImageView.layer.cornerRadius = shouldAdd ? 10 : 0;
    backgroundShadowView.layer.cornerRadius = shouldAdd ? 10 : 0;
    webContainerView.layer.cornerRadius = shouldAdd ? 10 : 0;
}

@end
