//
//  BlockKnowledgeVC1.m
//  BlockKnowledge
//
//  Created by Snow WarLock on 2020/5/19.
//  Copyright © 2020 Chineseall. All rights reserved.
//

#import "BlockKnowledgeVC1.h"
#import "BlockKnowledgeVC2.h"

@interface BlockKnowledgeVC1 ()

@end

@implementation BlockKnowledgeVC1

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //block精髓:保存一段代码块
    //持有 - 随时随地
    //匿名函数 —— block -> 对象
    void (^block1)(void) = ^{
        NSLog(@"Hello Block");
    };
    
    block1();
    //NSLog -- printf
    //I/O 耗时 -- 性能优化
    //使用宏 调试代码 -- lldb
    //viewDidLoad 本质
    //方法 -- 消息
    NSLog(@"block = %@",block1); //全局 静态  __NSGlobalBlock__
    
    int a = 10; //10存在栈中 取了个"a"的别名
    void (^block2)(void) = ^{
        NSLog(@"Hello Block - %d",a);
    };
    block2();
    NSLog(@"block = %@",block2); // __NSMallocBlock__ 堆block
    
    //void (^block)(void) =
    //取别名 block
    NSLog(@"%@",^{
        NSLog(@"Hello Block - %d",a);
    });
    
    
    UIButton *go = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    go.backgroundColor = [UIColor yellowColor];
    [go setTitle:@"跳转" forState:UIControlStateNormal];
    [go addTarget:self action:@selector(gotoVC2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:go];
    go.center = self.view.center;
}

- (void)gotoVC2 {
    BlockKnowledgeVC2 *vc2 = [BlockKnowledgeVC2 new];
    [self.navigationController pushViewController:vc2 animated:YES];
}

@end
