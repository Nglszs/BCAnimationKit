//
//  BCFlowLayout.m
//  BCAnimationKit
//
//  Created by Jack on 16/5/23.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "BCFlowLayout.h"

@implementation BCFlowLayout


//重写三个方法，实现各种布局


- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {


    return YES;
}



- (void)prepareLayout {

    [super prepareLayout];
    
    
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;//水平滑动
    
    
    self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);




}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{

    NSArray *newArr = [super layoutAttributesForElementsInRect:rect];
    

CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width * 0.5;

    for (UICollectionViewLayoutAttributes *attributes in newArr) {
        CGFloat gapX = ABS(attributes.center.x - centerX);
        
        // 根据间距值计算 cell的缩放比例
        CGFloat scale = 1 - gapX / self.collectionView.frame.size.width;
        
        // 设置缩放比例
        attributes.transform = CGAffineTransformMakeScale(scale, scale);

    }
    return newArr;
}
@end
