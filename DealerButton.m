//
//  DealerButton.m
//  Text Holdem
//
//  Created by Simon Robbie on 5/22/12.
//  Copyright (c) 2012 Simon Robbie. All rights reserved.
//

#import "DealerButton.h"

#import <CoreText/CoreText.h>
#import <QuartzCore/QuartzCore.h>

#import <math.h>

@interface DealerButton (Private)

+ (CGRect) glyphBoundingBoxForCGFont:(CGFontRef)cgFont
                            withSize:(CGFloat)fontSize
                              glyphs:(CGGlyph *)glyphs
                          glyphCount:(NSUInteger)glyphCount;

@end

@implementation DealerButton

- (id)init
{
    self = [super init];
    
    if (self != nil) {
    }
    
    return self;
}

- (UIImage *) imageWithScale:(CGFloat)scale
{
    const BOOL isPhone = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone);
    const CGFloat buttonScale = (isPhone ? 0.45f : 1.0f) * scale;
    const CGRect rect = CGRectMake(0.0f, 0.0f, 60.0f * 0.05f * 72.0f * buttonScale, 60.0f * 0.05f * 72.0f * buttonScale);
    const CGSize size = rect.size;
    const CGFloat width = size.width;
    const CGFloat midX = size.width * 0.5f;
    const CGFloat midY = size.height * 0.5f;
    const CGFloat buttonOffset = width * 0.12f;
    const BOOL opaque = NO;
    const CGFloat blur = 1.0f;
    const CGFloat contentScaleFactor = [UIScreen mainScreen].scale;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(size.width + blur * 2.0f, size.height + blur * 2.0f + buttonOffset), opaque, contentScaleFactor);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(ctx);
    CGContextTranslateCTM(ctx, blur, blur);
    CGContextSetShadow(ctx, CGSizeZero, blur);
    
    UIColor *buttonColor = self.color;
    
    CGContextSetFillColorWithColor(ctx, buttonColor.CGColor);
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithOvalInRect:rect];
    
    CGContextAddPath(ctx, bezierPath.CGPath);
    CGContextFillPath(ctx);
    CGContextSetShadow(ctx, CGSizeZero, 0);
    
    CGContextAddPath(ctx, bezierPath.CGPath);
    CGContextClip(ctx);
    
    const CGFloat borderWidth = width / 6.0f;
    
    CGContextSetLineWidth(ctx, width * 0.03f);
    
    UIColor *detailColor = [UIColor blackColor];

    CGContextSetFillColorWithColor(ctx, detailColor.CGColor);

    NSString *fontName = @"Arial";
    const CGFloat fontSize = (40.0f * buttonScale);
    CGContextSetTextMatrix(ctx, CGAffineTransformMakeScale(1.0f, -1.0f));
    
    CGContextSelectFont(ctx, "Arial", fontSize, kCGEncodingMacRoman);
    const NSUInteger charCount = 6;
    const UniChar label[charCount] = { 'D', 'E', 'A', 'L', 'E', 'R' };
    
    CGFontRef cgFont = CGFontCreateWithFontName((CFStringRef)fontName);
    CTFontRef ctFont = CTFontCreateWithName((CFStringRef)fontName, fontSize, NULL);
    
    CGGlyph glyphs[charCount] = { CGGlyphMin, CGGlyphMin, CGGlyphMin, CGGlyphMin };
    
    CTFontGetGlyphsForCharacters(ctFont, label, glyphs, charCount);
    
    const CGRect box = [[self class] glyphBoundingBoxForCGFont:cgFont
                                                      withSize:fontSize
                                                        glyphs:glyphs
                                                    glyphCount:charCount];
    
    const CGSize adjust = CGSizeMake(CGRectGetMinX(box) + CGRectGetWidth(box) * 0.5f,
                                     CGRectGetMinY(box) - CGRectGetHeight(box) * 0.5f);
    
    CGContextSetFont(ctx, cgFont);
    CGContextSetFontSize(ctx, fontSize);
    CGContextSetTextPosition(ctx,
                             midX - adjust.width,
                             midY - adjust.height);
    
    CGContextShowGlyphs(ctx, glyphs, charCount);
    
    CFRelease(ctFont);
    CGFontRelease(cgFont);
    
    CGContextRestoreGState(ctx);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIColor *) whiteColor
{
    return [UIColor whiteColor];
}

- (UIColor *) yellowColor
{
    return [UIColor colorWithRed:233.0f / 255.0f green:202.0f / 255.0f blue:0.0f / 255.0f alpha:1.0f];
}

- (UIColor *) redColor
{
    return [UIColor colorWithRed:197.0f / 255.0f green:22.0f / 255.0f blue:29.0f / 255.0f alpha:1.0f];
}

- (UIColor *) blueColor
{
    return [UIColor colorWithRed:74.0f / 255.0f green:94.0f / 255.0f blue:204.0f / 255.0f alpha:1.0f];
}

- (UIColor *) grayColor
{
    return [UIColor grayColor];
}

- (UIColor *) greenColor
{
    return [UIColor colorWithRed:77.0f / 255.0f green:183.0f / 255.0f blue:72.0f / 255.0f alpha:1.0f];
}

- (UIColor *) orangeColor
{
    return [UIColor colorWithRed:252.0f / 255.0f green:114.0f / 255.0f blue:70.0f / 255.0f alpha:1.0f];
}

- (UIColor *) blackColor
{
    return [UIColor blackColor];
}

- (UIColor *) pinkColor
{
    return [UIColor colorWithRed:254.0f / 255.0f green:163.0f / 255.0f blue:187.0f / 255.0f alpha:1.0f];
}

- (UIColor *) purpleColor
{
    return [UIColor colorWithRed:70.0f / 255.0f green:61.0f / 255.0f blue:116.0f / 255.0f alpha:1.0f];
}
- (UIColor *) burgundyColor
{
    return [UIColor colorWithRed:86.0f / 255.0f green:12.0f / 255.0f blue:35.0f / 255.0f alpha:1.0f];
}

- (UIColor *) lightBlueColor
{
    return [UIColor colorWithRed:87.0f / 255.0f green:202.0f / 255.0f blue:246.0f / 255.0f alpha:1.0f];
}

- (UIColor *) brownColor
{
    return [UIColor colorWithRed:165.0f / 255.0f green:132.0f / 255.0f blue:125.0f / 255.0f alpha:1.0f];
}

- (UIColor *) color
{
    return self.whiteColor;
}

@end

@implementation DealerButton (Private)

+ (CGRect) glyphBoundingBoxForCGFont:(CGFontRef)cgFont
                            withSize:(CGFloat)fontSize
                              glyphs:(CGGlyph *)glyphs
                          glyphCount:(NSUInteger)glyphCount
{
    CGRect *boxes = calloc(glyphCount, sizeof(CGRect));
    int *advances = calloc(glyphCount, sizeof(int));
    
    CGFontGetGlyphBBoxes(cgFont, glyphs, glyphCount, boxes);
    CGFontGetGlyphAdvances(cgFont, glyphs, glyphCount, advances);
    
    CGRect box = boxes[0];
    CGFloat minX = 0;
    CGFloat minY = 0;
    CGFloat maxX = CGFLOAT_MIN;
    CGFloat maxY = CGFLOAT_MIN;
    int advance = 0;
    
    for (NSUInteger i = 0; i < glyphCount; i++) {
        CGRect nextBox = boxes[i];
        
        nextBox.origin.x = advance;
        
        CGFloat nextMinX = CGRectGetMinX(nextBox);
        CGFloat nextMinY = CGRectGetMinY(nextBox);
        CGFloat nextMaxX = CGRectGetMaxX(nextBox);
        CGFloat nextMaxY = CGRectGetMaxY(nextBox);
        
        if (minX > nextMinX) {
            minX = nextMinX;
        }
        
        if (minY > nextMinY) {
            minY = nextMinY;
        }
        
        if (maxX < nextMaxX) {
            maxX = nextMaxX;
        }
        
        if (maxY < nextMaxY) {
            maxY = nextMaxY;
        }

        advance += advances[i];
    }
    
    const int unitsPerEm = CGFontGetUnitsPerEm(cgFont);

    box = CGRectMake(minX * fontSize / unitsPerEm,
                     minY * fontSize / unitsPerEm,
                     (maxX - minX) * fontSize / unitsPerEm,
                     (maxY - minY) * fontSize / unitsPerEm);

    return box;
}

@end
