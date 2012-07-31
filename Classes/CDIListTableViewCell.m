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
		UIImageView *disclosureImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 15.0f)];
		disclosureImageView.image = [UIImage imageNamed:@"disclosure"];
		self.accessoryView = disclosureImageView;
		
		disclosureImageView.highlightedImage = [UIImage imageNamed:@"disclosure-highlighted"];
		SSGradientView *selectedBackground = [[SSGradientView alloc] initWithFrame:CGRectZero];
		selectedBackground.colors = [[NSArray alloc] initWithObjects:
									 [UIColor colorWithRed:0.0f green:0.722f blue:0.918f alpha:1.0f],
									 [UIColor colorWithRed:0.0f green:0.631f blue:0.835f alpha:1.0f],
									 nil];
		selectedBackground.bottomBorderColor = [UIColor colorWithRed:0.0f green:0.502f blue:0.725f alpha:1.0f];
		selectedBackground.contentMode = UIViewContentModeRedraw;
		self.selectedBackgroundView = selectedBackground;
	}
	return self;
}

@end
