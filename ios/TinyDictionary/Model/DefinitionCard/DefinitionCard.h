//
//  DefinitionCard.h
//  TinyDictionary
//
//  Created by Meler Paine on 2019/1/13.
//  Copyright © 2019 Sinking Soul. All rights reserved.
//

#ifndef DefinitionCard_h
#define DefinitionCard_h


#endif /* DefinitionCard_h */

#import "CardsProtocol.h"

@interface DefinitionCard: NSObject <CardItem>

@property (nonatomic, copy) NSString *cardTitle;
@property (nonatomic, copy) NSString *htmlContent;
@property (nonatomic, copy) UIImage *cardBackgroundImage;

- (instancetype)initWith:(NSString *)title content:(NSString *)content background:(UIImage *)cardBackgroundImage;

@end
