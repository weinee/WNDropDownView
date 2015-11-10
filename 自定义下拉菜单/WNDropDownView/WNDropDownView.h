//
//  WNDropDownView.h
//  TKClub
//
//  Created by cpr on 15/10/30.
//  Copyright (c) 2015年 weinee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WNDropDownView;
@protocol WNDropDownDelegate <NSObject>

-(void)dropDown:(WNDropDownView *)dropDown selectedAtIndex:(NSInteger)index;

@optional
/**
 *  将要打开的代理
 *
 *  @param dropDown 下拉菜单
 */
-(void)dropDownWillOpen:(WNDropDownView *)dropDown;
/**
 *  将要关闭的代理
 *
 *  @param dropDown 下拉菜单
 */
-(void)dropDownWillDeopen:(WNDropDownView *)dropDown;
/**
 *  已经打开的代理
 *
 *  @param dropDown 下拉菜单
 */
-(void)dropDownDidOpen:(WNDropDownView *)dropDown;
/**
 *  已经关闭的代理
 *
 *  @param dropDown 下拉菜单
 */
-(void)dropDownDidDeopen:(WNDropDownView *)dropDown;
@end

@interface WNDropDownView : UIView
//标题数组,选项
@property(nonatomic, strong)NSArray *titles;

@property(nonatomic, strong)NSString *currentTitle;
//当前显示的内容(和标题数组下标是相对应的)
@property(nonatomic, strong, readonly)NSString *selectedTitle;
//当前选中的下标
@property(nonatomic, assign)NSInteger selectedIndex;
@property(nonatomic, strong)id<WNDropDownDelegate>delegate;
//菜单是否展开
@property(nonatomic, assign, getter=isOpen)BOOL open;

//使用尺寸进行初始化，适用于自动布局
- (instancetype)initWithSize:(CGSize)size;
//使用标题数组进行初始化
- (instancetype)initWithFrame:(CGRect)frame andTitles:(NSArray *)titles;
- (instancetype)initWithSize:(CGSize)size andTitles:(NSArray *)titles;
@end