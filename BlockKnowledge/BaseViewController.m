//
//  BaseViewController.m
//  BlockKnowledge
//
//  Created by Snow WarLock on 2020/5/19.
//  Copyright © 2020 Chineseall. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"%@ ------- show",[NSString stringWithUTF8String:object_getClassName(self)]);
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"%@ ------- dealloc",[NSString stringWithUTF8String:object_getClassName(self)]);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
}


- (void)dealloc {
    
}

@end
