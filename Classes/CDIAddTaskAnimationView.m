//
//  CDIAddTaskAnimationView.m
//  Cheddar for iOS
//
//  Created by Sam Soffes on 4/29/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDIAddTaskAnimationView.h"
#import "CDITableViewCell.h"
#import "UIFont+CheddariOSAdditions.h"
#import "UIColor+CheddariOSAdditions.h"
#import <QuartzCore/QuartzCore.h>

@implementation CDIAddTaskAnimationView

@synthesize title = _title;

#pragma mark - Animation

- (void)animationToPoint:(CGPoint)point height:(CGFloat)height insertTask:(void(^)(void))insertTask completion:(void(^)(void))completion {
	CGSize size = self.bounds.size;
	CGFloat cellHeight = [CDITableViewCell cellHeight];
	CGFloat topShadowHeight = 6.0f;
	CGFloat bottomShadowHeight = 6.0f;
	
	UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0.0f, -topShadowHeight, size.width, cellHeight + topShadowHeight + bottomShadowHeight)];
	container.alpha = 0.0f;
	[self addSubview:container];
	
	// Top shadow
	SSGradientView *topShadow = [[SSGradientView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, size.width, topShadowHeight)];
	topShadow.backgroundColor = [UIColor clearColor];
	topShadow.alpha = 0.0f;
	topShadow.colors = [NSArray arrayWithObjects:
						[UIColor colorWithWhite:0.0f alpha:0.0f],
						[UIColor colorWithWhite:0.0f alpha:0.09f],
						nil];
	[container addSubview:topShadow];
	
	// Bottom shadow
	SSGradientView *bottomShadow = [[SSGradientView alloc] initWithFrame:CGRectMake(0.0f, cellHeight + topShadowHeight, size.width, bottomShadowHeight)];
	bottomShadow.backgroundColor = [UIColor clearColor];
	bottomShadow.alpha = 0.0f;
	bottomShadow.colors = [NSArray arrayWithObjects:
						   [UIColor colorWithWhite:0.0f alpha:0.13f],
						   [UIColor colorWithWhite:0.0f alpha:0.0f],
						   nil];
	[container addSubview:bottomShadow];
	
	// Background
	SSBorderedView *background = [[SSBorderedView alloc] initWithFrame:CGRectMake(0.0f, topShadowHeight, size.width, cellHeight)];
	background.backgroundColor = [UIColor whiteColor];
	background.bottomBorderColor = [UIColor colorWithWhite:0.92f alpha:1.0f];
	background.contentMode = UIViewContentModeRedraw;
	[container addSubview:background];
	
	// Checkbox
	UIImageView *checkbox = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"checkbox"] stretchableImageWithLeftCapWidth:4 topCapHeight:4]];
	checkbox.frame = CGRectMake(-34.0f, 13.0f, 24.0f, 24.0f);
	[background addSubview:checkbox];
	
	// Label
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16.0f, 7.0f, size.width - 32.0f, 38.0f)];
	label.font = [UIFont cheddarFontOfSize:18.0f];
	label.textColor = [UIColor cheddarTextColor];
	label.backgroundColor = [UIColor clearColor];
	label.text = self.title;
	[background addSubview:label];
	
	// Adjust point
	point.y = fminf(point.y, size.height);
	
	// Animate
	UIViewAnimationOptions options = UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction;
	[UIView animateWithDuration:0.2 delay:0.0 options:options animations:^{
		container.alpha = 1.0f;
	} completion:nil];
	
	NSTimeInterval boxDuration = 0.2f;
	NSTimeInterval moveDuration = fmax(0.2, 0.3 * (point.y / height));
	
	[UIView animateWithDuration:boxDuration delay:0.10 options:options animations:^{
		topShadow.alpha = 1.0f;
		bottomShadow.alpha = 1.0f;
		
		CGRect frame = checkbox.frame;
		frame.origin.x = 10.0f;
		checkbox.frame = frame;
		
		label.frame = CGRectMake(44.0f, 13.0f, size.width - 54.0f, 24.0f);
		label.font = [UIFont cheddarFontOfSize:18.0f];
		
		frame = container.frame;
		frame.origin.y += 20.0f;
		container.frame = frame;
	} completion:^(BOOL finished) {
		[UIView animateWithDuration:moveDuration delay:0.0 options:options animations:^{		
			CGRect frame = container.frame;
			frame.origin.y = point.y - topShadowHeight;
			container.frame  = frame;
		} completion:^(BOOL finished) {
			if (insertTask) {
				insertTask();
			}
		}];
		
		[UIView animateWithDuration:0.2 delay:moveDuration options:options animations:^{
			container.alpha = 0.0f;
		} completion:^(BOOL finished) {
			if (completion) {
				completion();
			}
		}];
	}];
}

@end
