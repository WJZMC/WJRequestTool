//
//  WJErrorWebVIew.m
//  iOSTool
//
//  Created by jack wei on 2018/7/30.
//  Copyright © 2018年 jack wei. All rights reserved.
//

#import "WJErrorWebVIew.h"
#import <WebKit/WebKit.h>

@implementation WJErrorWebVIew

-(instancetype)initWithFrame:(CGRect)frame WithhtmlData:(NSData *)data
{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor=[UIColor whiteColor];
        WKWebView *errorwebview=[[WKWebView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-60)];
//        errorwebview.tag=kbigWebErrorTag;
        [self addSubview:errorwebview];
        
        [errorwebview loadData:data MIMEType:@"text/html" characterEncodingName:@"UTF-8" baseURL:[NSURL URLWithString:@""]];
        
        UIButton *closebtn=[[UIButton alloc]initWithFrame:CGRectMake(0, frame.size.height-60, frame.size.width, 60)];
        [self addSubview:closebtn];
        [closebtn setTitle:@"关闭" forState:UIControlStateNormal];
        [closebtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [closebtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
-(void)closeAction
{
    [self removeFromSuperview];
}
@end
