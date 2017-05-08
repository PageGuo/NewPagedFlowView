//
//  TestViewController.m
//  NewPagedFlowViewDemo
//
//  Created by sskh on 16/8/11.
//  Copyright © 2016年 robertcell.net. All rights reserved.
//

#import "TestViewController.h"
#import "NewPagedFlowView.h"
#import "PGIndexBannerSubiew.h"

#define Width [UIScreen mainScreen].bounds.size.width

@interface TestViewController ()<NewPagedFlowViewDelegate, NewPagedFlowViewDataSource>

/**
 *  图片数组
 */
@property (nonatomic, strong) NSMutableArray *imageArray;

/**
 *  指示label
 */
@property (nonatomic, strong) UILabel *indicateLabel;

/**
 *  轮播图
 */
@property (nonatomic, strong) NewPagedFlowView *pageFlowView;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"NewPagedFlowView1";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Scroll" style:UIBarButtonItemStyleDone target:self action:@selector(gotoPage)];
    
    for (int index = 0; index < 5; index++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"Yosemite%02d",index]];
        [self.imageArray addObject:image];
    }
    
    [self setupUI];
}

#pragma mark --滚动到指定的页数
- (void)gotoPage {
    
    //产生跳转的随机数
    int value = arc4random() % self.imageArray.count;
    NSLog(@"value~~%d",value);
    
    [self.pageFlowView scrollToPage:value];
}

- (void)setupUI {
    
    
    NewPagedFlowView *pageFlowView = [[NewPagedFlowView alloc] initWithFrame:CGRectMake(0, 8, Width, Width * 9 / 16)];
    pageFlowView.backgroundColor = [UIColor whiteColor];
    pageFlowView.delegate = self;
    pageFlowView.dataSource = self;
    pageFlowView.minimumPageAlpha = 0.4;
    pageFlowView.orginPageCount = self.imageArray.count;
    pageFlowView.isOpenAutoScroll = YES;
    //初始化pageControl
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, pageFlowView.frame.size.height - 24, Width, 8)];
    pageFlowView.pageControl = pageControl;
    [pageFlowView addSubview:pageControl];
    
//    [self.view addSubview:pageFlowView];
    
    /****************************
     使用导航控制器(UINavigationController)
     如果控制器中不存在UIScrollView或者继承自UIScrollView的UI控件
     请使用UIScrollView作为NewPagedFlowView的容器View,才会显示正常,如下
     *****************************/
    
    UIScrollView *bottomScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [pageFlowView reloadData];
    [bottomScrollView addSubview:pageFlowView];
    [self.view addSubview:bottomScrollView];
    
    [bottomScrollView addSubview:pageFlowView];
    
    self.pageFlowView = pageFlowView;
    //添加到主view上
    [self.view addSubview:self.indicateLabel];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark NewPagedFlowView Delegate
- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex {
    
    NSLog(@"点击了第%ld张图",(long)subIndex + 1);
    
    self.indicateLabel.text = [NSString stringWithFormat:@"点击了第%ld张图",(long)subIndex + 1];
}

#pragma mark NewPagedFlowView Datasource
- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView {
    
    return self.imageArray.count;
}

- (UIView *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    
    PGIndexBannerSubiew *bannerView = (PGIndexBannerSubiew *)[flowView dequeueReusableCell];
    if (!bannerView) {
        bannerView = [[PGIndexBannerSubiew alloc] initWithFrame:CGRectMake(0, 0, Width, Width * 9 / 16)];
        bannerView.layer.cornerRadius = 4;
        bannerView.layer.masksToBounds = YES;
    }
    
    //在这里下载网络图片
    //[bannerView.mainImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:hostUrlsImg,imageDict[@"img"]]] placeholderImage:[UIImage imageNamed:@""]];
    bannerView.mainImageView.image = self.imageArray[index];
    
    return bannerView;
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(NewPagedFlowView *)flowView {
    
    NSLog(@"TestViewController 滚动到了第%ld页",pageNumber);
}

#pragma mark --懒加载
- (NSMutableArray *)imageArray {
    if (_imageArray == nil) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

- (UILabel *)indicateLabel {
    
    if (_indicateLabel == nil) {
        _indicateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 400, Width, 16)];
        _indicateLabel.textColor = [UIColor blueColor];
        _indicateLabel.font = [UIFont systemFontOfSize:16.0];
        _indicateLabel.textAlignment = NSTextAlignmentCenter;
        _indicateLabel.text = @"指示Label";
    }
    
    return _indicateLabel;
}

#pragma mark --旋转屏幕改变newPageFlowView大小之后实现该方法
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id)coordinator {
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        [coordinator animateAlongsideTransition:^(id context) { [self.pageFlowView reloadData]; } completion:NULL];
    }
}

- (void)dealloc {
    
    /****************************
    在dealloc或者返回按钮里停止定时器
     ****************************/
    
    [self.pageFlowView stopTimer];
}



@end
