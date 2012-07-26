//
//  CDIListTableViewCell.m
//  Cheddar for iOS
//
//  Created by Sam Soffes on 4/24/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDIListTableViewCell.h"
#import "UIColor+CheddariOSAdditions.h"

@implementation CDIListTableViewCell

@synthesize list = _list;

- (void)setList:(CDKList *)list {
	_list = list;
	
	self.textLabel.text = list.title;
	[self setNeedsLayout];
}


- (void)setEditingText:(BOOL)editingText {
	self.textField.text = self.list.title;
	[super setEditingText:editingText];
}


#pragma mark - UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
		UIImageView *disclosureImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 15.0f)];
		disclosureImageView.image = [UIImage imageNamed:@"disclosure.png"];
		self.accessoryView = disclosureImageView;
		
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
			self.textLabel.highlightedTextColor = [UIColor cheddarTextColor];
			
			SSGradientView *selected = [[SSGradientView alloc] initWithFrame:CGRectZero];
			selected.colors = [[NSArray alloc] initWithObjects:
							   [UIColor colorWithWhite:0.929f alpha:1.0f],
							   [UIColor colorWithWhite:0.969f alpha:1.0f],
							   [UIColor colorWithWhite:0.969f alpha:1.0f],
							   [UIColor colorWithWhite:0.929f alpha:1.0f],
							   nil];
			selected.locations = [[NSArray alloc] initWithObjects:
								  [NSNumber numberWithFloat:0.0f],
								  [NSNumber numberWithFloat:0.098f],
								  [NSNumber numberWithFloat:0.902f],
								  [NSNumber numberWithFloat:1.0f],
								  nil];
			selected.bottomBorderColor = [UIColor colorWithWhite:0.906f alpha:1.0f];
			self.selectedBackgroundView = selected;
		} else {
			disclosureImageView.highlightedImage = [UIImage imageNamed:@"disclosure-highlighted.png"];
			SSGradientView *selectedBackground = [[SSGradientView alloc] initWithFrame:CGRectZero];
			selectedBackground.colors = [[NSArray alloc] initWithObjects:
										 [UIColor colorWithRed:0.0f green:0.722f blue:0.918f alpha:1.0f],
										 [UIColor colorWithRed:0.0f green:0.631f blue:0.835f alpha:1.0f],
										 nil];
//			selectedBackground.topBorderColor = [UIColor colorWithRed:0.392f green:0.808f blue:0.945f alpha:1.0f];
//			selectedBackground.bottomInsetColor = [UIColor colorWithRed:0.306f green:0.745f blue:0.886f alpha:1.0f];
			selectedBackground.bottomBorderColor = [UIColor colorWithRed:0.0f green:0.502f blue:0.725f alpha:1.0f];
			selectedBackground.contentMode = UIViewContentModeRedraw;
			self.selectedBackgroundView = selectedBackground;
		}
	}
	return self;
}

@end
