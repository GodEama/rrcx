//
//  DateView.m
//  nq
//
//  Created by 一仓科技 on 15/12/18.
//  Copyright © 2015年 yckj. All rights reserved.
//

#import "DateView.h"
#import "AppDelegate.h"

#define TITLE_HEIGHT 40

@interface DateView ()

@property (nonatomic, retain) UIDatePicker *datePicker;
@property (nonatomic, retain) UIView *backgroundView;
@property (nonatomic, retain) UILabel *titleLable;

@end

@implementation DateView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        
        [self initializationView];
        self.maxDate = [NSDate distantFuture];
        self.minDate = [NSDate distantPast];
    }
    return self;
}

- (void)initializationView {
    
    _backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    _backgroundView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.500];
    [self addSubview:_backgroundView];
    
    UIView *rootView = [[UIView alloc] init];
    rootView.translatesAutoresizingMaskIntoConstraints = NO;
    rootView.backgroundColor = [UIColor whiteColor];
    [self addSubview:rootView];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:rootView
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:0
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1
                                                      constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:rootView
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:0
                                                        toItem:self
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1
                                                      constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:rootView
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:0
                                                        toItem:self
                                                     attribute:NSLayoutAttributeWidth
                                                    multiplier:1
                                                      constant:0]];
    
    UIView *titleView = [[UIView alloc] init];
    titleView.translatesAutoresizingMaskIntoConstraints = NO;
    titleView.backgroundColor = [UIColor whiteColor];
    [rootView addSubview:titleView];
    
    _titleLable = [[UILabel alloc] init];
    _titleLable.translatesAutoresizingMaskIntoConstraints = NO;
    _titleLable.textColor = [UIColor blackColor];
    _titleLable.font = [UIFont systemFontOfSize:16];
    [titleView addSubview:_titleLable];
    [titleView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLable
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:0
                                                             toItem:titleView
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1
                                                           constant:0]];
    [titleView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLable
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:0
                                                             toItem:titleView
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1
                                                           constant:0]];
    
    UIView *line = [[UIView alloc] init];
    line.translatesAutoresizingMaskIntoConstraints = NO;
    line.backgroundColor = [UIColor colorWithWhite:0.839 alpha:1.000];
    [rootView addSubview:line];
    
    [rootView addConstraint:[NSLayoutConstraint constraintWithItem:line
                                                         attribute:NSLayoutAttributeBottom
                                                         relatedBy:0
                                                            toItem:titleView
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1
                                                          constant:0]];
    [rootView addConstraint:[NSLayoutConstraint constraintWithItem:line
                                                         attribute:NSLayoutAttributeWidth
                                                         relatedBy:0
                                                            toItem:rootView
                                                         attribute:NSLayoutAttributeWidth
                                                        multiplier:1
                                                          constant:0]];
    [rootView addConstraint:[NSLayoutConstraint constraintWithItem:line
                                                         attribute:NSLayoutAttributeCenterX
                                                         relatedBy:0
                                                            toItem:rootView
                                                         attribute:NSLayoutAttributeCenterX
                                                        multiplier:1
                                                          constant:0]];
    [rootView addConstraint:[NSLayoutConstraint constraintWithItem:line
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:0
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeHeight
                                                        multiplier:1
                                                          constant:0.5]];
    
    _datePicker = [[UIDatePicker alloc] init];
    _datePicker.translatesAutoresizingMaskIntoConstraints = NO;
    
    
#pragma mark 设置datePicker时间
    _datePicker.date = [NSDate date];
    _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    _datePicker.minuteInterval = 10;
    [rootView addSubview:_datePicker];
    
    UIButton *defineButton = [UIButton buttonWithType:UIButtonTypeCustom];
    defineButton.translatesAutoresizingMaskIntoConstraints = NO;
    defineButton.exclusiveTouch = YES;
    defineButton.layer.masksToBounds = YES;
    [defineButton setTitle:@"确认" forState:UIControlStateNormal];
    [defineButton setTitleColor:[UIColor colorWithRed:0.875 green:0.184 blue:0.271 alpha:1.000] forState:UIControlStateNormal];
    defineButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [defineButton addTarget:self action:@selector(defineButton:) forControlEvents:UIControlEventTouchUpInside];
    [rootView addSubview:defineButton];
    
    [defineButton addConstraint:[NSLayoutConstraint constraintWithItem:defineButton
                                                             attribute:NSLayoutAttributeHeight
                                                             relatedBy:0
                                                                toItem:nil
                                                             attribute:NSLayoutAttributeHeight
                                                            multiplier:1
                                                              constant:40]];
    [rootView addConstraint:[NSLayoutConstraint constraintWithItem:defineButton
                                                         attribute:NSLayoutAttributeRight
                                                         relatedBy:0
                                                            toItem:rootView
                                                         attribute:NSLayoutAttributeRight
                                                        multiplier:1
                                                          constant:-10]];
    [rootView addConstraint:[NSLayoutConstraint constraintWithItem:defineButton
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:0
                                                            toItem:rootView
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1
                                                          constant:0]];
    
    [rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[titleView(TITLE_HEIGHT)][_datePicker]|"
                                                                     options:0
                                                                     metrics:@{@"TITLE_HEIGHT" : @(TITLE_HEIGHT)}
                                                                       views:NSDictionaryOfVariableBindings(titleView, _datePicker)]];
    [rootView addConstraint:[NSLayoutConstraint constraintWithItem:titleView
                                                         attribute:NSLayoutAttributeWidth
                                                         relatedBy:0
                                                            toItem:rootView
                                                         attribute:NSLayoutAttributeWidth
                                                        multiplier:1
                                                          constant:0]];
    [rootView addConstraint:[NSLayoutConstraint constraintWithItem:titleView
                                                         attribute:NSLayoutAttributeCenterX
                                                         relatedBy:0
                                                            toItem:rootView
                                                         attribute:NSLayoutAttributeCenterX
                                                        multiplier:1
                                                          constant:0]];
    [rootView addConstraint:[NSLayoutConstraint constraintWithItem:_datePicker
                                                         attribute:NSLayoutAttributeLeft
                                                         relatedBy:0
                                                            toItem:rootView
                                                         attribute:NSLayoutAttributeLeft
                                                        multiplier:1
                                                          constant:0]];
    [rootView addConstraint:[NSLayoutConstraint constraintWithItem:_datePicker
                                                         attribute:NSLayoutAttributeRight
                                                         relatedBy:0
                                                            toItem:rootView
                                                         attribute:NSLayoutAttributeRight
                                                        multiplier:1
                                                          constant:0]];
}

- (void)setTitle:(NSString *)title {
    
    _title = title;
    _titleLable.text = _title;
}

- (void)setMaxDate:(NSDate *)maxDate {
    
    _maxDate = maxDate;
    _datePicker.maximumDate = maxDate;
}

- (void)setMinDate:(NSDate *)minDate {
    
    _minDate = minDate;
    _datePicker.minimumDate = minDate;
}

- (void)defineButton:(UIButton *)sender {
    
    if (_block) {
        
        static NSDateFormatter *dateFormatter = nil;
        if (!dateFormatter) {
            
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        }
        NSString *time = [dateFormatter stringFromDate:_datePicker.date];
        time = [NSString stringWithFormat:@"%@0", [time substringToIndex:time.length - 1]];
        _block([dateFormatter dateFromString:time]);
    }
    [self dismiss];
}

- (void)showInWindow {
    
    self.alpha = 0;
    
    AppDelegate *appDelegate = APPDELEGATE;
    [appDelegate.window addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.alpha = 1;
    }];
}

- (void)dismiss {
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         
                         self.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         
                         [self removeFromSuperview];
                     }];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    if ([touch.view isEqual:_backgroundView]) {
        
        [self dismiss];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
