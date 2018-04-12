//
//  LabelsView.h
//  LabelsView
//
//  Created by peipei on 2018/4/12.
//  Copyright © 2018年 peipei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,LabelViewLayoutStyle) {
    FixedBothHeightAndWidthStyle=0,
    AutoAdjustHeightAndWidthStyle=1,
};

typedef void (^resetBlock)(CGSize newSize);

@protocol LabelsViewDelegate<NSObject>
@optional
/*********************代理方法，点击事件代理和重新计算宽高的回调**************************/
-(void)touchLabelAtIndex:(NSUInteger)index;
-(void)touchLabelAtIndex:(NSUInteger)index content:(NSString*)content;
-(void)updateLabelViewFrame:(CGSize)frameSize;
@end

@interface LabelsView : UIView

/*********************传入要显示的内容数组**************************/
@property(nonatomic,strong) NSArray *contentArr;

/*********************字体大小**************************/
@property(nonatomic,assign)CGFloat fontSize;

/*********************选中时和未选中时的边框以及字体颜色**************************/
@property(nonatomic,strong)UIColor* selectedColor;
@property(nonatomic,strong)UIColor* unselectedColor;

/*********************是否有初始选中的标签，如果有选中的下标是多少**************************/
@property(nonatomic,assign)BOOL hasDefualtSelected;
@property(nonatomic,assign)NSUInteger defaultSelected;

/*********************标签和view的内边距**************************/
@property(nonatomic,assign)CGFloat edge;

/*********************标签之间的间距**************************/
@property(nonatomic,assign)CGFloat space;

/*********************是否可以多选**************************/
@property(nonatomic,assign)BOOL isMutiSelected;

/*********************标签边框宽度**************************/
@property(nonatomic,assign)CGFloat borderWidth;

/*********************标签边框圆角率**************************/
@property(nonatomic,assign)CGFloat cornerRadiusRate;

/*********************选中时和未选中时的标签背景颜色**************************/
@property(nonatomic,strong)UIColor *selectedBackgroudColor;
@property(nonatomic,strong)UIColor *unselectedBackgroudColor;

@property(nonatomic,weak)id<LabelsViewDelegate> delegate;
-(instancetype)initWithFrame:(CGRect)frame contentArray:(NSArray*)contentArray;
-(instancetype)initWithFrame:(CGRect)frame contentArray:(NSArray*)contentArray fontSize:(CGFloat)fontsize;
-(instancetype)initWithFrame:(CGRect)frame contentArray:(NSArray*)contentArray fontSize:(CGFloat)fontsize options:(LabelViewLayoutStyle)options;
-(instancetype)initWithFrame:(CGRect)frame contentArray:(NSArray*)contentArray fontSize:(CGFloat)fontsize options:(LabelViewLayoutStyle)options sizeBlock:(resetBlock)block;
-(void)reloadView;

@end

