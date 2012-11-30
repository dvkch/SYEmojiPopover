//
//  SYEmojiPopover.m
//  SYEmojiPopoverExample
//
//  Created by rominet on 11/29/12.
//  Copyright (c) 2012 Syan. All rights reserved.
//

#import "SYEmojiPopover.h"
#import "GMGridView.h"
#import "PopoverView.h"

#define EMOJI_RUNNING_IPHONE        ( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone )
#define EMOJI_ITEM_SIZE             ( EMOJI_RUNNING_IPHONE ? 33.f : 45.f )
#define EMOJI_FONT_SIZE             ( EMOJI_RUNNING_IPHONE ? 29.f : 39.f )
#define EMOJI_NB_ITEM_IN_ROW        ( EMOJI_RUNNING_IPHONE ? 8 : 8 )
#define EMOJI_NB_ITEM_IN_COL        ( EMOJI_RUNNING_IPHONE ? 5 : 5 )
#define EMOJI_GRID_MARGIN           ( EMOJI_RUNNING_IPHONE ? 1.f : 2.f )
#define EMOJI_GRID_DEFAULT_WIDTH    ( EMOJI_ITEM_SIZE * EMOJI_NB_ITEM_IN_ROW + EMOJI_GRID_MARGIN * 2.f )
#define EMOJI_GRID_DEFAULT_HEIGHT   ( EMOJI_ITEM_SIZE * EMOJI_NB_ITEM_IN_COL + EMOJI_GRID_MARGIN * 2.f )

@interface SYEmojiPopover (Private)
-(void)loadView;
@end

@implementation SYEmojiPopover

@synthesize delegate = _delegate;

#pragma mark - Initialization
- (id)init
{ if (self = [super init]) { [self loadView]; } return self; }

- (id)initWithFrame:(CGRect)frame
{ if (self = [super initWithFrame:frame]) { [self loadView]; } return self; }

- (id)initWithCoder:(NSCoder *)aDecoder
{ if (self = [super initWithCoder:aDecoder]) { [self loadView]; } return self; }


#pragma mark - Private methods
-(void)loadView {
    if (!self->_characters) {
        self->_characters = @[
        @"😄", @"😃", @"😀", @"😊",
        @"☺", @"😉", @"😍", @"😘",
        @"😚", @"😗", @"😙", @"😜",
        @"😝", @"😛", @"😳", @"😁",
        @"😔", @"😌", @"😒", @"😞",
        @"😣", @"😢", @"😂", @"😭",
        @"😪", @"😥", @"😰", @"😅",
        @"😓", @"😩", @"😫", @"😨",
        @"😱", @"😠", @"😡", @"😤",
        @"😖", @"😆", @"😋", @"😷",
        @"😎", @"😴", @"😵", @"😲",
        @"😟", @"😦", @"😧", @"😈",
        @"👿", @"😮", @"😬", @"😐", 
        @"😕", @"😯", @"😶", @"😇", 
        @"😏", @"😑"];
    }
}

#pragma mark - View methods

-(void)showFromPoint:(CGPoint)point inView:(UIView *)view {
    
    [self showFromPoint:point
                 inView:view
               withSize:CGSizeMake(EMOJI_GRID_DEFAULT_WIDTH, EMOJI_GRID_DEFAULT_HEIGHT)];
}

-(void)showFromPoint:(CGPoint)point inView:(UIView*)view withSize:(CGSize)size {
    
    if(!self->_gridView)
        self->_gridView = [[GMGridView alloc] initWithFrame:CGRectMake(0.f, 0.f, size.width, size.height)];
    
    self->_gridView.autoresizingMask = UIViewAutoresizingNone;
    self->_gridView.backgroundColor = [UIColor clearColor];
    
    self->_gridView.style = GMGridViewStyleSwap;
    self->_gridView.itemSpacing = 0.f;
    self->_gridView.minEdgeInsets = UIEdgeInsetsMake(EMOJI_GRID_MARGIN, EMOJI_GRID_MARGIN,
                                                     EMOJI_GRID_MARGIN, EMOJI_GRID_MARGIN);
    self->_gridView.centerGrid = NO;
    self->_gridView.showsVerticalScrollIndicator = YES;
    self->_gridView.showsHorizontalScrollIndicator = NO;
    self->_gridView.alwaysBounceVertical = YES;
    self->_gridView.clipsToBounds = YES;
    
    // so that cells cannot be moved
    self->_gridView.enableEditOnLongPress = NO;
    self->_gridView.sortingDelegate = nil;
    
    self->_gridView.actionDelegate = self;
    self->_gridView.dataSource = self;
    
    [self->_gridView reloadData];
    
    [self->_popover setAutoresizingMask:view.autoresizingMask];
    self->_popover = [PopoverView showPopoverAtPoint:point
                                              inView:view
                                           withTitle:@"Emoji selection"
                                     withContentView:self->_gridView
                                            delegate:nil];
}

-(void)moveToPoint:(CGPoint)point inView:(UIView*)view withDuration:(NSTimeInterval)duration {

    if(!self->_popover)
        return;
    
    [self->_popover animateRotationToNewPoint:point
                                       inView:view
                                 withDuration:duration];
}

#pragma mark - SYGalleryDataSource methods
- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView
{
    return [self->_characters count];
}

- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    return CGSizeMake(EMOJI_ITEM_SIZE, EMOJI_ITEM_SIZE);
}

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index
{
    NSString *text = (index < 0 || index >= [self->_characters count]) ? @"" : [self->_characters objectAtIndex:index];
    
    NSString *cellIdentifier = @"cellEmoji";
    GMGridViewCell *cell = [gridView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell)
        cell = [[GMGridViewCell alloc] init];
    
    [cell setReuseIdentifier:cellIdentifier];
    
    UITextField *textView = (UITextField*)cell.contentView;
    if(!textView)
        textView = [[UITextField alloc] initWithFrame:cell.bounds];
    
    [textView setText:text];
    [textView setFont:[UIFont fontWithName:@"AppleColorEmoji" size:EMOJI_FONT_SIZE]];
    [textView setBackgroundColor:[UIColor clearColor]];
    [textView setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    [textView setTextAlignment:NSTextAlignmentCenter];
    [textView setUserInteractionEnabled:NO];
    
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell setContentView:textView];
    
    return cell;
}

- (BOOL)GMGridView:(GMGridView *)gridView canDeleteItemAtIndex:(NSInteger)index
{
    return NO;
}

#pragma mark - GMGridViewActionDelegate methods
- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position
{
    if(position < 0 || position >= [self->_characters count])
        return;
    
    if([self.delegate respondsToSelector:@selector(emojiPopover:didClickedOnCharacter:)])
        [self.delegate emojiPopover:self didClickedOnCharacter:[self->_characters objectAtIndex:position]];
    
    [self->_popover dismiss];
}

@end
