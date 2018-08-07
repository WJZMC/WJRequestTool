//
//  UNAPIBase.h
//  UGC
//
//  Created by jack wei on 2018/5/24.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/** 上传或者下载的进度, Progress.completedUnitCount:当前大小 - Progress.totalUnitCount:总大小*/
typedef void (^UNAPIResultProgress)(NSProgress *progress);
//api层结果block
typedef void (^UNAPIResultSucessBlock)(id result,NSString *msg);
typedef void (^UNAPIResultFailedBlock)(NSString *failMsg);
@interface WJRequestBase : NSObject
@property(nonatomic,strong) NSString *BaseUrl;
//alert
+(void)showAlertWithMsg:(NSString*)msg WithParentView:(UIView*)parentV;
//
+(void)postWithURL:(NSString *)url parameters:(id)parameters WithAnimation:(BOOL)isShowAnimation WithShowLogin:(BOOL)isShowLogin success:(UNAPIResultSucessBlock)success failure:(UNAPIResultFailedBlock)failure;
+ (void)uploadImageWithURL:(NSString *)url parameters:(id)parameters images:(NSArray<UIImage *> *)images name:(NSString *)name imageNames:(NSArray<NSString *> *)imageNames imageType:(NSString *)imageType imageScale:(CGFloat)scale prgress:(UNAPIResultProgress)progresss success:(UNAPIResultSucessBlock)success failure:(UNAPIResultFailedBlock)failure;
@end
