//
//  AppDelegate.m
//  BlockKnowledge
//
//  Created by Snow WarLock on 2020/5/19.
//  Copyright © 2020 Chineseall. All rights reserved.
//

#import "AppDelegate.h"
#import "BlockKnowledgeVC1.h"
#import "BlockKnowledgeVC2.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    _window = [[UIWindow alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
    [_window setBackgroundColor: [UIColor grayColor]];
    
    [_window makeKeyAndVisible];
    
    UINavigationController *nav = [[UINavigationController alloc] init];
    _window.rootViewController = nav;
    
    BlockKnowledgeVC1 *vc1 = [BlockKnowledgeVC1 new];
    BlockKnowledgeVC2 *vc2 = [BlockKnowledgeVC2 new];
    [nav pushViewController:vc1 animated:NO];
    
    
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
