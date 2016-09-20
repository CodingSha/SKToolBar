//
//  SKScrollToolBar.h
//  SKZQ
//
//  Created by 时刻足球 on 16/8/17.
//  Copyright © 2016年 时刻足球. All rights reserved.
//

#import <UIKit/UIKit.h>
#define self_heights 37 * SKConstant
@interface SKScrollToolBar : UIScrollView
@property (nonatomic,copy)NSArray *items;
@property (nonatomic,copy)void(^callBack)(NSInteger selectedIndex);
@end
