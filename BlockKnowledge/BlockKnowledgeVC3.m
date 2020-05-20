//
//  BlockKnowledgeVC3.m
//  BlockKnowledge
//
//  Created by Snow WarLock on 2020/5/19.
//  Copyright © 2020 Chineseall. All rights reserved.
//

#import "BlockKnowledgeVC3.h"

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
}

@end
