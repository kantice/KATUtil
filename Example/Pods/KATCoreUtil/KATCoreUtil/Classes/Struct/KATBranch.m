//
//  KATBranch.m
//  KATFramework
//
//  Created by Yi Yu on 2017/6/2.
//  Copyright © 2017年 KatApp. All rights reserved.
//

#import "KATBranch.h"



///节点类型
@interface KATBranchNode : NSObject

///索引
@property(nonatomic,copy) NSString *key;

///父节点数组
@property(nonatomic,retain) KATArray<NSString *> *parents;

///子节点数组
@property(nonatomic,retain) KATArray<NSString *> *children;


///获取实例
+ (instancetype)node;

///释放内存
- (void)dealloc;


@end



@implementation KATBranchNode

//获取实例
+ (instancetype)node
{
    KATBranchNode *node=[[[self alloc] init] autorelease];
    
    node.key=nil;
    node.parents=[KATArray arrayWithCapacity:16];
    node.children=[KATArray arrayWithCapacity:64];
    
    return node;
}


//释放资源
- (void)releaseData
{
    if(_children)
    {
        [_children clear];
    }
    
    if(_parents)
    {
        [_parents clear];
    }
}


//释放内存
- (void)dealloc
{
    [self releaseData];
    
    [_key release];
    [_parents release];
    [_children release];
    
    [super dealloc];
}


@end




@interface KATBranch ()

///节点树
@property(nonatomic,retain) KATTreeMap<KATBranchNode *> *nodes;

@end



@implementation KATBranch

//获取实例
+ (instancetype)branch
{
    KATBranch *branch=[[[self alloc] init] autorelease];
    
    branch.nodes=[KATTreeMap treeMap];
    
    return branch;
}


#pragma mark - 对象方法

//添加节点到父节点(可以重复添加，父节点可以为空)
- (void)addNode:(NSString *)node toParent:(NSString *)parent
{
    if(node)
    {
        KATBranchNode *n=_nodes[node];
        
        if(!n)//不存在，则创建
        {
            n=[KATBranchNode node];
            n.key=node;
            
            _nodes[node]=n;
        }
        
        if(parent && _nodes[parent])//存在父节点
        {
            //判断是否已经存在该父节点
            if(![n.parents hasMember:parent])
            {
                //添加父节点
                [n.parents put:parent];
            }
            
            //判读是否存在该子节点
            if(![_nodes[parent].children hasMember:node])
            {
                //添加子节点
                [_nodes[parent].children put:node];
            }
        }
    }
}


//添加节点到子节点(可以重复添加，子节点可以为空)
- (void)addNode:(NSString *)node toChild:(NSString *)child
{
    if(node)
    {
        KATBranchNode *n=_nodes[node];
        
        if(!n)//不存在，则创建
        {
            n=[KATBranchNode node];
            n.key=node;
            
            _nodes[node]=n;
        }
        
        if(child && _nodes[child])//存在子节点
        {
            //判断是否已经存在该子节点
            if(![n.children hasMember:child])
            {
                //添加子节点
                [n.children put:child];
            }
            
            //判读是否存在该父节点
            if(![_nodes[child].parents hasMember:node])
            {
                //添加子节点
                [_nodes[child].parents put:node];
            }
        }
    }
}


//添加独立的节点
- (void)addNode:(NSString *)node
{
    if(node)
    {
        KATBranchNode *n=_nodes[node];
        
        if(!n)//不存在，则创建
        {
            n=[KATBranchNode node];
            n.key=node;
            
            _nodes[node]=n;
        }
    }
}


//从父节点中删除
- (void)deleteNode:(NSString *)node fromParent:(NSString *)parent
{
    if(node && parent && _nodes[node] && _nodes[parent])
    {
        [_nodes[node].parents deleteMember:parent];
        
        [_nodes[parent].children deleteMember:node];
    }
}


//从子节点中删除
- (void)deleteNode:(NSString *)node fromChild:(NSString *)child
{
    if(node && child && _nodes[node] && _nodes[child])
    {
        [_nodes[node].children deleteMember:child];
        
        [_nodes[child].parents deleteMember:node];
    }
}


//删除节点
- (void)deleteNode:(NSString *)node
{
    if(node && _nodes[node])//存在该节点
    {
        //清除与父节点的联系
        for(NSString *parent in _nodes[node].parents)
        {
            if(_nodes[parent])
            {
                [_nodes[parent].children deleteMember:node];
            }
        }
        
        //清除与子节点的联系
        for(NSString *child in _nodes[node].children)
        {
            if(_nodes[child])
            {
                [_nodes[child].parents deleteMember:node];
            }
        }
        
        //清除关联
        [_nodes[node].parents clear];
        [_nodes[node].children clear];
        
        //删除节点
        [_nodes deleteValueWithKey:node];
    }
}


//获取该节点的所有父节点(包括父节点的父节点)
- (KATArray<NSString *> *)parentsWithNode:(NSString *)node
{
    KATArray<NSString *> *pArray=[KATArray array];
    
    [self _parentsWithNode:node andArray:pArray];
    
    return [pArray distinctArray];
}


//获取父节点的递归方法(内部方法)
- (void)_parentsWithNode:(NSString *)node andArray:(KATArray<NSString *> *)array
{
    for(NSString *p in _nodes[node].parents)
    {
        if(![array hasMember:p])//非自身循环则继续
        {
            [array put:p];
            
            [self _parentsWithNode:p andArray:array];
        }
    }
}


//获取该节点的所有子节点(包括子节点的子节点)
- (KATArray<NSString *> *)childrenWithNode:(NSString *)node
{
    KATArray<NSString *> *cArray=[KATArray array];
    
    [self _childrenWithNode:node andArray:cArray];
    
    return [cArray distinctArray];
}


//获取子节点的递归方法(内部方法)
- (void)_childrenWithNode:(NSString *)node andArray:(KATArray<NSString *> *)array
{
    for(NSString *c in _nodes[node].children)
    {
        if(![array hasMember:c])//非自身循环则继续
        {
            [array put:c];
            
            [self _childrenWithNode:c andArray:array];
        }
    }
}


//判断是否自己也是父节点(循环)
- (BOOL)hasSelfParentNode:(NSString *)node
{
    return [[self parentsWithNode:node] hasMember:node];
}


//判断是否自己也是子节点(循环)
- (BOOL)hasSelfChildNode:(NSString *)node
{
    return [[self childrenWithNode:node] hasMember:node];
}


//判断某条父节点线路中是否自己也是父节点(循环)
- (BOOL)hasSelfParentNode:(NSString *)node fromParent:(NSString *)parent
{
    if(node && parent)
    {
        if([node isEqualToString:parent])
        {
            return YES;
        }
        
        KATArray<NSString *> *parents=[self parentsWithNode:parent];
        
        return [parents hasMember:node];
    }
    
    return NO;
}


//判断某条子节点线路中是否自己也是子节点(循环)
- (BOOL)hasSelfChildNode:(NSString *)node fromChild:(NSString *)child
{
    if(node && child)
    {
        if([node isEqualToString:child])
        {
            return YES;
        }
        
        KATArray<NSString *> *children=[self childrenWithNode:child];
        
        return [children hasMember:node];
    }
    
    return NO;
}


//描述
- (NSString *)description
{
    NSMutableString *ms=[NSMutableString stringWithFormat:@"KATBranch: len=%i \n{\n",_nodes.length];
    
    KATArray *keys=[_nodes allKeys];
    
    for(NSString *key in keys)
    {
        [ms appendString:[NSString stringWithFormat:@"\n%@",key]];
        
        [ms appendString:@"\nparents: "];
        
        for(NSString *parent in _nodes[key].parents)
        {
            [ms appendString:[NSString stringWithFormat:@"%@,",parent]];
        }
        
        [ms appendString:@"\nchlidren: "];
        
        for(NSString *child in _nodes[key].children)
        {
            [ms appendString:[NSString stringWithFormat:@"%@,",child]];
        }
        
        [ms appendString:@"\n"];
    }
    
    [ms appendString:@"\n}"];
    
    return ms;
}


//释放内存
- (void)dealloc
{
    KATArray<KATBranchNode *> *nodeArray=[_nodes allValues];
    
    //释放资源
    for(KATBranchNode * node in nodeArray)
    {
        [node releaseData];
    }
    
    [_nodes release];
    
    [super dealloc];
}


@end








