//
//  UITableViewSectionHeaderModel.m
//  BFShop
//
//  Created by 周勇 on 2018/5/4.
//

#import "UITableViewSectionHeaderModel.h"

@implementation UITableViewSectionHeaderModel

- (instancetype)init {
    if (self = [super init]) {
        self.height = 0;
    }
    return self;
}

+ (instancetype)emptyModel {
    UITableViewSectionHeaderModel *model = [[UITableViewSectionHeaderModel alloc] init];
    return model;
}

@end
