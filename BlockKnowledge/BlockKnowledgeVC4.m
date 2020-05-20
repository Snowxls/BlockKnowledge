//
//  BlockKnowledgeVC4.m
//  BlockKnowledge
//
//  Created by Snow WarLock on 2020/5/20.
//  Copyright © 2020 Chineseall. All rights reserved.
//

#import "BlockKnowledgeVC4.h"
#import "BlockExampleA.h"

@interface BlockKnowledgeVC4 () {
    
}

typedef int (^SnowBlock) (int,int);
//作为对象的属性声明,copy后block会转移到堆中和对象一起
@property (nonatomic, copy) SnowBlock myBlock; //使用 typedef
@property (nonatomic, copy) int (^sumNumber)(int,int); //不使用 typedef

@end

@implementation BlockKnowledgeVC4

- (void)viewDidLoad {
    [super viewDidLoad];
    
#pragma mark Block的基础形式
    //无参数无返回值
    void(^Myblock1)(void) = ^{
        NSLog(@"无参数,无返回值");
    };
    Myblock1();
    
    //有参数,无返回值,声明和定义
    void(^Myblock2)(int a) = ^(int a){
        NSLog(@"%d是我传入的参数,无返回值",a);
    };
    Myblock2(100);
    
    //有参数,有返回值
    int(^Myblock3)(int,int) = ^(int a,int b) {
        NSLog(@"%d 和 %d 是我传入的参数,有返回值",a,b);
        return a + b;
    };
    Myblock3(11,12);
    
    //无参数,有返回值
    int(^Myblock4)(void) = ^ {
        NSLog(@"无参数,有返回值");
        return 233;
    };
    Myblock4();
    
    
    self.myBlock = ^int(int a, int b) {
        //TODO
        return a + b;
    };
    
#pragma mark Block循环引用相关
    int age = 27;
    void(^AgeBlock)(void) = ^{
        NSLog(@"age = %d",age);
    };
    age = 18;
    AgeBlock();
    
    __block int age2 = 27;
    void(^AgeBlock2)(void) = ^{
        NSLog(@"age2 = %d",age2);
    };
    age2 = 18;
    AgeBlock2();
    
    [[[[AgeBlock2 copy] copy] copy] copy];
    
    // ARC下使用
    __weak typeof(self) weakSelf = self;
    self.myBlock = ^int(int a, int b) {
        [weakSelf dosomething];
        return a + b;
    };
    
    // MRC下使用
//    __block typeof(self) blockSelf = self;
//    self.myBlock = ^int(int a, int b) {
//        [blockSelf dosomething];
//        return a + b;
//    };
    
    __block NSString *tmp = @"233";
    self.myBlock = ^int(int a, int b) {
        NSLog(@"%@",tmp);
        return a + b;
        tmp = nil;
    };
    
    self.myBlock(1,2);
    
    
#pragma mark Block的使用示例
    //Block作为变量
    int (^sum) (int,int); //定义一个 Block 变量 sum
    //给 Block 变量赋值
    //一般 返回值省略
    sum = ^int (int a,int b) {
        return a + b;
    };
    int n = sum(10,12);// 调用
    
    
    //Block作为属性
    // 给 Calculate 类型 sum2变量 赋值
    typedef int (^Calculate)(int,int); //Calculate 就是类型名
    Calculate sum2 = ^(int a,int b) {
        return a + b;
    };
    int a = sum2(10,20);//调用 sum2 变量
    
    self.sumNumber = ^int(int a, int b) {
        return a + b;
    };
    
    //无参数block函数调用
    [self testTimeConsume:^{
       // 放入 block 中的代码
    }];
    
    //有参数的block函数调用
    [self testTimeConsume2:^(NSString *name) {
        // 放入 block 中的代码 可以使用参数 name
        // 参数 name 是实现代码中传入的 在调用时只能使用 不能传值
    }];
    
    UIButton *go = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    go.backgroundColor = [UIColor yellowColor];
    [go setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [go setTitle:@"案例演示" forState:UIControlStateNormal];
    [go addTarget:self action:@selector(showExample) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:go];
    go.center = self.view.center;
    
}

#pragma mark 无参数传递的 Block
- (CGFloat)testTimeConsume:(void(^)(void))middleBlock {
    // 执行前记录下当前的时间
    CFTimeInterval startTime = CACurrentMediaTime();
    middleBlock();
    // 执行后记录下当前时间
    CFTimeInterval endTime = CACurrentMediaTime();
    return endTime - startTime;
}

#pragma mark 有参数传递的 Block
- (CGFloat)testTimeConsume2:(void(^)(NSString *name))middleBlock {
    // 执行前记录下当前的时间
    CFTimeInterval startTime = CACurrentMediaTime();
    NSString *name = @"有参数";
    middleBlock(name);
    // 执行后记录下当前时间
    CFTimeInterval endTime = CACurrentMediaTime();
    return endTime - startTime;
}


- (void)dosomething {
    
}

- (void)showExample {
    BlockExampleA *vcA = [BlockExampleA new];
    [self.navigationController pushViewController:vcA animated:YES];
}

@end
