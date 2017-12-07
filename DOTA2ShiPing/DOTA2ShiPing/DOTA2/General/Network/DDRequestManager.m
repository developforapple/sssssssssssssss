//
//  DDRequestManager.m
//
//
//  Created by Normal on 15/6/18.
//  Copyright (c) 2015年 bo wang. All rights reserved.
//

#import "DDRequestManager.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "CDTUserSession.h"
#import "NSObject+URLSessionTask.h"
#import "ReactiveObjC.h"

#pragma mark - RequestManager
@interface DDRequestManager ()
@property (strong, readwrite, nonatomic) AFHTTPSessionManager *manager;
@property (copy, nonatomic) DDRespSucHandler sucHandler;
@property (copy, nonatomic) DDRespFailHandler failHandler;
@end

@implementation DDRequestManager

+ (instancetype)managerWithHost:(NSString *)host
{
    __kindof DDRequestManager *manager = [[self alloc] init];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.requestCachePolicy = NSURLRequestReloadIgnoringCacheData;
    config.timeoutIntervalForRequest = 20;
    config.HTTPShouldSetCookies = NO;
    config.HTTPCookieAcceptPolicy = NSHTTPCookieAcceptPolicyNever;
#if DEBUG_MODE
//    config.protocolClasses = @[[DDTaskBenchmarkTest class]];
#endif
    
    AFHTTPSessionManager *afn = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:host] sessionConfiguration:config];
    afn.operationQueue.maxConcurrentOperationCount = 10;
    [afn.reachabilityManager startMonitoring];
    manager.manager = afn;
    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] setActivationDelay:0.4];
    
    [manager setSuccessResponseHandler:nil];
    [manager setFailureResponseHandler:nil];
    
    return manager;
}

- (NSMutableDictionary *)presetParameters
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"access_token"] = SESSION.accessToken;
    dict[@"device"] = [NSString stringWithFormat:@"%@|%@%@",Device_Hardware,Device_SysName,Device_SysVersionStr];
    dict[@"platform"] = @"iOS";
    dict[@"version"] = AppVersion;
    dict[@"channelId"] = kAppChannelID;
    dict[@"network"] = self.manager.reachabilityManager.reachableViaWWAN?@"Cellular":(self.manager.reachabilityManager.reachableViaWiFi?@"WiFi":@"Unknown");
    return dict;
}

- (void)setSuccessResponseHandler:(DDRespSucHandler)sucHandler
{
    if (sucHandler) {
        self.sucHandler = sucHandler;
    }else{
        self.sucHandler = ^(DDTASK task, id object, DDRespSucBlock sucCallback, DDRespFailBlock failCallback) {
            if ([task task_isCanceled] || !object) return;
            DDResponse *response = [DDResponse response:task.response object:object];
            RunOnMainQueue(^{
                if (response.suc && sucCallback) {
                    sucCallback(task,response);
                }else if (!response.suc && failCallback){
                    failCallback(task,response);
                }
                [SESSION checkAccessTokenValid:response.result];
            });
        };
    }
}

- (void)setFailureResponseHandler:(DDRespFailHandler)failHandler
{
    if (failHandler) {
        self.failHandler = failHandler;
    }else{
        self.failHandler = ^(DDTASK task, NSError *err, DDRespFailBlock failCallback) {
            if ([task task_isCanceled]) return;
            if (failCallback) {
                DDResponse *response = [DDResponse response:task.response error:err];
                RunOnMainQueue(^{
                    failCallback(task,response);
                });
            }
        };
    }
}

@end

#pragma mark - Request
@implementation DDRequestManager (Request)

- (DDTASK)request:(int)method :(NSString *)uri :(NSDictionary *)param :(NSDictionary *)data :(DDRespSucBlock)respSuc :(DDRespFailBlock)respFail
{
    void (^successHandler)(DDTASK, id) = ^(DDTASK task, id object){
        self.sucHandler(task, object, respSuc, respFail);
    };
    void (^failureHandler)(DDTASK, NSError *) = ^(DDTASK task, NSError *error){
        self.failHandler(task, error, respFail);
    };
    
    NSMutableDictionary *dict = [self presetParameters];
    [dict addEntriesFromDictionary:param];
    
    DDTASK task;
    
    switch (method) {
        case POST:{
            if (data && data.count > 0) {
                task = [self.manager POST:uri parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                    for (NSString *key in data) {
                        id v = data[key];
                        [formData appendPartWithFormData:v name:key];
                    }
                } progress:nil success:successHandler failure:failureHandler];
            }else{
                task = [self.manager POST:uri parameters:dict progress:nil success:successHandler failure:failureHandler];
            }
        }   break;
        case GET:{
            task = [self.manager GET:uri parameters:dict progress:nil success:successHandler failure:failureHandler];
        }   break;
    }
#if DEBUG_MODE
    SPLog(@"REQUEST : %@",task.currentRequest.URL.absoluteString);
#endif
    return task;
}

@end

#pragma mark - Progress
NO_WARNING_BEGIN(-Wundeclared-selector)
NO_WARNING_BEGIN(-Warc-performSelector-leaks)
@interface AFHTTPSessionManager (DDRequestManager)@end

@implementation AFHTTPSessionManager (DDRequestManager)

- (id)taskDelegate:(NSURLSessionTask *)task
{
    // AFURLSessionManager.m line 592.
    // - (AFURLSessionManagerTaskDelegate *)delegateForTask:(NSURLSessionTask *)task;
    if ([self respondsToSelector:@selector(delegateForTask:)]){
        return [self performSelector:@selector(delegateForTask:) withObject:task];
    }
    return nil;
}
@end

@implementation DDRequestManager (Progress)
- (void)setUploadProgressBlock:(DDProgressBlock)progress forTask:(DDTASK)task
{
    id delegate = [self.manager taskDelegate:task];
    
    // AFURLSessionManager.m line 123.
    // @property (nonatomic, copy) AFURLSessionTaskProgressBlock uploadProgressBlock;
    SEL progressSetter = @selector(setUploadProgressBlock:);
    if ([delegate respondsToSelector:progressSetter]) {
        [delegate performSelector:progressSetter withObject:progress];
    }
}

- (void)setDownloadProgressBlock:(DDProgressBlock)progress forTask:(DDTASK)task
{
    id delegate = [self.manager taskDelegate:task];
    
    // AFURLSessionManager.m line 123.
    // @property (nonatomic, copy) AFURLSessionTaskProgressBlock downloadProgressBlock;
    SEL progressSetter = @selector(setDownloadProgressBlock:);
    if ([delegate respondsToSelector:progressSetter]) {
        [delegate performSelector:progressSetter withObject:progress];
    }
}
NO_WARNING_END

@end
