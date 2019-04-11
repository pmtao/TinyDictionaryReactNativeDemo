//
//  CrashReportDetail.m
//  TinyDictionary
//
//  Created by Meler Paine on 2019/1/15.
//  Copyright © 2019 Sinking Soul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CrashReportDetail.h"
#import "DefinitionCard.h"

@implementation CrashReportDetail
@synthesize cardsTotalTitle, detail;



- (instancetype)initWithTitle:(NSString *)title Detail:(NSString *)detail {
    self = [super init];
    if (self) {
        cardsTotalTitle = title;
        self.detail = detail.description;
    }
    return self;
}

- (DefinitionCard *)makeCardFromDetail {
    DefinitionCard *card = [[DefinitionCard alloc] initWith:cardsTotalTitle content:detail background:nil];
    return card;
}

#pragma mark - 数据源代理方法

- (id<CardItem>)item:(NSInteger)index {
    return [self makeCardFromDetail];
}

- (NSInteger)numberOfItems {
    return 1;
}

@end
