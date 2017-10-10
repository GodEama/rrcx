//
//  QZCountNumTextView.m
//  Application
//
//  Created by MrYu on 2016/12/9.
//  Copyright © 2016年 yu qingzhu. All rights reserved.
//

#import "QZCountNumTextView.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface QZCountNumTextView ()<UITextViewDelegate>
{
    UILabel *_placeholderLabel;
    UILabel *_countLabel;
}
@end

@implementation QZCountNumTextView

+ (instancetype)countNumTextView
{
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0);
        [self makeSubviews];
        self.delegate = self;
    }
    return self;
    
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setFrameForSubviews];
}

- (void)setFrameForSubviews
{
    _placeholderLabel.frame =CGRectMake(5, 7, self.bounds.size.width - 10, 10);
    _countLabel.frame = CGRectMake(self.bounds.size.width - 100 - 5, self.bounds.size.height - 25, 100, 25);
    
}
- (void)makeSubviews
{
    _placeholderLabel = [[UILabel alloc] init];
    _placeholderLabel.numberOfLines = 0;
    _placeholderLabel.font = [UIFont systemFontOfSize:14];
    _placeholderLabel.textColor = UIColorFromRGB(0xcacaca);
    [self addSubview:_placeholderLabel];
    
    _countLabel = [[UILabel alloc] init];
    _countLabel.font = [UIFont systemFontOfSize:14];
    _countLabel.textColor = UIColorFromRGB(0xcacaca);
    _countLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_countLabel];
}

- (void)textViewDidChange:(UITextView *)textView
{
    _placeholderLabel.hidden = textView.text.length > 0;
    _countLabel.text = textView.text.length > self.maxCount ? [NSString stringWithFormat:@"-%ld",textView.text.length - self.maxCount ] : [NSString stringWithFormat:@"%ld",textView.text.length];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        textView.text = [NSString stringWithFormat:@"%@%@",textView.text,text];
    }
    return YES;
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholderLabel.text = placeholder;
    [_placeholderLabel sizeToFit];
}

@end
