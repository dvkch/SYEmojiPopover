//
//  SYViewController.m
//  SYEmojiPopoverExample
//
//  Created by rominet on 11/29/12.
//  Copyright (c) 2012 Syan. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "SYViewController.h"
#import "SYEmojiPopover.h"
#import "SYEmojiCharacters.h"

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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    for (UIView *v in @[self.labelEmoji, self.buttonEmoji]) {
        [v setBackgroundColor:[UIColor whiteColor]];
        [v.layer setCornerRadius:5.f];
        [v.layer setShadowColor:[UIColor darkGrayColor].CGColor];
        [v.layer setShadowOpacity:0.3f];
        [v.layer setShadowRadius:2];
        [v.layer setShadowOffset:CGSizeMake(0, 0)];
        [v.layer setMasksToBounds:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions
- (IBAction)selectEmojiClick:(id)sender {
    if(!self->_emojiPopover)
        self->_emojiPopover = [[SYEmojiPopover alloc] init];
    
    [self->_emojiPopover setDelegate:self];
    CGPoint p = self.buttonEmoji.center;
    p.y += self.buttonEmoji.frame.size.height / 2.f;
    [self->_emojiPopover showFromPoint:p inView:self.view withTitle:@"Click on a character to see it in big"];
}

#pragma mark - SYEmojiPopoverDelegate methods

-(void)emojiPopover:(SYEmojiPopover *)emojiPopover didClickedOnCharacter:(NSString *)character
{
    [self.labelEmoji setFont:[UIFont fontWithName:@"AppleColorEmoji" size:100.f]];
    [self.labelEmoji setText:character];
}


- (void)viewDidUnload {
    [self setButtonEmoji:nil];
    [self setLabelEmoji:nil];
    [super viewDidUnload];
}
@end
