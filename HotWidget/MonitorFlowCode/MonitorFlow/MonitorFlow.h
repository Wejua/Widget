//
//  MonitorFlow.h
//  MonitorFlow
//
//  Created by Yes-Cui on 16/10/27.
//  Copyright © 2016年 Yes-Cui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MonitorData : NSObject

@property (assign, nonatomic) float wwanSend;
@property (assign, nonatomic) float wwanReceived;
@property (assign, nonatomic) float wifiSend;
@property (assign, nonatomic) float wifiReceived;

@end

@interface MonitorFlow : NSObject

//开始检测
- (void)startMonitor;
//停止检测
- (void)stopMonitor;

- (NSMutableDictionary *)getWifiDataIncrement;

@end

