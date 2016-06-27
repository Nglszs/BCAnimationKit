//
//  BCSectionViewController.m
//  BCAnimationKit
//
//  Created by Jack on 16/6/6.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "BCSectionViewController.h"

@interface BCSectionViewController ()

{
    UIView *backView;
    CGFloat headFloat;
    CALayer *indicateLayer;
    UIScrollView *contentView;
}
/* 控制器数组和标题数组 */
@property (nonatomic, strong) NSArray *titlesArray;

@property (nonatomic, strong) NSArray *controllersArray;

@property (nonatomic, assign) BOOL isHaveNavVC;

@end

@implementation BCSectionViewController

- (instancetype)initWithTitle:(NSArray *)titleArray controller:(NSArray *)controllerArray isNavController:(BOOL)isNavVC {
    
    if (self = [super init]) {
        self.titlesArray = titleArray;
        self.controllersArray = controllerArray;
        self.isHaveNavVC = isNavVC;
    }
    return self;
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"热点";
    
    
    //添加子控制器
    [self addChildVc];
    
    //顶部标签栏
    [self addTitle];
    
    
    //声明scrollview
    [self addScorllView];
    
    
    //这个我为了方便直接返回首页，可以根据自己的需求来决定
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]
                                initWithTitle:@"返回首页"
                                style:UIBarButtonItemStylePlain
                                target:self
                                action:@selector(backView)];
    self.navigationItem.leftBarButtonItem = leftBtn;

    
}
- (void)backView {

    [self.navigationController popToRootViewControllerAnimated:YES];

}

- (void)addChildVc {

    for (UIViewController *VC in self.controllersArray) {
        
        [self addChildViewController:VC];
    }




}


- (void)addTitle {

//标题的背景
    
    if (_isHaveNavVC) {
        
        headFloat = 64;
        
    } else {
        headFloat = 0;
    }
    
    backView = [[UIView alloc] initWithFrame:CGRectMake(0, headFloat, BCWidth, 44)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    //红色指示器
    indicateLayer = [CALayer layer];
    indicateLayer.frame = CGRectMake(0, 42, BCWidth/self.titlesArray.count, 2);
    indicateLayer.backgroundColor = [UIColor redColor].CGColor;
    [backView.layer addSublayer:indicateLayer];

    //放置按钮
    for (NSInteger i = 0; i < self.titlesArray.count; i++) {
        
        @autoreleasepool {
            UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
            titleButton.frame = CGRectMake(i * BCWidth/self.titlesArray.count, 0, BCWidth/self.titlesArray.count, 44);
            [titleButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [titleButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
            [titleButton setTitle:_titlesArray[i] forState:UIControlStateNormal];
            titleButton.tag = i + 10086;
            if (i == 0) {
                titleButton.selected = YES;
            }
            [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
            [backView addSubview:titleButton];

        }
    
}

    
    
}


- (void)addScorllView {

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, headFloat + 44, BCWidth, BCHeight - headFloat - 44)];
    contentView.delegate = self;
    contentView.pagingEnabled = YES;
    contentView.showsHorizontalScrollIndicator = NO;
    contentView.showsVerticalScrollIndicator = NO;
    contentView.contentSize = CGSizeMake(BCWidth * self.titlesArray.count, BCHeight - headFloat - 44);
    [self.view addSubview:contentView];
   

    for (NSInteger i = 0; i < _titlesArray.count; i ++) {//添加所有子控制器的view
        UIViewController *vc = self.childViewControllers[i];
        
        vc.view.frame = CGRectMake(BCWidth * i, 0, BCWidth, CGRectGetHeight(contentView.frame));
        
        [contentView addSubview:vc.view];

    }


}

- (void)titleClick:(UIButton *)button
{

    //获得当前点击的按钮，并将其他按钮设为正常状态
    
    for (NSInteger i = 0; i < 4; i ++) {
        
        UIButton *newButton = [self.view viewWithTag:i + 10086];//如果是用self.view来检索的话，tag不能与sele.view上其他的view重合，否则报错，这里就不能从0开始，所以加上10086
        
        if (newButton.tag == button.tag) {
            
            button.selected = YES;
            
        } else {
        
            newButton.selected = NO;
        }
        
    }
    
    //点击按钮开始动画
    
    [UIView animateWithDuration:.25 animations:^{
       
       
       
    indicateLayer.frame = CGRectMake(BCWidth/self.titlesArray.count * (button.tag - 10086), 42, BCWidth/self.titlesArray.count, 2);
        
    }];
  
    // 滚动
       [contentView setContentOffset:CGPointMake(BCWidth * (button.tag - 10086), 0) animated:YES];

}

#pragma mark - <UIScrollViewDelegate>


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
   
    
    // 点击按钮
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    [self titleClick:[self.view viewWithTag:index + 10086]];
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
