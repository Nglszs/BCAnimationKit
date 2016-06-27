//
//  RefreshViewController.m
//  BCAnimationKit
//
//  Created by Jack on 16/5/4.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "RefreshViewController.h"

@interface RefreshViewController ()
{
    CALayer *layer;
    UITableView  *testTableView;
    NSMutableArray *dataArray;
    UIActivityIndicatorView *refreshView;
}
@property (nonatomic, strong) CAReplicatorLayer *replicatorLayer;
@end

@implementation RefreshViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    
    
    testTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, BCWidth, BCHeight) style:UITableViewStylePlain];
    testTableView.delegate = self;
    testTableView.dataSource = self;
    testTableView.tableFooterView = [UIView new];
    [self.view addSubview:testTableView];
    
    //指示器
    
    [self loadAnimations];

    dataArray = [NSMutableArray arrayWithObjects:@"",@"",@"", nil];
    
    
    
}

- (void)viewWillDisappear:(BOOL)animated {

    
    [super viewWillDisappear:animated];

    if (![self.navigationController.viewControllers containsObject:self]) {
        
        [layer removeAllAnimations];
        [layer removeFromSuperlayer];
        [_replicatorLayer removeFromSuperlayer];
    }

}
- (void)loadAnimations {

    layer = [CALayer layer];
    layer.frame = CGRectMake((BCWidth - 40)/2, 20, 10, 10);
    layer.cornerRadius = 5;
    layer.backgroundColor = [UIColor greenColor].CGColor;
    layer.transform = CATransform3DMakeScale(0.01, 0.01, 0.01);

  
    
    _replicatorLayer = [CAReplicatorLayer layer];
    _replicatorLayer.bounds = self.view.bounds;
    _replicatorLayer.position = self.view.center;
    _replicatorLayer.instanceCount = 3;
    _replicatorLayer.instanceDelay = 1.0/6;//这里必须是精度为0.1
    [_replicatorLayer addSublayer:layer];
    [self.view.layer addSublayer:_replicatorLayer];
    
    
    
    
    
    
    
    self.replicatorLayer.instanceTransform = CATransform3DMakeTranslation(20, 0, 0);
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = 1;
    animation.repeatCount = MAXFLOAT;
    animation.fromValue = @(1);
    animation.toValue = @(0.01);
    [layer addAnimation:animation forKey:nil];
    
    [self pauseLayer];
    
}

-(void)pauseLayer {//暂停动画
    
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
    _replicatorLayer.hidden = YES;
}

-(void)resumeLayer {//开始动画
    
     CFTimeInterval pausedTime = [layer timeOffset];
     layer.speed = 1.0;
     layer.timeOffset = 0.0;
     layer.beginTime = 0.0;
     CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
     layer.beginTime = timeSincePause;
    _replicatorLayer.hidden = NO;
    
 }

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return dataArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellid = @"celll";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        
        cell.textLabel.textColor = [UIColor orangeColor];
    }
    cell.textLabel.text = @"下拉刷新";
    
    
    return cell;
}

#pragma mark  下拉刷新和上拉刷新


//如果需要两种刷新同时存在，则都放入下面的条件，否则分开放，也就是说scrollview的代理方法只能存在一个，否则有一个不能识别
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {//这个方法如果一开始cell没有满屏，他每次下拉的y值都是为0
    
   
    if (scrollView.contentOffset.y <= -60) {
       
        
        NSLog(@"下拉刷新");
       
        testTableView.contentInset = UIEdgeInsetsMake(60, 0, 0, 0);
        
        [self resumeLayer];
        
        //具体的数据自己处理，这里简单演示
        [self addDataToArray];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self pauseLayer];
            
            [UIView animateWithDuration:1 animations:^{
                
                testTableView.contentInset = UIEdgeInsetsZero;
                [testTableView reloadData];

            }];
            
           
            
            });
        
    }  else if (scrollView.contentOffset.y + CGRectGetHeight(scrollView.frame) > scrollView.contentSize.height + 60) {
                    NSLog(@"上拉刷新");
            
                    //动画效果等同上拉刷新，这里不再写，简单的刷新数据
            
                    [self addDataToArray];
                    [testTableView reloadData];
                    
                    
    }


}






- (void)addDataToArray {

    for (int i = 0; i < 3; i++) {
        
        [dataArray addObject:@""];
    }

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
