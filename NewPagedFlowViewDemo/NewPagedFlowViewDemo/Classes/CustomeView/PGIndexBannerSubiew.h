//
//  PGIndexBannerSubiew.h
//  NewPagedFlowViewDemo
//
//  Created by Mars on 16/6/18.
//  Copyright © 2016年 Mars. All rights reserved.
//

/******************************
 
 可以根据自己的需要再次重写view
 
 ******************************/

#import <UIKit/UIKit.h>

@interface PGIndexBannerSubiew : UIView

/**
 *  主图
 */
@property (nonatomic, strong) UIImageView *mainImageView;

/**
 *  用来变色的view
 */
@property (nonatomic, strong) UIView *coverView;

/**
 *  覆盖button
 */
@property (nonatomic, strong) UIButton *allCoverButton;

@end
