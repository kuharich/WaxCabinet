//
//  DGAuthViewController.m
//  WaxCabinet
//
//  Created by Mark Kuharich on 12/17/15.
//  Copyright © 2015 Mark Kuharich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DGAuthViewController.h"
#import "DiscogsAPI.h"

@implementation DGAuthViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.opaque = YES;
    
    [DiscogsAPI.client.authentication authenticateWithPreparedAuthorizationViewHandler:^(UIView *authView) {
        authView.frame = [[UIScreen mainScreen] bounds];
        [self.view addSubview:authView];
    } success:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

@end