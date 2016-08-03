# NewPagedFlowView 1.0
###1.实现了什么功能
页面滚动的方向分为横向和纵向

Version 1.0:

目的:实现类似于选择电影票的效果,并且实现无限/自动轮播
 
特点:1.无限轮播;2.自动轮播;3.电影票样式的层次感;4.非当前显示view具有缩放和透明的特效

###2.动画效果
![NewPagedFlowViewGif](http://i2.piimg.com/1949/5e994658e6176a7d.gif)

###3.代码示例
    NewPagedFlowView *pageFlowView = [[NewPagedFlowView alloc] initWithFrame:CGRectMake(0, 64, Width, (Width - 84) * 9 / 16 + 24)];
    pageFlowView.backgroundColor = [UIColor whiteColor];
    pageFlowView.delegate = self;
    pageFlowView.dataSource = self;
    pageFlowView.minimumPageAlpha = 0.4;
    pageFlowView.minimumPageScale = 0.85;
    pageFlowView.orginPageCount = self.imageArray.count;
    
    //初始化pageControl
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, pageFlowView.frame.size.height - 24 - 8, Width, 8)];
    pageFlowView.pageControl = pageControl;
    [pageFlowView addSubview:pageControl];
    [pageFlowView startTimer];
    [self.view addSubview:pageFlowView];
**具体含义请看源代码, Designed By Page,QQ:799573715 **