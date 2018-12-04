//
//  UITableViewRow2.m
//  ZyxTableViewManager
//
//  Created by 周勇 on 11/02/2018.
//

#import "UITableViewRow2.h"

@interface UITableViewRow2 ()

@property (nonatomic, strong) NSMutableDictionary *cachedDataDict;

@end

@implementation UITableViewRow2

- (instancetype)copyWithZone:(NSZone *)zone {
    UITableViewRow2 *row = [[self.class allocWithZone:zone] init];

    _uuid = [[[NSUUID UUID] UUIDString] copy];
    row.backgroundColor = self.backgroundColor;
    row.accessoryType = self.accessoryType;
    row.height = self.height;
    
    row.title = [self.title copy];
    row.titleColor = self.titleColor;
    row.titleFont = [self.titleFont copy];
    row.titleAlignment = self.titleAlignment;
    
    row.subtitle = self.subtitle;
    row.subtitleColor = self.subtitleColor;
    row.subtitleFont = [self.subtitleFont copy];
    row.subtitleAlignment = self.subtitleAlignment;
    
    row.showLine = self.showLine;
    row.lineEdgeInsets = self.lineEdgeInsets;
    row.lineColor = self.lineColor;
    
    row.didSelectBlock = self.didSelectBlock;
    return row;
}

- (void)commonInit {
    _uuid = [[[NSUUID UUID] UUIDString] copy];
    
    self.titleFont = [UIFont systemFontOfSize:14];
    self.titleColor = HEXCOLOR(0x222222);
    self.titleAlignment = NSTextAlignmentLeft;
    
    self.subtitleFont = [UIFont systemFontOfSize:14];
    self.subtitleColor = HEXCOLOR(0x999999);
    self.subtitleAlignment = NSTextAlignmentRight;
    
    self.showLine = NO;
    self.lineColor = HEXCOLOR(0xdddddd);
    self.lineEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
}

- (instancetype)init {
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithModel:(BFModel *)model {
    if (self = [super init]) {
        self.model = model;
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle {
    if (self = [super init]) {
        self.title = title;
        self.subtitle = subtitle;
        [self commonInit];
    }
    return self;
}

+ (NSString *)cellIdentifier {
    static NSMutableDictionary<NSString *, NSString *> *cellIdentifiers = nil;
    if (cellIdentifiers == nil) {
        cellIdentifiers = [NSMutableDictionary dictionary];
    }
    NSString *key = NSStringFromClass(self.class);
    if (cellIdentifiers[key] == nil) {
        cellIdentifiers[key] = [NSString stringWithFormat:@"%@Cell", key];
    }
    return cellIdentifiers[key];
}

- (id)cachedDataForKey:(NSString *)key {
    return _cachedDataDict[key];
}
- (void)addCacheData:(id)data forKey:(NSString *)key {
    if (_cachedDataDict == nil) {
        _cachedDataDict = [NSMutableDictionary dictionary];
    }
    _cachedDataDict[key] = data;
}

@end
