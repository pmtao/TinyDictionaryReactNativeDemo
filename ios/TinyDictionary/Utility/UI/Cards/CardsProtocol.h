//
//  CardsProtocol.h
//  TinyDictionary
//
//  Created by Meler Paine on 2019/1/13.
//  Copyright © 2019 Sinking Soul. All rights reserved.
//

#ifndef CardsProtocol_h
#define CardsProtocol_h


#endif /* CardsProtocol_h */

#import <UIKit/UIKit.h>


/**
 单条卡片记录需要的数据
 */
@protocol CardItem <NSObject>

@property (nonatomic, copy) NSString *cardTitle;
@property (nonatomic, copy) NSString *htmlContent;
@property (nonatomic, copy) UIImage *cardBackgroundImage;

@end



/**
 提供给卡片视图的数据源
 */
@protocol CardsDataSource <NSObject>

@required

/// CardSliderItem for the card at given index, counting from the top.
- (id<CardItem>) item: (NSInteger) index;

/// Total number of cards.
-(NSInteger) numberOfItems;

@optional

@property (nonatomic, copy) NSString *cardsTotalTitle;

@end
