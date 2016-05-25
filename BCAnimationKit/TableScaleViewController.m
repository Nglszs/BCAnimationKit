//
//  TableScaleViewController.m
//  BCAnimationKit
//
//  Created by Jack on 16/5/25.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "TableScaleViewController.h"
#import "BCTableViewCell.h"
@interface TableScaleViewController ()
{

    UITableView *testTableView;
     NSArray *imageArr;
    
    NSMutableArray *frameArr;
    
    BOOL isClick;
    
    BCTableViewCell *testCell;//这个是为了判断每个cell的标志位
}
@end

@implementation TableScaleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    testTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    testTableView.delegate = self;
    testTableView.dataSource = self;
    testTableView.tableFooterView = [UIView new];
    
   
    [self.view addSubview:testTableView];
    
    imageArr = @[@"bc.jpg",@"bc1.jpg",@"head.jpg"];
    frameArr = [NSMutableArray arrayWithObjects:@"44",@"44",@"44", nil];
}


#pragma mark  代理相关

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {


    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {



    return 3;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *str = [frameArr objectAtIndex:indexPath.row];
    
    
   
    
    return [str floatValue];
   


}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

static NSString *cellid = @"cell";
    
    BCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    if (!cell) {
        cell = [[BCTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        cell.clipsToBounds = YES;
    }
    cell.testImage.image = [UIImage imageNamed:imageArr[indexPath.row]];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterRoundHalfUp;
  
    cell.testLabel.text = [formatter stringFromNumber:[NSNumber numberWithInteger:indexPath.row]];

    
        return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    
    
    testCell = [tableView cellForRowAtIndexPath:indexPath];
    testCell.isSelected = !testCell.isSelected;
    
  
    
    
    if (testCell.isSelected) {
        
        [frameArr replaceObjectAtIndex:indexPath.row withObject:@"144"];
        
    } else {
    
    [frameArr replaceObjectAtIndex:indexPath.row withObject:@"44"];
        
    }
    
    
    
    [testTableView reloadData];
  

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
