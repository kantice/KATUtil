//
//  KATBranch.h
//  KATFramework
//
//  Created by Yi Yu on 2017/6/2.
//  Copyright © 2017年 KatApp. All rights reserved.
//  分支结构，可以交叉，用于展现对象之间的联系，只存索引，若需要用到数据，则需与HashMap或TreeMap配合使用


#import <Foundation/Foundation.h>
#import "KATArray.h"
#import "KATTreeMap.h"




@interface KATBranch : NSObject


#pragma mark - 类方法

///获取实例
+ (instancetype)branch;


#pragma mark - 对象方法

///添加节点到父节点(可以重复添加，父节点可以为空)
- (void)addNode:(NSString *)node toParent:(NSString *)parent;

///添加节点到子节点(可以重复添加，子节点可以为空)
- (void)addNode:(NSString *)node toChild:(NSString *)child;

///添加独立的节点
- (void)addNode:(NSString *)node;

///删除与父节点的联系
- (void)deleteNode:(NSString *)node fromParent:(NSString *)parent;

///删除与子节点的联系
- (void)deleteNode:(NSString *)node fromChild:(NSString *)child;

///删除节点
- (void)deleteNode:(NSString *)node;

///获取该节点的所有父节点(包括父节点的父节点)
- (KATArray<NSString *> *)parentsWithNode:(NSString *)node;

///获取该节点的所有子节点(包括子节点的子节点)
- (KATArray<NSString *> *)childrenWithNode:(NSString *)node;

///判断是否自己也是父节点(循环)
- (BOOL)hasSelfParentNode:(NSString *)node;

///判断是否自己也是子节点(循环)
- (BOOL)hasSelfChildNode:(NSString *)node;

///判断某条父节点线路中是否自己也是父节点(循环)
- (BOOL)hasSelfParentNode:(NSString *)node fromParent:(NSString *)parent;

///判断某条子节点线路中是否自己也是子节点(循环)
- (BOOL)hasSelfChildNode:(NSString *)node fromChild:(NSString *)child;


@end




