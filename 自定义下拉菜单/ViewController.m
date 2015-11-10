//
//  ViewController.m
//  自定义下拉菜单
//
//  Created by cpr on 15/11/3.
//  Copyright (c) 2015年 scsys. All rights reserved.
//

#import "ViewController.h"
#import "WNDropDownView.h"

@interface ViewController ()<WNDropDownDelegate>
@property (strong,nonatomic) WNDropDownView *dropDownView;
@property (strong,nonatomic) WNDropDownView *dropDownView2;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //在单个单元格添加图片的下拉菜单
    //初始化
    self.dropDownView=[[WNDropDownView alloc] initWithFrame:CGRectMake(50, 115, 100, 20) andTitles:@[@"向上",@"向下",@"向左",@"向右"]];
    self.dropDownView.tag=1;
//    self.dropDownView.selectedIndex = 0;
    //    self.dropDownView.image=@[@"down_dark0",@"down_dark0",@"down_dark0"];
    self.dropDownView.delegate = self;
    [self.view addSubview:self.dropDownView];
    //全部添加图片的下拉菜单
    //初始化
    self.dropDownView2=[[WNDropDownView alloc] initWithFrame:CGRectMake(180, 115, 100, 20) andTitles:@[@"向上",@"向下",@"向左",@"向右"]];
    self.dropDownView2.tag=2;
    self.dropDownView2.selectedIndex = 0;
    self.dropDownView2.image=@[@"optionUp",@"optionDown",@"optionLeft",@"optionRight"];
    self.dropDownView2.delegate = self;
    [self.view addSubview:self.dropDownView2];
}

-(void)dropDown:(WNDropDownView *)dropDown selectedAtIndex:(NSInteger)index{
    NSLog(@"selected %ld",index);
    NSLog(@"select Title : %@",dropDown.selectedTitle);
}
-(void)dropDownWillOpen:(WNDropDownView *)dropDown{
    NSLog(@"will open");
}
-(void)dropDownDidOpen:(WNDropDownView *)dropDown{
    NSLog(@"did open");
}
-(void)dropDownWillDeopen:(WNDropDownView *)dropDown{
    NSLog(@"will close");
}
-(void)dropDownDidDeopen:(WNDropDownView *)dropDown{
    NSLog(@"did close");
}
-(void)dropDownView:(WNDropDownView *)dropDown items:(WNDropDownItem *)item atIndex:(NSUInteger)index{
    if (dropDown.tag==1) {
        if (index==2) {
            NSMutableDictionary *dics=[NSMutableDictionary dictionaryWithDictionary:item.dic];
            [dics setObject:@"down_dark0" forKey:@"icon"];
            item.dic=dics;
        }
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
