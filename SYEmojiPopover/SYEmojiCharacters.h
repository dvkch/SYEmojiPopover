//
//  SYEmojiCharacters.h
//  SYEmojiPopoverExample
//
//  Created by rominet on 12/6/12.
//  Copyright (c) 2012 Syan. All rights reserved.
//

#import <UIKit/UIKit.h>

// thanks to yasirmturk : http://stackoverflow.com/questions/3339722/check-iphone-ios-version/5337804#5337804
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


@interface SYEmojiCharacters : NSObject {
@private
    NSMutableArray *_characters;
}

+(SYEmojiCharacters*)sharedCharacters;

-(BOOL)isCharacterEmoji:(NSString *)string;

-(NSUInteger)numberOfSections;
-(NSUInteger)numberOfRowsInSection:(NSUInteger)section;
-(NSString*)emojiAtRow:(NSUInteger)row andSection:(NSUInteger)section;

@end
