//
//  HomeViewController.m
//  WaxCabinet
//
//  Created by Mark Kuharich on 11/29/15.
//  Copyright © 2015 Mark Kuharich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeViewController.h"
#import "DiscogsViewController.h"
#import "DiscogsOAuthClient.h"
#import "DTOAuthWebViewController.h"
#import "OAuthSettings.h"
#import "DiscogsAPI.h"
#import "DGAuthViewController.h"
@import UIKit;

@interface HomeViewController () <OAuthResultDelegate>

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    CALayer *btnRLayer = [self.btnReachOut layer];
    [btnRLayer setMasksToBounds:YES];
    [btnRLayer setCornerRadius:25.0f];
    [btnRLayer setBorderWidth:1.0f];
    [btnRLayer setBorderColor:[[UIColor whiteColor] CGColor]];
    
    [DiscogsAPI.client.user identityWithSuccess:^(DGIdentity *identity) {
        NSLog(@"Identity: %@", identity);
        self.userName.text = identity.userName;
        
        [DiscogsAPI.client.user getProfile:identity.userName success:^(DGProfile *profile) {
            NSLog(@"Profile: %@", profile);
            NSString *collection = [profile.numCollection stringValue];
            self.collection.text = collection;
            NSString *wants = [profile.numWantlist stringValue];
            self.wants.text = wants;
        } failure:^(NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    } failure:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}
@end