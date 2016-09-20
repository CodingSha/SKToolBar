//
//  SKToolBar.h
//  SKZQ
//
//  Created by 时刻足球 on 16/7/11.
//  Copyright © 2016年 时刻足球. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  通知字段
 *  @当滑动时间触发之后需要发送此通知回来,用于刷新item的UI
 */
@interface SKToolBar : UIView

@property (nonatomic,copy)NSArray *items;
@property (nonatomic,assign)NSInteger selectedIndex;
@property (nonatomic,assign)BOOL hiddenLine;
@property (nonatomic,strong)UIFont *itemFont;
@property (nonatomic,strong)UIColor *itemColor;
@property (nonatomic,strong)UIColor *itemSelectedColor;
@property (nonatomic,copy)void(^callBack)(NSInteger selectedIndex);
@property (nonatomic,copy)NSString *observerName;
/**
 *  初始化
 *
 *  @param frame    frame_只有y坐标起作用
 *  @param items    包含title的数组
 *  @param index    初始选中index
 *  @param callBack 回调函数
 *
 *  @return self
 */
-(id)initWithFrame:(CGRect)frame
             items:(NSArray *)items
     selectedIndex:(NSInteger)index
          callBack:(void(^)(NSInteger selectedIndex))callBack;
@end
