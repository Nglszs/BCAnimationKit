//
//  TableAnimationViewController.m
//  BCAnimationKit
//
//  Created by Jack on 16/6/28.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "TableAnimationViewController.h"
#import "TableViewCell.h"
#import "RollingTableViewCell.h"

#define SHOWOFFSET 40
@interface TableAnimationViewController ()
{

    NSInteger animationType;//动画类型
    
    NSCache *imageCache; // 缓存被异步解压缩后的图片

}
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *images;
@end

@implementation TableAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.alpha = 0;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    animationType = arc4random_uniform(2);//等于0是视觉差动画，其他的这里都是缩放动画
    
   
    
    imageCache = [[NSCache alloc] init];
    
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    
    NSBlockOperation *enumP = [NSBlockOperation blockOperationWithBlock:^{
        for (NSInteger i = 1 ; i < 21; i ++) {
            
            
            NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%ld",i] ofType:@"jpg"];
            
            [self writeImage:[self preDecompressedImage:[UIImage imageWithContentsOfFile:path]andFrame:CGRectMake(0, 0, BCWidth, BCWidth * .625)] forKey:i];
            
            
            
        }

    }];
    
    NSBlockOperation *reloadOp = [NSBlockOperation blockOperationWithBlock:^{
        
        
         [self.view addSubview:self.tableview];
        
    
        [UIView animateWithDuration:1 animations:^{
            self.view.alpha = 1;
            
            if (animationType == 0) {
                 [self scrollViewDidScroll:self.tableview];//这里防止视觉差动画刚滑时产生的卡顿感
            }
            
        }];
    }];
    
    [reloadOp addDependency:enumP];
    [queue addOperation:enumP];
    [queue addOperation:reloadOp];

    

}



- (UITableView *)tableview
{
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource = self;
       [_tableview setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]];
        
        _tableview.rowHeight = BCWidth * .625;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableview;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (animationType == 0) {//视觉差
        
        self.title = @"视觉差动画";
        static NSString *identifier = @"Cell";
        RollingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[RollingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            
        }

        cell.bgImageView.image = [self readImgaeForKey:(indexPath.row + 1)];
        return cell;

    } else {
    self.title = @"缩放动画";
    
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TableViewCell" owner:self options:nil] lastObject];
        
        
        CGRect cellRect = [tableView rectForRowAtIndexPath:indexPath];
        CGFloat cellCenter = cellRect.origin.y + cellRect.size.height / 2;
        CGFloat contentCenter = tableView.contentOffset.y + tableView.bounds.size.height / 2;
        CGFloat scale = (1.0 - 0.7) * fabs(cellCenter - contentCenter) / tableView.bounds.size.height;
        
        cell.image.transform = CGAffineTransformMakeScale((1.0 - scale), (1.0 - scale));
       
        
        
        
    }
    
        
     cell.image.image = [self readImgaeForKey:(indexPath.row + 1)];
    
    
    return cell;
        
    }
}



#pragma mark 压缩图片

- (void)writeImage:(UIImage *)image forKey:(NSInteger)index {


    [imageCache setObject:image forKey:[NSString stringWithFormat:@"%ld",index]];

}

- (UIImage *)readImgaeForKey:(NSInteger)key {



    return [imageCache objectForKey:[NSString stringWithFormat:@"%ld",key]];
}
- (UIImage *)preDecompressedImage:(UIImage *)image andFrame:(CGRect)frame {
   
    
    UIGraphicsBeginImageContextWithOptions(frame.size, NO, 0);
    [image drawInRect:frame];
    UIImage *decompressedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return decompressedImage;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    
    
    if (animationType == 0) {//视觉差动画
        NSArray *visibleCells = [self.tableview visibleCells];
        
        for(RollingTableViewCell *cell in visibleCells) {
            
            [cell cellOnTableView:self.tableview didScrollOnView:self.view];
        }

    } else {
    
    for (TableViewCell *cell in [self.tableview visibleCells]) {
        CGFloat cellCenter = cell.center.y;
        CGFloat contentCenter = self.tableview.contentOffset.y + self.tableview.bounds.size.height / 2 + SHOWOFFSET;//SHOWOFFSET是调整完全大图显示的位置，为正时，像屏幕下方移动
        CGFloat scale = (1.0 - 0.7) * fabs(cellCenter - contentCenter) / self.tableview.bounds.size.height;
        
        
        [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState animations:^{
            cell.image.transform = CGAffineTransformMakeScale(1.0 - scale, 1.0 - scale);
        } completion:NULL];
        
    }
    
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
    
}
@end
