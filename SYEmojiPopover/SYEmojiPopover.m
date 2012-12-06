//
//  SYEmojiPopover.m
//  SYEmojiPopoverExample
//
//  Created by rominet on 11/29/12.
//  Copyright (c) 2012 Syan. All rights reserved.
//

#import "SYEmojiPopover.h"

#import "GMGridView.h"
#import "GMGridViewLayoutStrategies.h"

#import "PopoverView.h"
#import "SYEmojiCharacters.h"

#define EMOJI_RUNNING_IPHONE        ( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone )
#define EMOJI_ITEM_SIZE             ( EMOJI_RUNNING_IPHONE ? 33.f : 45.f )
#define EMOJI_FONT_SIZE             ( EMOJI_RUNNING_IPHONE ? 29.f : 39.f )
#define EMOJI_NB_ITEM_IN_ROW        ( EMOJI_RUNNING_IPHONE ? 8 : 8 )
#define EMOJI_NB_ITEM_IN_COL        ( EMOJI_RUNNING_IPHONE ? 5 : 5 )
#define EMOJI_GRID_MARGIN           ( EMOJI_RUNNING_IPHONE ? 1.f : 2.f )
#define EMOJI_GRID_DEFAULT_WIDTH    ( EMOJI_ITEM_SIZE * EMOJI_NB_ITEM_IN_ROW + EMOJI_GRID_MARGIN * 2.f )
#define EMOJI_GRID_DEFAULT_HEIGHT   ( EMOJI_ITEM_SIZE * EMOJI_NB_ITEM_IN_COL + EMOJI_GRID_MARGIN * 2.f )
#define EMOJI_PAGECONTROL_HEIGHT    10.f

@interface SYEmojiPopover (Private)
-(void)loadView;
-(void)updateFramesForSize:(CGSize)size;
-(void)setScrollEnabledAllGridViews:(BOOL)enabled;
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
    
    int numberOfSections = [[SYEmojiCharacters sharedCharacters] numberOfSections];
    
    /*************************************/
    /**********  MainView INIT  **********/
    /*************************************/
    if(!self->_mainView)
        self->_mainView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 1.f, 1.f)];
    
    self->_mainView.autoresizingMask = UIViewAutoresizingNone;
    self->_mainView.backgroundColor = [UIColor clearColor];
    self->_mainView.clipsToBounds = YES;
    
    
    /*************************************/
    /********  PageControl INIT  *********/
    /*************************************/
    if(!self->_pageControl)
        self->_pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0.f, 0.f, 1.f, 1.f)];
    
    self->_pageControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self->_pageControl.backgroundColor = [UIColor clearColor];
    self->_pageControl.clipsToBounds = YES;
    self->_pageControl.numberOfPages = numberOfSections;
    self->_pageControl.currentPage = 0;
    
    if([self->_pageControl respondsToSelector:@selector(setPageIndicatorTintColor:)])
        self->_pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    if([self->_pageControl respondsToSelector:@selector(setCurrentPageIndicatorTintColor:)])
        self->_pageControl.currentPageIndicatorTintColor = [UIColor darkGrayColor];
    
    [self->_mainView addSubview:self->_pageControl];
    
    /*************************************/
    /*********  ScrollView INIT  *********/
    /*************************************/
    if(!self->_scrollView)
        self->_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.f, 0.f, 1.f, 1.f)];
    
    self->_scrollView.autoresizingMask = UIViewAutoresizingNone;
    self->_scrollView.backgroundColor = [UIColor clearColor];
    self->_scrollView.pagingEnabled = YES;
    self->_scrollView.showsHorizontalScrollIndicator = NO;
    self->_scrollView.showsVerticalScrollIndicator = NO;
    self->_scrollView.alwaysBounceHorizontal = YES;
    self->_scrollView.clipsToBounds = YES;
    self->_scrollView.zoomScale = 1.f;
    self->_scrollView.maximumZoomScale = 1.f;
    self->_scrollView.minimumZoomScale = 1.f;
    self->_scrollView.contentSize = CGSizeMake(1.f, 1.f);
    self->_scrollView.delegate = self;
    
    [self->_mainView addSubview:self->_scrollView];
    
    /*************************************/
    /**********  GridView INIT  **********/
    /*************************************/
    if(!self->_gridViews) {
        self->_gridViews = [NSMutableArray arrayWithCapacity:numberOfSections];
        for(int i = 0; i < numberOfSections; ++i)
        {
            GMGridView *gridView = [[GMGridView alloc] initWithFrame:CGRectMake(0.f, 0.f, 1.f, 1.f)];
            
            gridView.autoresizingMask = UIViewAutoresizingNone;
            gridView.backgroundColor = [UIColor clearColor];
            
            gridView.style = GMGridViewStyleSwap;
            gridView.itemSpacing = 0.f;
            gridView.minEdgeInsets = UIEdgeInsetsMake(EMOJI_GRID_MARGIN, EMOJI_GRID_MARGIN,
                                                      EMOJI_GRID_MARGIN, EMOJI_GRID_MARGIN);
            gridView.centerGrid = NO;
            gridView.showsVerticalScrollIndicator = YES;
            gridView.showsHorizontalScrollIndicator = NO;
            gridView.alwaysBounceVertical = YES;
            gridView.clipsToBounds = YES;
            
            // so that cells cannot be moved
            gridView.enableEditOnLongPress = NO;
            gridView.sortingDelegate = nil;
            gridView.actionDelegate = self;
            
            gridView.delegate = self;
            
            [self->_scrollView addSubview:gridView];
            [self->_gridViews addObject:gridView];
            
            NSLog(@"zou");
            if(gridView.dataSource == nil)
                gridView.dataSource = self;
        }
    }
}

-(void)updateFramesForSize:(CGSize)size
{
    int numberOfSections = [[SYEmojiCharacters sharedCharacters] numberOfSections];
    CGFloat pageHeight = size.height - EMOJI_PAGECONTROL_HEIGHT;
    
    if(self->_mainView)
        [self->_mainView setFrame:CGRectMake(0.f, 0.f, size.width, size.height)];
    
    if(self->_pageControl)
        [self->_pageControl setFrame:CGRectMake(0.f, 0.f, size.width, EMOJI_PAGECONTROL_HEIGHT)];
    
    if(self->_scrollView) {
        [self->_scrollView setFrame:CGRectMake(0.f, EMOJI_PAGECONTROL_HEIGHT, size.width, pageHeight)];
        [self->_scrollView setContentSize:CGSizeMake(size.width * numberOfSections, pageHeight)];
    }
    
    if(self->_gridViews) {
        for(int i = 0; i < [self->_gridViews count]; ++i)
            [(GMGridView*)[self->_gridViews objectAtIndex:i] setFrame:CGRectMake(i * size.width, 0.f, size.width, pageHeight)];
    }
}

-(void)setScrollEnabledAllGridViews:(BOOL)enabled
{
    for(GMGridView *gridView in self->_gridViews)
        [gridView setScrollEnabled:enabled];
}


#pragma mark - View methods

-(void)showFromPoint:(CGPoint)point inView:(UIView *)view {
    
    [self showFromPoint:point
                 inView:view
               withSize:CGSizeMake(EMOJI_GRID_DEFAULT_WIDTH, EMOJI_GRID_DEFAULT_HEIGHT + EMOJI_PAGECONTROL_HEIGHT)];
}

-(void)showFromPoint:(CGPoint)point inView:(UIView*)view withSize:(CGSize)size {
    
    if(!self->_mainView)
        [self loadView];
    
    [self updateFramesForSize:size];
    
    [self->_popover setAutoresizingMask:UIViewAutoresizingNone];
    self->_popover = [PopoverView showPopoverAtPoint:point
                                              inView:view
                                           withTitle:@"Emoji selection"
                                     withContentView:self->_mainView
                                            delegate:nil];
}

-(void)moveToPoint:(CGPoint)point inView:(UIView*)view withDuration:(NSTimeInterval)duration {

    if(!self->_popover)
        return;
    
    [self->_popover animateRotationToNewPoint:point
                                       inView:view
                                 withDuration:duration];
}

#pragma mark - UIScrollViewDelegate methods
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if(scrollView == self->_scrollView) {
        [self setScrollEnabledAllGridViews:NO];
        return;
        
/*
        CGFloat pageWidth = self->_scrollView.frame.size.width;
        int pageIndex = (floor((self->_scrollView.contentOffset.x - pageWidth / 2.f) / pageWidth) + 1);
        if(pageIndex >= [[SYEmojiCharacters sharedCharacters] numberOfSections] || pageIndex < 0)
            pageIndex = 0;
        
        GMGridView *grid_n = [self->_gridViews objectAtIndex:pageIndex];
        GMGridView *grid_n_minus_1 = nil;
        if(pageIndex >= 1)
            grid_n_minus_1 = [self->_gridViews objectAtIndex:pageIndex];
        GMGridView *grid_n_plus_1 = nil;
        if(pageIndex -1 < [[SYEmojiCharacters sharedCharacters] numberOfSections])
            grid_n_plus_1 = [self->_gridViews objectAtIndex:pageIndex];
        
        if(grid_n && grid_n.delegate == nil)
            grid_n.delegate = self;
        if(grid_n_minus_1 && grid_n_minus_1.delegate == nil)
            grid_n_minus_1.delegate = self;
        if(grid_n_plus_1 && grid_n_plus_1.delegate == nil)
            grid_n_plus_1.delegate = self;
        */
    }
    else {
        [self->_scrollView setScrollEnabled:NO];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self setScrollEnabledAllGridViews:YES];
    [self->_scrollView setScrollEnabled:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self->_scrollView.frame.size.width;
    int pageIndex = (floor((self->_scrollView.contentOffset.x - pageWidth / 2.f) / pageWidth) + 1);
    
    if(pageIndex >= [[SYEmojiCharacters sharedCharacters] numberOfSections] || pageIndex < 0)
        pageIndex = 0;
    
    [self->_pageControl setCurrentPage:pageIndex];
}

#pragma mark - SYGalleryDataSource methods
- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView
{
    NSUInteger section = [self->_gridViews indexOfObject:gridView];
    if(section == NSNotFound)
        return 0;
    
    return [[SYEmojiCharacters sharedCharacters] numberOfRowsInSection:section];
}

- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    return CGSizeMake(EMOJI_ITEM_SIZE, EMOJI_ITEM_SIZE);
}

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index
{
    NSUInteger section = [self->_gridViews indexOfObject:gridView];
    if(section == NSNotFound)
        return [[GMGridViewCell alloc] init];
    
    NSString *text = [[SYEmojiCharacters sharedCharacters] emojiAtRow:index andSection:section];
    if(!text)
        text = @"";
    
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
    NSUInteger section = [self->_gridViews indexOfObject:gridView];
    if(section == NSNotFound)
        return;
    
    if(position < 0 || position >= [[SYEmojiCharacters sharedCharacters] numberOfRowsInSection:section])
        return;
    
    if([self.delegate respondsToSelector:@selector(emojiPopover:didClickedOnCharacter:)])
        [self.delegate emojiPopover:self didClickedOnCharacter:[[SYEmojiCharacters sharedCharacters] emojiAtRow:position andSection:section]];
    
    [self->_popover dismiss];
}

@end
