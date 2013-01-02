//
//  SYEmojiPopover.m
//  SYEmojiPopoverExample
//
//  Created by rominet on 11/29/12.
//  Copyright (c) 2012 Syan. All rights reserved.
//

#import "SYEmojiPopover.h"

#import "PopoverView.h"
#import "SYEmojiCharacters.h"

#define EMOJI_RUNNING_IPHONE        ( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone )
#define EMOJI_ITEM_SIZE             ( EMOJI_RUNNING_IPHONE ? 40.f : 40.f )
#define EMOJI_FONT_SIZE             ( EMOJI_RUNNING_IPHONE ? 32.f : 32.f )
#define EMOJI_NB_ITEM_IN_ROW        ( EMOJI_RUNNING_IPHONE ? 7.f : 7.f )
#define EMOJI_NB_ITEM_IN_COL        ( EMOJI_RUNNING_IPHONE ? 4.f : 4.f )
#define EMOJI_GRID_MARGIN           ( EMOJI_RUNNING_IPHONE ? 1.f : 2.f )
#define EMOJI_GRID_DEFAULT_WIDTH    ( EMOJI_ITEM_SIZE * EMOJI_NB_ITEM_IN_ROW + EMOJI_GRID_MARGIN * 2.f )
#define EMOJI_GRID_DEFAULT_HEIGHT   ( EMOJI_ITEM_SIZE * EMOJI_NB_ITEM_IN_COL + EMOJI_GRID_MARGIN * 2.f )
#define EMOJI_PAGECONTROL_HEIGHT    10.f

@interface SYEmojiPopoverCell : UITableViewCell {
    NSUInteger _row;
    NSUInteger _page;
    NSMutableArray *_buttons;
}
@property (nonatomic, copy) void (^clickedCharacter) (NSString*);

-(void)setRow:(NSUInteger)row andPage:(NSUInteger)page;
-(void)refresh;
-(void)refreshLayout;
-(void)emojiButtonTapped:(id)sender;
@end


@interface SYEmojiPopover (Private)
-(void)loadView;
-(void)loadPage:(int)pageIndex;
-(void)updateFramesForSize:(CGSize)size;
-(void)setScrollEnabledAllTableViews:(BOOL)enabled;
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
    
    uint numberOfSections = [[SYEmojiCharacters sharedCharacters] numberOfSections];
    
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
    /**********  TableView INIT  *********/
    /*************************************/
    if(!self->_tableViews) {
        self->_tableViews = [NSMutableArray arrayWithCapacity:numberOfSections];
        for(uint i = 0; i < numberOfSections; ++i)
        {
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.f, 0.f, 1.f, 1.f)];
            
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            tableView.rowHeight = EMOJI_ITEM_SIZE;
            
            tableView.autoresizingMask = UIViewAutoresizingNone;
            tableView.backgroundColor = [UIColor clearColor];
            
            tableView.showsVerticalScrollIndicator = YES;
            tableView.showsHorizontalScrollIndicator = NO;
            tableView.alwaysBounceVertical = YES;
            tableView.clipsToBounds = YES;
            
            tableView.delegate = self;
            tableView.dataSource = nil;
            
            [self->_scrollView addSubview:tableView];
            [self->_tableViews addObject:tableView];
        }
    }
}

-(void)updateFramesForSize:(CGSize)size
{
    uint numberOfSections = [[SYEmojiCharacters sharedCharacters] numberOfSections];
    CGFloat pageHeight = size.height - EMOJI_PAGECONTROL_HEIGHT - 2.f;
    
    if(self->_mainView)
        [self->_mainView setFrame:CGRectMake(0.f, 0.f, size.width, size.height)];
    
    if(self->_pageControl)
        [self->_pageControl setFrame:CGRectMake(0.f, 0.f, size.width, EMOJI_PAGECONTROL_HEIGHT)];
    
    if(self->_scrollView) {
        [self->_scrollView setFrame:CGRectMake(0.f, EMOJI_PAGECONTROL_HEIGHT + 2.f, size.width, pageHeight)];
        [self->_scrollView setContentSize:CGSizeMake(size.width * numberOfSections, pageHeight)];
    }
    
    if(self->_tableViews) {
        for(uint i = 0; i < [self->_tableViews count]; ++i)
            [(UITableView*)[self->_tableViews objectAtIndex:i] setFrame:CGRectMake(i * size.width, 0.f, size.width, pageHeight)];
    }
}

-(void)setScrollEnabledAllTableViews:(BOOL)enabled
{
    for(UITableView *tableView in self->_tableViews)
        [tableView setScrollEnabled:enabled];
}

-(void)loadPage:(int)pageIndex
{
    if(pageIndex < 0 || pageIndex >= (int)[self->_tableViews count])
        return;
    
    UITableView *tableView = [self->_tableViews objectAtIndex:(uint)pageIndex];
    if(tableView.dataSource == nil) {
        tableView.dataSource = self;
        [tableView reloadData];
    }
}

#pragma mark - View methods

-(void)showFromPoint:(CGPoint)point inView:(UIView *)view withTitle:(NSString *)title
{
    if(!self->_mainView)
        [self loadView];
    
    [self updateFramesForSize:CGSizeMake(EMOJI_GRID_DEFAULT_WIDTH, EMOJI_GRID_DEFAULT_HEIGHT + EMOJI_PAGECONTROL_HEIGHT)];
    [self loadPage:0];
    [self loadPage:1];
    
    [self->_popover setAutoresizingMask:UIViewAutoresizingNone];
    self->_popover = [PopoverView showPopoverAtPoint:point
                                              inView:view
                                           withTitle:title
                                     withContentView:self->_mainView
                                            delegate:nil];
}

-(void)moveToPoint:(CGPoint)point inView:(UIView*)view withDuration:(NSTimeInterval)duration
{
    if(!self->_popover)
        return;
    
    [self->_popover animateRotationToNewPoint:point
                                       inView:view
                                 withDuration:duration];
}

#pragma mark - UIScrollViewDelegate methods
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self->_scrollView.frame.size.width;
    int pageIndex = ((int)floor((self->_scrollView.contentOffset.x - pageWidth / 2.f) / pageWidth) + 1);
    
    if(scrollView == self->_scrollView) {
        [self setScrollEnabledAllTableViews:NO];
        
        [self loadPage:pageIndex-1];
        [self loadPage:pageIndex];
        [self loadPage:pageIndex+1];
    }
    else
        [self->_scrollView setScrollEnabled:NO];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self setScrollEnabledAllTableViews:YES];
    [self->_scrollView setScrollEnabled:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self->_scrollView.frame.size.width;
    int pageIndex = ((int)floor((self->_scrollView.contentOffset.x - pageWidth / 2.f) / pageWidth) + 1);
    
    if(pageIndex >= (int)[[SYEmojiCharacters sharedCharacters] numberOfSections] || pageIndex < 0)
        pageIndex = 0;
    
    [self->_pageControl setCurrentPage:pageIndex];
}

#pragma mark - UITableViewDataSource methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger page = [self->_tableViews indexOfObject:tableView];
    if(page == NSNotFound)
        return 0;
    
    CGFloat nbCharacters = (CGFloat)[[SYEmojiCharacters sharedCharacters] numberOfRowsInSection:page];
    return (int)ceil(nbCharacters / EMOJI_NB_ITEM_IN_ROW);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger page = [self->_tableViews indexOfObject:tableView];
    if(page == NSNotFound)
        return [[UITableViewCell alloc] init];
    
    NSString *cellIdentifier = @"cellEmoji";
    SYEmojiPopoverCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell)
        cell = [[SYEmojiPopoverCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    [cell setRow:(uint)indexPath.row andPage:page];
    
    if(!cell.clickedCharacter)
    {
        [cell setClickedCharacter:^(NSString *character) {
            SEL clickSel = @selector(emojiPopover:didClickedOnCharacter:);
            if([self.delegate respondsToSelector:clickSel])
                [self.delegate emojiPopover:self didClickedOnCharacter:character];
            
            [self->_popover dismiss];
        }];
    }
    
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath { return NO; }
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath { return NO; }


#pragma mark - UITableViewDelegate methods

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return UITableViewCellEditingStyleNone;
}

@end




@implementation SYEmojiPopoverCell

@synthesize clickedCharacter;

-(void)setRow:(NSUInteger)row andPage:(NSUInteger)page
{
    self->_row = row;
    self->_page = page;
    [self refresh];
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self refreshLayout];
}

#pragma mark - Display
-(void)refresh
{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self setAccessoryType:UITableViewCellAccessoryNone];
    [self setBackgroundColor:[UIColor clearColor]];
    
    if(!self->_buttons)
    {
        self->_buttons = [NSMutableArray arrayWithCapacity:EMOJI_NB_ITEM_IN_ROW];
        for(uint i = 0; i < EMOJI_NB_ITEM_IN_ROW; ++i)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            
            [button setBackgroundColor:[UIColor clearColor]];
            [button setTitle:@"" forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont fontWithName:@"AppleColorEmoji" size:EMOJI_FONT_SIZE]];
            [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
            
            [button setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
            [button addTarget:self action:@selector(emojiButtonTapped:) forControlEvents:UIControlEventTouchUpInside];

            [self->_buttons addObject:button];
            [self addSubview:button];
        }
    }
    
    NSUInteger firstCharacterIndex = self->_row * (uint)EMOJI_NB_ITEM_IN_ROW;
    for(uint i = 0; i < EMOJI_NB_ITEM_IN_ROW; ++i)
    {
        UIButton *button = [self->_buttons objectAtIndex:i];
        
        NSString *character = [[SYEmojiCharacters sharedCharacters] emojiAtRow:(i + firstCharacterIndex) andSection:self->_page];
        if(!character)
            character = @"";
        
        [button setTitle:character forState:UIControlStateNormal];
    }

    [self refreshLayout];

//    return CGSizeMake(EMOJI_ITEM_SIZE, EMOJI_ITEM_SIZE);
//    [textView setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
}

-(void)refreshLayout
{
    if(!self->_buttons || [self->_buttons count] != EMOJI_NB_ITEM_IN_ROW)
        return;
    
    CGFloat itemWidth = self.frame.size.width / EMOJI_NB_ITEM_IN_ROW;
    CGFloat itemInternalWidth = itemWidth * 0.9f;
    for(uint i = 0; i < EMOJI_NB_ITEM_IN_ROW; ++i)
    {
        UIButton *button = [self->_buttons objectAtIndex:i];
        [button setFrame:CGRectMake(i * itemWidth, 0.f, itemInternalWidth, self.frame.size.height)];
    }
}

#pragma mark - Button click
-(void)emojiButtonTapped:(id)sender
{
    NSString *character = @"";
    if([sender isKindOfClass:[UIButton class]])
        character = [(UIButton*)sender titleForState:UIControlStateNormal];
    
    if(![[SYEmojiCharacters sharedCharacters] isCharacterEmoji:character])
        return;
    
    if(self.clickedCharacter)
        self.clickedCharacter(character);
}

@end


