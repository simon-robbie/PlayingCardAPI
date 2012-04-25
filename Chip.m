//
//  Chip.m
//  Texas Holdem
//
//  Created by Simon Robbie on 8/26/11.
//  Copyright 2012 Simon Robbie. All rights reserved.
//

#import "Chip.h"

#import <CoreText/CoreText.h>
#import <QuartzCore/QuartzCore.h>

#import <math.h>

@interface Pile (Private)

+ (CGRect) glyphBoundingBoxForCGFont:(CGFontRef)cgFont
                            withSize:(CGFloat)fontSize
                              glyphs:(CGGlyph *)glyphs
                          glyphCount:(NSUInteger)glyphCount;

@end

@implementation Pile

@synthesize chip;
@synthesize count;

- (id)init
{
    self = [super init];
    
    if (self != nil) {
    }
    
    return self;
}

- (id) initWithChip:(Chip)chipType count:(NSUInteger)chipCount
{
    self = [self init];
    
    if (self != nil) {
        chip = chipType;
        count = chipCount;
    }
    
    return self;
}

- (void) addChipCount:(NSUInteger)chipCount
{
    count += chipCount;
}

- (void) removeChipCount:(NSUInteger)chipCount
{
    count -= chipCount;
}

- (NSUInteger) value
{
    const NSUInteger chipValue = self.chipValue;
    const NSUInteger value = (count * chipValue);
    
    return value;
}

+ (Pile *) pileWithChip:(Chip)chip count:(NSUInteger)count
{
    Pile *pile = [[[self class] alloc] initWithChip:chip count:count];
    
    return [pile autorelease];
}

+ (NSMutableArray *) defaultPilesOfChips
{
    NSMutableArray *piles = [[NSMutableArray alloc] init];
    
    [piles addObject:[Pile pileWithChip:kDollarChip count:9]];
    [piles addObject:[Pile pileWithChip:kTwentyFiveDollarChip count:5]];
    [piles addObject:[Pile pileWithChip:kFiveDollarChip count:2]];
    
    return [piles autorelease];
}

- (void) drawSymbolAtIndex:(NSInteger)index chipScale:(CGFloat)chipScale borderWidth:(CGFloat)borderWidth midY:(CGFloat)midY inContext:(CGContextRef)ctx
{
    NSString *fontName = @"ZapfDingbatsITC";
    const CGFloat symbolFontSize = (20.0f * chipScale);
    CGContextSetTextMatrix(ctx, CGAffineTransformMakeScale(1.0f, -1.0f));
    
    CGContextSelectFont(ctx, "ZapfDingbatsITC", symbolFontSize, kCGEncodingMacRoman);
    
    const UniChar kBlackSpadeSuit = 0x2660;
    const UniChar kBlackClubSuit = 0x2663;
    const UniChar kBlackHeartSuit = 0x2665;
    const UniChar kBlackDiamondSuit = 0x2666;
    
    const UniChar suites[4] = { kBlackSpadeSuit, kBlackClubSuit, kBlackHeartSuit, kBlackDiamondSuit };
    
    CGFontRef cgFont = CGFontCreateWithFontName((CFStringRef)fontName);
    CTFontRef ctFont = CTFontCreateWithName((CFStringRef)fontName, symbolFontSize, NULL);
    CTFontRef ctSymbolFont = CTFontCreateWithName((CFStringRef)fontName, symbolFontSize, NULL);
    
    CGGlyph symbolGlyphs[4] = { CGGlyphMin, CGGlyphMin, CGGlyphMin, CGGlyphMin };
    
    CTFontGetGlyphsForCharacters(ctSymbolFont, suites, symbolGlyphs, 4);
    
    const CGRect symbolBox = [[self class] glyphBoundingBoxForCGFont:cgFont
                                                            withSize:symbolFontSize
                                                              glyphs:symbolGlyphs + (index % 4)
                                                          glyphCount:1];
    
    const CGSize symbolAdjust = CGSizeMake(CGRectGetMinX(symbolBox) + CGRectGetWidth(symbolBox) * 0.5f,
                                           CGRectGetMinY(symbolBox) - CGRectGetHeight(symbolBox) * 0.5f);
        
    CGContextSetFont(ctx, cgFont);
    CGContextSetFontSize(ctx, symbolFontSize);
    CGContextSetTextPosition(ctx,
                             -symbolAdjust.width,
                             -(midY - symbolAdjust.height - borderWidth));
    
    CGContextShowGlyphs(ctx, symbolGlyphs + (index % 4), 1);
    
    CFRelease(ctFont);
    CFRelease(ctSymbolFont);
    CGFontRelease(cgFont);
}

- (UIImage *) imageWithScale:(CGFloat)scale
{
    const BOOL isPhone = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone);
    const CGFloat chipScale = (isPhone ? 0.45f : 1.0f) * scale;
    const CGRect rect = CGRectMake(0.0f, 0.0f, 39.0f * 0.05f * 72.0f * chipScale, 39.0f * 0.05f * 72.0f * chipScale);
    const CGSize size = rect.size;
    const CGFloat width = size.width;
    const CGFloat midX = size.width * 0.5f;
    const CGFloat midY = size.height * 0.5f;
    const CGFloat chipOffset = width * 0.08f;
    const BOOL opaque = NO;
    const CGFloat blur = 1.0f;
    const CGFloat contentScaleFactor = [UIScreen mainScreen].scale;

    UIGraphicsBeginImageContextWithOptions(CGSizeMake(size.width + blur * 2.0f, size.height + blur * 2.0f + chipOffset * count), opaque, contentScaleFactor);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    for (NSUInteger index = 0; index < count; index++) {
        CGContextSaveGState(ctx);
        CGContextTranslateCTM(ctx, blur, blur + index * chipOffset);
        CGContextSetShadow(ctx, CGSizeZero, blur);
        
        UIColor *chipColor = self.color;
        
        CGContextSetFillColorWithColor(ctx, chipColor.CGColor);
        
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithOvalInRect:rect];
        
        CGContextAddPath(ctx, bezierPath.CGPath);
        CGContextFillPath(ctx);
        CGContextSetShadow(ctx, CGSizeZero, 0);
        
        CGContextAddPath(ctx, bezierPath.CGPath);
        CGContextClip(ctx);
        
        const CGFloat borderWidth = width / 6.0f;
        const CGRect innerRect = CGRectInset(rect, borderWidth, borderWidth);
        
        CGContextSetLineWidth(ctx, width * 0.03f);
        
        UIColor *darkColor = (self.chip == kDollarChip ? [UIColor colorWithWhite:0.9f alpha:0.2f] : [UIColor colorWithWhite:0.1f alpha:0.2f]);
        
        CGContextSetStrokeColorWithColor(ctx, darkColor.CGColor);
        
        bezierPath = [UIBezierPath bezierPathWithOvalInRect:innerRect];
        
        CGContextAddPath(ctx, bezierPath.CGPath);
        CGContextStrokePath(ctx);

        UIColor *detailColor = (self.chip == kDollarChip ? [UIColor blackColor] : [UIColor whiteColor]);
        
        CGContextSetStrokeColorWithColor(ctx, detailColor.CGColor);
        
        const CGFloat lengths[] = { width * 0.1f, width * 0.075f };
        
        CGContextSetLineDash(ctx, width * 0.05f, lengths, 2);
        bezierPath = [UIBezierPath bezierPathWithOvalInRect:innerRect];
        
        CGContextAddPath(ctx, bezierPath.CGPath);
        CGContextStrokePath(ctx);
        
        CGContextSetFillColorWithColor(ctx, detailColor.CGColor);
        CGContextTranslateCTM(ctx, midX, midY);
        
        CGContextRotateCTM(ctx, M_PI / 8 + index * M_PI * (arc4random() % 101) * M_PI * 0.02f);
        
        for (NSInteger index = 0; index < 8; index++) {
            const CGRect topRect = CGRectMake(midX - 2.0f * borderWidth / 3.0f, -borderWidth / 4, borderWidth, borderWidth / 2);
            
            bezierPath = [UIBezierPath bezierPathWithRect:topRect];
            CGContextRotateCTM(ctx, M_PI / 8);
            CGContextAddPath(ctx, bezierPath.CGPath);
            CGContextFillPath(ctx);
            CGContextRotateCTM(ctx, M_PI / 8);
            [self drawSymbolAtIndex:index chipScale:chipScale borderWidth:borderWidth midY:midY inContext:ctx];
        }
        
        CGContextRestoreGState(ctx);
    }
    
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

- (NSUInteger) chipValue
{
    const NSUInteger values[] = { 1, 2, 5, 10, 20, 25, 50, 100, 250, 500, 1000, 2000, 5000 };
    const NSUInteger value = values[(NSUInteger)chip];
    
    return value;
}

- (UIColor *) color
{
    NSArray *colors = [NSArray arrayWithObjects:
                       self.whiteColor,
                       self.yellowColor,
                       self.redColor,
                       self.blueColor,
                       self.grayColor,
                       self.greenColor,
                       self.orangeColor,
                       self.blackColor,
                       self.pinkColor,
                       self.purpleColor,
                       self.burgundyColor,
                       self.lightBlueColor,
                       self.brownColor,
                       nil];
    
    UIColor *color = [colors objectAtIndex:(NSUInteger)chip];
    
    return color;
}

@end

@implementation PileManager

+ (NSUInteger) valueForPiles:(NSArray *)pilesOfChips
{
    NSUInteger value = 0;
    
    for (Pile *pile in pilesOfChips) {
        value += pile.value;
    }
    
    return value;
}

+ (NSArray *) pileAfterPile:(NSArray *)pilesOfChips withValueRemoved:(NSUInteger)value;
{
    NSLog(@"TODO");
    Pile *pile = [pilesOfChips objectAtIndex:0];
    pile.count -= value / pile.chipValue;
    
    return pilesOfChips;
}

@end

@implementation Pile (Private)

+ (CGRect) glyphBoundingBoxForCGFont:(CGFontRef)cgFont
                            withSize:(CGFloat)fontSize
                              glyphs:(CGGlyph *)glyphs
                          glyphCount:(NSUInteger)glyphCount
{
    CGRect boxes[2] = { CGRectZero, CGRectZero };
    
    CGFontGetGlyphBBoxes(cgFont, glyphs, glyphCount, boxes);
    
    const int unitsPerEm = CGFontGetUnitsPerEm(cgFont);
    CGRect box = boxes[0];
    
    if (glyphCount > 1) {
        const CGRect box2 = boxes[1];
        
        box.size.width += box2.origin.x + box2.size.width;
        box.size.height = MAX(box.size.height, box2.size.height);
    }
    
    box = CGRectMake(box.origin.x * fontSize / unitsPerEm,
                     box.origin.y * fontSize / unitsPerEm,
                     box.size.width * fontSize / unitsPerEm,
                     box.size.height * fontSize / unitsPerEm);
    
    return box;
}

@end
