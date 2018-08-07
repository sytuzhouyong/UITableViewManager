//
//  UITableViewRow2Cell.m
//  ZyxTableViewManager
//
//  Created by 周勇 on 11/02/2018.
//

#import "UITableViewRow2Cell.h"
#import <Masonry/Masonry.h>

@implementation UITableViewRow2Cell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *wrapperView = [[UIView alloc] init];
        wrapperView.mas_key = @"wrapperView";
        wrapperView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:wrapperView];
        [wrapperView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.leading.trailing.equalTo(self.contentView);
        }];
        _wrapperView = wrapperView;
        
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews {
}

// MARK: - 更新视图
- (void)renderWithRow:(UITableViewRow2 *)row {
    self.row = row;
    if (row.backgroundColor != nil) {
        self.wrapperView.backgroundColor = row.backgroundColor;
    }
    
    // 1. 标题
    if (row.title.length != 0) {
        self.titleLabel.text = row.title;
        self.titleLabel.textColor = row.titleColor;
        self.titleLabel.font = row.titleFont;
        self.titleLabel.textAlignment = row.titleAlignment;
    } else if (_titleLabel != nil) {
        [_titleLabel removeFromSuperview];
        _titleLabel = nil;
    }
    
    // 2. 副标题
    if (row.subtitle.length != 0) {
        self.subtitleLabel.text = row.subtitle;
        self.subtitleLabel.textColor = row.subtitleColor;
        self.subtitleLabel.font = row.subtitleFont;
        self.subtitleLabel.textAlignment = row.subtitleAlignment;
    } else if (_subtitleLabel != nil) {
        [_subtitleLabel removeFromSuperview];
        _subtitleLabel = nil;
    }
    
    // 3. 分隔线
    if (row.showLine) {
        self.line.backgroundColor = row.lineColor;
        [_line mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.wrapperView).offset(row.lineEdgeInsets.left);
            make.trailing.equalTo(self.wrapperView).offset(-row.lineEdgeInsets.right);
        }];
    } else if (_line != nil) {
        [_line removeFromSuperview];
        _line = nil;
    }
}

// MARK: - 约束

- (void)makeTitleLabelConstraints {
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.wrapperView).offset(15);
        make.centerY.equalTo(self.wrapperView);
    }];
    // 设置抗拉升和压缩
    [_titleLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
}

- (void)makeSubtitleLabelConstraints {
    [_subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.wrapperView).offset(-15);
        make.centerY.equalTo(self.wrapperView);
        if (self.row.title.length != 0) {
            make.leading.equalTo(self.titleLabel.mas_trailing).offset(10);
        }
    }];
}

- (void)makeLineConstraints {
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.wrapperView).offset(0);
        make.trailing.equalTo(self.wrapperView).offset(0);
        make.bottom.equalTo(self.wrapperView);
        make.height.mas_equalTo(0.5f);
    }];
}

// MARK: - Getter and Setter
- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.mas_key = @"titleLabel";
        [self.wrapperView addSubview:_titleLabel];
        [self makeTitleLabelConstraints];
    }
    return _titleLabel;
}

- (UILabel *)subtitleLabel {
    if (_subtitleLabel == nil) {
        _subtitleLabel = [[UILabel alloc] init];
        _subtitleLabel.mas_key = @"subtitleLabel";
        [self.wrapperView addSubview:_subtitleLabel];
        [self makeSubtitleLabelConstraints];
    }
    return _subtitleLabel;
}

- (UIView *)line {
    if (_line == nil) {
        _line = [[UIView alloc] init];
        _line.mas_key = @"line";
        [self.wrapperView addSubview:_line];
        [self makeLineConstraints];
    }
    return _line;
}

// MARK: - Util Methods

- (UILabel *)labelWithFontSize:(CGFloat)size textColor:(UIColor *)color textAlignment:(NSTextAlignment)alignment {
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:size];
    label.textColor = color;
    label.textAlignment = alignment;
    label.backgroundColor = [UIColor clearColor];
    return label;
}

- (UIButton *)buttonWithImageName:(NSString *)imageName {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    return button;
}

- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

@end


// MARK: - 分隔Row

@implementation UISeperatorRow

- (instancetype)initWithHeight:(CGFloat)height backgroundColor:(UIColor *)color {
    if (self = [super initWithModel:nil]) {
        self.height = height;
        self.backgroundColor = color;
    }
    return self;
}


@end

@implementation UISeperatorRowCell

- (void)renderWithRow:(UISeperatorRow *)row {
    [super renderWithRow:row];
}

@end

