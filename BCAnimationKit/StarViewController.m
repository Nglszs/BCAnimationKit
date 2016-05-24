//
//  StarViewController.m
//  BCAnimationKit
//
//  Created by Jack on 16/5/5.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "StarViewController.h"

#define count  5

@interface StarViewController ()
{

    UILabel  *resultLabel;
}
@end

@implementation StarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评星";
    
    for (int i = 0; i < count; i ++) {
        
        
        UIButton *starButton = [UIButton buttonWithType:UIButtonTypeCustom];
        starButton.tag = 10010 + i;
        starButton.frame = CGRectMake(100 + 42 * i, 200, 42, 42);
        [starButton setImage:[UIImage imageNamed:@"grade_star_path"] forState:UIControlStateNormal];
        [starButton setImage:[UIImage imageNamed:@"grade_star_fill"] forState:UIControlStateSelected];
        [starButton setImage:[UIImage imageNamed:@"grade_star_fill"] forState:UIControlStateHighlighted | UIControlStateSelected];
        
        
        [starButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:starButton];

        
    }
   
    
    
    
    
    
    resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
    resultLabel.center = self.view.center;
    resultLabel.font = text12Font;
    [self.view addSubview:resultLabel];



}

- (void)clickButton:(UIButton *)sender {

   
    //似乎没有什么难点。自己想想就能解决
    
    NSInteger index = sender.tag - 10010 + 1;
    if (!sender.selected) {//点击的星未选中
        
        for (int i = 0; i < index; i ++) {
            UIButton *button = [self.view viewWithTag:10010 + i];
            button.selected = YES;
        }
        
    } else {//点击时已选中
    
        
        for (int page = (int)index ;page < count ; page ++) {
            UIButton *button = [self.view viewWithTag:10010 + page];
            button.selected = NO;
            
        }
    
    }

    
    //显示评分
    NSDictionary *stingDic = @{NSForegroundColorAttributeName:DefaultColor,NSFontAttributeName:NewText20Font};
    NSMutableAttributedString *mutableString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"你当前的评分为: %ld 星",index]];
    
    [mutableString addAttributes:stingDic range:NSMakeRange(9, 1)];

    resultLabel.attributedText = mutableString;


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
