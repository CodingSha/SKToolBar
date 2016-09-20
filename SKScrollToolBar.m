//
//  SKScrollToolBar.m
//  SKZQ
//
//  Created by 时刻足球 on 16/8/17.
//  Copyright © 2016年 时刻足球. All rights reserved.
//

#import "SKScrollToolBar.h"
#define items_width kScreenW / 5
#define items_gray RGBColorAlpha(126, 126, 126, 1.0)
#define items_selected_color RGBColorAlpha(80, 128, 216, 1.0)
@interface SKScrollToolBar ()
{
    NSInteger _selectedItemIndex;
    NSInteger _animationIndex;
}
/**
 *  下划线
 */
@property (nonatomic,strong)CALayer *line;
@end
@implementation SKScrollToolBar
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _selectedItemIndex = 0;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.layer.masksToBounds = NO;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
-(void)creatSubviews{
    _line = [[CALayer alloc]init];
    _line.frame = CGRectMake(0,
                             self_heights,
                             items_width,
                             3);
    _line.backgroundColor = [items_selected_color CGColor];
    [self.layer addSublayer:_line];
}
-(void)setItems:(NSArray *)items{
    _items = items;
    self.contentSize = CGSizeMake(items_width * _items.count, self.height);
    for (NSInteger i=0; i<_items.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn setTitle:_items[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular"
                                              size:14 * SKConstant];
        [btn setTitleColor:items_gray
                  forState:UIControlStateNormal];
        if (i==_selectedItemIndex) {
            [btn setTitleColor:items_selected_color
                      forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium"
                                                  size:14 * SKConstant];
        }
        btn.frame = CGRectMake(i*items_width,
                               0,
                               items_width,
                               self_heights);
        btn.tag = i + 100;
        [btn addTarget:self
                action:@selector(selectedItemBtn:)
      forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    [self creatSubviews];
}
-(void)selectedItemBtn:(UIButton *)sender{
    [self refreshItemsWithSelectedIndex:sender.tag];
    [self anmationedScrollItem:sender.tag - 100];
}

-(void)refreshItemsWithSelectedIndex:(NSInteger)tag{
    UIButton *SelBtn = (UIButton *)[self viewWithTag:tag];
    UIButton *btn = (UIButton *)[self viewWithTag:_selectedItemIndex + 100];
    [btn setTitleColor:items_gray forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular"
                                          size:14 * SKConstant];
    btn.enabled = YES;
    [SelBtn setTitleColor:items_selected_color forState:UIControlStateNormal];
    SelBtn.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium"
                                          size:14 * SKConstant];
    SelBtn.enabled = NO;
    _selectedItemIndex = tag - 100;
    __weak typeof(_line)weakLine = _line;
    [UIView animateWithDuration:1.0 animations:^{
        //
        CGRect frame = weakLine.frame;
        frame.origin.x = _selectedItemIndex * items_width;
        weakLine.frame = frame;
    } completion:^(BOOL finished) {
        //
    }];
    _callBack(_selectedItemIndex);
}

-(void)anmationedScrollItem:(NSInteger)tag{
    if (tag > _animationIndex) {
        if (tag < _items.count - 1) {
            if (self.contentOffset.x/(kScreenW / 5) + 4 <= tag) {
                [UIView animateWithDuration:0.2 animations:^{
                    self.contentOffset = CGPointMake(self.contentOffset.x + items_width, self.contentOffset.y);
                }];
            }
        }else{
            [UIView animateWithDuration:0.2 animations:^{
                self.contentOffset = CGPointMake(items_width * _items.count - kScreenW , self.contentOffset.y);
            }];
        }
    }else{
        if (tag != 0) {
            if (self.contentOffset.x/(kScreenW / 5) >= tag) {
                [UIView animateWithDuration:0.2 animations:^{
                    self.contentOffset = CGPointMake(self.contentOffset.x - items_width , self.contentOffset.y);
                }];
            }
        }else{
            [UIView animateWithDuration:0.2 animations:^{
                self.contentOffset = CGPointMake(0 , self.contentOffset.y);
            }];
        }
    }
    _animationIndex = _selectedItemIndex;
}
@end
