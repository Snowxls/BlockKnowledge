//
//  BlockExampleB.m
//  BlockKnowledge
//
//  Created by Snow WarLock on 2020/5/20.
//  Copyright © 2020 Chineseall. All rights reserved.
//

#import "BlockExampleB.h"

@interface BlockExampleB ()<UITextFieldDelegate> {
    
}

@property (nonatomic,strong) UITextField *textField;

@end

@implementation BlockExampleB

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 300, 100)];
    [self.view addSubview:self.textField];
    self.textField.backgroundColor = [UIColor yellowColor];
    self.textField.center = self.view.center;
    
    UIButton *back = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 200, 200)];
    [back setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [back setTitle:@"返回" forState:UIControlStateNormal];
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
    self.CVBlock(self.textField.text);
}

@end
