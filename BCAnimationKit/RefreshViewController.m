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

    UITableView  *testTableView;
    NSMutableArray *dataArray;
    UIActivityIndicatorView *refreshView;
}
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
    refreshView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((BCWidth - 30)/2, 0, 30, 30)];
    refreshView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    refreshView.hidden = YES;
    [self.view addSubview:refreshView];
   


    dataArray = [NSMutableArray arrayWithObjects:@"",@"",@"", nil];
    
    
    
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

#pragma mark  下拉刷新
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {

    if (scrollView.contentOffset.y <= -60) {
       
        
        
        refreshView.hidden = NO;
        [refreshView startAnimating];
        testTableView.contentInset = UIEdgeInsetsMake(60, 0, 0, 0);
        
        //具体的数据自己处理，这里简单演示
        [self addDataToArray];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
            refreshView.hidden = YES;
            [refreshView stopAnimating];
            testTableView.contentInset = UIEdgeInsetsZero;
           
           
            [testTableView reloadData];
            
            });
        
    }



}


#pragma mark 上拉刷新

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {


    if (scrollView.contentOffset.y + CGRectGetHeight(testTableView.frame) > scrollView.contentSize.height + 60) {
        NSLog(@"下拉刷新");
        
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
