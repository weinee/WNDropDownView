//
//  WNDropDownView.m
//  TKClub
//
//  Created by cpr on 15/10/30.
//  Copyright (c) 2015年 weinee. All rights reserved.
//

#import "WNDropDownView.h"
#import "WNDropDownItem.h"
#import <CoreLocation/CoreLocation.h>
static NSString *const cellId = @"WNOptionCell";

@interface WNDropDownView ()<UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>{
//    当前所选的项
    UILabel *_selectedOption;
//    打开选项和关闭选项的指示器
    UIImageView *_frontArrow;
//    所有选项
    UITableView *_optionTableView;

//    控件宽
    CGFloat _width;
//    控件高
    CGFloat _heigth;
}
@end
@implementation WNDropDownView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _width = frame.size.width;
        _heigth = frame.size.height;
        _open = NO;
        //初始化
        [self initView];
        //布局
        [self layoutView];
    }
    return self;
}
- (instancetype)initWithSize:(CGSize)size
{
    self = [super init];
    if (self) {
        _width = size.width;
        _heigth = size.height;
        _open = NO;
        //初始化
        [self initView];
        //布局
        [self layoutView];
    }
    return self;
}
//使用选项数组进行初始化
- (instancetype)initWithFrame:(CGRect)frame andTitles:(NSArray *)titles{
    self = [super initWithFrame:frame];
    if (self) {
        _width = frame.size.width;
        _heigth = frame.size.height;
        _open = NO;
        
        _titles = titles;
        //初始化
        [self initView];
        //布局
        [self layoutView];
    }
    return self;
}
-(instancetype)initWithSize:(CGSize)size andTitles:(NSArray *)titles{
    self = [super init];
    if (self) {
        _width = size.width;
        _heigth = size.height;
        _open = NO;
        
        _titles = titles;
        //初始化
        [self initView];
        //布局
        [self layoutView];
    }
    return self;
}

-(void)initView{
    _selectedOption = [[UILabel alloc] init];
    _selectedOption.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_selectedOption];
//    添加点击手势给整个视图加
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAndHiddenMenu)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    _frontArrow = [[UIImageView alloc] init];
    _frontArrow.image = [UIImage imageNamed:@"down_dark0"];//向下
    [self addSubview:_frontArrow];
//    所有选项
    _optionTableView = [[UITableView alloc] init];
    //使分割线重头开始画
    if ([_optionTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_optionTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_optionTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_optionTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    _optionTableView.dataSource = self;
    _optionTableView.delegate = self;
    _optionTableView.scrollEnabled = NO;
    [_optionTableView registerClass:[WNDropDownItem class] forCellReuseIdentifier:cellId];
    [self addSubview:_optionTableView];
}

-(void)layoutView{
    _frontArrow.frame = CGRectMake(_width-_heigth, 0, _heigth, _heigth);
    
    _selectedOption.frame = CGRectMake(0, 0, _width-_heigth, _heigth);
    
    _optionTableView.frame = CGRectMake(0, _heigth, _width, 0);
}

-(void)layoutSubviews{
    
}

#pragma mark setter
-(void)setTitles:(NSArray *)titles{
    _titles = titles;
    [_optionTableView reloadData];
}
-(void)setSelectedIndex:(NSInteger)selectedIndex{
    //当前选中项的下标
    _selectedIndex = selectedIndex;
    //当前选中项的内容
    _selectedTitle = _titles[selectedIndex];
    //显示当前选中的内容
    _selectedOption.text = _selectedTitle;

}
-(void)setOpen:(BOOL)isOpen{
    //设置是否为打开
    [self bringSubviewToFront:self.superview];
    _open = isOpen;
    if (!_open) {
        if ([self.delegate conformsToProtocol:@protocol(WNDropDownDelegate)]) {
            if ([self.delegate respondsToSelector:@selector(dropDownWillDeopen:)]) {
                [self.delegate dropDownWillDeopen:self];
            }
        }
        NSLog(@"close");
        [UIView animateWithDuration:0.3 animations:^{
            _optionTableView.frame = CGRectMake(0, _heigth, _width, 0);
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, _width, _heigth);
        } completion:^(BOOL finished) {
            _frontArrow.transform = CGAffineTransformIdentity;
            if ([self.delegate conformsToProtocol:@protocol(WNDropDownDelegate)]) {
                if ([self.delegate respondsToSelector:@selector(dropDownDidDeopen:)]) {
                    [self.delegate dropDownDidDeopen:self];
                }
            }
        }];
    } else {
        NSLog(@"open");
        if ([self.delegate conformsToProtocol:@protocol(WNDropDownDelegate)]) {
            if ([self.delegate respondsToSelector:@selector(dropDownWillOpen:)]) {
                [self.delegate dropDownWillOpen:self];
            }
        }
        _frontArrow.transform = CGAffineTransformMakeRotation(3.1415926);
        [UIView animateWithDuration:0.3 animations:^{
            _optionTableView.frame = CGRectMake(0, _heigth, _width, _heigth*_titles.count);
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, _width, _heigth*(1+_titles.count));
        } completion:^(BOOL finished) {
            if ([self.delegate conformsToProtocol:@protocol(WNDropDownDelegate)]) {
                if ([self.delegate respondsToSelector:@selector(dropDownDidOpen:)]) {
                    [self.delegate dropDownDidOpen:self];
                }
            }
        }];
    }
}
#pragma mark UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titles.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WNDropDownItem *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    cell.dic = @{
                     @"title":_titles[indexPath.row],
                     @"heigth":[NSNumber numberWithDouble:_heigth],//设置单元格内容宽和高
                     @"width":[NSNumber numberWithDouble:_width]
                     };
   
    
    return cell;
}

#pragma mark UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _heigth;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self showAndHiddenMenu];
    [_delegate dropDown:self selectedAtIndex:indexPath.row];
    self.selectedIndex = indexPath.row;
}
//使单元格分割线重头开始画, 对当前要显示的单元格进行配置
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
#pragma mark 现实和隐藏下拉菜单
-(void)showAndHiddenMenu{
    self.open = !_open;
}

#pragma mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isKindOfClass:NSClassFromString(@"UITableViewCellContentView")]) {
        return NO;
    }
    return YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
