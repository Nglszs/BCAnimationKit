//
//  BCPhotoViewController.m
//  new
//
//  Created by Jack on 16/6/16.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "BCPhotoViewController.h"
#import "BCCollectionViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface BCPhotoViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,collectDelegate>
{
    UICollectionView *testCollectView;
    UIToolbar *toolbar;
    UIBarButtonItem *selectNum;
    NSMutableArray *imageArray;
    
    NSMutableArray *buttonState;//为了解决重用的问题
}
@end

@implementation BCPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    imageArray = [NSMutableArray array];
    buttonState = [NSMutableArray array];
    self.title = @"0/9";
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]
                                 initWithTitle:@"完成"
                                 style:UIBarButtonItemStylePlain
                                 target:self
                                 action:@selector(chooseDone)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(BCWidth/3 - 8, BCWidth/3 - 8);
    layout.minimumLineSpacing = 1;
    layout.minimumInteritemSpacing = 1;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    testCollectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 10, BCWidth, BCHeight) collectionViewLayout:layout];
   
    [testCollectView registerNib:[UINib nibWithNibName:NSStringFromClass([BCCollectionViewCell class])bundle:nil] forCellWithReuseIdentifier:@"jack"];
    testCollectView.backgroundColor = [UIColor whiteColor];
    testCollectView.delegate = self;
    testCollectView.dataSource = self;
    [self.view addSubview:testCollectView];
    
    
  
    for (int i = 0; i < _assetArray.count; i ++) {
        [buttonState addObject:@"0"];
    }
    
    

}

- (void)chooseDone {

       [[NSNotificationCenter defaultCenter] postNotificationName:@"IMG" object:imageArray];
    
    [self.navigationController popViewControllerAnimated:YES];

}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assetArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    BCCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"jack" forIndexPath:indexPath];
   
    cell.delegate = self;
    
    ALAsset *sset = [self.assetArray objectAtIndex:indexPath.row];
    cell.testImage.image = [UIImage imageWithCGImage:[sset thumbnail]];
    cell.kCheckButton.selected = [[buttonState objectAtIndex:indexPath.row] integerValue];//这句代码是为了解决重用的问题
    
    return cell;
}


#pragma mark cell代理
- (void)clickCell:(BCCollectionViewCell *)cell  {
 
    NSIndexPath *indexpath = [testCollectView indexPathForCell:cell];
    //这里可以设置选择的最大值
    
    if (imageArray.count >= 9 ) {
        
        cell.kCheckButton.selected = NO;
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"最多只能选择9个"
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];

    } else {
    
        if (cell.kCheckButton.selected) {
            [imageArray addObject:cell.testImage.image];
            [buttonState replaceObjectAtIndex:indexpath.row withObject:@"1"];
        } else {
            
            [imageArray removeObject:cell.testImage.image];
            [buttonState replaceObjectAtIndex:indexpath.row withObject:@"0"];
        }
        
        
        [self updateTitleInfo];
        
        
        
    }

}

- (void)updateTitleInfo {

    self.title = [NSString stringWithFormat:@"(%zd/9)", imageArray.count];


}
- (NSArray *)assetArray {
    if (!_assetArray) {
        _assetArray = [NSArray array];
    }
    
    return _assetArray;
}


- (void)dealloc {
    NSLog(@"释放");
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
