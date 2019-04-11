//
//  CardCell.h
//  TinyDictionary
//
//  Created by Meler Paine on 2019/1/13.
//  Copyright © 2019 Sinking Soul. All rights reserved.
//

#ifndef CardCell_h
#define CardCell_h


#endif /* CardCell_h */

#import <UIKit/UIKit.h>
#import "CardsProtocol.h"

@interface CardCell : UICollectionViewCell

- (void)setup:(id<CardItem>)item;
- (void)addRadius:(BOOL)shouldAdd;

@end
