//
//  UNAPIBase.m
//  iOSTool
//
//  Created by jack wei on 2018/7/30.
//  Copyright © 2018年 jack wei. All rights reserved.

#import "WJRequest.h"
#import "PPNetworkHelper.h"
#import "AFNetworking.h"
#import "WJSignTool.h"
#import "SVProgressHUD.h"
#import "WJErrorWebVIew.h"

//调试
#ifdef DEBUG
#define debugLog(...) NSLog(@"%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define debugLog(...)

#endif

@implementation WJRequest
+(void)postWithURL:(NSString *)url parameters:(id)parameters WithAnimation:(BOOL)isShowAnimation WithShowLogin:(BOOL)isShowLogin success:(WJAPIResultSucessBlock)success failure:(WJAPIResultFailedBlock)failure
{
    [PPNetworkHelper setRequestSerializer:(PPRequestSerializerJSON)];
    //是否显示加载动画
    if (isShowAnimation) {
        [SVProgressHUD show];
    }
    NSDictionary *dict=[WJRequest dealConfigParameters:parameters];
    
    debugLog(@"%@", dict);
    debugLog(@"%@", url);
    debugLog(@"UN发起网络请求，地址：%@；参数：%@",url,parameters);

    [PPNetworkHelper POST:url parameters:dict success:^(id responseObject) {
        
        [SVProgressHUD dismiss];
        [WJRequest dealSucessWithResult:responseObject WithShowLogin:isShowLogin success:success failure:failure];
        
    } failure:^(NSError *error) {
        
        debugLog(@"%@", error);
        [SVProgressHUD dismiss];
        [WJRequest dealFailWithResult:error WithShowLogin:isShowLogin failure:failure];
    }];
}
+ (void)uploadImageWithURL:(NSString *)url parameters:(id)parameters images:(NSArray<UIImage *> *)images name:(NSString *)name imageNames:(NSArray<NSString *> *)imageNames imageType:(NSString *)imageType imageScale:(CGFloat)scale prgress:(WJAPIResultProgress)progresss success:(WJAPIResultSucessBlock)success failure:(WJAPIResultFailedBlock)failure
{
    [PPNetworkHelper setRequestSerializer:(PPRequestSerializerJSON)];
    
    [SVProgressHUD show];

    
    NSDictionary *dict=[WJRequest dealConfigParameters:parameters];

    debugLog(@"%@", dict);
    debugLog(@"%@", url);
    [PPNetworkHelper uploadImagesWithURL:url parameters:dict name:name images:images fileNames:imageNames imageScale:scale imageType:imageType progress:^(NSProgress *progress) {
        
        progresss(progress);
    } success:^(id responseObject) {
        debugLog(@"%@", responseObject);
        [WJRequest dealSucessWithResult:responseObject WithShowLogin:NO success:success failure:failure];

    } failure:^(NSError *error) {
        debugLog(@"%@", error);
        [WJRequest dealFailWithResult:error WithShowLogin:NO failure:failure];
    }];
}
+(NSDictionary *)dealConfigParameters:(id)parameters
{
    /*
     设置httpheader  token 等
     */
    NSString *token=@"";
    [PPNetworkHelper setValue:token forHTTPHeaderField:@"token"];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:parameters];
    
    dict[@"ostype"] = @"iOS";
    
    dict[@"sign"] =[WJSignTool getSignStrWithOriginDic:dict];

    return dict;
}
+(void)dealSucessWithResult:(id)responseObject WithShowLogin:(BOOL)isShowLogin success:(WJAPIResultSucessBlock)success failure:(WJAPIResultFailedBlock)failure
{
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        NSArray *resultkeyArray=[responseObject allKeys];
        if ([resultkeyArray containsObject:@"code"]) {
            if ([responseObject[@"code"] intValue] == 1) {
                if ([resultkeyArray containsObject:@"data"]||[resultkeyArray containsObject:@"msg"]) {
                    id data;
                    NSString *msg;
                    if ([resultkeyArray containsObject:@"data"]) {
                        data=responseObject[@"data"];
                    }else
                    {
                        data=@"";
                    }
                    if ([resultkeyArray containsObject:@"msg"]) {
                        msg=responseObject[@"msg"];
                    }else
                    {
                        msg=@"";
                    }
                    success(data,msg);
                }else
                {
                    failure(@"无返回结果");
                }
            }else if ([responseObject[@"code"] intValue] == -1){
                //处理登陆信息失效相关逻辑
                
                if (isShowLogin) {
                    failure(@"登录信息失效，请重试");
                }else
                {
                    if ([resultkeyArray containsObject:@"msg"]){
                        failure(responseObject[@"msg"]);
                       
                    }else
                    {
                        failure(@"登录信息失效，请重试");
                    }
                    
                }
                
            }else if ([responseObject[@"code"] intValue] == 100){
                if ([resultkeyArray containsObject:@"data"]){
                    [WJRequest updateWithDataInfo:responseObject[@"data"]];
                }else
                {
                    failure(@"无最新版本描述");
                }
            }else if ([responseObject[@"code"] intValue] == -2){
//                [UNApplicationSingle getInstance].userModel.isAppLogin=NO;
                //封号
                if ([resultkeyArray containsObject:@"msg"]){
                    failure(responseObject[@"msg"]);
                }else
                {
                    failure(@"无错误描述");
                }
            }else if ([responseObject[@"code"] intValue] == -3){
                if ([resultkeyArray containsObject:@"msg"]){
                    failure(responseObject[@"code"]);
                }else
                {
                    failure(@"无错误描述");
                }
            }
            else{
                if ([resultkeyArray containsObject:@"msg"]){
                    failure(responseObject[@"msg"]);
                }else
                {
                    failure(@"无错误描述");
                }
                
            }
        }else
        {
            failure(@"非法的返回结果");

        }
    }else
    {
        failure(@"非法的返回结果");

    }
}
+(void)dealFailWithResult:(NSError*)error WithShowLogin:(BOOL)isShowLogin failure:(WJAPIResultFailedBlock)failure
{
    failure(error.localizedFailureReason);
    

    if ([[error.userInfo allKeys] containsObject:@"NSUnderlyingError"]) {
#ifdef DEBUG
        if ([[[error.userInfo[@"NSUnderlyingError"] userInfo] allKeys] containsObject:@"com.alamofire.serialization.response.error.data"]) {
            NSData *messagedata=[error.userInfo[@"NSUnderlyingError"] userInfo][@"com.alamofire.serialization.response.error.data"];
            //            MyLog(@"Error: -------%@",[[NSString alloc]initWithData:messagedata  encoding:NSUTF8StringEncoding]);
            dispatch_async(dispatch_get_main_queue(), ^{
                [WJRequest showErrorWithhtmlData:messagedata];
            });
        }
#else
        
#endif
        
    }
}
+(void)updateWithDataInfo:(NSDictionary *)info
{
    if ([info isKindOfClass:[NSDictionary class]]) {
        NSArray *allkeys=[info allKeys];
        if ([allkeys containsObject:@"info"]&&[allkeys containsObject:@"title"]&&[allkeys containsObject:@"url"]&&[allkeys containsObject:@"version"]) {
//            [WJRequestBase showAlertWithMsg:dic[@"title"] WithParentView:[[[UIApplication sharedApplication] delegate] window]];
        }else
        {
//            [WJRequestBase showAlertWithMsg:@"最新版本返回数据格式错误" WithParentView:[[[UIApplication sharedApplication] delegate] window]];
        }
    }else
    {
//        [WJRequestBase showAlertWithMsg:@"最新版本返回数据格式错误" WithParentView:[[[UIApplication sharedApplication] delegate] window]];
    }
   
}
+(void)showErrorWithhtmlData:(NSData*)data
{
    UIWindow *key=[UIApplication sharedApplication].keyWindow;
    WJErrorWebVIew *error=[[WJErrorWebVIew alloc]initWithFrame:key.bounds WithhtmlData:data];
    [key addSubview:error];
    [key bringSubviewToFront:error];
}
@end
