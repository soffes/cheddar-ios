//
//  CDIWebSignInViewController.h
//  Cheddar for iOS
//
//  Created by Sam Soffes on 7/26/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDISignInViewController.h"

@interface CDIWebSignInViewController : UIViewController <SSWebViewDelegate>

@property (nonatomic, strong, readonly) SSWebView *webView;

@end
