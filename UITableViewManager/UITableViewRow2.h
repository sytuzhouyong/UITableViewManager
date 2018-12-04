//
//  UITableViewRow2.h
//  ZyxTableViewManager
//
//  Created by 周勇 on 11/02/2018.
//

#import <UIKit/UIKit.h>
#import "BFModel.h"

@class UITableViewSection2;

/// cell的数据模型
@interface UITableViewRow2 : NSObject <NSCopying>

@property (nonatomic, copy, readonly) NSString *uuid;           // row的唯一标示
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, assign) CGFloat height;                   // row 高度
@property (nonatomic, assign) UITableViewCellAccessoryType accessoryType;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, assign) NSTextAlignment titleAlignment;

@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, strong) UIColor *subtitleColor;
@property (nonatomic, strong) UIFont *subtitleFont;
@property (nonatomic, assign) NSTextAlignment subtitleAlignment;

@property (nonatomic, assign) BOOL showLine;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) UIEdgeInsets lineEdgeInsets;

// eidtable
@property (nonatomic, assign) BOOL editable;    // 是否可编辑, 用于控制左滑按钮的出现
@property (nonatomic, assign) BOOL selected;    // 是否被选中
@property (nonatomic, strong) NSArray<UITableViewRowAction *> *rowActions;  // 左滑cell时出现什么按钮

@property (nonatomic, strong) BFModel *model;   // 数据
@property (nonatomic, weak) UITableViewSection2 *section;   // row 所在的 section

@property (nonatomic, copy) void(^ didSelectBlock)(UITableViewRow2 *row, NSIndexPath *indexPath);

/// 通用内部变量的初始化方法
- (void)commonInit;
/// 这两种初始化方法都会调用 commonInit 方法
- (instancetype)initWithModel:(BFModel *)model;
- (instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle;

/// cell 标识
+ (NSString *)cellIdentifier;

/// 缓存数据
- (id)cachedDataForKey:(NSString *)key;
- (void)addCacheData:(id)data forKey:(NSString *)key;

@end

