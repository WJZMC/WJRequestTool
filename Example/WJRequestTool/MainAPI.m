//
//  MainAPI.m
//  iOSTool
//
//  Created by jack wei on 2018/7/30.
//  Copyright © 2018年 jack wei. All rights reserved.
//

#import "MainAPI.h"
@implementation MainAPI
/**
 * 

 */
+ (void)getHomeChannelColumnListDataWithParameters:(id)parameters WithAnimation:(BOOL)isShowAnimation Success:(UNMainApiResultSucessBlock)success Failed:(WJAPIResultFailedBlock)failure
{
    [MainAPI postWithURL:@"请求全路径" parameters:parameters WithAnimation:isShowAnimation WithShowLogin:NO success:^(id result, NSString *msg)  {
        if ([result isKindOfClass:[NSArray class]]) {
            NSArray *array=result;
            NSMutableArray *resultArray=[NSMutableArray array];
            for (int i=0; i<array.count; i++) {
//                model *mt=[model mj_objectWithKeyValues:array[i]];
//                [resultArray addObject:mt];
            }
            success(resultArray);
        }else
        {
            failure(@"非法的返回结果");            
        }
    } failure:failure];
}

@end
