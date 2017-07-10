

#import <UIKit/UIKit.h>

typedef void(^PopoverBlock)(NSInteger index);

@interface PopoverView : UIView

// 菜单列表集合 attributedMenuTitles 优先于 menuTitles
@property (nonatomic, copy) NSArray *menuTitles;
@property (nonatomic, strong) NSArray<NSAttributedString *> *attributedMenuTitles;

// 默认白色
@property (nonatomic, strong) UIColor *popoverBackgroundColor;

// 边框是否隐藏。默认为NO
@property (nonatomic, assign) BOOL borderHidden;

/*!
 *  @author lifution
 *
 *  @brief 显示弹窗
 *
 *  @param aView    箭头指向的控件
 *  @param selected 选择完成回调
 */
- (void)showFromView:(UIView *)aView selected:(PopoverBlock)selected;
- (void)showFromRectOfScreen:(CGRect)aRect selected:(PopoverBlock)selected;

@end
