//
//  NSMutableArray+Check.h
//  BCAnimationKit
//
//  Created by Jack on 16/8/11.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Check)

//项目中的crash，在tableview界面有时候会出现莫名其妙的bug，这些bug有一共同点就是数组越界,原因是因为数据还没加载完就要显示出来，所以这里写个数组分类来替换数组的方法，当然你也可以使用下面屏蔽的方法


//1.2，当数据源改变时，和reloaddata之间是有时间差的，如果此时滚动tableview那么会崩溃，因为他们调用tableview的cellforrow方法，而此时数据源是被改变的，那么就会经常发生数组越界的情况，尤其是当你请求数据，吧原来数组数据全部移除时，在新数据还未加载进来，调用reloaddata或者滚动tableview都会crash，最好是在改变数据源的时候立马reloaddata，当然这个只是crash的原因，可以用下面的方法就解决了

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    WelfareItem *item = [_datasourceArray objectAtIndex:indexPath.row];
//有可能会越界，你在下拉刷新时会用[_datasourceArray removeAllObjects]，这时你又点了某个cell就会Crash

//解决方法：
//if (indexPath.row < [_datasourceArray count]) {//无论你武功有多高，有时也会忘记加
//    item = [_datasourceArray objectAtIndex:indexPath.row];
//}

//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    WelfareItem *item = _datasourceArray[indexPath.row];
//有可能会越界，两个地方用了[tableView reloadData]；后一个有[_datasourceArray removeAllObjects]；前一个还没有执行完，就会Crash

//解决方法：
//if (indexPath.row < [_datasourceArray count]) {
//    item = [_datasourceArray objectAtIndex:indexPath.row];
//}
//}

/**
  解决数组越界的方法
  检查是否越界和NSNull如果是返回nil
 */
- (id)objectAtIndexCheck:(NSUInteger)index; 

@end
