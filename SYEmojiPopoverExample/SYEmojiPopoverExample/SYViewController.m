//
//  SYViewController.m
//  SYEmojiPopoverExample
//
//  Created by rominet on 11/29/12.
//  Copyright (c) 2012 Syan. All rights reserved.
//

#import "SYViewController.h"
#import "SYEmojiPopover.h"

@implementation SYViewController

#pragma mark - Rotation support
-(BOOL)shouldAutorotate
{
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

#pragma mark - View Lifecycle
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration
{
    if(self->_emojiPopover)
    {
        [self->_emojiPopover moveToPoint:self.buttonEmoji.center
                                  inView:self.view
                            withDuration:duration];
    }
}

#pragma mark - IBActions
- (IBAction)selectEmojiClick:(id)sender {
    
    self->_emojiPopover = [[SYEmojiPopover alloc] init];
    
    [self->_emojiPopover setDelegate:self];
    [self->_emojiPopover showFromPoint:self.buttonEmoji.center inView:self.view];
}

#pragma mark - SYEmojiPopoverDelegate methods
-(void)emojiPopover:(SYEmojiPopover *)emojiPopover didClickedOnCharacter:(NSString *)character
{
    [self.labelEmoji setFont:[UIFont fontWithName:@"AppleColorEmoji" size:100.f]];
    [self.labelEmoji setText:character];
}


- (void)viewDidUnload {
    [self setButtonEmoji:nil];
    [super viewDidUnload];
}
@end
