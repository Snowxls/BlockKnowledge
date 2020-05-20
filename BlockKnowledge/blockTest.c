//
//  blockTest.c
//  BlockKnowledge
//
//  Created by Snow WarLock on 2020/5/20.
//  Copyright © 2020 Chineseall. All rights reserved.
//

#include <stdio.h>

int main(){
    __block int a = 10;
    void(^block)(void) = ^{
        printf("Block test by Snow -- %d",a);
    };
    block();
    return 0;
}
