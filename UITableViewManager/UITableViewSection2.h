//
//  UITableViewSection2.h
//  ZyxTableViewManager
//
//  Created by 周勇 on 11/02/2018.
//

#import <Foundation/Foundation.h>
#import "UITableViewRow2.h"

@interface UITableViewSection2 : NSObject

- (instancetype)initWithRows:(NSArray<UITableViewRow2 *> *)rows;

- (NSArray<UITableViewRow2 *> *)allRows;
- (NSInteger)numberOfRows;
- (UITableViewRow2 *)rowAtIndex:(NSInteger)index;
- (NSUInteger)indexOfRow:(UITableViewRow2 *)row;
- (NSArray<UITableViewRow2 *> *)rowsWithRange:(NSRange)range;

- (void)insertRows:(NSArray<UITableViewRow2 *> *)rows atIndex:(NSInteger)index;
- (void)appendRows:(NSArray<UITableViewRow2 *> *)rows;
- (void)deleteRows:(NSArray<UITableViewRow2 *> *)rows;
- (void)deleteRowAtIndex:(NSInteger)index;
- (void)deleteAllRows;

- (void)enumerateObjectsUsingBlock:(void (^)(UITableViewRow2 *row, NSInteger idx))block;

@end
