//
//  SYEmojiPopover.h
//  SYEmojiPopoverExample
//
//  Created by rominet on 11/29/12.
//  Copyright (c) 2012 Syan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PopoverView;
@class SYEmojiPopover;

@protocol SYEmojiPopoverDelegate <NSObject>
@required
-(void)emojiPopover:(SYEmojiPopover*)emojiPopover didClickedOnCharacter:(NSString*)character;
@end

@interface SYEmojiPopover : UIView
<UITableViewDataSource,
UITableViewDelegate,
UIScrollViewDelegate>
{
@private
    UIView *_mainView;
    UIPageControl *_pageControl;
    UIScrollView *_scrollView;
    NSMutableArray *_tableViews;
    PopoverView *_popover;
}

@property (weak, atomic) id<SYEmojiPopoverDelegate> delegate;

-(void)showFromPoint:(CGPoint)point inView:(UIView*)view withTitle:(NSString*)title;
-(void)moveToPoint:(CGPoint)point inView:(UIView*)view withDuration:(NSTimeInterval)duration;

@end

