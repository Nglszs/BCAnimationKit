//
//  NetWorkFlow.h
//  NetworkFlow
//
//  Created by Jack on 16/8/4.
//  Copyright © 2016年 Adways. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetWorkFlow : NSObject
{

        
        uint32_t _iBytes;
        uint32_t _oBytes;
        uint32_t _allFlow;
        uint32_t _wifiIBytes;
        uint32_t _wifiOBytes;
        uint32_t _wifiFlow;
        uint32_t _wwanIBytes;
        uint32_t _wwanOBytes;
        uint32_t _wwanFlow;

}



- (void)startNetworkFlow;
@end
