//
//  SMTEDelegateController.h
//  teiphone
//
//  Created by Greg Scown on 8/24/09.
//  Copyright 2009-2010 SmileOnMyMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMTEDelegateController : NSObject <UITextViewDelegate, UITextFieldDelegate, UIScrollViewDelegate, UIWebViewDelegate, UISearchBarDelegate> {
}
@property (nonatomic, assign) id nextDelegate;
@property (nonatomic, assign) BOOL provideUndoSupport; // Default: YES

+ (BOOL)isTextExpanderTouchInstalled;
+ (BOOL)snippetsAreShared;
+ (void)setExpansionEnabled:(BOOL)expansionEnabled;
- (void)resetKeyLog;
- (void)willEnterForeground;

@end
