//
//  WebImageViewController.m
//  BCAnimationKit
//
//  Created by Jack on 16/7/11.
//  Copyright © 2016年 毕研超. All rights reserved.
//

#import "WebImageViewController.h"

@interface WebImageViewController ()<UIWebViewDelegate,UIGestureRecognizerDelegate>
{

  
    UIWebView *webview;
    NSURL * imageURL;//点击图片的url
    UIImageView *imageview;
   
}
@end

@implementation WebImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    webview = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:webview];
    NSURL *url = [NSURL URLWithString:@"https://www.baidu.com"];
    
    NSURLRequest *re = [NSURLRequest requestWithURL:url];
    
    webview.delegate = self;
    [webview loadRequest:re];
    
    UITapGestureRecognizer *TapP = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [webview addGestureRecognizer:TapP];
    TapP.delegate = self;
    [webview.scrollView addGestureRecognizer:TapP];
    
    
    
    imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    imageview.backgroundColor = [UIColor redColor];
    imageview.alpha = 0;
    imageview.center = self.view.center;
    [self.view addSubview:imageview];
    
    
   
}


#pragma mark 点击手势代理
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)tapGesture:(UIGestureRecognizer *)sender {

    CGPoint touchPoint = [sender locationInView:self.view];
    if (sender.state == UIGestureRecognizerStateEnded) {
        
        NSString *imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", touchPoint.x, touchPoint.y];
        
        NSString *urlToSave = [webview stringByEvaluatingJavaScriptFromString:imgURL];
        
        //这里为了获取图片和webview进行比较，当然也可以直接在这里显示图片,在这里显示有个缺点是不管是什么图片都会显示出来，比如点击新闻页面的小图标还未进入正文时，他也会显示出来图片，显然不符合交互的，所以这个方法就适合简单的静态界面，不包含跳转的
        imageURL = [NSURL URLWithString:urlToSave];
        
        
        if ([[NSString stringWithFormat:@"%@",imageURL] isEqualToString:@""]) {
           
            [self zoomMinImage];
            
        }
        
        
    }


}


#pragma mark webview 代理

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    //下面是设置缓存
//    NSURLCache *urlCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1000 * 1000 diskCapacity:20 * 1000 * 1000 diskPath:kPathTemp];
//    [NSURLCache setSharedURLCache:urlCache];
//   
//    NSCachedURLResponse *response = [urlCache cachedResponseForRequest:webView.request];
//      if (response) {
//          
//         NSLog(@"---这个请求已经存在缓存");
//          
//          
//          
//      } else {
//          
//            NSLog(@"---这个请求没有缓存");
//      }
    
    
    NSString *str = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'";
    [webView stringByEvaluatingJavaScriptFromString:str];
    
    
    //js方法遍历图片添加点击事件 返回所有图片
    static  NSString * const jsGetImages =
    @"function getImages(){\
    var srcs = [];\
    var objs = document.getElementsByTagName(\"img\");\
    for(var i=0;i<objs.length;i++){\
    srcs[i] = objs[i].src;\
    };\
    for(var i=0;i<objs.length;i++){\
    objs[i].onclick=function(){\
    document.location=\"myweb:imageClick:\"+srcs+','+this.src;\
    };\
    };\
    return objs.length;\
    };";
    
    [webView stringByEvaluatingJavaScriptFromString:jsGetImages];//注入js方法
    [webView stringByEvaluatingJavaScriptFromString:@"getImages()"];
    
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *str = request.URL.absoluteString;
    if ([str hasPrefix:@"myweb:imageClick:"]) {
        str = [str stringByReplacingOccurrencesOfString:@"myweb:imageClick:"
                                             withString:@""];
        
        NSArray * imageUrlArr = [str  componentsSeparatedByString:@","];
        
        
        
        //这里将webview获取到的所有图片和点击的图片进行比较
        if ([imageUrlArr containsObject:[NSString stringWithFormat:@"%@",imageURL]]) {
            
            if (imageview.alpha == 1.0f) {
                
                [self zoomMinImage];
            
            } else {
            
            NSLog(@"有图片了");
            NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
            UIImage * image = [UIImage imageWithData:imageData];
            
            imageview.transform = CGAffineTransformMakeScale(.1, .1);
            [UIView animateWithDuration:1 animations:^{
                imageview.transform = CGAffineTransformMakeScale(1, 1);
                imageview.image = image;
                imageview.alpha = 1;
            }];
            
            }
            
        } else {
            
            
            [self zoomMinImage];
            
        }
        
        
        
    }
    
    
    return YES;
}

//缩小图片
- (void)zoomMinImage {

    [UIView animateWithDuration:.25 animations:^{
        
        imageview.transform = CGAffineTransformScale(imageview.transform, 1.2, 1.2);
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1 animations:^{
            
            imageview.transform = CGAffineTransformScale(imageview.transform, 0.1, 0.1);
            
            imageview.alpha = 0;
        } completion:^(BOOL finished) {
            imageview.image = nil;
        }];
        
    }];



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
