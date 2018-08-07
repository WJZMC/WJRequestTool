//
//  UNSignTool.m
//  iOSTool
//
//  Created by jack wei on 2018/7/30.
//  Copyright © 2018年 jack wei. All rights reserved.
//

#import "UNSignTool.h"
#import <CommonCrypto/CommonCrypto.h>
@implementation UNSignTool
+(NSString*)getSignStrWithOriginDic:(NSDictionary*)dic
{
    NSString *signStr=@"";
    NSArray *temArray=[dic allKeys];
    NSArray *resultArray = [temArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2]; //升序
    }];
    NSMutableString *resultTemstr=[NSMutableString string];
    for (int i=0; i<resultArray.count; i++) {
        [resultTemstr appendFormat:@"%@",dic[resultArray[i]]];
    }
    signStr=[UNSignTool md5:resultTemstr];
    signStr=[signStr lowercaseString];
    return signStr;
}
+(NSString *) md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr,(unsigned) strlen(cStr), result );
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
@end
