//
//  LabelsView.m
//  LabelsView
//
//  Created by peipei on 2018/4/12.
//  Copyright © 2018年 peipei. All rights reserved.
//

#import "LabelsView.h"

@interface LabelsView()
@property(nonatomic,assign) CGSize contentSize;
@property(nonatomic,assign) CGPoint contentOrigin;
@property(nonatomic,strong) NSMutableArray *contentArray;   //数组内容的包装
@property(nonatomic,strong) NSMutableArray *labels;
@property(nonatomic,strong) resetBlock sizeBlock;
@end

@implementation LabelsView{
    LabelViewLayoutStyle _options;
}

-(instancetype)initWithFrame:(CGRect)frame contentArray:(NSArray*)contentArray{
    return [self initWithFrame:frame contentArray:contentArray fontSize:17];
}

-(instancetype)initWithFrame:(CGRect)frame contentArray:(NSArray*)contentArray fontSize:(CGFloat)fontsize{
    return [self initWithFrame:frame contentArray:contentArray fontSize:fontsize options:FixedBothHeightAndWidthStyle];
}

-(instancetype)initWithFrame:(CGRect)frame contentArray:(NSArray*)contentArray fontSize:(CGFloat)fontsize options:(LabelViewLayoutStyle)options{
    return [self initWithFrame:frame contentArray:contentArray fontSize:fontsize options:options sizeBlock:nil];
}

-(instancetype)initWithFrame:(CGRect)frame contentArray:(NSArray*)contentArray fontSize:(CGFloat)fontsize options:(LabelViewLayoutStyle)options sizeBlock:(resetBlock)block{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        _labels = [NSMutableArray array];
        _contentOrigin = frame.origin;
        _contentSize = frame.size;
        _contentArr = contentArray;
        _fontSize = fontsize;
        _options = options;
        _sizeBlock = block;
        
        //default property
        _borderWidth = 1;
        _cornerRadiusRate = 0.25;
        _selectedBackgroudColor = [UIColor colorWithWhite:1 alpha:0];
        _unselectedBackgroudColor = [UIColor colorWithWhite:1 alpha:0];
        _selectedColor = [UIColor redColor];
        _unselectedColor = [UIColor blackColor];
        _defaultSelected = 0;
        _hasDefualtSelected = YES;
        _edge = 18;
        _space = 15;
        _isMutiSelected = NO;
        
        [self renderLabels:self.contentArr];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self setLabelsLayouts:self.contentArray];
}

-(void)reloadView{
    for (UILabel *label in self.subviews) {
        [label removeFromSuperview];
    }
    [_contentArray removeAllObjects];
    [_labels removeAllObjects];
    [self renderLabels:self.contentArr];
}

#pragma -mark private event
-(void)renderLabels:(NSArray*)contentArr{
    
    _contentArray = [[NSMutableArray alloc]init];
    for (int i=0; i<contentArr.count; i++) {
        NSDictionary *dic = [[NSDictionary dictionaryWithObjectsAndKeys:contentArr[i],@"content",@(NO),@"isSelected",@(i),@"arrIndex",nil] mutableCopy];
        [_contentArray setObject:dic atIndexedSubscript:i];
        
    }
    for (NSDictionary *strDic in _contentArray) {
        UILabel *label = [[UILabel alloc]init];
        [_labels addObject:label];
        label.text = strDic[@"content"];
        label.tag = [strDic[@"arrIndex"] intValue];
        label.textAlignment = NSTextAlignmentCenter;
        label.userInteractionEnabled = YES;
        label.numberOfLines = 1;
        [self addSubview:label];
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapLabel:)];
        [label addGestureRecognizer:tapGes];
    }
}

-(void)setLabelsLayouts:(NSArray*)contentArray{
    
    CGFloat edge = self.edge;
    CGFloat edgeTop = edge;
    CGFloat edgeLeft = edge;
    CGFloat space = self.space;
    
    int count=1;
    CGFloat rowHeight = 0.0;
    CGFloat totalHeight=0;
    CGFloat totalWidth=0;
    
    if (self.hasDefualtSelected) {
        if (self.defaultSelected<contentArray.count) {
            contentArray[self.defaultSelected][@"isSelected"] = @(YES);
        }else{
            NSLog(@"The default index beyonds array's count");
        }
    }
    
    for (NSDictionary *strDic in self.contentArray) {
        UILabel *label = _labels[[strDic[@"arrIndex"] intValue]];
        
        CGSize labelSize = [self labelAutoCalculateRectWith:strDic[@"content"] FontSize:self.fontSize MaxSize:_contentSize];
        CGFloat labelHeight = labelSize.height+10;
        rowHeight = labelHeight;
        CGFloat labelWidth = labelSize.width+labelHeight/2;
        totalWidth = totalWidth+labelWidth+space;
        
        if(labelWidth>_contentSize.width-edge*2){
            labelWidth=_contentSize.width-edge*2;
        }
        if ((edgeLeft+labelWidth+edge)>_contentSize.width) {
            edgeTop = edgeTop+labelHeight+space;
            edgeLeft = edge;
            count++;
        }
        
        label.frame = CGRectMake(edgeLeft, edgeTop, labelWidth, labelHeight);
        label.font = [UIFont systemFontOfSize:self.fontSize];
        label.layer.masksToBounds = YES;
        label.layer.borderWidth = self.borderWidth;
        label.layer.cornerRadius = labelHeight * self.cornerRadiusRate;
        if ([strDic[@"isSelected"] boolValue]) {
            label.textColor = self.selectedColor;
            label.layer.borderColor = [self.selectedColor CGColor];
            label.backgroundColor = self.selectedBackgroudColor;
        }else{
            label.textColor = self.unselectedColor;
            label.layer.borderColor = [self.unselectedColor CGColor];
            label.backgroundColor = self.unselectedBackgroudColor;
        }
        
        edgeLeft=edgeLeft+labelWidth+space;
    }
    
    if (_contentArray.count) {
        totalHeight = edge*2+count*rowHeight+(count-1)*space;
        totalWidth = totalWidth+edge*2-space;
    }
    if (_options == AutoAdjustHeightAndWidthStyle) {
        if (_contentSize.width>totalWidth) {
            _contentSize.width = totalWidth;
        }
        self.frame = CGRectMake(_contentOrigin.x, _contentOrigin.y, _contentSize.width, totalHeight);
        if(_sizeBlock){
            _sizeBlock(CGSizeMake(_contentSize.width, totalHeight));
        }
        if ([self.delegate respondsToSelector:@selector(updateLabelViewFrame:)]) {
            [self.delegate updateLabelViewFrame:self.frame.size];
        }
    }
}

- (CGSize)labelAutoCalculateRectWith:(NSString *)text FontSize:(CGFloat)fontSize MaxSize:(CGSize)maxSize{
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    NSDictionary * attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize], NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize labelSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    labelSize.height = ceil(labelSize.height);
    labelSize.width = ceil(labelSize.width);
    return labelSize;
}

-(void)tapLabel:(UITapGestureRecognizer*)sender{
    UILabel *label = _labels[sender.view.tag];
    if (_isMutiSelected) {
        NSMutableDictionary *labelState = _contentArray[sender.view.tag];
        if ([labelState[@"isSelected"] boolValue]) {
            label.textColor = self.unselectedColor;
            label.layer.borderColor = self.unselectedColor.CGColor;
            label.backgroundColor = self.unselectedBackgroudColor;
            labelState[@"isSelected"] = @(NO);
        }else{
            label.textColor = self.selectedColor;
            label.layer.borderColor = self.selectedColor.CGColor;
            label.backgroundColor = self.selectedBackgroudColor;
            labelState[@"isSelected"] = @(YES);
        }
    }else{
        for (int i=0; i<_contentArray.count; i++) {
            if (i==sender.view.tag) {
                UILabel *label = _labels[i];
                label.textColor = self.selectedColor;
                label.layer.borderColor = self.selectedColor.CGColor;
                label.backgroundColor = self.selectedBackgroudColor;
            }else{
                UILabel *label = _labels[i];
                label.textColor = self.unselectedColor;
                label.layer.borderColor = self.unselectedColor.CGColor;
                label.backgroundColor = self.unselectedBackgroudColor;
            }
        }
    }
    if ([self.delegate respondsToSelector:@selector(touchLabelAtIndex:)]) {
        [self.delegate touchLabelAtIndex:sender.view.tag];
    }
    if ([self.delegate respondsToSelector:@selector(touchLabelAtIndex:content:)]) {
        [self.delegate touchLabelAtIndex:sender.view.tag content:label.text];
    }
}
@end

