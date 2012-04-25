//
//  Chip.h
//  Texas Holdem
//
//  Created by Simon Robbie on 8/26/11.
//  Copyright 2012 Simon Robbie. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kDollarChip,
    kTwoDollarChip,
    kFiveDollarChip,
    kTenDollarChip,
    kTwentyDollarChip,
    kTwentyFiveDollarChip,
    kFiftyDollarChip,
    kHundredDollarChip,
    kTwoHundredAndFiftyDollarChip,
    kFiveHundredDollarChip,
    kThousandDollarChip,
    kTwoThousandDollarChip,
    kFiveThousandDollarChip
} Chip;

@interface Pile : NSObject
{
    Chip chip;
    NSUInteger count;
}

- (id) initWithChip:(Chip)chipType count:(NSUInteger)chipCount;
- (void) addChipCount:(NSUInteger)count;
- (void) removeChipCount:(NSUInteger)count;
- (NSUInteger) value;
- (NSUInteger) chipValue;

+ (Pile *) pileWithChip:(Chip)chip count:(NSUInteger)count;
+ (NSMutableArray *) defaultPilesOfChips;

@property(nonatomic,readonly) UIColor *color;
@property(nonatomic,assign) Chip chip;
@property(nonatomic,assign) NSUInteger count;

@end

@interface PileManager

+ (NSUInteger) valueForPiles:(NSArray *)pilesOfChips;

+ (NSArray *) pileAfterPile:(NSArray *)pilesOfChips withValueRemoved:(NSUInteger)value;

@end
