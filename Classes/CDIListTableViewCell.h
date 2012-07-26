//
//  CDIListTableViewCell.h
//  Cheddar for iOS
//
//  Created by Sam Soffes on 4/24/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDITableViewCell.h"

@class CDKList;

@interface CDIListTableViewCell : CDITableViewCell

@property (nonatomic, strong) CDKList *list;

@end
