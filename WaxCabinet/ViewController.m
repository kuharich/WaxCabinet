//
//  ViewController.m
//  WaxCabinet
//
//  Created by Mark Kuharich on 9/13/15.
//  Copyright (c) 2015 Mark Kuharich. All rights reserved.
//

#import "ViewController.h"
#import "DiscogsViewController.h"
#import "DiscogsOAuthClient.h"
#import "DTOAuthWebViewController.h"
#import "OAuthSettings.h"
#import "DiscogsAPI.h"
@import UIKit;

@interface ViewController () <OAuthResultDelegate>

@end

@implementation ViewController

DiscogsOAuthClient *auth;
BOOL startedAuth;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // create the client
    auth = [[DiscogsOAuthClient alloc] initWithConsumerKey:DISCOGS_CONSUMER_KEY consumerSecret:DISCOGS_CONSUMER_SECRET];
    
    CALayer *btnLayer = [self.btnDiscogs layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:25.0f];
    [btnLayer setBorderWidth:1.0f];
    [btnLayer setBorderColor:[[UIColor whiteColor] CGColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_showAlertWithTitle:(NSString *)title message:(NSString *)message
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [alert show];
    });
}

- (IBAction)discogs:(id)sender {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.opaque = YES;
    
    [DiscogsAPI.client.authentication authenticateWithPreparedAuthorizationViewHandler:^(UIView *authView) {
        authView.frame = [[UIScreen mainScreen] bounds];
        [self.view addSubview:authView];
    } success:^{
        [self dismissViewControllerAnimated:YES completion:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIViewController *top = [UIApplication sharedApplication].keyWindow.rootViewController;
            UITabBarController *tc = [[self storyboard] instantiateViewControllerWithIdentifier:@"TabBar"];
            [top presentViewController:tc animated:YES completion:NULL];
        });
    } failure:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

#pragma mark - OAuth

- (void)authorizationWasDenied:(DTOAuthWebViewController *)webViewController
{
    [self dismissViewControllerAnimated:YES completion:NULL];
    startedAuth = NO;
}

- (void)authorizationWasGranted:(DTOAuthWebViewController *)webViewController forToken:(NSString *)token withVerifier:(NSString *)verifier
{
    [self dismissViewControllerAnimated:YES completion:NULL];
    startedAuth = NO;
    
    if ([token isEqualToString:auth.token])
    {
        [auth authorizeTokenWithVerifier:verifier completion:^(NSError *error) {
            if (error)
            {
                NSLog(@"Error authorizing token: %@", [error localizedDescription]);
                return;
            }
            else
            {
                
            }
        }];
    }
    else
    {
        NSLog(@"Received authorization for token '%@' instead of requested token '%@", token, auth.token);
    }
}

@end