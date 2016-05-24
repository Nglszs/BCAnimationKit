//
//  CollectionViewController.m
//  BCAnimationKit
//
//  Created by Jack on 16/5/23.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "CollectionViewController.h"
#import "BCFlowLayout.h"
#import "BCCell.h"


@interface CollectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{

    NSArray *imageArr;

}
@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    imageArr = @[@"bc.jpg",@"bc1.jpg",@"head.jpg"];
    //这里用collectionview实现一些图片浏览的效果
   
    BCFlowLayout *layout = [[BCFlowLayout alloc] init];
    
    layout.itemSize = CGSizeMake(150, 150);
    
    UICollectionView *testCollectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 100, BCWidth, 200) collectionViewLayout:layout];
    testCollectView.delegate = self;
    testCollectView.dataSource = self;
    [self.view addSubview:testCollectView];
    
    
    
    [testCollectView registerNib:[UINib nibWithNibName:NSStringFromClass([BCCell class])bundle:nil] forCellWithReuseIdentifier:@"cell"];
    
    
    
    
}

#pragma mark  代理相关
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    

    BCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.testImage.image = [UIImage imageNamed:imageArr[indexPath.row]];
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击的item---%zd",indexPath.item);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
