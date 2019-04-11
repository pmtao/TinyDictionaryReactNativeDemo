//
//  CardsViewController.m
//  TinyDictionary
//
//  Created by Meler Paine on 2019/1/13.
//  Copyright © 2019 Sinking Soul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CardsViewController.h"
#import "CardsProtocol.h"
#import "CardCell.h"
#import "AppConfig.h"
#import "TextTool.h"

@interface CardsViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, assign) UIStatusBarStyle statusbarStyle;

@end

@implementation CardsViewController {
    UIStatusBarStyle _statusbarStyle;
}

@synthesize dataSource, retainedDataSource, collectionView, pageControl, shouldShowRightNavBarButton;
@dynamic statusbarStyle;

+ (CardsViewController *)new:(id<CardsDataSource>)dataSource {
    CardsViewController *vc = [[UIStoryboard storyboardWithName:@"CardSlider" bundle:nil] instantiateInitialViewController];
    vc.dataSource = dataSource;
    vc.shouldShowRightNavBarButton = YES;
    return vc;
}

#pragma mark - 视图生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBar.hidden = NO;
}


#pragma mark - 视图 UI 设置

- (void)setup {
    if (dataSource == nil) {
        dataSource = retainedDataSource;
    }
    [self pageControlSetup];
    [self collectionViewSetup];
    [self navigationBarSetup];
}

- (void)navigationBarSetup {
    self.navigationItem.title = self.dataSource.cardsTotalTitle;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor navBarTintColor]};
    if (shouldShowRightNavBarButton) {
        UIBarButtonItem *soundBarButtonItem =
        [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"sound"]
                                         style:UIBarButtonItemStyleDone
                                        target:self
                                        action:@selector(soundButtonTapped:)];
        self.navigationItem.rightBarButtonItem = soundBarButtonItem;
    }
}

- (void)pageControlSetup {
    pageControl.numberOfPages = dataSource.numberOfItems;
    pageControl.currentPage = 0;
    pageControl.userInteractionEnabled = NO;
    pageControl.pageIndicatorTintColor = [UIColor pageControlTintColor];
    pageControl.currentPageIndicatorTintColor = [UIColor navBarBackgroundColor];
}

- (void)collectionViewSetup {
    collectionView.pagingEnabled = YES;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.delaysContentTouches = NO;
    if (@available(iOS 11.0, *)) {
        collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    UINib *nib = [UINib nibWithNibName:@"CardCell" bundle:nil];
    [collectionView registerNib:nib forCellWithReuseIdentifier:@"singleCardCell"];
}


#pragma mark - 手机顶部状态栏设置

- (UIStatusBarStyle)statusbarStyle {
    return _statusbarStyle;
}

- (void)setStatusbarStyle:(UIStatusBarStyle)statusbarStyle {
    _statusbarStyle = statusbarStyle;
    [UIView animateWithDuration:0.3 animations:^{
        [self setNeedsStatusBarAppearanceUpdate];
    }];
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return _statusbarStyle;
}

#pragma mark - 数据源与视图代理扩展

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count = [self.dataSource numberOfItems];
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"singleCardCell" forIndexPath:indexPath];
    NSLog(@"cellForItemAtIndexPath");
    // Configure the cell
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    id<CardItem> item = [self.dataSource item:indexPath.item];
    [(CardCell *)cell setup:item];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
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
    pageControl.currentPage = [self getCurrentPage];
}

- (NSInteger)getCurrentPage {
    return MAX((floor(collectionView.contentOffset.x) / floor(collectionView.bounds.size.width)), 0);
}

#pragma mark - 事件响应

- (void)soundButtonTapped:(id)sender
{
    [TextTool readText:dataSource.cardsTotalTitle];
}


@end



