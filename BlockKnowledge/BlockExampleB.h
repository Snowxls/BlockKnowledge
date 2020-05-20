//
//  BlockExampleB.h
//  BlockKnowledge
//
//  Created by Snow WarLock on 2020/5/20.
//  Copyright © 2020 Chineseall. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN



@interface BlockExampleB : BaseViewController

typedef void(^getVCBstringBlock) (NSString *string);
@property (nonatomic, copy) getVCBstringBlock CVBlock;

@end

NS_ASSUME_NONNULL_END
