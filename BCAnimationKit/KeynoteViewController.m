//
//  KeynoteViewController.m
//  BCAnimationKit
//
//  Created by Jack on 16/7/19.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "KeynoteViewController.h"
#import "KeynoteSecondViewController.h"
#import "KeynoteTransition.h"
@interface KeynoteViewController ()
{
    NSArray *imageArr;
}

@end

@implementation KeynoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    
    _testTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, BCWidth, BCHeight) style:UITableViewStylePlain];
    _testTableView.delegate = self;
    _testTableView.dataSource = self;
    _testTableView.rowHeight = 64;
    _testTableView.tableFooterView = [UIView new];
    [self.view addSubview:_testTableView];

    imageArr = @[@"bc.jpg",@"bc1.jpg",@"head.jpg"];

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return 30;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellid = @"celll";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(16, 2, 80, 60)];
        imageV.tag = 100;
        [cell.contentView addSubview:imageV];
      
        
    }
        UIImageView *imageV = (UIImageView *)[cell.contentView viewWithTag:100];
     imageV.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageArr[indexPath.row%3]]];
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    self.clickIndexPath = indexPath;

    KeynoteSecondViewController *second = [[KeynoteSecondViewController alloc] init];
    self.navigationController.delegate = second;
    second.headerImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageArr[indexPath.row%3]]];
    [self.navigationController pushViewController:second animated:YES];
    
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
