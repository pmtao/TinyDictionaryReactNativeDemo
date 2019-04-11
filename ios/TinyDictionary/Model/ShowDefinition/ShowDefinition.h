//
//  ShowDefinition.h
//  TinyDictionary
//
//  Created by Meler Paine on 2019/1/13.
//  Copyright © 2019 Sinking Soul. All rights reserved.
//

#ifndef ShowDefinition_h
#define ShowDefinition_h


#endif /* ShowDefinition_h */

#import "CardsProtocol.h"
#import "CardsViewController.h"

@interface ShowDefinition : NSObject <CardsDataSource>

@property (nonatomic, copy) NSString *word;
@property (nonatomic, strong) CardsViewController *cardsView;
@property (nonatomic, copy) NSString *cardsTotalTitle;

- (instancetype)initWithWord:(NSString *)term;

@end
