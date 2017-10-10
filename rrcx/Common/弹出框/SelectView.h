//
//  SelectView.h

//

#import <UIKit/UIKit.h>

@class SelectView;
@class Skill;

@protocol SelectViewDelegate <NSObject>

@optional
- (void)selectView:(SelectView *)selectView
             index:(NSInteger)index;

- (void)selectView:(SelectView *)selectView
             skill:(Skill *)skill;

@end

@interface SelectView : UIView

@property (nonatomic, weak)id<SelectViewDelegate> deleagte;
@property (nonatomic, retain) NSArray *titles;
@property (nonatomic) NSInteger myTag;

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIView *rootView;
@property (nonatomic, retain) UIView *cancelView;

- (id)initWithTitle:(NSArray *)title
           delegate:(id<SelectViewDelegate>) delegate;
- (void)showInWindow;
- (void)dismiss;

@end
