//
//  ShowDefinition.m
//  TinyDictionary
//
//  Created by Meler Paine on 2019/1/13.
//  Copyright © 2019 Sinking Soul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShowDefinition.h"
#import "DefinitionCard.h"

@interface ShowDefinition ()

@property (nonatomic, strong) NSMutableArray<__kindof DefinitionCard *> *definitionCards;

@end

@implementation ShowDefinition {
    id dictManager;
}

@synthesize word, cardsTotalTitle, cardsView, definitionCards;

- (instancetype)initWithWord:(NSString *)term {
    self = [super init];
    if (self) {
        self.word = term;
        self.cardsTotalTitle = term;
        dictManager = [[self DictManager] new];
        [self initialCards];
        self.cardsView = [CardsViewController new:self];
    }
    return self;
}

- (void)initialCards {
    BOOL hasDefinition = [self hasDefinitionForTerm:word];
    if (hasDefinition) {
        NSMutableArray *definitions = [self getDefinitions:word];
        NSMutableArray *cards = [self makeCardsFromdefinitions:definitions];
        definitionCards = cards;
    } else {
    }
    
}

#pragma mark - 数据源代理方法

- (id<CardItem>)item:(NSInteger)index {
    return definitionCards[index];
}

- (NSInteger)numberOfItems {
    return [definitionCards count];
}

#pragma mark - 词典解释获取方法


- (BOOL)hasDefinitionForTerm:(NSString *)word {
    return [dictManager performSelector:NSSelectorFromString(@"_hasDefinitionForTerm:") withObject:word];
}

- (NSMutableArray *)getDefinitions:(NSString *)word {
    NSMutableArray *definitions = [dictManager performSelector:NSSelectorFromString(@"_definitionValuesForTerm:") withObject:word];
    return definitions;
}

- (NSMutableArray *)makeCardsFromdefinitions:(NSMutableArray *)definitions {
    NSMutableArray *cards = [NSMutableArray array];
    UIImage *image3 = [UIImage imageNamed:@"cardBackground3"];
    
    for (id definition in definitions) {
        NSString *dictName = [definition performSelector:NSSelectorFromString(@"localizedDictionaryName")];
        NSString *definitionString = [definition performSelector:NSSelectorFromString(@"longDefinition")];
        DefinitionCard *card = [[DefinitionCard alloc] initWith:dictName content:definitionString background:image3];
        [cards addObject:card];
    }
    return cards;
}

- (Class)DictManager {
    Class class = NSClassFromString(@"_UIDictionaryManager");
    return class;
}



@end

