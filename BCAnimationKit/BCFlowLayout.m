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
    
    //设置cell的大小
    self.itemSize = CGSizeMake(160, 160);
    
    //让图片都居中显示
    CGFloat insetGap = (self.collectionView.frame.size.width - self.itemSize.width) * 0.5;
    self.sectionInset = UIEdgeInsetsMake(0, insetGap, 0, insetGap);

    

}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{

    
    NSArray *newArr = [super layoutAttributesForElementsInRect:rect];
    
    
    //返回的必须是newarray的拷贝，否则控制台会打印错误信息但是不影响结果
    NSArray * array = [[NSArray alloc] initWithArray:newArr copyItems:YES];
    
    //collectionview中心点的位置
CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width * 0.5;

    
    for (UICollectionViewLayoutAttributes *attributes in array) {
        
        // cell的中点X 与 collectionView中心点的X间距
        CGFloat gapX = attributes.center.x - centerX;
        
        switch (_animationType) {
            case UICollectionViewAnimation1://两边小中间大
            {
                
               
                
                // 根据间距值计算 cell的缩放比例
                CGFloat scale = 1 - ABS(gapX) / self.collectionView.frame.size.width;
                
                // 设置缩放比例
                attributes.transform = CGAffineTransformMakeScale(scale, scale);
  
                
            }
                break;
                
                case UICollectionViewAnimation2://两边侧向
            {
                
               CGFloat normalizedDistance = gapX / 100;
                
                if (ABS(gapX) <= 45) {
                    
                    CATransform3D transfrom = CATransform3DIdentity;
                    transfrom.m34 = 1.0 / 600;
                    transfrom = CATransform3DRotate(transfrom, normalizedDistance * 2, 0.0f, 1.0f, 0.0f);
                    attributes.transform3D = transfrom;
                    attributes.zIndex = 1;
                    
                } else {
                    CATransform3D transform = CATransform3DIdentity;
                    transform.m34 = 1.0/600;
                    if (gapX > 0) {
                        
                        transform = CATransform3DRotate(transform,  45 , 0.0f, 1.0f, 0.0f);
                        
                    } else {
                    
                        transform = CATransform3DRotate(transform, -45, 0.0f, 1.0f, 0.0f);
                    }
                
                    attributes.transform3D = transform;
                    attributes.zIndex = 1;
                }
                
               
                
               
               
                
                
            }
                
                break;
            default:
                break;
        }

        
    }
    
    return array;
    
}
@end
