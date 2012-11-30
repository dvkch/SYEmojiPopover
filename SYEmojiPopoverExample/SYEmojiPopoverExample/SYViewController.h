//
//  SYViewController.h
//  SYEmojiPopoverExample
//
//  Created by rominet on 11/29/12.
//  Copyright (c) 2012 Syan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYEmojiPopover.h"

@interface SYViewController : UIViewController <SYEmojiPopoverDelegate> {
@private
    SYEmojiPopover *_emojiPopover;
}

@property (weak, nonatomic) IBOutlet UILabel *labelEmoji;
@property (weak, nonatomic) IBOutlet UIButton *buttonEmoji;

@end
