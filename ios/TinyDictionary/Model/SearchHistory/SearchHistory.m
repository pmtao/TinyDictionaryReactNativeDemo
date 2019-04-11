//
//  SearchHistory.m
//  TinyDictionary
//
//  Created by Meler Paine on 2019/1/14.
//  Copyright © 2019 Sinking Soul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchHistory.h"



@implementation SearchHistory

@synthesize searchedWords;

- (instancetype)init {
    self = [super init];
    if (self) {
        searchedWords = [NSMutableArray array];
    }
    return  self;
}


@end
