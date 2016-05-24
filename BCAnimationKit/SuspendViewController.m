//
//  SuspendViewController.m
//  BCAnimationKit
//
//  Created by Jack on 16/5/4.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "SuspendViewController.h"
#import "ShoppingCartViewController.h"
@interface SuspendViewController ()<UIPopoverPresentationControllerDelegate>

@property (strong, nonatomic) UIButton *button;
@property (strong, nonatomic) ShoppingCartViewController *shop;
@end

@implementation SuspendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    //导航栏和普通button有点区别
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"点我" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
    
    
    //当然这个效果也可以自定义的去实现，这里我调用系统的方法,很简单。自己去做的话需要美工给一个箭头图标即可
    
    _button = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 50)];//如果button在中间会有白线
    _button.backgroundColor = [UIColor cyanColor];
    [_button setTitle:@"点我" forState:UIControlStateNormal];
    [_button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.view addSubview:_button];
    [_button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];

    
    
    
}

- (void)rightItemClick{


    _shop = [[ShoppingCartViewController alloc] init];
    _shop.modalPresentationStyle = UIModalPresentationPopover;
    _shop.popoverPresentationController.barButtonItem = self.navigationItem.rightBarButtonItem;
    _shop.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    _shop.popoverPresentationController.delegate = self;
    [self presentViewController:_shop animated:YES completion:nil];



}
- (void)buttonClick:(UIButton *)sender{

    _shop = [[ShoppingCartViewController alloc] init];
    _shop.modalPresentationStyle = UIModalPresentationPopover;
    _shop.popoverPresentationController.sourceView = _button;
    _shop.popoverPresentationController.sourceRect = _button.bounds;
    _shop.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    _shop.popoverPresentationController.delegate = self;
    [self presentViewController:_shop animated:YES completion:nil];

    
    

}

#pragma mark 必须实现popoverPresentationController下面的代理
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller traitCollection:(UITraitCollection *)traitCollection {


    return UIModalPresentationNone;//这里返回none才有效果，其他的都是全屏

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
