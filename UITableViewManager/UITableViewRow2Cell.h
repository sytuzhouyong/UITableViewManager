//
//  UITableViewRow2Cell.h
//  ZyxTableViewManager
//
//  Created by 周勇 on 11/02/2018.
//

#import <Foundation/Foundation.h>
#import "UITableViewRow2.h"

#define kTitleColor         HEXCOLOR(0x222222)
#define kSubtitleColor      HEXCOLOR(0x666666)
#define kRightButtonSize    CGSizeMake(44, 44)

@interface UITableViewRow2Cell : UITableViewCell

@property (nonatomic, strong, readonly) UIView *wrapperView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UIButton *rightButton;    // 可以自定义，也可以通过accessorytype来设置
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UITableViewRow2 *row;

/// 添加自定义的视图
- (void)addSubviews;
/// 通过row渲染对应的cell
- (void)renderWithRow:(UITableViewRow2 *)row;

// 如果需要自定义titleLabel, subtitleLabel, line的约束，请重载对应的方法
/// titleLabel 约束
- (void)makeTitleLabelConstraints;
/// subtitleLabel 约束
- (void)makeSubtitleLabelConstraints;
/// line 约束
- (void)makeLineConstraints;


- (UILabel *)labelWithFontSize:(CGFloat)size textColor:(UIColor *)color textAlignment:(NSTextAlignment)alignment;
- (UIViewController *)viewController;

@end


// MARK: - 分隔Row
@interface UISeperatorRow : UITableViewRow2

- (instancetype)initWithHeight:(CGFloat)height backgroundColor:(UIColor *)color;

@end

@interface UISeperatorRowCell : UITableViewRow2Cell

@end

