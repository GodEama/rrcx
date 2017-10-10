//
//  DatePicker.m
//  school
//
//  Created by BW on 15/7/23.
//  Copyright (c) 2015年 bw. All rights reserved.
//

#import "DatePicker.h"
#import "AppDelegate.h"

@interface DatePicker ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, retain) UIDatePicker *datePicker;
@property (nonatomic, retain) UIPickerView *pickerView;
@property (nonatomic, retain) NSDateFormatter *yearDateFormatter;
@property (nonatomic, retain) NSDateFormatter *monthDateFormatter;

@end

@implementation DatePicker

- (instancetype)init {
    
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        
        [self initializationData];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        self.frame = [UIScreen mainScreen].bounds;
        [self initializationData];
    }
    return self;
}

- (void)initializationData {
    
    _minDate = [NSDate distantPast];
    _maxDate = [NSDate distantFuture];
}

- (void)initializationView {
 
    self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.5];
    
    UIView *view = [[UIView alloc] init];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    view.backgroundColor = [UIColor whiteColor];
    [self addSubview:view];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:0
                                                        toItem:self
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1
                                                      constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:0
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1
                                                      constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:0
                                                        toItem:self
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1
                                                      constant:0]];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    button.exclusiveTouch = YES;
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:0.875 green:0.184 blue:0.271 alpha:1.000] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [view addSubview:button];
    
    [button addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                       attribute:NSLayoutAttributeHeight
                                                       relatedBy:0
                                                          toItem:nil
                                                       attribute:NSLayoutAttributeHeight
                                                      multiplier:1
                                                        constant:40]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:0
                                                        toItem:view
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1
                                                      constant:-10]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:0
                                                        toItem:view
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1
                                                      constant:0]];
    UIView *line = [[UIView alloc] init];
    line.translatesAutoresizingMaskIntoConstraints = NO;
    line.backgroundColor = [UIColor colorWithWhite:0.839 alpha:1.000];
    [view addSubview:line];
    
    [line addConstraint:[NSLayoutConstraint constraintWithItem:line
                                                       attribute:NSLayoutAttributeHeight
                                                       relatedBy:0
                                                          toItem:nil
                                                       attribute:NSLayoutAttributeHeight
                                                      multiplier:1
                                                        constant:0.5]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:line
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:0
                                                        toItem:view
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1
                                                      constant:0]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:line
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:0
                                                        toItem:view
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1
                                                      constant:0]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:line
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:0
                                                        toItem:view
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1
                                                      constant:39]];
    
    if (_type == 0) {
        
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.translatesAutoresizingMaskIntoConstraints = NO;
        _datePicker.date = _defaultDate?_defaultDate:[NSDate date];
        _datePicker.backgroundColor = [UIColor whiteColor];
        _datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        _datePicker.maximumDate = _maxDate;
        _datePicker.minimumDate = _minDate;
        [_datePicker setDatePickerMode:UIDatePickerModeDate];
        [view addSubview:_datePicker];
        
        [view addConstraint:[NSLayoutConstraint constraintWithItem:_datePicker
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:0
                                                            toItem:view
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1
                                                          constant:40]];
        [view addConstraint:[NSLayoutConstraint constraintWithItem:_datePicker
                                                         attribute:NSLayoutAttributeBottom
                                                         relatedBy:0
                                                            toItem:view
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1
                                                          constant:0]];
        [view addConstraint:[NSLayoutConstraint constraintWithItem:_datePicker
                                                         attribute:NSLayoutAttributeCenterX
                                                         relatedBy:0
                                                            toItem:view
                                                         attribute:NSLayoutAttributeCenterX
                                                        multiplier:1
                                                          constant:0]];
    }
    else if (_type == 1) {
        
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.translatesAutoresizingMaskIntoConstraints = NO;
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _yearDateFormatter = [[NSDateFormatter alloc] init];
        [_yearDateFormatter setDateFormat:@"yyyy"];
        _monthDateFormatter = [[NSDateFormatter alloc] init];
        [_monthDateFormatter setDateFormat:@"MM"];
        [view addSubview:_pickerView];
        
        [view addConstraint:[NSLayoutConstraint constraintWithItem:_pickerView
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:0
                                                            toItem:view
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1
                                                          constant:30]];
        [view addConstraint:[NSLayoutConstraint constraintWithItem:_pickerView
                                                         attribute:NSLayoutAttributeBottom
                                                         relatedBy:0
                                                            toItem:view
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1
                                                          constant:0]];
        [view addConstraint:[NSLayoutConstraint constraintWithItem:_pickerView
                                                         attribute:NSLayoutAttributeCenterX
                                                         relatedBy:0
                                                            toItem:view
                                                         attribute:NSLayoutAttributeCenterX
                                                        multiplier:1
                                                          constant:0]];
        [self timeLocation];
    }
}

- (void)buttonPressed:(UIButton *)sender {
    
    if (_endBlock) {
        
        if (_type == 0) {
            
            _endBlock(_datePicker.date);
        }
        else if (_type == 1) {
            
            NSInteger nowYear = [[_yearDateFormatter stringFromDate:[NSDate date]] integerValue];
            
            NSInteger year = [_pickerView selectedRowInComponent:0] + nowYear - 25;
            
            NSInteger month = [_pickerView selectedRowInComponent:1] + 1;
            
            NSString *dateString = [NSString stringWithFormat:@"%@-%@", @(year), @(month)];
            
            static NSDateFormatter *dateFormatter;
            if (!dateFormatter) {
                
                dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-M"];
            }
            _endBlock([dateFormatter dateFromString:dateString]);
        }
    }
    [self removeFromSuperview];
}

- (void)setMinDate:(NSDate *)minDate {
    
    if (!minDate) {
        
        return;
    }
    _minDate = minDate;
    _datePicker.minimumDate = minDate;
}

- (void)setMaxDate:(NSDate *)maxDate {
    
    if (!maxDate) {
        
        return;
    }
    _maxDate = maxDate;
    _datePicker.maximumDate = maxDate;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self removeFromSuperview];
}

- (void)showInWindow {
    
    [self initializationView];
    
    AppDelegate *appDelegate = APPDELEGATE;
    [appDelegate.window addSubview:self];
}

/**
 *  定位到当前时间(包含越界)
 */
- (void)timeLocation {
    
    NSInteger minYear = [[_yearDateFormatter stringFromDate:_minDate] integerValue];
    NSInteger year = [[_yearDateFormatter stringFromDate:[NSDate date]] integerValue];
    NSInteger maxYear = [[_yearDateFormatter stringFromDate:_maxDate] integerValue];
    
    NSInteger month = [[_monthDateFormatter stringFromDate:[NSDate date]] integerValue];
    
    if (minYear > maxYear) {
        
        NSInteger year = minYear;
        minYear = maxYear;
        maxYear = year;
    }
    if (minYear < year - 25) {
        
        minYear = year - 25;
    }
    if (maxYear > year + 24) {
        
        maxYear = year + 24;
    }
    if (minYear > year) {
        
        year = minYear;
    }
    if (maxYear < year) {
        
        year = maxYear;
    }
    if (minYear == year || maxYear == year) {
        
        NSInteger minMonth = [[_monthDateFormatter stringFromDate:_minDate] integerValue];
        NSInteger maxMonth = [[_monthDateFormatter stringFromDate:_maxDate] integerValue];
        
        if (minYear == maxYear && minMonth > maxYear) {
            
            NSInteger month = minMonth;
            minMonth = maxMonth;
            maxMonth = month;
        }
        if (minMonth > month && minYear == year) {
            
            month = minMonth;
        }
        if (maxMonth < month && maxYear == year) {
            
            month = maxMonth;
        }
    }
    [self pickerViewSelectWithYear:year month:month];
}

/**
 *  时间越界判断
 */
- (void)timeBorder {
    
    if ([_maxDate timeIntervalSinceDate:_minDate] < 0) {
        
        NSDate *date = _maxDate;
        _maxDate = _minDate;
        _minDate = date;
    }
    
    NSInteger nowYear = [[_yearDateFormatter stringFromDate:[NSDate date]] integerValue];
    
    NSInteger year = [_pickerView selectedRowInComponent:0] + nowYear - 25;
    
    NSInteger month = [_pickerView selectedRowInComponent:1] + 1;
    
    NSInteger minYear = [[_yearDateFormatter stringFromDate:_minDate] integerValue];
    NSInteger minMonth = [[_monthDateFormatter stringFromDate:_minDate] integerValue];
    if (minYear > year) {
        
        [self pickerViewSelectWithYear:minYear month:minMonth];
    }
    else if (minYear == year && minMonth > month) {
        
        [self pickerViewSelectWithYear:minYear month:minMonth];
    }
    
    NSInteger maxYear = [[_yearDateFormatter stringFromDate:_maxDate] integerValue];
    NSInteger maxMonth = [[_monthDateFormatter stringFromDate:_maxDate] integerValue];
    if (maxYear < year) {
        
        [self pickerViewSelectWithYear:maxYear month:maxMonth];
    }
    else if (maxYear == year && maxMonth < month) {
        
        [self pickerViewSelectWithYear:maxYear month:maxMonth];
    }
}

/**
 *  选中某个年月
 *
 *  @param year  具体年
 *  @param month 具体月
 */
- (void)pickerViewSelectWithYear:(NSInteger)year
                           month:(NSInteger)month {
    
    NSInteger nowYear = [[_yearDateFormatter stringFromDate:[NSDate date]] integerValue];
    NSInteger selectYear = year - nowYear + 25;
    [_pickerView selectRow:month - 1 inComponent:1 animated:YES];
    [_pickerView selectRow:selectYear inComponent:0 animated:YES];
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (component == 0) {
        
        static NSInteger number = -25;
        NSString *year = [_yearDateFormatter stringFromDate:[NSDate date]];
        return [NSString stringWithFormat:@"%@年", @([year integerValue] + number + row)];
    }
    else {
        
        return [NSString stringWithFormat:@"%@月", @(row + 1)];
    }
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component {
    
    [self timeBorder];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (component == 0) {
        
        return 50;
    }
    else {
        
        return 12;
    }
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 2;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
