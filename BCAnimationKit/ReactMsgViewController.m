//
//  ReactMsgViewController.m
//  BCAnimationKit
//
//  Created by Jack on 16/7/20.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "ReactMsgViewController.h"
#import "ReactMsgTableViewCell.h"
@interface ReactMsgViewController ()
{
    UITableView *_testTableView;
    UIDynamicAnimator *Animator;
}
@end

@implementation ReactMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _testTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, BCWidth, BCHeight) style:UITableViewStyleGrouped];
    _testTableView.delegate = self;
    _testTableView.dataSource = self;
 
    _testTableView.tableFooterView = [UIView new];
    [self.view addSubview:_testTableView];
    
    
   Animator = [[UIDynamicAnimator alloc] initWithReferenceView:_testTableView];
   

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return 1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {


    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {


    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellid = @"celll";
    
    ReactMsgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    if (cell == nil) {
        cell = [[ReactMsgTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        
       
        
    }
    
          

    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {


    for (UIDynamicBehavior* b in Animator.behaviors) {
        if ([b isKindOfClass:[UIAttachmentBehavior class]]) {
            if ([[(UIAttachmentBehavior*)b items] containsObject:cell]){
                [Animator removeBehavior:b];
            }
        }
    }
    
    CGPoint anchorPoint = CGPointMake(cell.bounds.size.width/2, cell.frame.origin.y);
    
    UIAttachmentBehavior* attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:cell attachedToAnchor:anchorPoint];
    [attachmentBehavior setLength:0];
    [attachmentBehavior setFrequency:.8];
    [attachmentBehavior setDamping:0.2];
    [Animator addBehavior:attachmentBehavior];

}

- (void)dealloc {
    
    [Animator removeAllBehaviors];

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
