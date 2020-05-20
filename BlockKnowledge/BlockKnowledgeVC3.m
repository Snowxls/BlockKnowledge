//
//  BlockKnowledgeVC3.m
//  BlockKnowledge
//
//  Created by Snow WarLock on 2020/5/19.
//  Copyright © 2020 Chineseall. All rights reserved.
//

#import "BlockKnowledgeVC3.h"
#import "BlockKnowledgeVC4.h"

@interface BlockKnowledgeVC3 ()

@end

@implementation BlockKnowledgeVC3

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __block int a = 10;
    NSLog(@"进入block前 —— %p",&a); //0x7  栈
    void(^block)(void)= ^{
        a++;
        NSLog(@"block操作中 —— %p",&a); //0x6 堆
    };
    NSLog(@"block操作完毕 —— %p",&a); //0x6 堆
    block();
    
    UIButton *go = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    go.backgroundColor = [UIColor yellowColor];
    [go setTitle:@"跳转" forState:UIControlStateNormal];
    [go setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [go addTarget:self action:@selector(gotoVC4) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:go];
    go.center = self.view.center;
}

- (void)gotoVC4 {
    BlockKnowledgeVC4 *vc4 = [BlockKnowledgeVC4 new];
    [self.navigationController pushViewController:vc4 animated:YES];
}

@end
