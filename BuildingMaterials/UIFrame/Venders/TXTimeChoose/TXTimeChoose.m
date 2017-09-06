//
//  TXTimeChoose.m
//  TYSubwaySystem
//
//  Created by mac on 16/7/18.
//  Copyright © 2016年 TXZhongJiaowang. All rights reserved.
//

#import "TXTimeChoose.h"
#import "AADatePicker.h"

#define kZero 0
#define kFullWidth [UIScreen mainScreen].bounds.size.width
#define kFullHeight [UIScreen mainScreen].bounds.size.height

#define kDatePicY kFullHeight/3*2
#define kDatePicYB kFullHeight+fJFScreen(44*2)

#define kDatePicHeight kFullHeight/3

#define kDateTopBtnY kDatePicY - fJFScreen(44*2)
#define kDateTopBtnYB kFullHeight

#define kDateTopBtnHeight fJFScreen(44*2)

#define kDateTopRightBtnWidth kDateTopLeftBtnWidth

#define kDateTopLeftbtnX fJFScreen(15*2)
#define kDateTopLeftBtnWidth fJFScreen(50*2)


@interface TXTimeChoose()<AADatePickerDelegate>

@property (nonatomic,strong)AADatePicker *dateP;
@property (nonatomic,strong)UIView *groundV;
@property (nonatomic,strong)UIButton *leftBtn;
@property (nonatomic,strong)UIButton *rightBtn;
@property (nonatomic,strong)UILabel *titleLab;
@property (nonatomic,strong)UIView *topView;

@property (nonatomic,assign)UIDatePickerMode type;
@end

@implementation TXTimeChoose

- (instancetype)initWithFrame:(CGRect)frame type:(UIDatePickerMode)type{
    self = [super initWithFrame:frame];
    if (self) {
        self.type = type;
        [self addSubview:self.groundV];
        [self addSubview:self.dateP];
        [self addSubview:self.topView];
        [self.topView addSubview:self.leftBtn];
        [self.topView addSubview:self.rightBtn];
        [self.topView addSubview:self.titleLab];
        
        self.leftBtn.sd_layout
        .leftSpaceToView(self.topView, fJFScreen(kDateTopLeftbtnX*2))
        .topSpaceToView(self.topView, 0)
        .heightIs(kDateTopBtnHeight)
        .widthIs(kDateTopLeftBtnWidth);
        
        self.rightBtn.sd_layout
        .rightSpaceToView(self.topView, fJFScreen(kDateTopLeftbtnX*2))
        .topSpaceToView(self.topView, 0)
        .heightIs(kDateTopBtnHeight)
        .widthIs(kDateTopLeftBtnWidth);
        
        self.titleLab.sd_layout
        .leftSpaceToView(self.leftBtn, fJFScreen(10*2))
        .rightSpaceToView(self.rightBtn, fJFScreen(10*2))
        .topSpaceToView(self.topView, 0)
        .heightIs(kDateTopBtnHeight);
        
        [UIView animateWithDuration:0.3 animations:^{
            self.topView.frame = CGRectMake(kZero, kDateTopBtnY, kFullWidth, kDateTopBtnHeight);
            self.dateP.frame = CGRectMake(kZero, kDatePicY, kFullWidth, kDatePicHeight);
        } completion:^(BOOL finished) {
        }];
        
        [self.groundV bk_whenTapped:^{
            [UIView animateWithDuration:0.3 animations:^{
                self.topView.frame = CGRectMake(kZero, kDateTopBtnYB, kFullWidth, kDateTopBtnHeight);
                self.dateP.frame = CGRectMake(kZero, kDatePicYB, kFullWidth, kDatePicHeight);
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        }];
    }
    return self;
}

- (AADatePicker *)dateP {
    if (!_dateP) {
        
       NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDate *currentDate = [NSDate date];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        [comps setDay:60];//设置最大时间为：当前时间后推3天
        NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
        [comps setDay:0];//设置最小时间为：当前时间前推0天
        NSDate *minDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
        
        _dateP = [[AADatePicker alloc] initWithFrame:CGRectMake(kZero, kDatePicYB, kFullWidth, kDatePicHeight) maxDate:maxDate minDate:minDate showValidDatesOnly:YES];
        
        self.dateP.backgroundColor = [UIColor whiteColor];
        
        _dateP.delegate = self;
     
//        self.dateP.datePickerMode = self.type;
        
//        self.dateP.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CHS_CN"];
//        //        NSDate *maxDate = [NSDate date];
//        //        self.dateP.maximumDate = maxDate;
//        self.dateP.minuteInterval = 3;
//        
//        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//        NSDate *currentDate = [NSDate date];
//        NSDateComponents *comps = [[NSDateComponents alloc] init];
//        [comps setDay:2];//设置最大时间为：当前时间后推3天
//        NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
//        [comps setDay:0];//设置最小时间为：当前时间前推0天
//        NSDate *minDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
//        
//        [self.dateP setMaximumDate:maxDate];
//        [self.dateP setMinimumDate:minDate];
        
        
//        [self.dateP addTarget:self action:@selector(handleDateP:) forControlEvents:UIControlEventValueChanged];
    }
    return _dateP;
}

- (UIView *)groundV {
    if (!_groundV) {
        _groundV = [[UIView alloc]initWithFrame:self.bounds];
        _groundV.backgroundColor = [UIColor blackColor];
        _groundV.alpha = 0.7;
        _groundV.userInteractionEnabled = YES;
    }
    return _groundV;
}

- (UIButton *)leftBtn{
    if (!_leftBtn) {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_leftBtn setTitle:@"取消" forState:UIControlStateNormal];
        _leftBtn.titleLabel.font = [UIFont systemFontOfSize:fJFScreen(15*2)];
        [_leftBtn addTarget:self action:@selector(handleDateTopViewLeft) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.textColor = Text_Color;
        _titleLab.font = [UIFont systemFontOfSize:fJFScreen(17*2)];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.text = @"看房时间";
    }
    return _titleLab;
}

- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_rightBtn setTitle:@"确定" forState:UIControlStateNormal];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:fJFScreen(15*2)];
        [_rightBtn addTarget:self action:@selector(handleDateTopViewRight) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

- (UIView *)topView {
    if (!_topView) {
        self.topView = [[UIView alloc]initWithFrame:CGRectMake(kZero, kDateTopBtnYB, kFullWidth, kDateTopBtnHeight)];
        self.topView.backgroundColor = BG_Color;
        
    }
    return _topView;
}

- (void)setNowTime:(NSString *)dateStr{
    
    [self.dateP setDate:[self dateFromString:dateStr]];
}

- (void)end{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.topView.frame = CGRectMake(kZero, kDateTopBtnYB, kFullWidth, kDateTopBtnHeight);
        self.dateP.frame = CGRectMake(kZero, kDatePicYB, kFullWidth, kDatePicHeight);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)dateChanged:(AADatePicker *)sender {
    
    [self.delegate changeTime:self.dateP.date];
}

//- (void)handleDateP :(NSDate *)date {
//    
//    
//}

- (void)handleDateTopViewLeft {
    [self end];
}

- (void)handleDateTopViewRight {
    [self.delegate determine:self.dateP.date];
    [self end];
}



// NSDate --> NSString
- (NSString*)stringFromDate:(NSDate*)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    switch (self.type) {
        case UIDatePickerModeTime:
            [dateFormatter setDateFormat:@"HH:mm"];
            break;
         case UIDatePickerModeDate:
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            break;
        case UIDatePickerModeDateAndTime:
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            break;
        case UIDatePickerModeCountDownTimer:
            [dateFormatter setDateFormat:@"HH:mm"];
            break;
        default:
            break;
    }
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
    
}

//NSDate <-- NSString
- (NSDate*)dateFromString:(NSString*)dateString{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    switch (self.type) {
        case UIDatePickerModeTime:
            [dateFormatter setDateFormat:@"HH:mm"];
            break;
        case UIDatePickerModeDate:
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            break;
        case UIDatePickerModeDateAndTime:
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            break;
        case UIDatePickerModeCountDownTimer:
            [dateFormatter setDateFormat:@"HH:mm"];
            break;
        default:
            break;
    }
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    return destDate;
}


@end
