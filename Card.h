/*
 
 Card.h

 Copyright (c) 2012 Simon Robbie
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

*/

typedef enum
{
    kSpades,
    kClubs,
    kHearts,
    kDiamonds,
	kSuiteCount
} Suit;

typedef enum
{
    kAceCard = 1,
    kTwoCard = 2,
    kThreeCard = 3,
    kFourCard = 4,
    kFiveCard = 5,
    kSixCard = 6,
    kSevenCard = 7,
    kEightCard = 8,
    kNineCard = 9,
    kTenCard = 10,
    kJackCard = 11,
    kQueenCard = 12,
    kKingCard = 13,
	kCardsInSuiteCount = 13
} CardName;

@interface Card : NSObject
{
    Suit suit;
    CardName name;
    BOOL isFaceUp;
}

+ (Card *) cardWithSuit:(Suit)cardSuit name:(CardName)cardName;

- (UIImage *) imageWithScale:(CGFloat)scale;

@property(nonatomic,assign) Suit suit;
@property(nonatomic,assign) CardName name;
@property(nonatomic,readonly) NSString *description;
@property(nonatomic,readonly) BOOL isPictureCard;
@property(nonatomic,assign) BOOL isFaceUp;

@end
