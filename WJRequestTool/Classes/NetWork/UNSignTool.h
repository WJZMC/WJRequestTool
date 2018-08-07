//
//  UNSignTool.h
//  iOSTool
//
//  Created by jack wei on 2018/7/30.
//  Copyright © 2018年 jack wei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UNSignTool : NSObject
/**
 *@param dic 所有请求参数.
 *重写此方法可以自定义加密串，默认参数升序后取value拼接 对结果md5
 */
+(NSString*)getSignStrWithOriginDic:(NSDictionary*)dic;
@end
