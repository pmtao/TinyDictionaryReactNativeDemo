//
//  CardsLayout.m
//  TinyDictionary
//
//  Created by Meler Paine on 2019/1/13.
//  Copyright © 2019 Sinking Soul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardsLayout.h"


@interface CardsLayout ()

// 普通属性
@property (nonatomic, assign) CGRect contentBounds;
/** 存储 UICollectionViewLayoutAttributes 类型 */
@property (nonatomic, strong) NSMutableArray *cachedAttributes;

// 计算属性
@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, assign, readonly) NSInteger itemsCount;
@property (nonatomic, assign, readonly) CGRect collectionBounds;
@property (nonatomic, assign, readonly) CGPoint contentOffset;
@property (nonatomic, assign, readonly) NSInteger currentPage;


@end

@implementation CardsLayout {
    CGSize _itemSize;
}

@synthesize contentBounds;
@synthesize cachedAttributes;

#pragma mark - 便利计算属性

@dynamic itemSize;
@dynamic itemsCount;
@dynamic collectionBounds;
@dynamic contentOffset;
@dynamic currentPage;

- (void)setItemSize:(CGSize)size {
    _itemSize = size;
    [self invalidateLayout];
}

- (CGSize)itemSize {
    return _itemSize;
}

- (NSInteger)itemsCount {
    return [self.collectionView numberOfItemsInSection: 0];
}

- (CGRect)collectionBounds {
    return self.collectionView.bounds;
}

- (CGPoint)contentOffset {
    return self.collectionView.contentOffset;
}

- (NSInteger)currentPage {
    if (self.collectionBounds.size.width == 0) {
        return 0;
    } else {
        return MAX((floor(self.contentOffset.x) / floor(self.collectionBounds.size.width)), 0);
    }
}

- (instancetype)init {
    self = [super init];
    if (self) {
        contentBounds = CGRectZero;
        cachedAttributes = [NSMutableArray array];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        contentBounds = CGRectZero;
        cachedAttributes = [NSMutableArray array];
    }
    return self;
}

#pragma mark - 自定义布局方法

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    CGFloat maxBoundsX = self.collectionBounds.size.width * (CGFloat)(self.itemsCount - 1);
    CGFloat minBoundsX = 0;
    if (newBounds.origin.x > maxBoundsX || newBounds.origin.x < minBoundsX) {
        return NO;
    } else {
        return YES;
    }
}

- (void)prepareLayout {
    [super prepareLayout];
    if (self.collectionView) {
        [cachedAttributes removeAllObjects];
        self.contentBounds = CGRectMake(CGPointZero.x,
                                        CGPointZero.y,
                                        self.collectionView.bounds.size.width,
                                        self.collectionView.bounds.size.height);
        CGFloat width = self.collectionBounds.size.width;
        CGFloat height = self.collectionBounds.size.height;
        self.itemSize = CGSizeMake(width, height);
        [self createAtributes];
    }
}

- (CGSize)collectionViewContentSize {
    return  self.contentBounds.size;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.cachedAttributes[indexPath.item];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *layoutAttributes = [NSMutableArray array];
    
    for (UICollectionViewLayoutAttributes *attributes in self.cachedAttributes) {
        if (CGRectIntersectsRect(rect, attributes.frame)) {
            [layoutAttributes addObject:attributes];
        }
    }
    return layoutAttributes;
}


#pragma mark - 布局辅助计算方法

- (UICollectionViewLayoutAttributes *)layoutAttributes: (NSInteger)index {
    UICollectionViewLayoutAttributes *attributes =
    [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath: [NSIndexPath indexPathForItem:index inSection:0]];
    attributes.size = self.itemSize;
    CGFloat fixedOffset = self.contentOffset.x + self.collectionBounds.size.width - self.itemSize.width / 2;
    if (index <= self.currentPage) {
        attributes.center = CGPointMake(fixedOffset, CGRectGetMidY(self.collectionBounds));
    } else {
        CGFloat offset = (CGFloat)(index - self.currentPage) * self.collectionBounds.size.width - (NSInteger)self.contentOffset.x % (NSInteger)self.collectionBounds.size.width;
        attributes.center = CGPointMake(fixedOffset + offset, CGRectGetMidY(self.collectionBounds));
    }
    CGFloat offset = (NSInteger)self.contentOffset.x % (NSInteger)self.collectionBounds.size.width;
    CGFloat offsetProgress = offset / self.collectionBounds.size.width;
    if (index <= self.currentPage && offsetProgress > 0) {
        CGFloat scale = 0.8 + 0.2 * (1 - offsetProgress);
        attributes.transform = CGAffineTransformMakeScale(scale, scale);
    }
    if (index < self.currentPage) {
        attributes.size = CGSizeMake(self.itemSize.width * 0.8, self.itemSize.height * 0.8);
    }
    return attributes;
}

- (void)createAtributes {
    NSLog(@"CardLayout createAtributes.");
    for ( int i = 0; i < self.itemsCount; ++i ) {
        UICollectionViewLayoutAttributes *attribute = [self layoutAttributes:i];
        [self.cachedAttributes addObject:attribute];
    }
    CGSize size = CGSizeMake(self.collectionBounds.size.width * self.itemsCount,
                                         self.collectionBounds.size.height);
    self.contentBounds = CGRectMake(self.contentBounds.origin.x, self.contentBounds.origin.y,
                                    size.width, size.height);
}

@end
