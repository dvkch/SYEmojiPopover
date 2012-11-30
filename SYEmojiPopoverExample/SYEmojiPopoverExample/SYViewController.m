//
//  SYViewController.m
//  SYEmojiPopoverExample
//
//  Created by rominet on 11/29/12.
//  Copyright (c) 2012 Syan. All rights reserved.
//

#import "SYViewController.h"
#import "SYEmojiPopover.h"

@interface SYViewController ()

@end

@implementation SYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectEmojiClick:(id)sender {
    SYEmojiPopover *pop = [[SYEmojiPopover alloc]
                           initWithFrame:CGRectMake(0.f, 0.f, 0.f, 0.f)];
    
    UIView *senderView = (UIView*)sender;
    CGPoint point = senderView.center;
    point.y = senderView.frame.origin.y + senderView.frame.size.height;
    
    [pop showFromPoint:point inView:self.view];
}

@end
