//
//  DefinitionCard.m
//  TinyDictionary
//
//  Created by Meler Paine on 2019/1/13.
//  Copyright © 2019 Sinking Soul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DefinitionCard.h"

@implementation DefinitionCard

- (instancetype)initWith:(NSString *)title content:(NSString *)content background:(UIImage *)cardBackgroundImage {
    self = [super init];
    if (self) {
        self.cardTitle = title;
        self.htmlContent = content;
        self.cardBackgroundImage = cardBackgroundImage;
    }
    return self;
}

@end
