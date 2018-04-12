//
//  ViewController.m
//  LabelsView
//
//  Created by peipei on 2018/4/12.
//  Copyright © 2018年 peipei. All rights reserved.
//

#import "ViewController.h"
#import "LabelsView.h"

@interface ViewController ()<LabelsViewDelegate>
@property(nonatomic,strong)LabelsView *lView;
@property(nonatomic,strong)NSArray *contentArr;
@end

@implementation ViewController

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.contentArr = @[@"jfhksdf",@"safa",@"asfsaf",@"你好",@"你好你好你好你d",@"*&%&^$",@"jfhksdf",@"safa",@"asfsaf",@"你好",@"你好你好",@"*&%&^$",@"jfhksdf",@"safa",@"asfsaf",@"你好",@"你好你好你好你好",@"*&%&^$",@"jfhksdf",@"safa",@"asfsaf",@"你好",@"你好你好你好",@"*&%&^$"];
    [self demo3];
    
    
}

-(void)demo1{
    //快速创建
    self.lView = [[LabelsView alloc]initWithFrame:[UIScreen mainScreen].bounds contentArray:self.contentArr];
    [self.view addSubview:_lView];
}

-(void)demo2{
    //指定字体大小，并且自适应标签进行大小的调整
    self.lView = [[LabelsView alloc]initWithFrame:[UIScreen mainScreen].bounds contentArray:self.contentArr fontSize:15 options:AutoAdjustHeightAndWidthStyle];
    [self.view addSubview:_lView];
}

-(void)demo3{
    //可自定义多种属性，通过block可获取重新布局后view的宽高
    self.lView = [[LabelsView alloc]initWithFrame:CGRectMake(0, 80, 375, 800) contentArray:self.contentArr fontSize:14 options:AutoAdjustHeightAndWidthStyle sizeBlock:^(CGSize newSize) {
        NSLog(@"新的宽度：%f，新的高度：%f",newSize.width,newSize.height);
    }];
    self.lView.borderWidth = 0.5;
    self.lView.edge = 10;
    self.lView.space = 8;
    self.lView.selectedColor = [UIColor whiteColor];
    self.lView.selectedBackgroudColor = [UIColor orangeColor];
    self.lView.isMutiSelected = YES;
    self.lView.delegate = self;
    [self.view addSubview:_lView];
}

///////代理方法///////
//点击标签事件
-(void)touchLabelAtIndex:(NSUInteger)index{
    NSLog(@"%lu",index);
}

-(void)touchLabelAtIndex:(NSUInteger)index content:(NSString *)content{
    NSLog(@"%lu__%@",index,content);
    //传进新数组后刷新
    NSArray *newArr = @[@"sadasf",@"sfnk",@"aaaa",@"safnjvnk",@"popopopopop",@"a"];
    self.lView.contentArr = newArr;
    [self.lView reloadView];
}

//获取新的宽高
-(void)updateLabelViewFrame:(CGSize)frameSize{
    NSLog(@"新的宽度：%f，新的高度：%f",frameSize.width,frameSize.height);
}

@end
