//
//  SYEmojiPopover.h
//  SYEmojiPopoverExample
//
//  Created by rominet on 11/29/12.
//  Copyright (c) 2012 Syan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMGridView.h"

@class PopoverView;
@class SYEmojiPopover;

@protocol SYEmojiPopoverDelegate <NSObject>
@required
-(void)emojiPopover:(SYEmojiPopover*)emojiPopover didClickedOnCharacter:(NSString*)character;
@end

@interface SYEmojiPopover : UIView
<GMGridViewActionDelegate,
GMGridViewDataSource>
{
@private
    GMGridView *_gridView;
    NSArray *_characters;
    PopoverView *_popover;
}

@property (weak, atomic) id<SYEmojiPopoverDelegate> delegate;

-(void)showFromPoint:(CGPoint)point inView:(UIView*)view;
-(void)showFromPoint:(CGPoint)point inView:(UIView*)view withSize:(CGSize)size;

-(void)moveToPoint:(CGPoint)point inView:(UIView*)view withDuration:(NSTimeInterval)duration;

@end
