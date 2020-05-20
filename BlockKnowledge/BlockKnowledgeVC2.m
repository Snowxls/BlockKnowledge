//
//  BlockKnowledgeVC2.m
//  BlockKnowledge
//
//  Created by Snow WarLock on 2020/5/19.
//  Copyright © 2020 Chineseall. All rights reserved.
//

#import "BlockKnowledgeVC2.h"
#import "BlockKnowledgeVC3.h"

typedef void(^SnowBlock) (void);

typedef void(^SnowBlock2) (BlockKnowledgeVC2 *vc);

@interface BlockKnowledgeVC2 () {
    
}

@property (nonatomic, copy) SnowBlock block;
@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) SnowBlock2 block2;

@end

@implementation BlockKnowledgeVC2

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.name = @"Snow";
    
    //使用 __strong 关键字
    //[self method1];
    
    //使用 __block 关键字
    //[self method2];
    
    //使用带参数传入的block
    [self method3];
    
    
    UIButton *go = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    go.backgroundColor = [UIColor yellowColor];
    [go setTitle:@"跳转" forState:UIControlStateNormal];
    [go setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [go addTarget:self action:@selector(gotoVC3) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:go];
    go.center = self.view.center;
}

- (void)method1 {
    // 防止循环引用方案1 block中用 __strong
    __weak typeof(self) weakSelf = self;
    self.block = ^{
        __strong typeof(self) strongSelf = weakSelf;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //这时会输出null
            //NSLog(@"%@",weakSelf.name);
            //weakSelf.name — 代用getter — 消息 —> 向nil发消息
            NSLog(@"%@",strongSelf.name);
        });
    };
    self.block();
}

- (void)method2 {
    // 防止循环引用方案2 __block
    __block BlockKnowledgeVC2* vc = self;
    self.block = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"%@",vc.name);
            vc = nil;
        });
    };
    self.block();
}

- (void)method3 {
    //使用带参数的block
    self.block2 = ^(BlockKnowledgeVC2 *vc) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"%@",vc.name);
        });
    };
    self.block2(self);
}

- (void)gotoVC3 {
    BlockKnowledgeVC3 *vc3 = [BlockKnowledgeVC3 new];
    [self.navigationController pushViewController:vc3 animated:YES];
}

- (void)dealloc {
    NSLog(@"dealloc 触发");
}

@end
