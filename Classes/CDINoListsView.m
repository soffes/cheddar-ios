//
//  CDINoListsView.m
//  Cheddar for iOS
//
//  Created by Sam Soffes on 5/24/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDINoListsView.h"
#import "UIFont+CheddariOSAdditions.h"

@interface CDINoListsView ()

@property (strong, nonatomic) UIImage *listIconImage;
@property (strong, nonatomic) UIImage *addListArrowImage;
@property (strong, nonatomic) UILabel *addAListLabel;
@property (strong, nonatomic) UILabel *noListsLabel;

@end

@implementation CDINoListsView

#pragma mark - Initializers

- (id)initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame]))
    {
		self.userInteractionEnabled = NO;
        self.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin);
        self.backgroundColor = [UIColor clearColor];
        
        // Register a notification to be notified if the device orientation has changed
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(orientationChanged:)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];
        
        // Set the list icon image
        _listIconImage = [UIImage imageNamed:@"list-icon"];
        
        // Set the add list arrow image
        _addListArrowImage = [UIImage imageNamed:@"add-list-arrow"];
        
        // This label is displayed to the right of add list arrow image
		_addAListLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _addAListLabel.text = @"Add a list";
        _addAListLabel.font = [UIFont fontWithName:@"Noteworthy"
                                              size:19.0f];
        _addAListLabel.textColor = [UIColor colorWithWhite:0.294f
                                                     alpha:0.45f];
		
        // This label is displayed under the list icon image
		_noListsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_noListsLabel.textAlignment = UITextAlignmentCenter;
		_noListsLabel.textColor = [UIColor colorWithRed:0.702f
                                                  green:0.694f
                                                   blue:0.686f
                                                  alpha:1.0f];
		_noListsLabel.text = @"You don't have any lists.";
		_noListsLabel.font = [UIFont cheddarInterfaceFontOfSize:22.0f];
		_noListsLabel.shadowColor = [UIColor whiteColor];
		_noListsLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
	}
    
	return self;
}

#pragma mark - Memory Management

- (void)dealloc
{
    // Remove the device orientation did change notification
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDeviceOrientationDidChangeNotification
                                                  object:nil];
}

#pragma mark - Orientation Changed

/**
 Invoked when the device orientation changes. Calls setNeedsDisplay to redraw the view's content.
 */
- (void)orientationChanged:(NSNotification *)notification
{
    [self setNeedsDisplay];
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
    // Get the current graphics context
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Draw the list icon
    CGPoint listIconImagePoint = CGPointMake((self.bounds.size.width - _listIconImage.size.width) / 2, (self.bounds.size.height - _listIconImage.size.height) / 2);
    [_listIconImage drawAtPoint:listIconImagePoint];
    
    // iPad's nav bar buttons are 7pt from the edge instead of iPhone's 5pt
    CGFloat offset = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 16.0f : 14.0f;
    
    // Add List Arrow icon
    [_addListArrowImage drawAtPoint:CGPointMake(self.bounds.size.width - _addListArrowImage.size.width - offset, 5.0f)];
     
    // Save a copy of the current graphics context
    CGContextSaveGState(context);
    
    // Create the rect which the add a list label will be drawn in
    CGRect addAListRect = CGRectMake(self.bounds.size.width - 118.0f, 30.0f, 70.0f, 20.0f);
    
    // Slighly rotates the add a list label when drawn
    CGContextTranslateCTM(context, 0, +addAListRect.size.height / 2);
    CGContextRotateCTM(context, DEGREES_TO_RADIANS(-4.0f));
    
    // The y coordinate is different depending whether in portrait or landscape mode on the iPhone
    float translateY = UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation) || UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? +addAListRect.size.height / 2 : +addAListRect.size.height;
    CGContextTranslateCTM(context, 0, translateY);
    
    // Draw the add a list label
    [_addAListLabel drawTextInRect:addAListRect];
    
    // Restore a copy of the graphics context that was saved before
    CGContextRestoreGState(context);
    
    // Create a rect for the no lists label below the list icon image and then draw the text in the rect
    CGRect noListsRect = CGRectMake(0, listIconImagePoint.y + _listIconImage.size.height, self.bounds.size.width, 60.0f);
    [_noListsLabel drawTextInRect:noListsRect];
}

@end