Block的特性

- 保存一段代码块
- 随时随地的持有
- 匿名函数 —— block -> 对象 -> struct 
- 自动捕获变量 并在 struct中增加对应属性
- 进入栈 ——> 操作符重写 ——> copy
- 进入堆
####Block的分类
- NSGlobalBlock

```
    void (^block1)(void) = ^{
        NSLog(@"Hello Block");
    };
    
    block1();
    NSLog(@"block = %@",block1); //全局 静态  __NSGlobalBlock__
```
![](https://upload-images.jianshu.io/upload_images/8416233-49182efd68fdff88.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

- NSMallocBlock

```
    int a = 10; //10存在栈中 取了个"a"的别名
    void (^block2)(void) = ^{
        NSLog(@"Hello Block - %d",a);
    };
    block2();
    NSLog(@"block = %@",block2); // __NSMallocBlock__ 堆block
```
![](https://upload-images.jianshu.io/upload_images/8416233-a4a19d57093dafc2.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

- NSStackBlock

```
    //void (^block)(void) =
    //取别名 block
    NSLog(@"%@",^{
        NSLog(@"Hello Block - %d",a);
    });
```
![](https://upload-images.jianshu.io/upload_images/8416233-35d24913ac6e352b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
#####总结
变量通过内存的布局来分类
######知识点
栈区:0x7

堆区:0x6

静态变量:0x1
####block初探
######正常释放流程
![A持有B](https://upload-images.jianshu.io/upload_images/8416233-15076e05df84bc2e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
![A释放B](https://upload-images.jianshu.io/upload_images/8416233-b57e1ed211579f3d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
######循环引用
![AB相互持有](https://upload-images.jianshu.io/upload_images/8416233-6ad99aa739d3be47.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
循环引用也可能出现在多个对象之间
######循环引用示例
```
    self.name = @"Snow";
    self.block = ^{
        NSLog(@"%@",self.name);
    };
    self.block();
```
######解除循环引用方法
```
    self.name = @"Snow";
    __weak typeof(self) weakSelf = self;
    self.block = ^{
        NSLog(@"%@",weakSelf.name);
    };
    self.block();
```
但是这个方法不够完美

如果对打印添加延时操作会输出null

```
    self.name = @"Snow";
    __weak typeof(self) weakSelf = self;
    self.block = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //这时会输出null
            NSLog(@"%@",weakSelf.name);
        });
    };
    self.block();
```
原因是先触发dealloc方法 self = nil
weakSelf.name — 代用getter — 消息 —> 向nil发消息 —> 返回null
######优化方案
```
    self.name = @"Snow";
    __weak typeof(self) weakSelf = self;
    self.block = ^{
        __strong typeof(self) strongSelf = weakSelf;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"%@",strongSelf.name);
        });
    };
    self.block();
```
这样就能执行完block内容再执行dealloc
######使用 __block 来解除循环引用
```
    __block BlockKnowledgeVC2* vc = self;
    self.block = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"%@",vc.name);
            vc = nil;
        });
    };
    self.block();
```
######重点:这个vc必须在block使用结束后设置为nil
__block 能 copy 对象 —> struct 中
self —> block —> vc —> self     这时还是相互持有的
self —> block —> nil(对象回收) —> self    设置成nil后对象回收,循环解除   
######新思路:将需要使用的对象当成参数传入
```
typedef void(^SnowBlock2) (BlockKnowledgeVC2 *vc);
```
```
    self.block2 = ^(BlockKnowledgeVC2 *vc) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"%@",vc.name);
        });
    };
    self.block2(self);
```
######在block中对外部对象进行操作 需要加 __block 
```
    __block int a = 10;
    void(^block)(void)= ^{
        a++;
    };
    block();
```
为了研究 block 工作原理 添加辅助代码

```
    __block int a = 10;
    NSLog(@"进入block前 —— %p",&a);
    void(^block)(void)= ^{
        a++;
        NSLog(@"block操作中 —— %p",&a);
    };
    NSLog(@"block操作完毕 —— %p",&a);
    block();
```
结果
![](https://upload-images.jianshu.io/upload_images/8416233-177263faf5b18aa1.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
进入前0x7  在栈区

操作中 0x6  在堆

操作完毕 0x6  在堆
######关于为什么block中使用外部属性需要加 __block 再深入探索下 
建立一个.c文件并写入

```
#include <stdio.h>

int main(){
    void(^block)(void) = ^{
        printf("Block test by Snow");
    };
    block();
    return 0;
}
```
之后终端 gcc 执行.c文件

![](https://upload-images.jianshu.io/upload_images/8416233-a7494df1137a8a52.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

这时会生成个a.out的文件

![](https://upload-images.jianshu.io/upload_images/8416233-5b605e6a998f2eaf.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

终端执行a.out文件 就能看到之前在文件中printf的内容

![](https://upload-images.jianshu.io/upload_images/8416233-6aa747458cc3d849.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

将blockTest.c还原成c++文件 
clang -rewrite-objc blockTest.c -o blockTest.cpp

![](https://upload-images.jianshu.io/upload_images/8416233-6bad40a14901967f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

得到blockTest.cpp文件

![](https://upload-images.jianshu.io/upload_images/8416233-07d89c6fd4f7c074.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

打开后 找到对应上面的main函数

![](https://upload-images.jianshu.io/upload_images/8416233-4c56f239beb2bce5.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

- 对应的block结构体

```
void(*block)(void) = ((void (*)())&__main_block_impl_0((void *)__main_block_func_0, &__main_block_desc_0_DATA));
```

- 对应block执行

```
((void (*)(__block_impl *))((__block_impl *)block)->FuncPtr)((__block_impl *)block);
```

- block结构体

```
// block 结构体对象
struct __main_block_impl_0 {
  struct __block_impl impl;
  struct __main_block_desc_0* Desc;
  __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, int flags=0) {
    // 初始化
    impl.isa = &_NSConcreteStackBlock; //对象
    impl.Flags = flags;
    // 属性函数
    impl.FuncPtr = fp; // 函数调用 -- 保存函数 -- block 保存了代码块
    Desc = desc;
  }
};
```

现在我们调整下.c文件，添加一个int a

```
int main(){
    int a = 10;
    void(^block)(void) = ^{
        printf("Block test by Snow -- %d",a);
    };
    block();
    return 0;
}
```

转成cpp文件并打开后得到

```
int main(){
    int a = 10; // 新增的参数
    void(*block)(void) = ((void (*)())&__main_block_impl_0((void *)__main_block_func_0, &__main_block_desc_0_DATA, a));
    // 将自己作为参数传入
    ((void (*)(__block_impl *))((__block_impl *)block)->FuncPtr)((__block_impl *)block);
    return 0;
}
```

得到的block结构体

```
struct __main_block_impl_0 {
  struct __block_impl impl;
  struct __main_block_desc_0* Desc;
  int a; // 自动捕获到了变量
  __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, int _a, int flags=0) : a(_a) {
    impl.isa = &_NSConcreteStackBlock;
    impl.Flags = flags;
    impl.FuncPtr = fp;
    Desc = desc;
  }
};
```

执行时得到

```
static void __main_block_func_0(struct __main_block_impl_0 *__cself) {
  int a = __cself->a; // 创建了一个新的变量 - block -> a --值传递 10

        printf("Block test by Snow -- %d",a);
    }
```

######得到结论：这是一个值的传递 block保存了a的值，也就是10
######现在我们再调整下.c文件 在int a 前添加 __block

```
int main(){
    __block int a = 10;
    void(^block)(void) = ^{
        printf("Block test by Snow -- %d",a);
    };
    block();
    return 0;
}
```

找到cpp中的main函数

```
int main(){
    __attribute__((__blocks__(byref))) __Block_byref_a_0 a = {
        (void*)0,
        (__Block_byref_a_0 *)&a, // 引用 指针 -- 属性
        0,
        sizeof(__Block_byref_a_0),
        10 //值
    };
    
    //&a -- 结构体的指针地址
    void(*block)(void) = ((void (*)())&__main_block_impl_0((void *)__main_block_func_0, &__main_block_desc_0_DATA, (__Block_byref_a_0 *)&a, 570425344));
    
    ((void (*)(__block_impl *))((__block_impl *)block)->FuncPtr)((__block_impl *)block);
    
    return 0;
}
```

block结构体

```
struct __main_block_impl_0 {
  struct __block_impl impl;
  struct __main_block_desc_0* Desc;
  __Block_byref_a_0 *a; // 自动捕获指针a
  __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, __Block_byref_a_0 *_a, int flags=0) : a(_a->__forwarding) {
    impl.isa = &_NSConcreteStackBlock;
    impl.Flags = flags;
    impl.FuncPtr = fp;
    Desc = desc;
  }
};
```

可以看到block自动捕获了指针a

```
static void __main_block_func_0(struct __main_block_impl_0 *__cself) {
    
  // __cself->a --> 结构体 -> &a(原来的a )
  __Block_byref_a_0 *a = __cself->a; // bound by ref -- 指针传递

        printf("Block test by Snow -- %d",(a->__forwarding->a));
    }
```

block的执行中使用的也是a的指针

#####总结:

#####- 没有__block -- 值传递 -- 不能修改 -- 只读

#####- 有__block -- 指针的传递 -- 可以修改