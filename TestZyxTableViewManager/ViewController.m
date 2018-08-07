//
//  ViewController.m
//  TestZyxTableViewManager
//
//  Created by 周勇 on 02/04/2018.
//  Copyright © 2018 zhouyong. All rights reserved.
//

#import "ViewController.h"
#import <Masonry.h>
#import "UITableViewManager2.h"
#import "YYFPSLabel.h"


@interface ViewController ()

@property (nonatomic, strong) YYFPSLabel *fpsLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITableViewManager2 *manager;
//@property (nonatomic, strong)

@end

@implementation ViewController {
    CADisplayLink *_link;
    NSUInteger _renderCount;
    NSTimeInterval _lastTime;
    
    UILabel *label_;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addRows)];
    UIBarButtonItem *delItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(delRows)];
    self.navigationItem.rightBarButtonItems = @[addItem, delItem];
    
    [self addSubviews];
    [self testFPSLabel];
    [self initDataSource];
}

- (void)addRows {
    static NSInteger height = 34;
    UITableViewRow2 *row = [[UITableViewRow2 alloc] initWithTitle:@"xxx" subtitle:@"222"];
    row.height = height;
    row.showLine = YES;
    height += 2;
    
    [self.manager insertRows:@[row] atIndex:0];
}

- (void)delRows {
    NSArray *rows = [self.manager subRowsWithRange:NSMakeRange(2, 2)];
    [self.manager deleteRows:rows];
}

- (void)initDataSource {
    static int index1 = 1000;
    static int index2 = 2000;
    NSMutableArray *rows = [NSMutableArray array];
    for (int i=0; i<200; i++) {
        NSString *subtitle = [NSString stringWithFormat:@"%@ - 粉丝掉了飞机撒劳动纠纷律师的加夫里什大家放辣椒少点六块腹肌撒的", @(index2++)];
        UITableViewRow2 *row1 = [[UITableViewRow2 alloc] initWithTitle:@(index1++).stringValue subtitle:subtitle];
        row1.showLine = YES;
        row1.height = 44;
        row1.lineEdgeInsets = UIEdgeInsetsMake(0, i, 0, i);
        row1.didSelectBlock = ^(UITableViewRow2 *row, NSIndexPath *indexPath) {
            NSLog(@"select row[%@]", row.uuid);
        };
        [rows addObject:row1];
    }
    
    UISeperatorRow *row6 = [[UISeperatorRow alloc] initWithHeight:20 backgroundColor:[UIColor lightGrayColor]];
    UISeperatorRow *row7 = [[UISeperatorRow alloc] initWithHeight:30 backgroundColor:[UIColor orangeColor]];
    row7.title = @"粉丝掉了飞机撒劳动纠纷律师的加夫里什大家放辣椒少点六块腹肌撒的";
    row7.titleFont = [UIFont systemFontOfSize:10];
    row7.titleColor = [UIColor purpleColor];
    [rows addObjectsFromArray:@[row6, row7]];
    
    self.manager = [[UITableViewManager2 alloc] initWithTableView:self.tableView rows:rows];
    [self.manager reloadData];
}

- (void)addSubviews {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor redColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView = [UIView new];
    // ⚠️ 必须要在tableview加入到父view之后设置才有效
    tableView.estimatedRowHeight = 50.0f;
    [self.view addSubview:tableView];
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
        }];
    } else if ([UIDevice currentDevice].systemVersion.floatValue >= 10.0f) {
//        self.automaticallyAdjustsScrollViewInsets = NO;
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
            make.bottom.equalTo(self.mas_bottomLayoutGuide);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
        }];
    } else {
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height);
            make.bottom.equalTo(self.mas_bottomLayoutGuide);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
        }];
    }
    self.tableView = tableView;
}

#pragma mark - FPS demo

- (void)testFPSLabel {
    _fpsLabel = [YYFPSLabel new];
    _fpsLabel.frame = CGRectMake(200, 200, 50, 30);
    [_fpsLabel sizeToFit];
    [self.view addSubview:_fpsLabel];
    
    // 如果直接用 self 或者 weakSelf，都不能解决循环引用问题
    
    // 移除也不能使 label里的 timer invalidate
    //        [_fpsLabel removeFromSuperview];
}

#pragma mark - 子线程 timer demo

- (void)testSubThread {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(200, 200, 100, 50)];
    label_ = label;
    label.backgroundColor = [UIColor grayColor];
    [self.tableView addSubview:label];
    
    // 开启子线程，新建 runloop， 避免主线程 阻塞时， timer不能用
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self->_link = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick:)];
        
        // NOTE: 子线程的runloop默认不创建； 在子线程获取 currentRunLoop 对象的时候，就会自动创建RunLoop
        
        // 这里不加到 main loop，必须创建一个 runloop
        NSRunLoop *runloop = [NSRunLoop currentRunLoop];
        [self->_link addToRunLoop:runloop forMode:NSRunLoopCommonModes];
        
        // 必须 timer addToRunLoop 后，再run
        [runloop run];
    });
    
    // 模拟 主线程阻塞 （不应该模拟主线程卡死，模拟卡顿即可）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"即将阻塞");
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"同步阻塞主线程");
        });
        NSLog(@"不会执行");
    });
}

- (void)tick:(CADisplayLink *)link {
    if (_lastTime == 0) {
        _lastTime = link.timestamp;
        return;
    }
    
    _renderCount++;
    NSTimeInterval delta = link.timestamp - _lastTime;
    if (delta < 1) return;
    _lastTime = link.timestamp;
    float fps = _renderCount / delta;
    _renderCount = 0;
    
    NSString *text = [NSString stringWithFormat:@"%d FPS",(int)round(fps)];
    
    // 尝试1：主线程阻塞， 这里就不能获取到主线程了
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        //  阻塞时，想通过 在主线程更新UI 来查看是不可行了
    //        label_.text = text;
    //    });
    
    // 尝试2：不在主线程操作 UI ，界面会发生变化
    label_.text = text;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
