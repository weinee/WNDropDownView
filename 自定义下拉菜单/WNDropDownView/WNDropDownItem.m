//
//  WNDropDownItem.m
//  TKClub
//
//  Created by cpr on 15/10/30.
//  Copyright (c) 2015年 weinee. All rights reserved.
//

#import "WNDropDownItem.h"

@implementation WNDropDownItem{
//    图标
    UIImageView *_icon;
//    标题
    UILabel *_title;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
        
    }
    return self;
}

-(void)initView{
    _icon = [[UIImageView alloc] init];
    [self.contentView addSubview:_icon];
    
    _title = [[UILabel alloc] init];
    _title.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_title];
}

-(void)layoutView{
    CGFloat heigth = [_dic[@"heigth"] doubleValue];
    CGFloat width = [_dic[@"width"] doubleValue];
    
    _icon.frame = CGRectMake(2, 2, heigth-4, heigth-4);
    
    _title.frame = CGRectMake(_icon.frame.origin.x+8, 0, width-8, heigth);
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self layoutView];
    
    _icon.image = [UIImage imageNamed:_dic[@"icon"]];
    _title.text = _dic[@"title"];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}

@end
