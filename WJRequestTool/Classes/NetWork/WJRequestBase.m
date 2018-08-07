//
//  UNAPIBase.m
//  iOSTool
//
//  Created by jack wei on 2018/7/30.
//  Copyright © 2018年 jack wei. All rights reserved.

#import "WJRequestBase.h"
#import "PPNetworkHelper.h"
#import "AFNetworking.h"
#import "WJSignTool.h"
#import "WJToast.h"
#import "SVProgressHUD.h"
#import "WJErrorWebVIew.h"

//调试
#ifdef DEBUG
#define debugLog(...) NSLog(@"%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define debugLog(...)

#endif


@implementation WJRequestBase
//alert 消息提示
+(void)showAlertWithMsg:(NSString*)msg WithParentView:(UIView*)parentV
{
    [CSToastManager sharedStyle].titleNumberOfLines=0;
    [parentV makeToast:msg duration:1.0f position:CSToastPositionCenter];
}
+(void)showErrorWithhtmlData:(NSData*)data
{
    UIWindow *key=[UIApplication sharedApplication].keyWindow;
    WJErrorWebVIew *error=[[WJErrorWebVIew alloc]initWithFrame:key.bounds WithhtmlData:data];
    [key addSubview:error];
    [key bringSubviewToFront:error];
}
+(void)postWithURL:(NSString *)url parameters:(id)parameters WithAnimation:(BOOL)isShowAnimation WithShowLogin:(BOOL)isShowLogin success:(UNAPIResultSucessBlock)success failure:(UNAPIResultFailedBlock)failure
{
    [PPNetworkHelper setRequestSerializer:(PPRequestSerializerJSON)];
    //是否显示加载动画
    if (isShowAnimation) {
        [SVProgressHUD show];
    }
    NSDictionary *dict=[WJRequestBase dealConfigParameters:parameters];
    
    debugLog(@"%@", dict);
    debugLog(@"%@", url);
    debugLog(@"UN发起网络请求，地址：%@；参数：%@",url,parameters);

    [PPNetworkHelper POST:url parameters:dict success:^(id responseObject) {
        
        [SVProgressHUD dismiss];
        [WJRequestBase dealSucessWithResult:responseObject WithShowLogin:isShowLogin success:success failure:failure];
        
    } failure:^(NSError *error) {
        
        debugLog(@"%@", error);
        [SVProgressHUD dismiss];
        [WJRequestBase dealFailWithResult:error WithShowLogin:isShowLogin failure:failure];
    }];
}
+ (void)uploadImageWithURL:(NSString *)url parameters:(id)parameters images:(NSArray<UIImage *> *)images name:(NSString *)name imageNames:(NSArray<NSString *> *)imageNames imageType:(NSString *)imageType imageScale:(CGFloat)scale prgress:(UNAPIResultProgress)progresss success:(UNAPIResultSucessBlock)success failure:(UNAPIResultFailedBlock)failure
{
    [PPNetworkHelper setRequestSerializer:(PPRequestSerializerJSON)];
    
    [SVProgressHUD show];

    
    NSDictionary *dict=[WJRequestBase dealConfigParameters:parameters];

//    debugLog(@"%@", dict);
//    debugLog(@"%@", url);
    [PPNetworkHelper uploadImagesWithURL:url parameters:dict name:name images:images fileNames:imageNames imageScale:scale imageType:imageType progress:^(NSProgress *progress) {
        
        progresss(progress);
    } success:^(id responseObject) {
//        debugLog(@"%@", responseObject);
        [WJRequestBase dealSucessWithResult:responseObject WithShowLogin:NO success:success failure:failure];

    } failure:^(NSError *error) {
        debugLog(@"%@", error);
        [WJRequestBase dealFailWithResult:error WithShowLogin:NO failure:failure];
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
+(void)dealSucessWithResult:(id)responseObject WithShowLogin:(BOOL)isShowLogin success:(UNAPIResultSucessBlock)success failure:(UNAPIResultFailedBlock)failure
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
//                UNUserModel *mt=kApplicationSingle.userModel;
//                mt.token=@"";
//                mt.isAppLogin=NO;
//                [kApplicationSingle refushUserModelWithModel:mt];
                
                if (isShowLogin) {
                    failure(@"");
                    [WJRequestBase showAlertWithMsg:@"登录信息失效，请重试" WithParentView:[[[UIApplication sharedApplication] delegate] window]];

                }else
                {
                    if ([resultkeyArray containsObject:@"msg"]){
                        failure(responseObject[@"msg"]);
                        [WJRequestBase showAlertWithMsg:@"登录信息失效，请重试" WithParentView:[[[UIApplication sharedApplication] delegate] window]];
                    }else
                    {
                        failure(@"登录信息失效，请重试");
                        [WJRequestBase showAlertWithMsg:@"登录信息失效，请重试" WithParentView:[[[UIApplication sharedApplication] delegate] window]];
                    }
                    
                }
                
            }else if ([responseObject[@"code"] intValue] == 100){
                if ([resultkeyArray containsObject:@"data"]){
                    [WJRequestBase updateWithData:responseObject[@"data"]];
                }else
                {
                    [WJRequestBase showAlertWithMsg:@"无最新版本描述" WithParentView:[[[UIApplication sharedApplication] delegate] window]];
                }
                failure(@"");
            }else if ([responseObject[@"code"] intValue] == -2){
//                [UNApplicationSingle getInstance].userModel.isAppLogin=NO;
                //封号
                if ([resultkeyArray containsObject:@"msg"]){
                    failure(responseObject[@"msg"]);
                    [WJRequestBase showAlertWithMsg:responseObject[@"msg"] WithParentView:[[[UIApplication sharedApplication] delegate] window]];
                }else
                {
                    failure(@"无错误描述");
                    [WJRequestBase showAlertWithMsg:@"无错误描述" WithParentView:[[[UIApplication sharedApplication] delegate] window]];
                }
            }else if ([responseObject[@"code"] intValue] == -3){
                if ([resultkeyArray containsObject:@"msg"]){
                    failure(responseObject[@"code"]);
                    [WJRequestBase showAlertWithMsg:responseObject[@"msg"] WithParentView:[[[UIApplication sharedApplication] delegate] window]];
                }else
                {
                    failure(@"无错误描述");
                    [WJRequestBase showAlertWithMsg:@"无错误描述" WithParentView:[[[UIApplication sharedApplication] delegate] window]];
                }
            }
            else{
                if ([resultkeyArray containsObject:@"msg"]){
                    failure(responseObject[@"msg"]);
                    [WJRequestBase showAlertWithMsg:responseObject[@"msg"] WithParentView:[[[UIApplication sharedApplication] delegate] window]];
                }else
                {
                    failure(@"无错误描述");
                    [WJRequestBase showAlertWithMsg:@"无错误描述" WithParentView:[[[UIApplication sharedApplication] delegate] window]];
                }
                
            }
        }else
        {
            failure(@"非法的返回结果");
            [WJRequestBase showAlertWithMsg:@"非法的返回结果" WithParentView:[[[UIApplication sharedApplication] delegate] window]];

        }
    }else
    {
        failure(@"非法的返回结果");
        [WJRequestBase showAlertWithMsg:@"非法的返回结果" WithParentView:[[[UIApplication sharedApplication] delegate] window]];

    }
}
+(void)dealFailWithResult:(NSError*)error WithShowLogin:(BOOL)isShowLogin failure:(UNAPIResultFailedBlock)failure
{
    failure(error.localizedFailureReason);
    
    [WJRequestBase showAlertWithMsg:error.localizedFailureReason WithParentView:[[[UIApplication sharedApplication] delegate] window]];

    if ([[error.userInfo allKeys] containsObject:@"NSUnderlyingError"]) {
#ifdef DEBUG
        if ([[[error.userInfo[@"NSUnderlyingError"] userInfo] allKeys] containsObject:@"com.alamofire.serialization.response.error.data"]) {
            NSData *messagedata=[error.userInfo[@"NSUnderlyingError"] userInfo][@"com.alamofire.serialization.response.error.data"];
            //            MyLog(@"Error: -------%@",[[NSString alloc]initWithData:messagedata  encoding:NSUTF8StringEncoding]);
            dispatch_async(dispatch_get_main_queue(), ^{
                [WJRequestBase showErrorWithhtmlData:messagedata];
            });
        }
#else
        
#endif
        
    }
}
+(void)updateWithData:(NSDictionary*)dic
{
    if ([dic isKindOfClass:[NSDictionary class]]) {
        NSArray *allkeys=[dic allKeys];
        if ([allkeys containsObject:@"info"]&&[allkeys containsObject:@"title"]&&[allkeys containsObject:@"url"]&&[allkeys containsObject:@"version"]) {
            [WJRequestBase showAlertWithMsg:dic[@"title"] WithParentView:[[[UIApplication sharedApplication] delegate] window]];

        }else
        {
            [WJRequestBase showAlertWithMsg:@"最新版本返回数据格式错误" WithParentView:[[[UIApplication sharedApplication] delegate] window]];
        }
    }else
    {
        [WJRequestBase showAlertWithMsg:@"最新版本返回数据格式错误" WithParentView:[[[UIApplication sharedApplication] delegate] window]];
    }
   
}
@end
