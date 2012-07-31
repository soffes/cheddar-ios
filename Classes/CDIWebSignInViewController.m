//
//  CDIWebSignInViewController.m
//  Cheddar for iOS
//
//  Created by Sam Soffes on 7/26/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDIWebSignInViewController.h"
#import "CDILoadingView.h"
#import "UIColor+CheddariOSAdditions.h"
#import <SSToolkit/SSCategories.h>

@interface CDIWebSignInViewController ()
- (void)_authorizeWithCode:(NSString *)code;
@end

@implementation CDIWebSignInViewController {
	BOOL _authorizing;
}

@synthesize webView = _webView;

#pragma mark - NSObject

- (id)init {
	if ((self = [super init])) {
		self.title = @"Cheddar";
		UIImageView *title = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav-title"]];
		title.frame = CGRectMake(0.0f, 0.0f, 116.0f, 21.0f);
		self.navigationItem.titleView = title;
	}
	return self;
}


#pragma mark - UIViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor cheddarArchesColor];
	
	CDILoadingView *loadingView = [[CDILoadingView alloc] initWithFrame:self.view.bounds];
	loadingView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.view addSubview:loadingView];
	
	_webView = [[SSWebView alloc] initWithFrame:self.view.bounds];
	_webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_webView.delegate = self;
	_webView.alpha = 0.0f;
	[_webView loadURLString:[NSString stringWithFormat:@"https://api.cheddarapp.com/oauth/authorize?client_id=%@", kCDIAPIClientID]];
	[self.view addSubview:_webView];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		return YES;
	}
	
	return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}


#pragma mark - Private

- (void)_authorizeWithCode:(NSString *)code {
	_authorizing = YES;
	
	[UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
		_webView.alpha = 0.0f;
	} completion:nil];
	
	[[CDKHTTPClient sharedClient] signInWithAuthorizationCode:code success:^(AFJSONRequestOperation *operation, id responseObject) {
		[self.navigationController dismissModalViewControllerAnimated:YES];
	} failure:^(AFJSONRequestOperation *operation, NSError *error) {
		NSLog(@"Failed to sign in: %@", error);
		[_webView loadURLString:[NSString stringWithFormat:@"https://api.cheddarapp.com/oauth/authorize?client_id=%@", kCDIAPIClientID]];
		_authorizing = NO;
	}];
}


#pragma mark - SSWebViewDelegate

- (BOOL)webView:(SSWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)aRequest navigationType:(UIWebViewNavigationType)navigationType {
	NSURL *url = aRequest.mainDocumentURL;
	if ([url.scheme isEqualToString:@"cheddar"] && [url.host isEqualToString:@"oauth"]) {
		NSString *code = [[url queryDictionary] objectForKey:@"code"];
		if (code) {
			[self _authorizeWithCode:code];
		}
		return NO;
	}
	
	return YES;
}


- (void)webViewDidStartLoadingPage:(SSWebView *)aWebView {
	if (_authorizing) {
		return;
	}
	
	[UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
		_webView.alpha = 1.0f;
	} completion:nil];
}


- (void)webViewDidFinishLoadingPage:(SSWebView *)aWebView {
	if (_authorizing) {
		return;
	}
	
	[UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
		_webView.alpha = 1.0f;
	} completion:nil];
}

@end
