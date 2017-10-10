//

//

#import "SelectView.h"
//#import "Header.h"
#import "AppDelegate.h"

#define HEIGHT 50
#define CANCEL_HEIGHT 56
#define EDGE 0
#define WINDOW_WIDTH [UIScreen mainScreen].bounds.size.width
#define WINDOW_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface SelectView ()

@property (nonatomic, retain) UIView *backgroundView;

@end

@implementation SelectView

- (id)initWithTitle:(NSArray *)title
           delegate:(id<SelectViewDelegate>) delegate {
    
    self = [self initWithFrame:CGRectZero];
    if (self) {
        
        self.titles = title;
        self.deleagte = delegate;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        
        [self initializationView];
    }
    return self;
}

- (void)initializationView {
    
    _backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    _backgroundView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.500];
    [self addSubview:_backgroundView];
    
    _rootView = [[UIView alloc] init];
    _rootView.frame = CGRectMake(0, WINDOW_HEIGHT - CANCEL_HEIGHT, WINDOW_WIDTH, CANCEL_HEIGHT);
    [self addSubview:_rootView];
    
    _scrollView = [[UIScrollView alloc] init];
    [_rootView addSubview:_scrollView];
    
    _cancelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, CANCEL_HEIGHT)];
    _cancelView.backgroundColor = [UIColor colorWithWhite:0.949 alpha:1.000];
    [_rootView addSubview:_cancelView];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.exclusiveTouch = YES;
    cancelButton.frame = CGRectMake(0, 6, WINDOW_WIDTH, CANCEL_HEIGHT - 6);
    cancelButton.backgroundColor = [UIColor whiteColor];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [_cancelView addSubview:cancelButton];
}

- (void)setTitles:(NSArray *)titles {
    
    _titles = titles;
    for (UIView *view in _scrollView.subviews) {
        
        [view removeFromSuperview];
    }
    for (int i = 0; i < titles.count; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.exclusiveTouch = YES;
        button.frame = CGRectMake(0, i * HEIGHT, WINDOW_WIDTH, HEIGHT);
        button.backgroundColor = [UIColor whiteColor];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:17];
        [button addTarget:self action:@selector(selectButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:button];
        
        if (i != 0) {
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(EDGE, 0, WINDOW_WIDTH - EDGE * 2, 0.5)];
            line.backgroundColor = [UIColor colorWithWhite:0.839 alpha:1.000];
            [button addSubview:line];
        }
    }
    CGFloat height = titles.count * HEIGHT;
    _scrollView.contentSize = CGSizeMake(0, height);
    if (height > WINDOW_HEIGHT - CANCEL_HEIGHT) {
        
        height = WINDOW_HEIGHT - CANCEL_HEIGHT;
    }
    _scrollView.frame = CGRectMake(0, 0, WINDOW_WIDTH, height);
    _cancelView.frame = CGRectMake(0, height, WINDOW_WIDTH, CANCEL_HEIGHT);
    _rootView.frame = CGRectMake(0, WINDOW_HEIGHT - CANCEL_HEIGHT - height, WINDOW_WIDTH, height + CANCEL_HEIGHT);
}

- (void)selectButtonPressed:(UIButton *)sender {
    
    if (_deleagte && [_deleagte respondsToSelector:@selector(selectView:index:)]) {
        
        [_deleagte selectView:self index:[_titles indexOfObject:sender.titleLabel.text]];
    }
    [self dismiss];
}

- (void)showInWindow {
    
    _backgroundView.alpha = 0;
    CGRect rect = _rootView.frame;
    CGFloat y = CGRectGetMinY(rect);
    rect.origin.y = KHeight;
    _rootView.frame = rect;
    rect.origin.y = y;
    
    AppDelegate *appDelegate = APPDELEGATE;
    [appDelegate.window addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _backgroundView.alpha = 1;
        _rootView.frame = rect;
    }];
}

- (void)dismiss {
    
    CGRect rect = _rootView.frame;
    rect.origin.y = WINDOW_HEIGHT;
    [UIView animateWithDuration:0.3
                     animations:^{
                         
                         _backgroundView.alpha = 0;
                         _rootView.frame = rect;
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
