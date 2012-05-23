//
//  Blind.h
//  Text Holdem
//
//  Created by Simon Robbie on 5/22/12.
//  Copyright (c) 2012 Simon Robbie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Blind : NSObject
{
    BOOL little;
    NSUInteger value;
}

- (id) initIsLittle:(BOOL)isLittle value:(NSUInteger)value;

@property(nonatomic,readonly,getter=isLittle) BOOL little;
@property(nonatomic,readonly) NSUInteger value;

@end
