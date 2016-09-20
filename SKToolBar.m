//
//  SKToolBar.m
//  SKZQ
//
//  Created by 时刻足球 on 16/7/11.
//  Copyright © 2016年 时刻足球. All rights reserved.
//

#import "SKToolBar.h"
#define items_width _frame.size.width/_items.count
#define items_gray RGBColorAlpha(42, 51, 66, 1.0)
#define items_selected_color RGBColorAlpha(80, 128, 216, 1.0)

@interface SKToolBar()
{
    BOOL _isSetColor;
    BOOL _isSetSelectedColor;
    CGRect _frame;
}
/**
 *  下划线
 */
@property (nonatomic,strong)CALayer *line;
@end
@implementation SKToolBar
/**
 *  初始化
 *
 *  @param frame    frame
 *  @param items    必须传装有字符串的数组
 *  @param index    初始选中的index
 *  @param callBack 回调函数
 *
 *  @return self
 */
-(id)initWithFrame:(CGRect)frame
             items:(NSArray *)items
     selectedIndex:(NSInteger)index
          callBack:(void (^)(NSInteger))callBack{
    
    if (self = [super initWithFrame:frame]) {
        _frame = frame;
        self.frame = CGRectMake(0,
                                _frame.origin.y,
                                _frame.size.width,
                                _frame.size.height * SKConstant);
        _items = items;
        _selectedIndex = index;
        _callBack = [callBack copy];
        self.backgroundColor = [UIColor whiteColor];
        [self creatUI];
    }
    return self;
}
/**
 *  创建items以及line
 */
-(void)creatUI{
    for (NSInteger i=0; i<_items.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn setTitle:_items[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15 * SKConstant];
        [btn setTitleColor:items_gray
                  forState:UIControlStateNormal];
        if (i==_selectedIndex) {
            [btn setTitleColor:_isSetSelectedColor ? _itemSelectedColor : items_selected_color
                      forState:UIControlStateNormal];
        }
        btn.frame = CGRectMake(i*items_width,
                               0,
                               items_width,
                               _frame.size.height * SKConstant);
        btn.tag = i + 100;
        [btn addTarget:self
                action:@selector(selectedItemBtn:)
      forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    _line = [[CALayer alloc]init];
    _line.frame = CGRectMake(_selectedIndex*items_width,
                             _frame.size.height * SKConstant,
                             items_width,
                             2);
    _line.backgroundColor = [items_selected_color CGColor];
    [self.layer addSublayer:_line];
}
-(void)setHiddenLine:(BOOL)hiddenLine{
    _hiddenLine = hiddenLine;
    _line.hidden = _hiddenLine;
}
/**
 *  点击了itme之后刷新界面,以及回调刷新外界界面的block
 */
-(void)selectedItemBtn:(UIButton *)sender{
    _selectedIndex = sender.tag;
    [self refreshItems];
    _callBack(_selectedIndex - 100);
}
/**
 *  外界界面滑动之后调用次方法刷新item以及线的UI
 */
-(void)scrollToselectedItem:(NSNotification *)noti{
    _selectedIndex = [[noti object] integerValue] + 100;
    [self refreshItems];
}
/**
 *  刷新线的位置以及itme的颜色
 */
-(void)refreshItems{
    for (NSInteger i=0; i<_items.count; i++) {
        SKLog(@"%@",NSStringFromClass([[self viewWithTag:i + 100] class]));
        UIButton *btn = (UIButton *)[self viewWithTag:i + 100];
        [btn setTitleColor:_isSetColor ? _itemColor : items_gray
                  forState:UIControlStateNormal];
        if (i + 100 ==_selectedIndex) {
            [btn setTitleColor:_isSetSelectedColor ? _itemSelectedColor : items_selected_color
                      forState:UIControlStateNormal];
        }
    }
    __weak typeof(_line)weakLine = _line;
    [UIView animateWithDuration:0.618 animations:^{
        //
        CGRect frame = weakLine.frame;
        frame.origin.x = (_selectedIndex - 100) * items_width;
        weakLine.frame = frame;
    } completion:^(BOOL finished) {
        //
    }];
}
-(void)setItemFont:(UIFont *)itemFont{
    _itemFont = itemFont;
    for (NSInteger i=0; i<_items.count; i++) {
        UIButton *btn = (UIButton *)[self viewWithTag:i + 100];
        btn.titleLabel.font = _itemFont;
    }
}
-(void)setItemColor:(UIColor *)itemColor{
    _itemColor = itemColor;
    _isSetColor = YES;
    for (NSInteger i=0; i<_items.count; i++) {
        UIButton *btn = (UIButton *)[self viewWithTag:i + 100];
        if (!(i+100 == _selectedIndex)) {
            [btn setTitleColor:_itemColor forState:UIControlStateNormal];
        }
    }
}
-(void)setItemSelectedColor:(UIColor *)itemSelectedColor{
    _itemSelectedColor = itemSelectedColor;
    _isSetSelectedColor = YES;
    UIButton *btn = [self viewWithTag:_selectedIndex + 100];
    [btn setTitleColor:_itemSelectedColor forState:UIControlStateNormal];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)setObserverName:(NSString *)observerName{
    _observerName = observerName;
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(scrollToselectedItem:)
                                                name:_observerName
                                              object:nil];
}
@end
