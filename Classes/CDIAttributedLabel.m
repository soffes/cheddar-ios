//
//  CDIAttributedLabel.m
//  Cheddar for iOS
//
//  Created by Sam Soffes on 4/30/12.
//  Copyright (c) 2012 Nothing Magical. All rights reserved.
//

#import "CDIAttributedLabel.h"
#import <CoreText/CoreText.h>

@implementation CDIAttributedLabel

- (void)drawStrike:(CTFrameRef)frame inRect:(CGRect)rect context:(CGContextRef)c {
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
    CGPoint origins[[lines count]];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), origins);
    
    CFIndex lineIndex = 0;
    for (id line in lines) {        
        CGRect lineBounds = CTLineGetImageBounds((__bridge CTLineRef)line, c);
        lineBounds.origin.x = origins[lineIndex].x;
        lineBounds.origin.y = origins[lineIndex].y;
        
        for (id glyphRun in (__bridge NSArray *)CTLineGetGlyphRuns((__bridge CTLineRef)line)) {
            NSDictionary *attributes = (__bridge NSDictionary *)CTRunGetAttributes((__bridge CTRunRef) glyphRun);
            BOOL strikeOut = [[attributes objectForKey:kTTTStrikeOutAttributeName] boolValue];
            NSInteger superscriptStyle = [[attributes objectForKey:(id)kCTSuperscriptAttributeName] integerValue];
            
            if (strikeOut) {
                CGRect runBounds = CGRectZero;
                CGFloat ascent = 0.0f;
                CGFloat descent = 0.0f;
                
                runBounds.size.width = CTRunGetTypographicBounds((__bridge CTRunRef)glyphRun, CFRangeMake(0, 0), &ascent, &descent, NULL);
                runBounds.size.height = ascent + descent;
                
                CGFloat xOffset = CTLineGetOffsetForStringIndex((__bridge CTLineRef)line, CTRunGetStringRange((__bridge CTRunRef)glyphRun).location, NULL);
                runBounds.origin.x = origins[lineIndex].x + rect.origin.x + xOffset;
				runBounds.origin.y = origins[lineIndex].y; // + rect.origin.y;
                runBounds.origin.y -= descent;
                
                // Don't draw strikeout too far to the right
                if (CGRectGetWidth(runBounds) > CGRectGetWidth(lineBounds)) {
                    runBounds.size.width = CGRectGetWidth(lineBounds);
                }
                
				switch (superscriptStyle) {
					case 1:
						runBounds.origin.y -= ascent * 0.47f;
						break;
					case -1:
						runBounds.origin.y += ascent * 0.25f;
						break;
					default:
						break;
				}
                
                // Use text color, or default to black
                id color = [attributes objectForKey:(id)kCTForegroundColorAttributeName];
				
                if (color) {
                    CGContextSetStrokeColorWithColor(c, (__bridge CGColorRef)color);
                } else {
                    CGContextSetGrayStrokeColor(c, 0.0f, 1.0);
                }
                
                // CTFontRef font = CTFontCreateWithName((CFStringRef)self.font.fontName, self.font.pointSize, NULL);
                CGContextSetLineWidth(c, 2.0f); // CTFontGetUnderlineThickness(font));
                CGFloat y = roundf(runBounds.origin.y + runBounds.size.height / 2.0f) - 1.0f;
                CGContextMoveToPoint(c, runBounds.origin.x, y);
                CGContextAddLineToPoint(c, runBounds.origin.x + runBounds.size.width, y);
                
                CGContextStrokePath(c);
            }
        }
        
        lineIndex++;
    }
}

@end
