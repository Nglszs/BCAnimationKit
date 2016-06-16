//
//  NavbarGradientViewController.m
//  BCAnimationKit
//
//  Created by Jack on 16/5/4.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "NavbarGradientViewController.h"
#import "UINavigationBar+Gradient.h"
@implementation NavbarGradientViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    
    self.title = @"导航栏渐变";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UITableView *testTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    testTableView.delegate = self;
    testTableView.dataSource = self;
    [self.view addSubview:testTableView];
    
    
    
   
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //刚进来就透明
    [self.navigationController.navigationBar setNavbarBackgroundColor:[[UIColor clearColor]colorWithAlphaComponent:0]];


}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //退出时调整bar的颜色为原样
    [self.navigationController.navigationBar resetNavbarColor];
    
   

}
#pragma mark  UITableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return 55;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellid = @"celll";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        
        currentIndex = indexPath.row;
    }
    cell.contentView.backgroundColor = RandomColor;
    
    cell.textLabel.text = @"导航栏渐变";
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {


        
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = 1.0 / -500;
    transform = CATransform3DTranslate(transform, -cell.layer.bounds.size.width/2.0f, 0.0f, 0.0f);
    transform = CATransform3DRotate(transform, M_PI/2, 0.0f, 1.0f, 0.0f);
    cell.layer.transform = CATransform3DTranslate(transform, cell.layer.bounds.size.width/2.0f, 0.0f, 0.0f);
    
    [UIView animateWithDuration:.8 delay:0.005 * indexPath.row usingSpringWithDamping:1 initialSpringVelocity:0.0 options:0 animations:^{
        
        
        
        
        cell.layer.transform = CATransform3DIdentity;
        cell.layer.opacity = 1.0f;
        
        
    } completion:^(BOOL finished) {
        
        
    }];
   
    
   
   
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    //如果导航栏不是渐变，即是到某个位置突变，其实是不用runtime的，但这里我分成两种情况，用runtime更方便一些
 
    CGFloat alphaValue;
    if (_isGradient) {//渐变
        
        alphaValue = MIN(1, scrollView.contentOffset.y/328);
        
    } else {//突变
    
        alphaValue = 1;
    
    }
    
    
    UIColor  *color = [UIColor colorWithRed:100/255.0 green:200/255.0 blue:100/255.0 alpha:1];
    
    if (scrollView.contentOffset.y > 164) {//设置触发条件
        
        [self.navigationController.navigationBar setNavbarBackgroundColor:[color colorWithAlphaComponent:alphaValue]];
        
        
    } else {
    
     
    [self.navigationController.navigationBar setNavbarBackgroundColor:[color colorWithAlphaComponent:0]];
       
    
    }

}


@end
