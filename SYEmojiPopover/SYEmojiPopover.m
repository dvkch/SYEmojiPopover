//
//  SYEmojiPopover.m
//  SYEmojiPopoverExample
//
//  Created by rominet on 11/29/12.
//  Copyright (c) 2012 Syan. All rights reserved.
//

#import "SYEmojiPopover.h"
#import "SYGalleryThumbView.h"
#import "PopoverView.h"

@interface SYEmojiPopover (Private)
-(void)loadView;
@end

@implementation SYEmojiPopover

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
-(void)showFromPoint:(CGPoint)point inView:(UIView*)view {
    SYGalleryThumbView *emojiView = [[SYGalleryThumbView alloc] initWithFrame:CGRectMake(0, 0, 250, 100)];
    
    [emojiView setCellBorderWidth:0.f andColor:[UIColor clearColor]];
    [emojiView setDataSource:self];
    [emojiView setActionDelegate:self];
    [emojiView setCacheImages:NO];
    [emojiView reloadGallery];
    
    self->_popover = [PopoverView showPopoverAtPoint:point
                                              inView:view
                                           withTitle:@"Emoji selection"
                                     withContentView:emojiView
                                            delegate:nil];
}

#pragma mark - SYGalleryDataSource methods
- (NSUInteger)numberOfItemsInGallery:(id<SYGalleryView>)gallery
{
    return [self->_characters count];
}

- (SYGallerySourceType)gallery:(id<SYGalleryView>)gallery
             sourceTypeAtIndex:(NSUInteger)index
{
    return SYGallerySourceTypeText;
}

- (NSString*)gallery:(id<SYGalleryView>)gallery
 absolutePathAtIndex:(NSUInteger)index
             andSize:(SYGalleryPhotoSize)size
{
    return @"";
}

- (NSString*)gallery:(id<SYGalleryView>)gallery
          urlAtIndex:(NSUInteger)index
             andSize:(SYGalleryPhotoSize)size
{
    return nil;
}

- (NSString*)gallery:(id<SYGalleryView>)gallery
         textAtIndex:(NSUInteger)index
             andSize:(SYGalleryPhotoSize)size
{
    if(index >= [self->_characters count])
        return @"";
    else
        return [self->_characters objectAtIndex:index];
}

- (BOOL)gallery:(id<SYGalleryView>)gallery canDeleteAtIndex:(NSUInteger)index
{
    return NO;
}

- (CGFloat)galleryThumbCellSize:(id<SYGalleryView>)gallery
{
    return 29.f;
}

- (CGFloat)galleryThumbCellSpacing:(id<SYGalleryView>)gallery
{
    return 2.f;
}

- (BOOL)gallery:(id<SYGalleryView>)gallery shouldDisplayBadgeAtIndex:(NSUInteger)index
{
    return NO;
}

- (UIFont*)gallery:(id<SYGalleryView>)gallery
   textFontAtIndex:(NSUInteger)index andSize:(SYGalleryPhotoSize)size
{
    return [UIFont systemFontOfSize:20.f];
}

-(UIColor *)gallery:(id<SYGalleryView>)gallery textColorAtIndex:(NSUInteger)index andSize:(SYGalleryPhotoSize)size
{
    return [UIColor blackColor];
}

#pragma mark - SYGalleryThumbViewActions methods

- (void)gallery:(id<SYGalleryView>)gallery didTapOnItemAtIndex:(NSUInteger)index
{
    NSLog(@"choosed character: %@", [self->_characters objectAtIndex:index]);
    [self->_popover dismiss];
}

@end
