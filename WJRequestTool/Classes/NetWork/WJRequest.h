//
//  UNAPIBase.h
//  UGC
//
//  Created by jack wei on 2018/5/24.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/** 上传或者下载的进度, Progress.completedUnitCount:当前大小 - Progress.totalUnitCount:总大小*/
typedef void (^WJAPIResultProgress)(NSProgress *progress);
//api层结果block
typedef void (^WJAPIResultSucessBlock)(id result,NSString *msg);
typedef void (^WJAPIResultFailedBlock)(NSString *failMsg);
@interface WJRequest : NSObject
+(void)postWithURL:(NSString *)url parameters:(id)parameters WithAnimation:(BOOL)isShowAnimation WithShowLogin:(BOOL)isShowLogin success:(WJAPIResultSucessBlock)success failure:(WJAPIResultFailedBlock)failure;
+(void)uploadImageWithURL:(NSString *)url parameters:(id)parameters images:(NSArray<UIImage *> *)images name:(NSString *)name imageNames:(NSArray<NSString *> *)imageNames imageType:(NSString *)imageType imageScale:(CGFloat)scale prgress:(WJAPIResultProgress)progresss success:(WJAPIResultSucessBlock)success failure:(WJAPIResultFailedBlock)failure;
+(void)dealSucessWithResult:(id)responseObject WithShowLogin:(BOOL)isShowLogin success:(WJAPIResultSucessBlock)success failure:(WJAPIResultFailedBlock)failure;
+(void)updateWithDataInfo:(NSDictionary *)info;
@end
