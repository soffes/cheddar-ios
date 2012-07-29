//
//  CDIWebViewController.h
//  Cheddar for iOS
//
//  Created by Sam Soffes on 7/28/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import <MessageUI/MessageUI.h>

@interface CDIWebViewController : UIViewController <SSWebViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) SSWebView *webView;

- (void)loadURL:(NSURL *)url;
- (NSURL *)currentURL;

- (void)close:(id)sender;
- (void)openSafari:(id)sender;
- (void)openActionSheet:(id)sender;
- (void)copyURL:(id)sender;
- (void)emailURL:(id)sender;

@end
