//
//  MonitorFlow.m
//  MonitorFlow
//
//  Created by Yes-Cui on 16/10/27.
//  Copyright © 2016年 Yes-Cui. All rights reserved.
//

#import "MonitorFlow.h"
#import "Reachability.h"
#import <sys/sysctl.h>
#import <mach/mach.h>
#include <sys/param.h>
#include <sys/mount.h>
#include <ifaddrs.h>
#include <sys/socket.h>
#include <net/if.h>


@implementation MonitorData

@end

@interface MonitorFlow ()

@property (nonatomic,strong) NSTimer *timer;

@property (assign, nonatomic) float tempWWANReceived;
@property (assign, nonatomic) float tempWWANSend;
@property (assign, nonatomic) float tempWifiReceived;
@property (assign, nonatomic) float tempWifiSend;


@end

@implementation MonitorFlow

- (void)startMonitor {
    [self currentFlow];
    self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(refreshFlow) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)stopMonitor{
    [self.timer invalidate];
}

- (void)refreshFlow{
    // 上传、下载
    //不需要连通网络获取的是总的数据
    Reachability *reachability = [Reachability reachabilityWithHostName:@"Yes-Cui"];
    MonitorData *monitor = [self getMonitorDataDetail];
    switch (reachability.currentReachabilityStatus) {
        case ReachableViaWiFi:
        {
            float wifiSend = monitor.wifiSend - self.tempWifiSend;
            float wifiReceived = monitor.wifiReceived - self.tempWifiReceived;
            NSLog(@"wifi上传速度：%@",[NSString stringWithFormat:@"%.0f KB/s",wifiSend]);
            NSLog(@"wifi下载速度：%@",[NSString stringWithFormat:@"%.0f KB/s",wifiReceived]);
        }
            break;
        case ReachableViaWWAN:
        {
            float wwanSend = monitor.wwanSend - self.tempWWANReceived;
            float wwanReceived = monitor.wifiReceived - self.tempWWANSend;
            NSLog(@"wwan上传速度：%@",[NSString stringWithFormat:@"%.0f KB/s",wwanSend]);
            NSLog(@"wwan下载速度：%@",[NSString stringWithFormat:@"%.0f KB/s",wwanReceived]);
        }
            break;
        default:
        {
            NSLog(@"无网络");

        }
            break;
    }

    [self currentFlow];
}

- (NSMutableDictionary *)getWifiDataIncrement {
    // 上传、下载
    //不需要连通网络获取的是总的数据
    Reachability *reachability = [Reachability reachabilityWithHostName:@"Yes-Cui"];
    MonitorData *monitor = [self getMonitorDataDetail];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    switch (reachability.currentReachabilityStatus) {
        case ReachableViaWiFi:
        {
            float wifiSend = monitor.wifiSend - self.tempWifiSend;
            float wifiReceived = monitor.wifiReceived - self.tempWifiReceived;
            [dic setValue:@(wifiSend) forKey:@"send"];
            [dic setValue:@(wifiReceived) forKey:@"received"];
        }
            break;
        case ReachableViaWWAN:
        {
//            float wwanSend = monitor.wwanSend - self.tempWWANReceived;
//            float wwanReceived = monitor.wifiReceived - self.tempWWANSend;
//            NSLog(@"wwan上传速度：%@",[NSString stringWithFormat:@"%.0f KB/s",wwanSend]);
//            NSLog(@"wwan下载速度：%@",[NSString stringWithFormat:@"%.0f KB/s",wwanReceived]);
        }
            break;
        default:
        {
//            NSLog(@"无网络");

        }
            break;
    }

    [self currentFlow];
    return dic;
}


//赋值当前流量
- (void)currentFlow{
    MonitorData *monitor = [self getMonitorDataDetail];
    self.tempWifiSend = monitor.wifiSend;
    self.tempWifiReceived = monitor.wifiReceived;
    self.tempWWANSend = monitor.wwanSend;
    self.tempWWANReceived = monitor.wwanReceived;
}


//上传、下载总额流量
- (MonitorData *)getMonitorDataDetail
{
    BOOL success;
    struct ifaddrs *addrs;
    struct ifaddrs *cursor;
    struct if_data *networkStatisc;
    long tempWiFiSend = 0;
    long tempWiFiReceived = 0;
    long tempWWANSend = 0;
    long tempWWANReceived = 0;
    NSString *dataName;
    success = getifaddrs(&addrs) == 0;
    if (success)
    {
        cursor = addrs;
        while (cursor != NULL)
        {
            dataName = [NSString stringWithFormat:@"%s",cursor->ifa_name];

            if (cursor->ifa_addr->sa_family == AF_LINK)
            {
                if ([dataName hasPrefix:@"en"])
                {
                    networkStatisc = (struct if_data *) cursor->ifa_data;
                    tempWiFiSend += networkStatisc->ifi_obytes;
                    tempWiFiReceived += networkStatisc->ifi_ibytes;
                }
                if ([dataName hasPrefix:@"pdp_ip"])
                {
                    networkStatisc = (struct if_data *) cursor->ifa_data;
                    tempWWANSend += networkStatisc->ifi_obytes;
                    tempWWANReceived += networkStatisc->ifi_ibytes;
                }
            }
            cursor = cursor->ifa_next;
        }
        freeifaddrs(addrs);
    }
    MonitorData *monitorData = [MonitorData new];
    monitorData.wifiSend = tempWiFiSend/1024;
    monitorData.wifiReceived = tempWiFiReceived/1024;
    monitorData.wwanSend = tempWWANSend/1024;
    monitorData.wwanReceived = tempWWANReceived/1024;
    return monitorData;
}

@end
