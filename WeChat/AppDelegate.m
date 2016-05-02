//
//  AppDelegate.m
//  WeChat
//
//  Created by 斌 曹 on 16/4/28.
//  Copyright © 2016年 斌 曹. All rights reserved.
//

#import "AppDelegate.h"
#import "XMPPFramework.h"

@interface AppDelegate() <XMPPStreamDelegate>

@property(nonatomic, strong) XMPPStream *xmppStream;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self setupStream];
    [self connectToHost];
    return YES;
}

#pragma mark - private method
//初始化xmpp
-(void)setupStream
{
    _xmppStream = [[XMPPStream alloc] init];
    
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
}

// 连接服务器(传一个jid)
-(void)connectToHost
{
    //1、设置jid
    // resource 用户登录客户端设备登录类型
    XMPPJID *myJid = [XMPPJID jidWithUser:@"caobin" domain:@"bogon" resource:@"ios"];
    _xmppStream.myJID = myJid;
    
    //2、设置主机地址
    _xmppStream.hostName = @"127.0.0.1";
    
    
    //3、设置主机端口号
    _xmppStream.hostPort = 5222;
    
    //4、发送连接
    NSError *error = nil;
    [_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error];
}

//连接成功，接着发送密码
-(void)sendPwdToHost
{
    NSError *error = nil;
    [_xmppStream authenticateWithPassword:@"123456" error:&error];
    if(error) {
        NSLog(@"%s : %@",__FUNCTION__,error);
    }
}

//发送一个在线消息给服务器
-(void)sendOnline
{
    XMPPPresence *presence = [XMPPPresence presence];
    NSLog(@"presence : %@",presence);
    [_xmppStream sendElement:presence];
}
#pragma mark - public method
/**
 *  用户登录
 **/
-(void)xmppLogin
{
    //1、初始化登录
    
    
    //2、连接服务器(传一个jid)
    
    //3、连接成功，接着发送密码
    
    //4、发送一个‘在线’请求给服务器(默认登录成功不在线)
}


#pragma mark - XMPPStream Delegate

//建立连接成功
-(void)xmppStreamDidConnect:(XMPPStream *)sender
{
    NSLog(@"%s",__FUNCTION__);
    [self sendPwdToHost];
}

-(void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    NSLog(@"%s",__FUNCTION__);
    [self sendOnline];
}

-(void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error
{
    NSLog(@"%s : %@",__FUNCTION__,error);
}
@end
