//
//  main.m
//  Cheddar for iOS
//
//  Created by Sam Soffes on 3/25/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDIAppDelegate.h"
#import "CDITableViewCellDeleteConfirmationControl.h"
#import <objc/runtime.h>

int main(int argc, char *argv[]) {
	@autoreleasepool {
		// Swizzle archive button
		Class deleteControl = NSClassFromString([NSString stringWithFormat:@"_%@DeleteConfirmationControl", @"UITableViewCell"]);
		if (deleteControl) {
			Method drawRectCustom = class_getInstanceMethod(deleteControl, @selector(drawRect:));
			Method drawRect = class_getInstanceMethod([CDITableViewCellDeleteConfirmationControl class], @selector(drawRectCustom:));
			method_exchangeImplementations(drawRect, drawRectCustom);
		}

		return UIApplicationMain(argc, argv, nil, NSStringFromClass([CDIAppDelegate class]));
	}
}
