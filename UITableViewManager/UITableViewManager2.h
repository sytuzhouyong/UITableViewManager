//
//  UITableViewManager2.h
//  ZyxTableViewManager
//
//  Created by 周勇 on 19/03/2018.
//

#import <Foundation/Foundation.h>
#import "UITableViewRow2.h"
#import "UITableViewSection2.h"
#import "UITableViewRow2Cell.h"
#import "UITableViewSectionHeaderModel.h"

typedef NS_ENUM(NSInteger, UITableViewDataSourceChangeType) {
    UITableViewDataSourceChangeTypeInsert = 1,
    UITableViewDataSourceChangeTypeDelete = 2,
};

@interface UITableViewManager2 : NSObject

@property (nonatomic, weak) id<UIScrollViewDelegate> scrollDelegate;

/// 执行完update动作后的回调
@property (nonatomic, copy) void (^updateFinishBlock)(NSIndexPath *indexPath, UITableViewDataSourceChangeType type);

- (instancetype)initWithTableView:(UITableView *)tableView rows:(NSArray<UITableViewRow2 *> *)rows;
- (instancetype)initWithTableView:(UITableView *)tableView sections:(NSArray<UITableViewSection2 *> *)sections;

// MARK: - Section Header Model
- (void)addSectionHeaders:(NSArray<UITableViewSectionHeaderModel *> *)sectionHeaders;

// MARK: - Section Util Methods
- (NSUInteger)numberOfSections;
- (NSArray<UITableViewSection2 *> *)allSections;
- (UITableViewSection2 *)sectionAtIndex:(NSInteger)index;

// MARK: - Row Util Methods
- (NSUInteger)numberOfRows;
- (NSUInteger)numberOfRowsInSection:(NSUInteger)section;
- (NSArray<UITableViewRow2 *> *)rowsAtSectionIndex:(NSUInteger)index;
- (UITableViewRow2 *)rowAtIndex:(NSUInteger)index;
- (UITableViewRow2 *)rowAtIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPathOfRow:(UITableViewRow2 *)row;
- (UITableViewRow2Cell *)cellForRow:(UITableViewRow2 *)row;
- (NSArray<UITableViewRow2 *> *)subRowsWithRange:(NSRange)range;

// MARK: - Edit Util Methods
- (void)insertRows:(NSArray<UITableViewRow2 *> *)rows atIndex:(NSUInteger)index;
- (void)insertRows:(NSArray<UITableViewRow2 *> *)rows atIndexPath:(NSIndexPath *)indexPath;
- (void)deleteRows:(NSArray<UITableViewRow2 *> *)rows;
- (void)deleteRowAtIndex:(NSInteger)index;
- (void)deleteRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;
- (void)reloadRows:(NSArray<UITableViewRow2 *> *)rows atSection:(NSInteger)section;

- (void)insertSection:(UITableViewSection2 *)section;
- (void)insertSection:(UITableViewSection2 *)section atIndex:(NSInteger)index;
- (void)deleteSectionAtIndex:(NSInteger)index;
- (void)deleteAllSections;
- (void)replaceSection:(UITableViewSection2 *)section atIndex:(NSInteger)index;

// MARK: -
- (void)reloadData;
- (void)reloadRow:(UITableViewRow2 *)row;
- (void)reloadAtIndexPath:(NSIndexPath *)indexPath;
- (void)reloadAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;
- (BOOL)resignFirstResponder;

@end
