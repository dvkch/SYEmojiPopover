//
//  SYEmojiPopover.h
//  SYEmojiPopoverExample
//
//  Created by rominet on 11/29/12.
//  Copyright (c) 2012 Syan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYGalleryDelegates.h"

@class PopoverView;
@class SYGalleryThumbView;

@interface SYEmojiPopover : UIView
<SYGalleryDataSource,
SYGalleryThumbViewActions>
{
@private
    SYGalleryThumbView *_thumbView;
    NSArray *_characters;
    PopoverView *_popover;
}

-(void)showFromPoint:(CGPoint)point inView:(UIView*)view;

@end
