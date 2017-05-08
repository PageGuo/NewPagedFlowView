//
//  NewPagedFlowView.m
//  dianshang
//
//  Created by sskh on 16/7/13.
//  Copyright © 2016年 Mars. All rights reserved.
//  Designed By PageGuo,
//  QQ:799573715
//  github:https://github.com/PageGuo/NewPagedFlowView

#import "NewPagedFlowView.h"
#import "PGIndexBannerSubiew.h"

@interface NewPagedFlowView ()

@property (nonatomic, assign, readwrite) NSInteger currentPageIndex;

/**
 *  计时器用到的页数
 */
@property (nonatomic, assign) NSInteger page;

/**
 *  一页的尺寸
 */
@property (nonatomic,assign) CGSize pageSize;

@end

//子控制器的类名
static NSString *subviewClassName;

@implementation NewPagedFlowView

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private Methods
- (void)initialize{
    self.clipsToBounds = YES;
    
    self.needsReload = YES;
    self.pageCount = 0;
    self.isOpenAutoScroll = YES;
    self.isCarousel = YES;
    self.leftRightMargin = 20;
    self.topBottomMargin = 30;
    _currentPageIndex = 0;
    
    _minimumPageAlpha = 1.0;
    _autoTime = 5.0;
    
    self.visibleRange = NSMakeRange(0, 0);
    
    self.reusableCells = [[NSMutableArray alloc] initWithCapacity:0];
    self.cells = [[NSMutableArray alloc] initWithCapacity:0];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scrollView.scrollsToTop = NO;
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.clipsToBounds = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    
    subviewClassName = @"PGIndexBannerSubiew";
    
    /*由于UIScrollView在滚动之后会调用自己的layoutSubviews以及父View的layoutSubviews
     这里为了避免scrollview滚动带来自己layoutSubviews的调用,所以给scrollView加了一层父View
     */
    UIView *superViewOfScrollView = [[UIView alloc] initWithFrame:self.bounds];
    [superViewOfScrollView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [superViewOfScrollView setBackgroundColor:[UIColor clearColor]];
    [superViewOfScrollView addSubview:self.scrollView];
    [self addSubview:superViewOfScrollView];
    
}

- (void)setLeftRightMargin:(CGFloat)leftRightMargin {
    _leftRightMargin = leftRightMargin * 0.5;
    
}

- (void)setTopBottomMargin:(CGFloat)topBottomMargin {
    _topBottomMargin = topBottomMargin * 0.5;
}

- (void)startTimer {
    
    if (self.orginPageCount > 1 && self.isOpenAutoScroll && self.isCarousel) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.autoTime target:self selector:@selector(autoNextPage) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];

    }
    
}

- (void)stopTimer {
    
    [self.timer invalidate];
}

#pragma mark --自动轮播
- (void)autoNextPage {
    
    self.page ++;
    
    
    
    switch (self.orientation) {
        case NewPagedFlowViewOrientationHorizontal:{
            
            [_scrollView setContentOffset:CGPointMake(self.page * _pageSize.width, 0) animated:YES];
            break;
        }
        case NewPagedFlowViewOrientationVertical:{
            
            [_scrollView setContentOffset:CGPointMake(0, self.page * _pageSize.height) animated:YES];
            
            break;
        }
        default:
            break;
    }
}


- (void)queueReusableCell:(UIView *)cell{
    [_reusableCells addObject:cell];
}

- (void)removeCellAtIndex:(NSInteger)index{
    UIView *cell = [_cells objectAtIndex:index];
    if ((NSObject *)cell == [NSNull null]) {
        return;
    }
    
    [self queueReusableCell:cell];
    
    if (cell.superview) {
        [cell removeFromSuperview];
    }
    
    [_cells replaceObjectAtIndex:index withObject:[NSNull null]];
}

- (void)refreshVisibleCellAppearance{
    
    if (_minimumPageAlpha == 1.0) {
        return;//无需更新
    }
    switch (self.orientation) {
        case NewPagedFlowViewOrientationHorizontal:{
            CGFloat offset = _scrollView.contentOffset.x;
            
            for (NSInteger i = self.visibleRange.location; i < self.visibleRange.location + _visibleRange.length; i++) {
                PGIndexBannerSubiew *cell = [_cells objectAtIndex:i];
                subviewClassName = NSStringFromClass([cell class]);
                CGFloat origin = cell.frame.origin.x;
                CGFloat delta = fabs(origin - offset);
                
                CGRect originCellFrame = CGRectMake(_pageSize.width * i, 0, _pageSize.width, _pageSize.height);//如果没有缩小效果的情况下的本该的Frame
                
                if (delta < _pageSize.width) {
                    
                    cell.coverView.alpha = (delta / _pageSize.width) * _minimumPageAlpha;
                    
                    CGFloat leftRightInset = self.leftRightMargin * delta / _pageSize.width;
                    CGFloat topBottomInset = self.topBottomMargin * delta / _pageSize.width;
                    
                    cell.layer.transform = CATransform3DMakeScale((_pageSize.width-leftRightInset*2)/_pageSize.width,(_pageSize.height-topBottomInset*2)/_pageSize.height, 1.0);
                    cell.frame = UIEdgeInsetsInsetRect(originCellFrame, UIEdgeInsetsMake(topBottomInset, leftRightInset, topBottomInset, leftRightInset));

                    
                } else {
                    cell.coverView.alpha = _minimumPageAlpha;
                    cell.layer.transform = CATransform3DMakeScale((_pageSize.width-self.leftRightMargin*2)/_pageSize.width,(_pageSize.height-self.topBottomMargin*2)/_pageSize.height, 1.0);
                    cell.frame = UIEdgeInsetsInsetRect(originCellFrame, UIEdgeInsetsMake(self.topBottomMargin, self.leftRightMargin, self.topBottomMargin, self.leftRightMargin));

                    
                }

            }
            break;
        }
        case NewPagedFlowViewOrientationVertical:{
            CGFloat offset = _scrollView.contentOffset.y;
            
            for (NSInteger i = self.visibleRange.location; i < self.visibleRange.location + _visibleRange.length; i++) {
                PGIndexBannerSubiew *cell = [_cells objectAtIndex:i];
                subviewClassName = NSStringFromClass([cell class]);
                CGFloat origin = cell.frame.origin.y;
                CGFloat delta = fabs(origin - offset);
                
                CGRect originCellFrame = CGRectMake(0, _pageSize.height * i, _pageSize.width, _pageSize.height);//如果没有缩小效果的情况下的本该的Frame
                
                if (delta < _pageSize.height) {
                    cell.coverView.alpha = (delta / _pageSize.height) * _minimumPageAlpha;
                    
                    CGFloat leftRightInset = self.leftRightMargin * delta / _pageSize.height;
                    CGFloat topBottomInset = self.topBottomMargin * delta / _pageSize.height;
                    
                    cell.layer.transform = CATransform3DMakeScale((_pageSize.width-leftRightInset*2)/_pageSize.width,(_pageSize.height-topBottomInset*2) / _pageSize.height, 1.0);
                    cell.frame = UIEdgeInsetsInsetRect(originCellFrame, UIEdgeInsetsMake(topBottomInset, leftRightInset, topBottomInset, leftRightInset));
                    cell.mainImageView.frame = cell.bounds;
                } else {
                    cell.coverView.alpha = _minimumPageAlpha;
                    cell.frame = UIEdgeInsetsInsetRect(originCellFrame, UIEdgeInsetsMake(self.topBottomMargin, self.leftRightMargin, self.topBottomMargin, self.leftRightMargin));
                    cell.mainImageView.frame = cell.bounds;
                }
    
            }
        }
        default:
            break;
    }
    
}

- (void)setPageAtIndex:(NSInteger)pageIndex{
    NSParameterAssert(pageIndex >= 0 && pageIndex < [_cells count]);
    
    UIView *cell = [_cells objectAtIndex:pageIndex];
    
    if ((NSObject *)cell == [NSNull null]) {
        cell = [_dataSource flowView:self cellForPageAtIndex:pageIndex % self.orginPageCount];
        NSAssert(cell!=nil, @"datasource must not return nil");
        [_cells replaceObjectAtIndex:pageIndex withObject:cell];
        
        //添加点击手势
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleCellTapAction:)];
        [cell addGestureRecognizer:singleTap];
        cell.tag = pageIndex % self.orginPageCount;
        
        switch (self.orientation) {
            case NewPagedFlowViewOrientationHorizontal:
                cell.frame = CGRectMake(_pageSize.width * pageIndex, 0, _pageSize.width, _pageSize.height);
                break;
            case NewPagedFlowViewOrientationVertical:
                cell.frame = CGRectMake(0, _pageSize.height * pageIndex, _pageSize.width, _pageSize.height);
                break;
            default:
                break;
        }
        
        if (!cell.superview) {
            [_scrollView addSubview:cell];
        }
    }
}


- (void)setPagesAtContentOffset:(CGPoint)offset{
    //计算_visibleRange
    CGPoint startPoint = CGPointMake(offset.x - _scrollView.frame.origin.x, offset.y - _scrollView.frame.origin.y);
    CGPoint endPoint = CGPointMake(startPoint.x + self.bounds.size.width, startPoint.y + self.bounds.size.height);
    
    
    switch (self.orientation) {
        case NewPagedFlowViewOrientationHorizontal:{
            NSInteger startIndex = 0;
            for (int i =0; i < [_cells count]; i++) {
                if (_pageSize.width * (i +1) > startPoint.x) {
                    startIndex = i;
                    break;
                }
            }
            
            NSInteger endIndex = startIndex;
            for (NSInteger i = startIndex; i < [_cells count]; i++) {
                //如果都不超过则取最后一个
                if ((_pageSize.width * (i + 1) < endPoint.x && _pageSize.width * (i + 2) >= endPoint.x) || i+ 2 == [_cells count]) {
                    endIndex = i + 1;//i+2 是以个数，所以其index需要减去1
                    break;
                }
            }
            
            //可见页分别向前向后扩展一个，提高效率
            startIndex = MAX(startIndex - 1, 0);
            endIndex = MIN(endIndex + 1, [_cells count] - 1);
            
            //            self.visibleRange.location = startIndex;
            //            self.visibleRange.length = endIndex - startIndex + 1;
            self.visibleRange = NSMakeRange(startIndex, endIndex - startIndex + 1);
            for (NSInteger i = startIndex; i <= endIndex; i++) {
                [self setPageAtIndex:i];
            }
            
            for (int i = 0; i < startIndex; i ++) {
                [self removeCellAtIndex:i];
            }
            
            for (NSInteger i = endIndex + 1; i < [_cells count]; i ++) {
                [self removeCellAtIndex:i];
            }
            break;
        }
        case NewPagedFlowViewOrientationVertical:{
            NSInteger startIndex = 0;
            for (int i =0; i < [_cells count]; i++) {
                if (_pageSize.height * (i +1) > startPoint.y) {
                    startIndex = i;
                    break;
                }
            }
            
            NSInteger endIndex = startIndex;
            for (NSInteger i = startIndex; i < [_cells count]; i++) {
                //如果都不超过则取最后一个
                if ((_pageSize.height * (i + 1) < endPoint.y && _pageSize.height * (i + 2) >= endPoint.y) || i+ 2 == [_cells count]) {
                    endIndex = i + 1;//i+2 是以个数，所以其index需要减去1
                    break;
                }
            }
            
            //可见页分别向前向后扩展一个，提高效率
            startIndex = MAX(startIndex - 1, 0);
            endIndex = MIN(endIndex + 1, [_cells count] - 1);
            
            _visibleRange.location = startIndex;
            _visibleRange.length = endIndex - startIndex + 1;
            
            for (NSInteger i = startIndex; i <= endIndex; i++) {
                [self setPageAtIndex:i];
            }
            
            for (NSInteger i = 0; i < startIndex; i ++) {
                [self removeCellAtIndex:i];
            }
            
            for (NSInteger i = endIndex + 1; i < [_cells count]; i ++) {
                [self removeCellAtIndex:i];
            }
            break;
        }
        default:
            break;
    }
    
    
    
}




////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Override Methods

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initialize];
    }
    return self;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark NewPagedFlowView API

- (void)reloadData
{
    _needsReload = YES;
    
    //移除所有self.scrollView的子控件
    for (UIView *view in self.scrollView.subviews) {
        if ([NSStringFromClass(view.class) isEqualToString:subviewClassName]) {
            [view removeFromSuperview];
        }
    }
    
    [self stopTimer];

    if (_needsReload) {
        //如果需要重新加载数据，则需要清空相关数据全部重新加载
        
        
        //重置pageCount
        if (_dataSource && [_dataSource respondsToSelector:@selector(numberOfPagesInFlowView:)]) {
            
            //原始页数
            self.orginPageCount = [_dataSource numberOfPagesInFlowView:self];
            
            //总页数
            if (self.isCarousel) {
                _pageCount = self.orginPageCount == 1 ? 1: [_dataSource numberOfPagesInFlowView:self] * 3;
            }else {
                _pageCount = self.orginPageCount == 1 ? 1: [_dataSource numberOfPagesInFlowView:self];
            }
            
            //如果总页数为0，return
            if (_pageCount == 0) {
                
                return;
            }
            
            if (self.pageControl && [self.pageControl respondsToSelector:@selector(setNumberOfPages:)]) {
                [self.pageControl setNumberOfPages:self.orginPageCount];
            }
        }
        
        //重置pageWidth
        _pageSize = CGSizeMake(self.bounds.size.width - 4 * self.leftRightMargin,(self.bounds.size.width - 4 * self.leftRightMargin) * 9 /16);
        if (self.delegate && [self.delegate respondsToSelector:@selector(sizeForPageInFlowView:)]) {
            _pageSize = [self.delegate sizeForPageInFlowView:self];
        }
        
        [_reusableCells removeAllObjects];
        _visibleRange = NSMakeRange(0, 0);
        
        //填充cells数组
        [_cells removeAllObjects];
        for (NSInteger index=0; index<_pageCount; index++)
        {
            [_cells addObject:[NSNull null]];
        }
        
        // 重置_scrollView的contentSize
        switch (self.orientation) {
            case NewPagedFlowViewOrientationHorizontal://横向
                _scrollView.frame = CGRectMake(0, 0, _pageSize.width, _pageSize.height);
                _scrollView.contentSize = CGSizeMake(_pageSize.width * _pageCount,_pageSize.height);
                CGPoint theCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
                _scrollView.center = theCenter;
                
                if (self.orginPageCount > 1) {
                    
                    if (self.isCarousel) {
                        
                        //滚到第二组
                        [_scrollView setContentOffset:CGPointMake(_pageSize.width * self.orginPageCount, 0) animated:NO];
                        
                        self.page = self.orginPageCount;
                        
                        //启动自动轮播
                        [self startTimer];
                        
                    }else {
                        //滚到开始
                        [_scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
                        
                        self.page = self.orginPageCount;
                        
                    }
                    
                }
                
                break;
            case NewPagedFlowViewOrientationVertical:{
                _scrollView.frame = CGRectMake(0, 0, _pageSize.width, _pageSize.height);
                _scrollView.contentSize = CGSizeMake(_pageSize.width ,_pageSize.height * _pageCount);
                CGPoint theCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
                _scrollView.center = theCenter;
                
                if (self.orginPageCount > 1) {
                    
                    if (self.isCarousel) {
                        //滚到第二组
                        [_scrollView setContentOffset:CGPointMake(0, _pageSize.height * self.orginPageCount) animated:NO];
                        
                        self.page = self.orginPageCount;
                        
                        //启动自动轮播
                        [self startTimer];
                    }else {
                        //滚到第二组
                        [_scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
                        
                        self.page = self.orginPageCount;
                        
                    }
                    
                }
                
                break;
            }
            default:
                break;
        }
        
        _needsReload = NO;
    }
    
    
    [self setPagesAtContentOffset:_scrollView.contentOffset];//根据当前scrollView的offset设置cell
    
    [self refreshVisibleCellAppearance];//更新各个可见Cell的显示外貌
}


- (UIView *)dequeueReusableCell{
    PGIndexBannerSubiew *cell = [_reusableCells lastObject];
    if (cell)
    {
        [_reusableCells removeLastObject];
    }
    
    return cell;
}

- (void)scrollToPage:(NSUInteger)pageNumber {
    if (pageNumber < _pageCount) {
        
        //首先停止定时器
        [self stopTimer];
        
        if (self.isCarousel) {
            
            self.page = pageNumber + self.orginPageCount;
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startTimer) object:nil];
            [self performSelector:@selector(startTimer) withObject:nil afterDelay:0.5];
            
        }else {
            self.page = pageNumber;
        }
        
        switch (self.orientation) {
            case NewPagedFlowViewOrientationHorizontal:
                [_scrollView setContentOffset:CGPointMake(_pageSize.width * (pageNumber + self.orginPageCount), 0) animated:YES];
                break;
            case NewPagedFlowViewOrientationVertical:
                [_scrollView setContentOffset:CGPointMake(0, _pageSize.height * (pageNumber + self.orginPageCount)) animated:YES];
                break;
        }
        [self setPagesAtContentOffset:_scrollView.contentOffset];
        [self refreshVisibleCellAppearance];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark hitTest

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if ([self pointInside:point withEvent:event]) {
        CGPoint newPoint = CGPointZero;
        newPoint.x = point.x - _scrollView.frame.origin.x + _scrollView.contentOffset.x;
        newPoint.y = point.y - _scrollView.frame.origin.y + _scrollView.contentOffset.y;
        if ([_scrollView pointInside:newPoint withEvent:event]) {
            return [_scrollView hitTest:newPoint withEvent:event];
        }
        
        return _scrollView;
    }
    
    return nil;
}


#pragma mark -
#pragma mark UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (self.orginPageCount == 0) {
        return;
    }
    
    NSInteger pageIndex;
    
    switch (self.orientation) {
        case NewPagedFlowViewOrientationHorizontal:
            pageIndex = (int)round(_scrollView.contentOffset.x / _pageSize.width) % self.orginPageCount;
            break;
        case NewPagedFlowViewOrientationVertical:
            pageIndex = (int)round(_scrollView.contentOffset.y / _pageSize.height) % self.orginPageCount;
            break;
        default:
            break;
    }
    
    if (self.isCarousel) {
        
        if (self.orginPageCount > 1) {
            switch (self.orientation) {
                case NewPagedFlowViewOrientationHorizontal:
                {
                    if (scrollView.contentOffset.x / _pageSize.width >= 2 * self.orginPageCount) {
                        
                        [scrollView setContentOffset:CGPointMake(_pageSize.width * self.orginPageCount, 0) animated:NO];
                        
                        self.page = self.orginPageCount;
                        
                    }
                    
                    if (scrollView.contentOffset.x / _pageSize.width <= self.orginPageCount - 1) {
                        [scrollView setContentOffset:CGPointMake((2 * self.orginPageCount - 1) * _pageSize.width, 0) animated:NO];
                        
                        self.page = 2 * self.orginPageCount;
                    }
                    
                }
                    break;
                case NewPagedFlowViewOrientationVertical:
                {
                    if (scrollView.contentOffset.y / _pageSize.height >= 2 * self.orginPageCount) {
                        
                        [scrollView setContentOffset:CGPointMake(0, _pageSize.height * self.orginPageCount) animated:NO];
                        
                        self.page = self.orginPageCount;
                        
                    }
                    
                    if (scrollView.contentOffset.y / _pageSize.height <= self.orginPageCount - 1) {
                        [scrollView setContentOffset:CGPointMake(0, (2 * self.orginPageCount - 1) * _pageSize.height) animated:NO];
                        self.page = 2 * self.orginPageCount;
                    }
                    
                }
                    break;
                default:
                    break;
            }
            
            
        }else {
            
            pageIndex = 0;
            
            
        }
    }
    
    
    [self setPagesAtContentOffset:scrollView.contentOffset];
    [self refreshVisibleCellAppearance];
    
    if (self.pageControl && [self.pageControl respondsToSelector:@selector(setCurrentPage:)]) {
        
        [self.pageControl setCurrentPage:pageIndex];
    }
    
    if ([_delegate respondsToSelector:@selector(didScrollToPage:inFlowView:)] && _currentPageIndex != pageIndex && pageIndex > 0) {
        [_delegate didScrollToPage:pageIndex inFlowView:self];
    }
    
    _currentPageIndex = pageIndex;
}

#pragma mark --将要开始拖拽
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self.timer invalidate];
    
}

#pragma mark --将要结束拖拽
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    if (self.orginPageCount > 1 && self.isOpenAutoScroll && self.isCarousel) {
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.autoTime target:self selector:@selector(autoNextPage) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        
        switch (self.orientation) {
            case NewPagedFlowViewOrientationHorizontal:
            {
                if (self.page == floor(_scrollView.contentOffset.x / _pageSize.width)) {
                    
                    self.page = floor(_scrollView.contentOffset.x / _pageSize.width) + 1;
                    
                }else {
                    
                    self.page = floor(_scrollView.contentOffset.x / _pageSize.width);
                }
            }
                break;
            case NewPagedFlowViewOrientationVertical:
            {
                if (self.page == floor(_scrollView.contentOffset.y / _pageSize.height)) {
                    
                    self.page = floor(_scrollView.contentOffset.y / _pageSize.height) + 1;
                    
                }else {
                    
                    self.page = floor(_scrollView.contentOffset.y / _pageSize.height);
                }
            }
                break;
            default:
                break;
        }
        
    }
}

//点击了cell
- (void)singleCellTapAction:(UIGestureRecognizer *)gesture {
    
    if ([self.delegate respondsToSelector:@selector(didSelectCell:withSubViewIndex:)]) {
        
        [self.delegate didSelectCell:gesture.view withSubViewIndex:gesture.view.tag];
        
    }
}

@end
