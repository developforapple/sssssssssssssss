

#import "SPPopoverView.h"

// 字体大小
#define kPopoverFontSize 14.f

// 十六进制颜色
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define SCREEN_W [UIScreen mainScreen].bounds.size.width

// 箭头高度
#define kArrowH 8
// 箭头宽度
#define kArrowW 15

// 边框颜色
#define kBorderColor UIColorFromRGB(0x888888)

@interface PopoverArrow : UIView
@property (strong, nonatomic) UIColor *popoverBackgroundColor;
@property (assign, nonatomic) BOOL borderHidden;
@end

@interface PopoverView () <UITableViewDelegate, UITableViewDataSource>
{
    PopoverBlock _selectedBlock;
    UIView *_backgroundView;
    PopoverArrow *_arrowView;
}

@property (nonatomic, retain) UITableView *tableView;

@end

@implementation PopoverView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) return nil;
    
    self.backgroundColor = [UIColor clearColor];
    
    // 箭头
    _arrowView = [PopoverArrow new];
    [self addSubview:_arrowView];
    
    // tableView放在箭头底下, 用于箭头挡住tableView边框
    [self insertSubview:self.tableView belowSubview:_arrowView];
    
    self.popoverBackgroundColor = [UIColor whiteColor];
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置tableView默认的分割线起终点位置
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    self.tableView.layer.masksToBounds = YES;
    self.tableView.layer.cornerRadius  = 5.f;
    if (!self.borderHidden) {
        self.tableView.layer.borderColor   = kBorderColor.CGColor;
        self.tableView.layer.borderWidth   = 0.5f;
    }else{
        self.tableView.layer.borderColor   = nil;
        self.tableView.layer.borderWidth   = 0.f;
    }
    self.tableView.backgroundColor = self.popoverBackgroundColor;
}

- (void)setPopoverBackgroundColor:(UIColor *)popoverBackgroundColor
{
    _popoverBackgroundColor = popoverBackgroundColor;
    self.tableView.backgroundColor = popoverBackgroundColor;
    self->_arrowView.popoverBackgroundColor = popoverBackgroundColor;
}

- (void)setBorderHidden:(BOOL)borderHidden
{
    _borderHidden = borderHidden;
    [self setNeedsLayout];
    self->_arrowView.borderHidden = borderHidden;
}

#pragma mark -- getter

- (UITableView *)tableView
{
    if (_tableView) return _tableView;
    
    _tableView = [UITableView new];
    
    _tableView.delegate        = self;
    _tableView.dataSource      = self;
    _tableView.rowHeight       = 44;
    _tableView.separatorColor  = UIColorFromRGB(0xE1E2E3);
    _tableView.scrollEnabled   = NO;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.showsVerticalScrollIndicator = NO;
    //    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"kPopoverCellIdentifier"];
    
    _tableView.tableFooterView = UIView.new;
    
    return _tableView;
}

#pragma mark -- delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.attributedMenuTitles) {
        return self.attributedMenuTitles.count;
    }
    return self.menuTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kPopoverCellIdentifier"];
    cell.backgroundColor = [UIColor clearColor];
    if (self.attributedMenuTitles) {
        cell.textLabel.attributedText = self.attributedMenuTitles[indexPath.row];
    }else{
        cell.textLabel.font   = [UIFont systemFontOfSize:kPopoverFontSize];
        cell.textLabel.text   = [self.menuTitles objectAtIndex:indexPath.row];
    }
    cell.textLabel.highlightedTextColor = [UIColor colorWithRed:205/255.f green:84/255.f blue:71/255.f alpha:1];
    return cell;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.highlighted = YES;
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.highlighted = NO;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [_backgroundView removeFromSuperview];
        _backgroundView = nil;
        
        if (_selectedBlock) {
            _selectedBlock(indexPath.row);
        }
        
        [self removeFromSuperview];
    }];
}

#pragma mark -- private
// 点击透明层隐藏
- (void)hide
{
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [_backgroundView removeFromSuperview];
        _backgroundView = nil;
        [self removeFromSuperview];
    }];
}

#pragma mark -- public
- (void)showFromRectOfScreen:(CGRect)aRect selected:(PopoverBlock)selected
{
    if (selected) _selectedBlock = selected;
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    // 背景遮挡
    _backgroundView = UIView.new;
    _backgroundView.frame = keyWindow.bounds;
    _backgroundView.backgroundColor = [UIColor clearColor];
    _backgroundView.userInteractionEnabled = YES;
    [_backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)]];
    [keyWindow addSubview:_backgroundView];
    
    // 刷新数据更新contentSize
    [self.tableView reloadData];
    
    // 获取触发弹窗的按钮在window中的坐标
    CGRect triggerRect   = aRect;
    // 箭头指向的中心点
    CGFloat arrowCenterX = CGRectGetMaxX(triggerRect)-CGRectGetWidth(triggerRect)/2;
    
    // 取得标题中的最大宽度
    CGFloat maxWidth = 0;
    
    if (self.attributedMenuTitles) {
        for (NSAttributedString *text in self.attributedMenuTitles) {
            CGFloat width = [text boundingRectWithSize:CGSizeMake(2000, 30) options:NSStringDrawingUsesFontLeading context:nil].size.width;
            if (width > maxWidth) {
                maxWidth = width;
            }
        }
    }else{
        for (id obj in self.menuTitles) {
            if ([obj isKindOfClass:[NSString class]]) {
                CGSize titleSize = [obj sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kPopoverFontSize]}];
                if (titleSize.width > maxWidth) {
                    maxWidth = titleSize.width;
                }
            }
        }
    }
    CGFloat curWidth  = ((maxWidth+60)>SCREEN_W-30)?SCREEN_W-30:(maxWidth+60);
    CGFloat curHeight = self.tableView.contentSize.height+kArrowH;
    CGFloat curX      = arrowCenterX-curWidth/2;
    CGFloat curY      = CGRectGetMaxY(triggerRect)+10;
    
    // 如果箭头指向点距离屏幕右边减去5px不足curWidth的一半的话就重新设置curX
    if ((SCREEN_W-arrowCenterX-5)<curWidth/2) {
        curX = curX-(curWidth/2-(SCREEN_W-arrowCenterX-5));
    }
    // 如果箭头指向点距离屏幕左边加上5px不足curWidth的一半的话就重新设置curX
    if (arrowCenterX+5<curWidth/2) {
        curX = curX+(curWidth/2-arrowCenterX)+5;
    }
    
    self.frame           = CGRectMake(curX, curY, curWidth, curHeight);
    _arrowView.frame     = CGRectMake(arrowCenterX-curX-kArrowW/2, 0, kArrowW, kArrowH+1); // 箭头高度 +1 遮挡住tableView的边框
    self.tableView.frame = CGRectMake(0, kArrowH, curWidth, self.tableView.contentSize.height);
    [keyWindow addSubview:self];
    
    self.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    }];
}

/*!
 *  @author lifution
 *
 *  @brief 显示弹窗
 *
 *  @param aView    箭头指向的控件
 *  @param selected 选择完成回调
 */
- (void)showFromView:(UIView *)aView selected:(PopoverBlock)selected
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    // 获取触发弹窗的按钮在window中的坐标
    CGRect triggerRect   = [aView convertRect:aView.bounds toView:keyWindow];
    [self showFromRectOfScreen:triggerRect selected:selected];
}

@end

// 箭头
@implementation PopoverArrow

- (instancetype)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) return nil;
    
    self.backgroundColor = [UIColor clearColor];
    
    return self;
}

- (void)setPopoverBackgroundColor:(UIColor *)popoverBackgroundColor
{
    _popoverBackgroundColor = popoverBackgroundColor;
    [self setNeedsDisplay];
}

- (void)setBorderHidden:(BOOL)borderHidden
{
    _borderHidden = borderHidden;
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    // Drawing code
    
    CGSize curSize = rect.size;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (!self.borderHidden) {
        CGContextSetLineWidth(context, 0.5f);
        CGContextSetStrokeColorWithColor(context, kBorderColor.CGColor);
    }else{
        CGContextSetLineWidth(context, 0);
        CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
    }
    CGContextSetFillColorWithColor(context, _popoverBackgroundColor.CGColor);
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, curSize.height);
    CGContextAddLineToPoint(context, curSize.width/2, 0);
    CGContextAddLineToPoint(context, curSize.width, curSize.height);
    
    CGContextDrawPath(context, kCGPathFillStroke);
}

@end








