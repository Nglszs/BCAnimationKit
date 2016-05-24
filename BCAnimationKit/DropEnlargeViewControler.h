//
//  DropEnlargeViewControler.h
//  BCAnimationKit
//
//  Created by Jack on 16/5/4.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "BaseViewController.h"

@interface DropEnlargeViewControler : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    
    UITableView *testTableView;
    NSArray *testArray;
    UIImageView *headImage;
    UIImageView *cornerImage;
}

@end
