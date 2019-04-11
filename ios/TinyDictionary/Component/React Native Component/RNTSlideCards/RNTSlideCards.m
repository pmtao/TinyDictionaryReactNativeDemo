//
//  RNTSlideCards.m
//  TinyDictionary
//
//  Created by Meler Paine on 2019/3/29.
//  Copyright © 2019 Sinking Soul. All rights reserved.
//

#import "RNTSlideCards.h"
#import "AppConfig.h"
#import "UIView+Extension.h"
#import "CardsLayout.h"
#import "Masonry.h"
#import "CardCell.h"

#import "ShowDefinition.h"
#import "DefinitionCard.h"
#import "TextTool.h"

@interface RNTSlideCards () <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray<__kindof DefinitionCard *> *definitionCards;

@end

@implementation RNTSlideCards {
    id dictManager;
}

@synthesize collectionView, pageControl;

#pragma mark - 视图初始化


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        dictManager = [[self DictManager] new];
//        [self initialCards];
        
        pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
//        [self pageControlSetup];
        [self addSubview:pageControl];
        
        collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[[CardsLayout alloc] init]];
        [self collectionViewSetup];
        [self addSubview:collectionView];
        
        [self subViewLayout];
    }
    return self;
}

- (void)pageControlSetup {
    pageControl.backgroundColor = UIColor.whiteColor;
    pageControl.numberOfPages = self.numberOfItems;
    pageControl.currentPage = 0;
    pageControl.userInteractionEnabled = NO;
    pageControl.pageIndicatorTintColor = [UIColor pageControlTintColor];
    pageControl.currentPageIndicatorTintColor = [UIColor navBarBackgroundColor];
}

- (void)collectionViewSetup {
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor = UIColor.whiteColor;
    collectionView.pagingEnabled = YES;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.delaysContentTouches = NO;
    if (@available(iOS 11.0, *)) {
        collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    UINib *nib = [UINib nibWithNibName:@"CardCell" bundle:nil];
    [collectionView registerNib:nib forCellWithReuseIdentifier:@"singleCardCell"];
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    [self subViewLayout];
}

- (void)subViewLayout {
    [pageControl makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.mas_safeAreaLayoutGuideTop);
        } else {
            make.top.equalTo(self).offset(64);
        }
        make.bottom.equalTo(self.collectionView.mas_top).offset(0);
    }];
    
    [collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.mas_safeAreaLayoutGuideTop).offset(20);
//            make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom);
        } else {
            make.top.equalTo(self).offset(64 + 20);
//            make.bottom.equalTo(self);
        }
        make.bottom.equalTo(self);
    }];
}

//- (void)setDataSource:(id<CardsDataSource>)dataSource {
//    self.dataSource = dataSource;
//}

- (void)initialCards {
    BOOL hasDefinition = [self hasDefinitionForTerm:_term];
    if (hasDefinition) {
        NSMutableArray *definitions = [self getDefinitions:_term];
        NSMutableArray *cards = [self makeCardsFromdefinitions:definitions];
        _definitionCards = cards;
        [collectionView reloadData];
    } else {
        
    }
    
}

#pragma mark - 视图设置

- (void)setupNavigation:(NSString *)title {
    UIViewController *parentVC = [self parentViewController];
    parentVC.navigationItem.title = title;
    parentVC.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor navBarTintColor]};
    
    if (parentVC.navigationItem.rightBarButtonItem == nil) {
        UIBarButtonItem *soundBarButtonItem =
        [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"sound"]
                                         style:UIBarButtonItemStyleDone
                                        target:self
                                        action:@selector(soundButtonTapped:)];
        parentVC.navigationItem.rightBarButtonItem = soundBarButtonItem;
    }
}

- (void)soundButtonTapped:(id)sender {
    [TextTool readText:_term];
}

#pragma mark - 接收 RN 属性传值

- (void)setTerm:(NSString *)term {
    _term = term;
    [self initialCards];
    [self pageControlSetup];
}

//- (void)didMoveToSuperview {
//    [self setupNavigation:[self item:0].cardTitle];
//}

//- (void)setViewController:(UIViewController *)viewController {
//    _viewController = viewController;
//    
//}

#pragma mark - 数据源与视图代理扩展

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    [self setupNavigation:[self item:0].cardTitle];
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count = [self numberOfItems];
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"singleCardCell" forIndexPath:indexPath];
    NSLog(@"cellForItemAtIndexPath");
    // Configure the cell
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    id<CardItem> item = [self item:indexPath.item];
    [(CardCell *)cell setup:item];
}

#pragma mark - scrollView 代理

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.collectionView.visibleCells enumerateObjectsUsingBlock:^(__kindof UICollectionViewCell * _Nonnull cell, NSUInteger idx, BOOL * _Nonnull stop) {
        [(CardCell *)cell addRadius:YES];
    }];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    pageControl.currentPage = [self getCurrentPage];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self.collectionView.visibleCells enumerateObjectsUsingBlock:^(__kindof UICollectionViewCell * _Nonnull cell, NSUInteger idx, BOOL * _Nonnull stop) {
        [(CardCell *)cell addRadius:NO];
    }];
    NSInteger page = [self getCurrentPage];
    pageControl.currentPage = page;
    id<CardItem> item = [self item:page];
    [self setupNavigation:item.cardTitle];
}

- (NSInteger)getCurrentPage {
    if (collectionView.bounds.size.width == 0) {
        return 0;
    } else {
        return MAX((floor(collectionView.contentOffset.x) / floor(collectionView.bounds.size.width)), 0);
    }
}


#pragma mark - 数据源代理方法

- (id<CardItem>)item:(NSInteger)index {
    return _definitionCards[index];
}

- (NSInteger)numberOfItems {
    return [_definitionCards count];
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
