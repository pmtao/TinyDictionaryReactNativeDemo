//
//  CardsViewController.h
//  TinyDictionary
//
//  Created by Meler Paine on 2019/1/13.
//  Copyright © 2019 Sinking Soul. All rights reserved.
//

#ifndef CardsViewController_h
#define CardsViewController_h


#endif /* CardsViewController_h */

#import <UIKit/UIKit.h>
#import "CardsProtocol.h"

@interface CardsViewController : UIViewController

@property (weak, nonatomic) id<CardsDataSource> dataSource;
@property (strong, nonatomic) id<CardsDataSource> retainedDataSource;
@property (assign, nonatomic) BOOL shouldShowRightNavBarButton;


+ (CardsViewController *)new:(id<CardsDataSource>)dataSource;

@end
