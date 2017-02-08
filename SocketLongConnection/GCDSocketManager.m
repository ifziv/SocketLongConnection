//
//  GCDSocketManager.m
//  SocketLongConnection
//
//  Created by zivInfo on 16/12/9.
//  Copyright © 2016年 xiwangtech.com. All rights reserved.
//

#import "GCDSocketManager.h"

@interface GCDSocketManager ()

@property(nonatomic, assign) int     pushCount;      //握手次数
@property(nonatomic, assign) int     reconnectCount; //重连次数
@property(nonatomic, strong) NSTimer *timer;         //断开重连计时器

@end

@implementation GCDSocketManager

@synthesize socket = _socket;

//单例
+(instancetype)sharedSocketManager
{
    static GCDSocketManager *socketManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        socketManager = [[self alloc] init];
        // your code
        //[socketManager connectToServer];
        
    });
    return socketManager;
}

//连接
-(void)connectToServer
{
    self.pushCount = 0;
    self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    NSError *error = nil;
    [self.socket connectToHost:SOCKETHOST onPort:SOCKETPORT error:&error];
    if (error) {
        NSLog(@"Socket Connect Error!\n%@", error);
    }
}

//GCDAsyncSocketDelegate  连接成功的回调
-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"Socket Conncet Success!");
    
    [self sendDataToServer];
}

//GCDAsyncSocketDelegate  连接成功向服务器发送数据后,服务器会有响应
-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    [self.socket readDataWithTimeout:-1 tag:200];
    
    //服务器推送次数
    self.pushCount++;
 
    //在这里进行校验操作,情况分为成功和失败两种,成功的操作一般都是拉取数据
    
}

//GCDAsyncSocketDelegate  连接失败的回调
-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    NSLog(@"Socket Connect Lose!");
    
    self.pushCount = 0;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *currentStatu = [userDefaults valueForKey:@"Statu"];
    
    //程序在前台才进行重连
    if ([currentStatu isEqualToString:@"foreground"]) {
        
        //重连次数
        self.reconnectCount++;
        
        //如果连接失败 累加1秒重新连接 减少服务器压力
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 * self.reconnectCount target:self selector:@selector(reconnectServer) userInfo:nil repeats:NO];
        
        self.timer = timer;
    }
}

//连接成功后向服务器发送数据
-(void)sendDataToServer
{
    NSData *jsonData = [[NSData alloc] init];
    //发送
    [self.socket writeData:jsonData withTimeout:-1 tag:1];
    //读取数据
    [self.socket readDataWithTimeout:-1 tag:200];
}

//如果连接失败,5秒后重新连接
- (void)reconnectServer
{
    self.pushCount = 0;
    self.reconnectCount = 0;
    
    //连接失败重新连接
    NSError *error = nil;
    [self.socket connectToHost:SOCKETHOST onPort:SOCKETPORT error:&error];
    if (error) {
        NSLog(@"Socket Connect Error!\n%@", error);
    }
}

//切断连接
-(void)cutOffSocket
{
    NSLog(@"Socket Disconnect!");
    
    self.pushCount = 0;
    self.reconnectCount = 0;
    
    [self.timer invalidate];
    self.timer = nil;
    
    [self.socket disconnect];
}

@end
