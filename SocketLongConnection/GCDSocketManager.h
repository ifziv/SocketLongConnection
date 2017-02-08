//
//  GCDSocketManager.h
//  SocketLongConnection
//
//  Created by zivInfo on 16/12/9.
//  Copyright © 2016年 xiwangtech.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GCDAsyncSocket.h"

#define SOCKETHOST @""
#define SOCKETPORT 123

@interface GCDSocketManager : NSObject<GCDAsyncSocketDelegate>

@property(nonatomic, strong) GCDAsyncSocket *socket;

//单例
+(instancetype)sharedSocketManager;

//连接
-(void)connectToServer;

//断开
-(void)cutOffSocket;

@end
