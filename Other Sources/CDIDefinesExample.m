//
//  CDIDefines.m
//  Cheddar for iOS
//
//  Created by Sam Soffes on 7/24/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDIDefines.h"

#pragma mark - API

//
// Remove the line that starts with `#error` after you have filled
// in your API credentials.
//
// If you don't have API credentials yet, you can register an app
// at https://cheddarapp.com/developer/apps
//
// You must set the redirect URI to `cheddar://oauth`
//
#error You need to fill in CDIDefines.m with your API credentials

NSString *const kCDIAPIClientID = @"YOUR_API_KEY";
NSString *const kCDIAPIClientSecret = @"YOUR_API_SECRET";


#pragma mark - Fonts

// Since we cannot distribute Gotham for licensing reasons, you get to use
// Helvetica Neue in development. If you're feeling fancy, feel free to use
// different fonts here.

NSString *const kCDIRegularFontName = @"HelveticaNeue";
NSString *const kCDIBoldFontName = @"HelveticaNeue-Bold";
NSString *const kCDIBoldItalicFontName = @"HelveticaNeue-BoldItalic";
NSString *const kCDIItalicFontName = @"HelveticaNeue-Italic";
