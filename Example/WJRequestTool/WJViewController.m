//
//  WJViewController.m
//  WJRequestTool
//
//  Created by jack on 08/07/2018.
//  Copyright (c) 2018 jack. All rights reserved.
//

#import "WJViewController.h"
#import "MainAPI.h"
@interface WJViewController ()

@end

@implementation WJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [MainAPI getHomeChannelColumnListDataWithParameters:@{@"type":@"1"} WithAnimation:YES Success:^(NSArray *result) {
        
    } Failed:^(NSString *failMsg) {
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
