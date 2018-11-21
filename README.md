# NewPagedFlowView 3.2.1
### 1.实现了什么功能
* 页面滚动的方向分为横向和纵向
* 目的:实现类似于选择电影票的效果,并且实现无限/自动轮播
* 特点:1.无限轮播;2.自动轮播;3.电影票样式的层次感;4.非当前显示view具有缩放和透明的特效

### 2.版本信息

##### Version 3.2.1:

 * 添加参数(leftRightMargin、topBottomMargin)可自定义控制上下左右间距
 * 修复部分bug.
 * pageSize使用更方便
 * 增加adjustCenterSubview，卡住一半时可以调用;

**具体含义请看源代码, 如发现bug请联系:799573715@qq.com (2017-05-08)**
***
##### Version 3.1.0:

 * 添加参数控制是否支持无限轮播
 * 左右滑动透明度的bug修复.

**具体含义请看源代码, 如发现bug请联系:799573715@qq.com (2017-02-07)**
***
##### Version 3.0.0:

 * 弃用layoutSubviews，需要手动调用reloadData，方便懒加载等;
 * 子控件支持跟随父控件进行缩放；
 * 定时器添加到NSRunLoop，UIScrollview滚动时继续轮播。

**具体含义请看源代码, 如发现bug请联系:799573715@qq.com (2016-10-10)**
***
##### Version 2.0.1:

 * 是否进行自动轮播更新为参数控制,isOpenAutoScroll;
 * 解决reloadData的bug
 * 解决iOS8运行时重叠的bug

**具体含义请看源代码, 如发现bug请联系:799573715@qq.com (2016-08-30)**
***

##### Version 1.0.0:
* 页面滚动的方向分为横向和纵向
* 目的:实现类似于选择电影票的效果,并且实现无限/自动轮播
* 特点:1.无限轮播;2.自动轮播;3.电影票样式的层次感;4.非当前显示view具有缩放和透明的特效

***
### 3.动画效果
<img src="gif/NewPagedFlowViewGif.gif" width="100%">
</br>动图请移步:</br>
  <a href="http://example.com/">http://ww4.sinaimg.cn/mw690/9c6a8c79jw1f6geyiao4tg20a00dc4qu.gif</a>

### 4.功能介绍
	/**
     *  是否开启自动滚动,默认为开启
     */
    @property (nonatomic, assign) BOOL isOpenAutoScroll;
    /**
     *  是否开启无限轮播,默认为开启
     */
    @property (nonatomic, assign) BOOL isCarousel;
    /**
     * 左右间距,默认20
     */
    @property (nonatomic, assign) CGFloat leftRightMargin;

    /**
     * 上下间距,默认30
    */
    @property (nonatomic, assign) CGFloat topBottomMargin;

	/**
	 *  关闭定时器,关闭自动滚动
	 */
	- (void)stopTimer;
	
	
**代理方法的使用**

    @protocol  NewPagedFlowViewDelegate<NSObject>

	/**
	 *  单个子控件的Size
	 *
	 *  @param flowView <#flowView description#>
	 *
	 *  @return <#return value description#>
	*/
	- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView;

	@optional
	/**
	 *  滚动到了某一列
	 *
	 *  @param pageNumber <#pageNumber description#>
	 *  @param flowView   <#flowView description#>
	 */
	- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(NewPagedFlowView *)flowView;
	
	/**
     *  点击了第几个cell
     *
     *  @param subView 点击的控件
     *  @param subIndex    点击控件的index
     *
     *  @return <#return value description#>
     */
     - (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex;

	@end
	
    @protocol NewPagedFlowViewDataSource <NSObject>

    /**
    *  返回显示View的个数
    *
    *  @param flowView <#flowView description#>
    *
    *  @return <#return value description#>
    */
    - (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView;

	/**
	*  给某一列设置属性
	*
	*  @param flowView <#flowView description#>
 	*  @param index    <#index description#>
 	*  @return <#return value description#>
	*/
    - (UIView *)flowView:(NewPagedFlowView *)flowView 	cellForPageAtIndex:(NSInteger)index;

	@end

### 5.代码示例
    NewPagedFlowView *pageFlowView = [[NewPagedFlowView alloc] initWithFrame:CGRectMake(0, 64, Width, (Width - 84) * 9 / 16 + 24)];
    pageFlowView.backgroundColor = [UIColor whiteColor];
    pageFlowView.delegate = self;
    pageFlowView.dataSource = self;
    pageFlowView.minimumPageAlpha = 0.4;
    pageFlowView.minimumPageScale = 0.85;
    
    //初始化pageControl
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, pageFlowView.frame.size.height - 24 - 8, Width, 8)];
    pageFlowView.pageControl = pageControl;
    [pageFlowView addSubview:pageControl];
    [pageFlowView startTimer];
    [self.view addSubview:pageFlowView];
**具体含义请看源代码, Designed By Page,QQ:799573715 **
