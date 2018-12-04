//
//  UITableViewManager2.m
//  ZyxTableViewManager
//
//  Created by 周勇 on 19/03/2018.
//

#import "UITableViewManager2.h"
#import "UITableViewRow2.h"
#import "UITableViewSection2.h"
#import "UITableViewSectionHeaderModel.h"

@interface UITableViewManager2 () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableSet<NSString *> *cellIdentifiers;
@property (nonatomic, strong) NSMutableArray<UITableViewSection2 *> *sections;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSIndexPath *> *indexPathDict;    // key: uuid, value: row's indexpath
@property (nonatomic, strong) NSArray<UITableViewSectionHeaderModel *> *sectionHeaders;         // section title model
@end

@implementation UITableViewManager2

// MARK: - Init Methods
- (void)commonInitWithTableView:(UITableView *)tableView {
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView = tableView;
    self.cellIdentifiers = [NSMutableSet set];
    self.indexPathDict = [NSMutableDictionary dictionaryWithCapacity:16];
}

- (instancetype)initWithTableView:(UITableView *)tableView rows:(NSArray<UITableViewRow2 *> *)rows {
    if (self = [super init]) {
        [self commonInitWithTableView:tableView];
        
        UITableViewSection2 *section = [[UITableViewSection2 alloc] initWithRows:rows];
        self.sections = [NSMutableArray arrayWithArray:@[section]];
        [self registerSections:self.sections];
    }
    return self;
}

- (instancetype)initWithTableView:(UITableView *)tableView sections:(NSArray<UITableViewSection2 *> *)sections {
    if (self = [super init]) {
        [self commonInitWithTableView:tableView];
        
        self.sections = [NSMutableArray arrayWithArray:sections];;
        [self registerSections:sections];
    }
    return self;
}

- (void)registerSections:(NSArray<UITableViewSection2 *> *)sections {
    [sections enumerateObjectsUsingBlock:^(UITableViewSection2 *section, NSUInteger idx1, BOOL *stop) {
        [self registerRows:[section allRows]];
    }];
}

- (void)registerRows:(NSArray<UITableViewRow2 *> *)rows {
    for (UITableViewRow2 *row in rows) {
        NSString *identifier = [row.class cellIdentifier];
        if (![self.cellIdentifiers containsObject:identifier]) {
            [self.cellIdentifiers addObject:identifier];
            [self.tableView registerClass:NSClassFromString(identifier) forCellReuseIdentifier:identifier];
        }
    }
}

// MARK: - Section Header Model
- (void)addSectionHeaders:(NSArray<UITableViewSectionHeaderModel *> *)sectionHeaders {
    self.sectionHeaders = sectionHeaders;
}

// MARK: - Section Util Methods
- (NSUInteger)numberOfSections {
    return self.sections.count;
}

- (NSArray<UITableViewSection2 *> *)allSections {
    return self.sections;
}
- (UITableViewSection2 *)sectionAtIndex:(NSInteger)index {
    return self.sections[index];
}

// MARK: - Row Util Methods
- (NSUInteger)numberOfRows {
    return [self.sections[0] numberOfRows];
}

- (NSUInteger)numberOfRowsInSection:(NSUInteger)section {
    return [self.sections[section] numberOfRows];
}

- (NSArray<UITableViewRow2 *> *)rowsAtSectionIndex:(NSUInteger)index {
    return [self.sections[index] allRows];
}

- (UITableViewRow2 *)rowAtIndex:(NSUInteger)index {
    return [self.sections[0] rowAtIndex:index];
}

- (UITableViewRow2 *)rowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRow2 *row = [self.sections[indexPath.section] rowAtIndex:indexPath.row];
    return row;
}

- (NSIndexPath *)indexPathOfRow:(UITableViewRow2 *)row {
    NSIndexPath *indexPath = self.indexPathDict[row.uuid];
    if (indexPath != nil) {
        return indexPath;
    }
    
    NSInteger sectionIndex = 0, rowIndex = 0;
    for (UITableViewSection2 *section in _sections) {
        for (UITableViewRow2 *item in section.allRows) {
            if (![row.uuid isEqualToString:item.uuid]) {
                rowIndex++;
                continue;
            }
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex];
            _indexPathDict[row.uuid] = indexPath;
            return indexPath;
        }
        sectionIndex++;
    }
    
    return nil;
}

// MARK: - Edit DataSource Util Methods
- (void)insertRows:(NSArray<UITableViewRow2 *> *)rows atIndex:(NSUInteger)index {
    [self insertRows:rows atIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
}
- (void)insertRows:(NSArray<UITableViewRow2 *> *)rows atIndexPath:(NSIndexPath *)indexPath {
    [self registerRows:rows];
    
    [self.sections[indexPath.section] insertRows:rows atIndex:indexPath.row];
    
    NSMutableArray *indexPaths = [[NSMutableArray alloc] initWithCapacity:rows.count];
    for (int i=0; i<rows.count; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:indexPath.row+i inSection:indexPath.section]];
    }
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self refreshIndexPathDict];
}

- (void)deleteRowAtIndex:(NSInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self deleteRowAtIndexPath:indexPath];
}
- (void)deleteRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.sections[indexPath.section] deleteRowAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self refreshIndexPathDict];
}

- (void)deleteRows:(NSArray<UITableViewRow2 *> *)rows {
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:rows.count];
    for (UITableViewRow2 *row in rows) {
        NSIndexPath *indexPath = [self indexPathOfRow:row];
        if (indexPath != nil) {
            [indexPaths addObject:indexPath];
        }
    }
    for (UITableViewRow2 *row in rows) {
        NSIndexPath *indexPath = [self indexPathOfRow:row];
        if (indexPath != nil) {
            [self.sections[indexPath.section] deleteRows:@[row]];
        }
    }
    [self deleteRowsAtIndexPaths:indexPaths];
}

- (void)deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    if (indexPaths.count == 0) {
        return;
    }
    NSArray<NSIndexPath *> *sortedIndexPaths = [indexPaths sortedArrayUsingComparator:^NSComparisonResult(NSIndexPath *obj1, NSIndexPath *obj2) {
        if (obj1.section > obj2.section) {
            return NSOrderedAscending;
        }
        if (obj1.section < obj2.section) {
            return NSOrderedDescending;
        }
        if (obj1.row > obj2.row) {
            return NSOrderedAscending;
        }
        return NSOrderedDescending;
    }];
    
    // 删除 section 下的 row
    for (NSIndexPath *indexPath in sortedIndexPaths) {
        [_sections[indexPath.section] deleteRowAtIndex:indexPath.row];
    }
    // 找出所有空的 section，并删除空 section
    NSMutableIndexSet *emptySections = [NSMutableIndexSet indexSet];
    for (NSInteger i=0; i<_sections.count; i++) {
        UITableViewSection2 *section = _sections[i];
        if (section.allRows.count == 0) {
            [emptySections addIndex:i];
            [_sections removeObjectAtIndex:i];
        }
    }
    // 删除除了 导致空 section 外的 row
    NSMutableArray<NSIndexPath *> *_indexPaths = [NSMutableArray arrayWithArray:indexPaths];
    for (NSIndexPath *indexPath in indexPaths) {
        if ([emptySections containsIndex:indexPath.section]) {
            [_indexPaths removeObject:indexPath];
        }
    }
    
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:_indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView deleteSections:emptySections withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
    [self refreshIndexPathDict];
}

- (void)reloadRows:(NSArray<UITableViewRow2 *> *)rows atSection:(NSInteger)section {
    UITableViewSection2 *sectionModel = [self sectionAtIndex:section];
    [sectionModel deleteAllRows];
    [sectionModel insertRows:rows atIndex:0];
    [self registerRows:rows];
    [self.tableView reloadData];
    [self refreshIndexPathDict];
}

- (void)insertSection:(UITableViewSection2 *)section {
    [self insertSection:section atIndex:self.sections.count];
}

- (void)insertSection:(UITableViewSection2 *)section atIndex:(NSInteger)index {
    [self.sections insertObject:section atIndex:index];
    [self registerRows:section.allRows];
    [self.tableView insertSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self refreshIndexPathDict];
}

- (void)deleteSectionAtIndex:(NSInteger)index {
    [self.sections removeObjectAtIndex:index];
    [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self refreshIndexPathDict];
}

- (void)deleteAllSections {
    [self.sections removeAllObjects];
    [self.tableView reloadData];
    [self refreshIndexPathDict];
}

- (void)replaceSection:(UITableViewSection2 *)section atIndex:(NSInteger)index {
    [self.sections replaceObjectAtIndex:index withObject:section];
    // 调下面的方法，在数据多于一屏时会导致新的数据刷不出来，必须要用手滑动一下才出来
//    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView reloadData];
    [self refreshIndexPathDict];
}

// 刷新indexPath, 增加或者删除后会导致indexPath变化
- (void)refreshIndexPathDict {
    [self.indexPathDict removeAllObjects];
    NSArray<NSIndexPath *> *newIndexPaths = [self.tableView indexPathsForVisibleRows];
    for (NSIndexPath *indexPath in newIndexPaths) {
        UITableViewRow2 *row = [self rowAtIndexPath:indexPath];
        self.indexPathDict[row.uuid] = indexPath;
    }
}

/// returns nil if cell is not visible or index path is out of range
- (UITableViewRow2Cell *)cellForRow:(UITableViewRow2 *)row {
    NSIndexPath *indexPath = self.indexPathDict[row.uuid];
    return [self.tableView cellForRowAtIndexPath:indexPath];
}

- (NSArray<UITableViewRow2 *> *)subRowsWithRange:(NSRange)range {
    return [self.sections[0] rowsWithRange:range];
}

// MARK: - UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger number = [self.sections[section] numberOfRows];
    return number;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRow2 *row = [self rowAtIndexPath:indexPath];
    if (row.height != 0) {
        return row.height;
    } else {
        return UITableViewAutomaticDimension;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRow2 *row = [self rowAtIndexPath:indexPath];
    UITableViewRow2Cell *cell = [tableView dequeueReusableCellWithIdentifier:[row.class cellIdentifier] forIndexPath:indexPath];
    [cell renderWithRow:row];
    self.indexPathDict[row.uuid] = indexPath;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    UITableViewSectionHeaderModel *model = self.sectionHeaders[section];
    return model.height;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewSectionHeaderModel *model = self.sectionHeaders[section];
    return model.view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRow2 *row = [self rowAtIndexPath:indexPath];
    !row.didSelectBlock ? : row.didSelectBlock(row, indexPath);
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRow2 *row = [self rowAtIndexPath:indexPath];
    if (!row.editable) {
        return @[]; // 不显示左滑的函数按钮,就返回空数组而不是nil
    }
    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        !self.updateFinishBlock ?: self.updateFinishBlock(indexPath, UITableViewDataSourceChangeTypeDelete);
    }];
    
    return @[action1];
}

// MARK: - Util Methods

- (void)reloadData {
    [self.tableView reloadData];
}
- (void)reloadRow:(UITableViewRow2 *)row {
    NSIndexPath *indexPath = [self indexPathOfRow:row];
    if (indexPath != nil) {
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}
- (void)reloadAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}
- (void)reloadAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (BOOL)resignFirstResponder {
    NSArray<UITableViewRow2Cell *> *cells = [self.tableView visibleCells];
    for (UITableViewRow2Cell *cell in cells) {
        [cell resignFirstResponder];
    }
    return YES;
}

// MARK: - Scroll View Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.scrollDelegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.scrollDelegate scrollViewDidScroll:scrollView];
    }
}

- (void)dealloc {
    self.scrollDelegate = nil;
}

@end
