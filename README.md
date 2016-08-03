# NewPagedFlowView 1.0
###1.实现了什么功能
#####Version 1.1.0:

 * 简化数组,使用时只需创建一个图片数组即可
 * 解决首次加载时,直接从第一页跳到第三页的bug
 * 解决拖动时,偶尔乱跳的bug
 * 指示Label更明确
 <br>
 **具体含义请看源代码, 如发现bug请联系:799573715@qq.com (2016-08-03)**
***

#####Version 1.0:
* 页面滚动的方向分为横向和纵向
* 目的:实现类似于选择电影票的效果,并且实现无限/自动轮播
 
* 特点:1.无限轮播;2.自动轮播;3.电影票样式的层次感;4.非当前显示view具有缩放和透明的特效

###2.动画效果

![NewPagedFlowViewGif](http://code.cocoachina.com/uploads/attachments/20160802/132352/36b5a77373e3c39db3b707953ba33976.png)
</br>动图请移步:</br>
  <a href="http://example.com/">http://ww4.sinaimg.cn/mw690/9c6a8c79jw1f6geyiao4tg20a00dc4qu.gif</a>
###3.代码示例
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