//
//  BCCollectionViewCell.h
//  new
//
//  Created by Jack on 16/6/16.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BCCollectionViewCell;
@protocol collectDelegate <NSObject>

@required
- (void)clickCell:(BCCollectionViewCell *)cell;

@end
@interface BCCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *testImage;
@property (nonatomic, strong) UIButton *kCheckButton;
@property (nonatomic, weak) id<collectDelegate>delegate;

@end
