//
//  BlockExampleA.m
//  BlockKnowledge
//
//  Created by Snow WarLock on 2020/5/20.
//  Copyright © 2020 Chineseall. All rights reserved.
//

#import "BlockExampleA.h"
#import "BlockExampleB.h"

@interface BlockExampleA () {
    
}

@property (nonatomic,strong) UILabel *textLabel;

@end

@implementation BlockExampleA

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
    [self.view addSubview:self.textLabel];
    self.textLabel.center = self.view.center;
    
    UIButton *gotoB = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 200, 200)];
    [gotoB setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [gotoB setTitle:@"切换到B界面" forState:UIControlStateNormal];
    [gotoB addTarget:self action:@selector(gotoB) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:gotoB];
    
}

- (void)gotoB {
    BlockExampleB *vcB = [BlockExampleB new];
    [self.navigationController pushViewController:vcB animated:YES];
    
    __weak typeof(self) weakSelf = self;
    [vcB setCVBlock:^(NSString * string) {
        weakSelf.textLabel.text = string;
    }];
}



@end
