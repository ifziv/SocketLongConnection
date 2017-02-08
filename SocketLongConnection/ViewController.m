//
//  ViewController.m
//  SocketLongConnection
//
//  Created by zivInfo on 16/12/9.
//  Copyright © 2016年 xiwangtech.com. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    GCDSocketManager *socketManager = [GCDSocketManager sharedSocketManager];
    [socketManager connectToServer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
