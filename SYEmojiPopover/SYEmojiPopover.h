//
//  SYEmojiPopover.h
//  SYEmojiPopoverExample
//
//  Created by rominet on 11/29/12.
//  Copyright (c) 2012 Syan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WYPopoverController;
@class SYEmojiPopover;

@protocol SYEmojiPopoverDelegate <NSObject>
@required
-(void)emojiPopover:(SYEmojiPopover*)emojiPopover didClickedOnCharacter:(NSString*)character;
@end

@interface SYEmojiPopover : UIViewController
<UITableViewDataSource,
UITableViewDelegate,
UIScrollViewDelegate>
{
@private
    UINavigationController *_navController;
    UIPageControl *_pageControl;
    UIScrollView *_scrollView;
    NSMutableArray *_tableViews;
    CGSize _preferredSize;
}

@property (weak, atomic) id<SYEmojiPopoverDelegate> delegate;
@property (strong, readonly) WYPopoverController *popover;

-(void)showFromPoint:(CGPoint)point inView:(UIView*)view withTitle:(NSString*)title;

@end

