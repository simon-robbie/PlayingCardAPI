/*
 
 Card.m
 
 Copyright (c) 2012 Simon Robbie
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */


#import "Card.h"
#import <CoreText/CoreText.h>
#import <QuartzCore/QuartzCore.h>

@interface Card (Private)

+ (CGRect) glyphBoundingBoxForCGFont:(CGFontRef)cgFont
                            withSize:(CGFloat)fontSize
                              glyphs:(CGGlyph *)glyph
                          glyphCount:(NSUInteger)glyphCount;

- (id) initWithCardSuit:(Suit)cardSuit cardName:(CardName)cardName;

- (UIImage *) pictureImage;

@end

@implementation Card

@synthesize suit;
@synthesize name;
@synthesize isFaceUp;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (BOOL) isPictureCard
{
    const BOOL isPictureCard = (name > (NSUInteger)kTenCard);
    
    return isPictureCard;
}

- (NSString *) description
{
    NSArray *cardDescriptions = [NSArray arrayWithObjects:
                                 @"Ace",
                                 @"Two",
                                 @"Three",
                                 @"Four",
                                 @"Five",
                                 @"Six",
                                 @"Seven",
                                 @"Eight",
                                 @"Nine",
                                 @"Ten",
                                 @"Jack",
                                 @"Queen",
                                 @"King",
                                 nil];

    NSString *cardDescription = [cardDescriptions objectAtIndex:name - 1];
    
    NSArray *suitDescriptions = [NSArray arrayWithObjects:
                                 @"Spade",
                                 @"Club",
                                 @"Heart",
                                 @"Diamond",
                                 nil];
    
    NSString *suiteDescription = [suitDescriptions objectAtIndex:suit];
    NSString *description = [NSString stringWithFormat:@"%@ of %@s", cardDescription, suiteDescription];
    
    return description; 
}

- (UIImage *) imageWithScale:(CGFloat)scale
{
    const BOOL isPhone = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone);
    const CGFloat cardScale = (isPhone ? 0.45f : 1.0f);
    const CGRect rect = CGRectMake(0.0f, 0.0f, 2.5f * 72.0f * cardScale, 3.5f * 72.0f * cardScale);
    const CGSize size = rect.size;

    const BOOL opaque = NO;
    const CGFloat blur = 1.0f;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(size.width + blur * 2.0f, size.height + blur * 2.0f), opaque, scale);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(ctx, blur, blur);
    CGContextSetShadow(ctx, CGSizeZero, blur);
    CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:10.0f * cardScale];
    
    CGContextAddPath(ctx, bezierPath.CGPath);
    CGContextFillPath(ctx);
    CGContextSetShadow(ctx, CGSizeZero, 0);

    CGContextAddPath(ctx, bezierPath.CGPath);
    CGContextClip(ctx);

    if (isFaceUp) {
        const BOOL isPictureCard = self.isPictureCard;

#if FORREFERENCE
        if (isPictureCard) {
            UIImage *image = [self pictureImage];
            const CGFloat height = image.size.height;
            const CGFloat width = image.size.width;
            const CGFloat scaleYPicture = (height / size.height);
            const CGFloat scaleXPicture = (width / size.width);
            const CGFloat scalePicture = MAX(scaleXPicture, scaleYPicture);
            
            CGContextScaleCTM(ctx, scalePicture, -scalePicture);
            CGContextDrawTiledImage(ctx, rect, image.CGImage);
            CGContextScaleCTM(ctx, 1/scalePicture, -1/scalePicture);
        }
#endif
        
        NSString *fontName = @"Times New Roman";
        const CGFloat valueFontSize = (24.0f * cardScale);
        const CGFloat symbolFontSize = (((name == kAceCard && suit == kSpades) ? 112.0f : 56.0f) * cardScale);
        const CGFloat midX = size.width * 0.5f;
        const CGFloat midY = size.height * 0.5f;
        CGContextSetTextMatrix(ctx, CGAffineTransformMakeScale(1.0f, -1.0f));
        
        const BOOL isBlackCard = (suit == kClubs || suit == kSpades);
        
        CGContextSetFillColorWithColor(ctx, isBlackCard ? [UIColor blackColor].CGColor : [UIColor redColor].CGColor);
        CGContextSelectFont(ctx, "Times New Roman", valueFontSize, kCGEncodingMacRoman);
        
        const UniChar kBlackSpadeSuit = 0x2660;
        const UniChar kBlackClubSuit = 0x2663;
        const UniChar kBlackHeartSuit = 0x2665;
        const UniChar kBlackDiamondSuit = 0x2666;
        
        NSArray *values = [NSArray arrayWithObjects: @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K", nil];
        const NSUInteger cardValue = (name - 1);
        NSString *value = [values objectAtIndex:cardValue];
        const size_t valueLength = value.length;
        UniChar uniChars[2] = { 0, 0 };
        CGGlyph valueGlyphs[2] = { CGGlyphMin, CGGlyphMin };
        const UniChar suites[4] = { kBlackSpadeSuit, kBlackClubSuit, kBlackHeartSuit, kBlackDiamondSuit };
        CGGlyph symbolGlyphs[1] = { CGGlyphMin };
        const NSRange range = NSMakeRange(0, valueLength);
        
        [value getCharacters:uniChars range:range];
        
        CGFontRef cgFont = CGFontCreateWithFontName((CFStringRef)fontName);
        CTFontRef ctFont = CTFontCreateWithName((CFStringRef)fontName, symbolFontSize, NULL);
        CTFontRef ctValueFont = CTFontCreateWithName((CFStringRef)fontName, valueFontSize, NULL);
        
        CTFontGetGlyphsForCharacters(ctValueFont, uniChars, valueGlyphs, valueLength);
        
        const CGRect valueBox = [[self class] glyphBoundingBoxForCGFont:cgFont
                                                               withSize:valueFontSize
                                                                 glyphs:valueGlyphs
                                                             glyphCount:valueLength];
        
        const CGSize valueAdjust = CGSizeMake(CGRectGetMinX(valueBox) + CGRectGetWidth(valueBox) * 0.5f,
                                              CGRectGetMinY(valueBox) - CGRectGetHeight(valueBox) * 0.5f);
        
        CTFontGetGlyphsForCharacters(ctFont, suites + suit, symbolGlyphs, 1);
        
        const CGRect symbolBox = [[self class] glyphBoundingBoxForCGFont:cgFont
                                                                withSize:valueFontSize
                                                                  glyphs:symbolGlyphs
                                                              glyphCount:1];
        
        const CGSize symbolAdjust = CGSizeMake(CGRectGetMinX(symbolBox) + CGRectGetWidth(symbolBox) * 0.5f,
                                               CGRectGetMinY(symbolBox) - CGRectGetHeight(symbolBox) * 0.5f);
        
        const CGRect box = [[self class] glyphBoundingBoxForCGFont:cgFont
                                                          withSize:symbolFontSize
                                                            glyphs:symbolGlyphs
                                                        glyphCount:1];
        
        const CGSize adjust = CGSizeMake(CGRectGetMinX(box) + CGRectGetWidth(box) * 0.5f,
                                         CGRectGetMinY(box) - CGRectGetHeight(box) * 0.5f);
        
        const CGFloat borderWidth = (size.width / 8.0f + MAX(CGRectGetWidth(box), CGRectGetHeight(box)) * 0.5f);
        
        CGContextSetFont(ctx, cgFont);
        CGContextSetFontSize(ctx, valueFontSize);
        CGContextSetTextPosition(ctx,
                                 borderWidth * 0.5f - valueAdjust.width,
                                 borderWidth * 0.5f - valueAdjust.height);
        
        CGContextShowGlyphs(ctx, valueGlyphs, valueLength);
        
        CGContextSetTextPosition(ctx,
                                 borderWidth * 0.5f - symbolAdjust.width,
                                 borderWidth * 0.5f + CGRectGetHeight(valueBox) - valueAdjust.height - symbolAdjust.height);
        
        CGContextShowGlyphs(ctx, symbolGlyphs, 1);
        
        CGContextSetTextPosition(ctx,
                                 size.width - borderWidth * 0.5f - valueAdjust.width,
                                 size.height - borderWidth * 0.5f - valueAdjust.height);
        
        CGContextShowGlyphs(ctx, valueGlyphs, valueLength);
        
        CGContextSetTextPosition(ctx,
                                 size.width - borderWidth * 0.5f - symbolAdjust.width,
                                 size.height - borderWidth * 0.5f - CGRectGetHeight(valueBox) + valueAdjust.height - symbolAdjust.height);
        
        CGContextShowGlyphs(ctx, symbolGlyphs, 1);
        
        CGContextSetFontSize(ctx, symbolFontSize);
        
        const CGSize symbolBorder = CGSizeMake(3.0f * borderWidth * 0.5f, borderWidth);
        const BOOL isOdd = (((name % 2) == 1) && !isPictureCard);
        
        if (isOdd) {
            if (name != kSevenCard) {
                // Center
                CGContextSetTextPosition(ctx, midX - adjust.width, midY - adjust.height);
            }
            else {
                CGContextSetTextPosition(ctx, midX - adjust.width, (symbolBorder.height + midY) * 0.5f - adjust.height);
            }
            
            CGContextShowGlyphs(ctx, symbolGlyphs, 1);
        }
        
        if (name == kTwoCard
            || name == kThreeCard) {
            
            // Middle top and middle bottom
            CGContextSetTextPosition(ctx,
                                     midX - adjust.width,
                                     symbolBorder.height - adjust.height);
            
            CGContextShowGlyphs(ctx, symbolGlyphs, 1);
            
            CGContextSetTextPosition(ctx,
                                     midX - adjust.width,
                                     size.height - symbolBorder.height - adjust.height);
            
            CGContextShowGlyphs(ctx, symbolGlyphs, 1);
        }
        
        if (name == kFourCard
            || name == kFiveCard
            || name == kSixCard
            || name == kSevenCard
            || name == kEightCard
            || name == kNineCard
            || name == kTenCard) {
            
            // Top left and bottom right
            CGContextSetTextPosition(ctx,
                                     symbolBorder.width - adjust.width,
                                     symbolBorder.height - adjust.height);
            
            CGContextShowGlyphs(ctx, symbolGlyphs, 1);
            
            CGContextSetTextPosition(ctx,
                                     size.width - symbolBorder.width - adjust.width,
                                     size.height - symbolBorder.height - adjust.height);
            
            CGContextShowGlyphs(ctx, symbolGlyphs, 1);
        }
        
        if (name == kFourCard
            || name == kFiveCard
            || name == kSixCard
            || name == kSevenCard
            || name == kEightCard
            || name == kNineCard
            || name == kTenCard
            || isPictureCard) {
            
            // Top right and bottom left        
            CGContextSetTextPosition(ctx,
                                     size.width - symbolBorder.width - adjust.width,
                                     symbolBorder.height - adjust.height);
            
            CGContextShowGlyphs(ctx, symbolGlyphs, 1);
            
            CGContextSetTextPosition(ctx,
                                     symbolBorder.width - adjust.width,
                                     size.height - symbolBorder.height - adjust.height);
            CGContextShowGlyphs(ctx, symbolGlyphs, 1);
        }
        
        if (name == kSixCard
            || name == kSevenCard
            || name == kEightCard) {
            
            // Middle left and middle right
            CGContextSetTextPosition(ctx, symbolBorder.width - adjust.width, midY - adjust.height);
            CGContextShowGlyphs(ctx, symbolGlyphs, 1);
            CGContextSetTextPosition(ctx, size.width - symbolBorder.width - adjust.width, midY - adjust.height);
            CGContextShowGlyphs(ctx, symbolGlyphs, 1);
        }
        
        if (name == kEightCard
            || name == kTenCard) {
            
            // Middle middle top and middle middle bottom
            CGContextSetTextPosition(ctx, midX - adjust.width, (symbolBorder.height + midY) * 0.5f - adjust.height);
            CGContextShowGlyphs(ctx, symbolGlyphs, 1);
            CGContextSetTextPosition(ctx, midX - adjust.width, size.height - (symbolBorder.height + midY) * 0.5f - adjust.height);
            CGContextShowGlyphs(ctx, symbolGlyphs, 1);
        }
        
        if (name == kNineCard
            || name == kTenCard) {
            
            // Middle 4
            CGContextSetTextPosition(ctx,
                                     symbolBorder.width - adjust.width,
                                     symbolBorder.height + (size.height - symbolBorder.height * 2.0f) / 3.0f - adjust.height);
            
            CGContextShowGlyphs(ctx, symbolGlyphs, 1);
            
            CGContextSetTextPosition(ctx, size.width - symbolBorder.width - adjust.width,
                                     symbolBorder.height + (size.height - symbolBorder.height * 2.0f) / 3.0f - adjust.height);
            
            CGContextShowGlyphs(ctx, symbolGlyphs, 1);
            
            CGContextSetTextPosition(ctx,
                                     symbolBorder.width - adjust.width,
                                     symbolBorder.height + 2.0f * (size.height - symbolBorder.height * 2.0f) / 3.0f - adjust.height);
            
            CGContextShowGlyphs(ctx, symbolGlyphs, 1);
            
            CGContextSetTextPosition(ctx,
                                     size.width - symbolBorder.width - adjust.width,
                                     symbolBorder.height + 2.0f * (size.height - symbolBorder.height * 2.0f) / 3.0f - adjust.height);
            
            CGContextShowGlyphs(ctx, symbolGlyphs, 1);
        }
        
        CFRelease(ctFont);
        CFRelease(ctValueFont);
        CGFontRelease(cgFont);
    }
    else {
        UIImage *image = [UIImage imageNamed:@"Tartan.png"];
        const CGFloat width = image.size.width;
        const CGFloat scalePicture = (width / size.width) / 4.0f;
        
        CGContextTranslateCTM(ctx, width * 0.5f, width * 0.5f);
        CGContextScaleCTM(ctx, scalePicture, -scalePicture);
        CGContextDrawTiledImage(ctx, rect, image.CGImage);
        CGContextScaleCTM(ctx, 1/scalePicture, -1/scalePicture);
}
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

+ (Card *) cardWithSuit:(Suit)cardSuit name:(CardName)cardName
{
    Card *card = [[[self class] alloc] initWithCardSuit:cardSuit cardName:cardName];
    
    return [card autorelease];
}

@end

@implementation Card (Private)

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

- (id) initWithCardSuit:(Suit)cardSuit cardName:(CardName)cardName
{
    self = [self init];
    
    if (self != nil) {
        self.suit = cardSuit;
        self.name = cardName;
    }
    
    return self;
}
- (UIImage *) pictureImage
{
    UIImage *image = [UIImage imageNamed:@"Tartan.png"];
    
    return image;
}

@end
