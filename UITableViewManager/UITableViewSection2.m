//
//  UITableViewSection2.m
//  ZyxTableViewManager
//
//  Created by 周勇 on 11/02/2018.
//

#import "UITableViewSection2.h"

@interface UITableViewSection2 ()

@property (nonatomic, strong) NSMutableArray<UITableViewRow2 *> *rows;

@end

@implementation UITableViewSection2

- (instancetype)initWithRows:(NSArray<UITableViewRow2 *> *)rows {
    if (self = [super init]) {
        self.rows = [NSMutableArray arrayWithArray:rows];
        for (UITableViewRow2 *row in rows) {
            row.section = self;
        }
    }
    return self;
}

- (NSArray<UITableViewRow2 *> *)allRows {
    return self.rows;
}

- (NSInteger)numberOfRows {
    return self.rows.count;
}

- (UITableViewRow2 *)rowAtIndex:(NSInteger)index {
    NSAssert(index < self.rows.count, @"index[%ld] must in [0, %lu]", (long)index, (unsigned long)self.rows.count);
    return self.rows[index];
}

- (NSUInteger)indexOfRow:(UITableViewRow2 *)row {
    return [self.rows indexOfObject:row];
}

- (NSArray<UITableViewRow2 *> *)rowsWithRange:(NSRange)range {
    // po ((UITableViewRow2 *)items[1]).title
    NSArray *items = [self.rows subarrayWithRange:range];
    return items;
}

- (void)enumerateObjectsUsingBlock:(void (^)(UITableViewRow2 *row, NSInteger idx))block {
    if (block == nil) {
        return;
    }
    [self.rows enumerateObjectsUsingBlock:^(UITableViewRow2 * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        block(obj, idx);
    }];
}

- (void)insertRows:(NSArray<UITableViewRow2 *> *)rows atIndex:(NSInteger)index {
    [rows enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UITableViewRow2 *obj, NSUInteger idx, BOOL *stop) {
        [self.rows insertObject:obj atIndex:index];
    }];
}

- (void)appendRows:(NSArray<UITableViewRow2 *> *)rows {
    NSInteger index = self.rows.count;
    [self insertRows:rows atIndex:index];
}

- (void)deleteRows:(NSArray<UITableViewRow2 *> *)rows {
    [self.rows removeObjectsInArray:rows];
}

- (void)deleteRowAtIndex:(NSInteger)index; {
    [self.rows removeObjectAtIndex:index];
}

- (void)deleteAllRows {
    [self.rows removeAllObjects];
}

@end
