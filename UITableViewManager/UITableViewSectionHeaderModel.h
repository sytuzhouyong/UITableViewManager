//
//  UITableViewSectionHeaderModel.h
//  BFShop
//
//  Created by 周勇 on 2018/5/4.
//

#import <Foundation/Foundation.h>

@interface UITableViewSectionHeaderModel : NSObject

@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) UIView *view;

+ (instancetype)emptyModel;

@end
