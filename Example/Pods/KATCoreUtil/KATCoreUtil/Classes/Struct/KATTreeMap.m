//
//  KATTreeMap.m
//  KATFramework
//
//  Created by Kantice on 13-11-20.
//  Copyright (c) 2013年 Kantice. All rights reserved.
//

#import "KATTreeMap.h"


#define TREE_COLOR_BLACK false
#define TREE_COLOR_RED true


///节点类型
typedef struct KATTreeNode
{
    NSString *key;//索引
    id value;//内容
    struct KATTreeNode *parent;//父节点
    struct KATTreeNode *left;//左节点
    struct KATTreeNode *right;//右节点
    
    bool color;//颜色(是否为红色)
}
KATTreeNode;



@interface KATTreeMap ()
{
    @private
    KATTreeNode *_root;//根节点
}


@end



@implementation KATTreeMap


#pragma mark - 类方法

//构造方法
+ (instancetype)treeMap
{
    KATTreeMap *treeMap=[[[self alloc] init] autorelease];
    
    //初始化root
    KATTreeNode *root=(KATTreeNode *)malloc(sizeof(KATTreeNode));//分配空间
    root->key=nil;
    root->value=nil;
    root->parent=nil;
    root->left=nil;
    root->right=nil;
    
    [treeMap setRoot:root];
    
    [treeMap setLength:0];//节点个数0
    
    treeMap.replace=YES;//默认为可以覆盖
    treeMap.balance=YES;//默认为红黑树
    
    return treeMap;
}


#pragma mark - 私有方法

//设置_length
- (void)setLength:(int)value
{
    _length=value;
}


//获取根节点
- (KATTreeNode *)root
{
    return _root;
}

//设置根节点
- (void)setRoot:(KATTreeNode *)root
{
    _root=root;
}



#pragma mark - 对象方法

//放置元素，成功则返回YES
- (BOOL)putWithKey:(NSString *)key andValue:(id)value
{
    if(key && value)
    {
        if(_root->key)
        {
            //初始化node
            KATTreeNode *node=nil;
            node=(KATTreeNode *)malloc(sizeof(KATTreeNode));//分配空间
            node->key=[key copy];
            node->value=[value retain];
            node->left=nil;
            node->right=nil;
            node->parent=nil;
            node->color=TREE_COLOR_RED;
            
            return [self addNode:node toParent:_root];//添加节点
        }
        else//root没有值，则将节点设为root
        {
            _root->key=[key copy];
            _root->value=[value retain];
            _root->color=TREE_COLOR_BLACK;
            _length++;
            
            return YES;
        }
    }
    else if(key && !value)//value为空则删除
    {
        return [self deleteValueWithKey:key];
    }
    
    return NO;
}


//添加节点（递归）（私有函数）
- (BOOL)addNode:(KATTreeNode *)node toParent:(KATTreeNode *)parent
{
    NSComparisonResult r=[node->key compare:parent->key];//比较
    
    if(r==NSOrderedAscending)//node的索引比parent小
    {
        if(parent->left)
        {
            return [self addNode:node toParent:parent->left];//再将node交给左节点进行比较
        }
        else//parent没有左节点，则把node添加为左节点
        {
            parent->left=node;
            node->parent=parent;
            
            [self checkBalanceWithNode:parent];
            
            _length++;
            
            return YES;
        }
    }
    else if(r==NSOrderedDescending)//node的索引比parent大
    {
        if(parent->right)
        {
            return [self addNode:node toParent:parent->right];//再将node交给右节点进行比较
        }
        else//parent没有左节点，则把node添加为左节点
        {
            parent->right=node;
            node->parent=parent;
            
            [self checkBalanceWithNode:parent];
            
            _length++;
            
            return YES;
        }
        
    }
    else//相同的索引
    {
        if(_replace)//可以覆盖
        {
            [parent->key release];
            parent->key=node->key;
            [parent->value release];//先释放后赋值
            parent->value=node->value;
            
            free(node);
            node=nil;
            
            return YES;
        }
        else//不能覆盖，则返回NO
        {
            //释放内存
            [node->key release];
            [node->value release];
            
            free(node);
            node=nil;
            
            return NO;
        }
    }
    
    
    
}




//根据索引获取值，失败则返回nil
- (id)getValueWithKey:(NSString *)key
{
    if(!key)
    {
        return nil;
    }
    
    if(_root->key)
    {
        KATTreeNode *node=[self getNode:_root forKey:key];
        
        if(node)
        {
            return node->value;
        }
        else
        {
            return nil;
        }
    }
    else//没有root
    {
        return nil;
    }
}


//根据索引设置元素值
- (BOOL)setValue:(id)value withKey:(NSString *)key
{
    if(!key || !value)
    {
        return NO;
    }
    
    if(_root->key)
    {
        KATTreeNode *node=[self getNode:_root forKey:key];
        
        if(node)
        {
            [node->value release];
            node->value=[value retain];
            
            return YES;
        }
        else
        {
            return NO;
        }
    }
    else//没有root
    {
        return NO;
    }
}


//返回节点（递归）（私有函数）
- (KATTreeNode *)getNode:(KATTreeNode *)node forKey:(NSString *)key
{
    NSComparisonResult r=[key compare:node->key];//比较
    
    if(r==NSOrderedAscending)//搜索的索引比node索引小
    {
        if(node->left)//继续在node的左节点中搜索
        {
            return [self getNode:node->left forKey:key];
        }
        else//不存在左节点，则找不到索引
        {
            return nil;
        }
    }
    else if(r==NSOrderedDescending)//搜索的索引比node索引小
    {
        if(node->right)//继续在node的左节点中搜索
        {
            return [self getNode:node->right forKey:key];
        }
        else//不存在左节点，则找不到索引
        {
            return nil;
        }

    }
    else//搜索的索引就是node索引，找到节点
    {
        return node;
    }

}


//删除元素，若成功则返回YES
- (BOOL)deleteValueWithKey:(NSString *)key
{
    if(!key)
    {
        return NO;
    }
    
    if(_root->key)
    {
        return [self deleteNode:_root forKey:key];
    }
    else//没有root
    {
        return NO;
    }

}


//删除节点（递归）（私有函数）
- (BOOL)deleteNode:(KATTreeNode *)node forKey:(NSString *)key
{
    NSComparisonResult r=[key compare:node->key];//比较
    
    if(r==NSOrderedAscending)//搜索的索引比node索引小
    {
        if(node->left)//继续在node的左节点中搜索
        {
            return [self deleteNode:node->left forKey:key];
        }
        else//不存在左节点，则找不到索引
        {
            return NO;
        }
    }
    else if(r==NSOrderedDescending)//搜索的索引比node索引小
    {
        if(node->right)//继续在node的左节点中搜索
        {
            return [self deleteNode:node->right forKey:key];
        }
        else//不存在左节点，则找不到索引
        {
            return NO;
        }
        
    }
    else//搜索的索引就是node索引，找到节点
    {
        //NSLog(@"---- 删除点:%@",node->key);
        
        //节点移位
        if(node->left)//有左节点
        {
            //NSLog(@"非叶子节点，有左节点");
            
            KATTreeNode *new=node->left;
            
            BOOL replace=NO;//是否是替换被删节点
            
            KATTreeNode *replaceLeft=nil;//替换点的左节点
            KATTreeNode *replaceBrother=nil;//替换点的兄弟
            
            //找到最右边的节点
            while(new->right)
            {
                new=new->right;
            }
            
            
            if(new->parent!=node)//如果new是node的子节点，则无需替换
            {
                replace=YES;
                
                replaceBrother=[self brotherWithNode:new];
                
                if(new->left)//最右节点存在左节点，则左节点替换最右节点的位置
                {
                    replaceLeft=new->left;
                    
                    new->parent->right=new->left;
                    new->left->parent=new->parent;
                    
                    //左节点变黑(该左节点必为单枝红色)
                    new->left->color=TREE_COLOR_BLACK;
                }
                else
                {
                    new->parent->right=nil;
                }
            }
            
            //最右节点替换被删除节点的位置
            if(node->parent)//非根节点
            {
                //NSLog(@"非根节点");
                
                if(node->parent->left==node)
                {
                    node->parent->left=new;
                }
                else
                {
                    node->parent->right=new;
                }
                
                if(node->left!=new)
                {
                    new->left=node->left;
                    
                    if(new->left)
                    {
                        new->left->parent=new;
                    }
                }
                
                if(node->right!=new)
                {
                    new->right=node->right;
                    
                    if(new->right)
                    {
                        new->right->parent=new;
                    }
                }
                
                new->parent=node->parent;
                
                if(_balance)
                {
                    if(replace)//左节点最右端节点替换模式，该模式下删除点必有与左节点子树平衡的右子树，该替换点必为黑色，且最多有一个红色左子节点
                    {
                        //NSLog(@"左节点最右端节点替换模式");
                        
                        //替换点改为被删点颜色
                        new->color=node->color;
                        
                        if(replaceLeft)//替换点有左红子节点
                        {
                            //NSLog(@"替换点有左红子节点");
                            
                            //左红子节点变黑
                            replaceLeft->color=TREE_COLOR_BLACK;
                        }
                        else//替换点为独立黑点
                        {
                            //NSLog(@"替换点为独立黑点");
                            
                            if(replaceBrother)//必有左兄弟
                            {
                                KATTreeNode *parent=replaceBrother->parent;//父节点(不会是根节点)
                                KATTreeNode *grand=parent->parent;//祖父节点
                                
                                BOOL isLeftSon=NO;
                                
                                if(grand && grand->left==parent)
                                {
                                    isLeftSon=YES;
                                }
                                
                                if(parent->color==TREE_COLOR_RED)//父节点为红色
                                {
                                    //NSLog(@"父节点为红色");
                                    
                                    if(replaceBrother->color==TREE_COLOR_RED)//兄弟节点为红色，不可能出现这种情况！
                                    {
                                        //NSLog(@"兄弟节点为红色，不可能出现这种情况！");
                                    }
                                    else//兄弟节点为黑色
                                    {
                                        //NSLog(@"兄弟节点为黑色");
                                        
                                        if(replaceBrother->left)//兄弟节点有左红子节点
                                        {
                                            //NSLog(@"兄弟节点有左红子节点");
                                            
                                            KATTreeNode *nephew=replaceBrother->left;
                                            
                                            //三点换色
                                            replaceBrother->color=TREE_COLOR_RED;
                                            parent->color=TREE_COLOR_BLACK;
                                            nephew->color=TREE_COLOR_BLACK;
                                            
                                            //兄弟替父位（相当于右转）
                                            //父非根
                                            if(grand->left==parent)
                                            {
                                                grand->left=replaceBrother;
                                            }
                                            else
                                            {
                                                grand->right=replaceBrother;
                                            }
                                            
                                            replaceBrother->parent=grand;
                                            replaceBrother->left=nephew;
                                            replaceBrother->right=parent;
                                            
                                            parent->parent=replaceBrother;
                                            parent->left=nil;
                                            parent->right=nil;
                                            
                                            nephew->parent=replaceBrother;
                                            nephew->left=nil;
                                            nephew->right=nil;
                                        }
                                        else//兄弟节点无子节点
                                        {
                                            //NSLog(@"兄弟节点无子节点");
                                            
                                            //父兄换色
                                            parent->color=TREE_COLOR_BLACK;
                                            replaceBrother->color=TREE_COLOR_RED;
                                        }
                                    }
                                }
                                else//父节点为黑色
                                {
                                    //NSLog(@"父节点为黑色");
                                    
                                    if(replaceBrother->color==TREE_COLOR_RED)//兄弟节点为红色
                                    {
                                        //NSLog(@"兄弟节点为红色");
                                        
                                        if(replaceBrother->left && replaceBrother->right)//必有两个黑色子节点
                                        {
                                            KATTreeNode *nephewL=replaceBrother->left;//左侄
                                            KATTreeNode *nephewR=replaceBrother->right;//右侄
                                            
                                            if(nephewR->left)//有右孙子
                                            {
                                                //NSLog(@"有右孙子");
                                                
                                                KATTreeNode *grandson=nephewR->left;
                                                
                                                //兄变黑，右侄和孙换色
                                                replaceBrother->color=TREE_COLOR_BLACK;
                                                nephewR->color=TREE_COLOR_RED;
                                                grandson->color=TREE_COLOR_BLACK;
                                                
                                                //兄替父位，右侄替删点，父在右侄右
                                                //父非根
                                                if(grand->left==parent)
                                                {
                                                    grand->left=replaceBrother;
                                                }
                                                else
                                                {
                                                    grand->right=replaceBrother;
                                                }
                                                
                                                replaceBrother->parent=grand;
                                                replaceBrother->left=nephewL;
                                                replaceBrother->right=nephewR;
                                                
                                                nephewR->parent=replaceBrother;
                                                nephewR->left=grandson;
                                                nephewR->right=parent;
                                                
                                                parent->parent=nephewR;
                                                parent->left=nil;
                                                parent->right=nil;
                                                
                                                nephewL->parent=replaceBrother;
                                                
                                                grandson->parent=nephewR;
                                            }
                                            else//没有孙子
                                            {
                                                //NSLog(@"没有孙子");
                                                
                                                //右侄变红，兄变黑
                                                nephewR->color=TREE_COLOR_RED;
                                                replaceBrother->color=TREE_COLOR_BLACK;
                                                
                                                //兄替父位，父替删点
                                                //父非根
                                                if(grand->left==parent)
                                                {
                                                    grand->left=replaceBrother;
                                                }
                                                else
                                                {
                                                    grand->right=replaceBrother;
                                                }
                                                
                                                replaceBrother->parent=grand;
                                                replaceBrother->left=nephewL;
                                                replaceBrother->right=parent;
                                                
                                                parent->parent=replaceBrother;
                                                parent->left=nephewR;
                                                parent->right=nil;
                                                
                                                nephewR->parent=parent;
                                                nephewR->left=nil;
                                                nephewR->right=nil;
                                                
                                                nephewL->parent=replaceBrother;
                                            }

                                        }
                                    }
                                    else//兄弟节点为黑色
                                    {
                                        //NSLog(@"兄弟节点为黑色");
                                        
                                        if(replaceBrother->left)//兄弟有左红子节点
                                        {
                                            //NSLog(@"兄弟有左红子节点");
                                            
                                            KATTreeNode *nephew=replaceBrother->left;
                                            
                                            //侄子变黑
                                            nephew->color=TREE_COLOR_BLACK;
                                            
                                            //兄替父位，父替删点（相当于右转）
                                            //父非根
                                            if(grand->left==parent)
                                            {
                                                grand->left=replaceBrother;
                                            }
                                            else
                                            {
                                                grand->right=replaceBrother;
                                            }
                                            
                                            replaceBrother->parent=grand;
                                            replaceBrother->left=nephew;
                                            replaceBrother->right=parent;
                                            
                                            parent->parent=replaceBrother;
                                            parent->left=nil;
                                            parent->right=nil;
                                            
                                            nephew->parent=replaceBrother;
                                            nephew->left=nil;
                                            nephew->right=nil;
                                        }
                                        else//兄弟无子节点
                                        {
                                            //NSLog(@"兄弟无子节点");
                                            
                                            //兄弟变红
                                            replaceBrother->color=TREE_COLOR_RED;
                                            
                                            //再平衡
                                            [self deleteBalanceWithNode:parent];
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else//左节点连接模式，该模式下，左节点无右分支，只能为独立红节点(无兄弟)，或者为最多带一个红左子节点的黑节点(有兄弟)
                    {
                        //被删点的家族成员
                        KATTreeNode *brother=new->right;//兄弟节点(连接后，兄弟节点为右子节点)
                        KATTreeNode *parent=new;//父节点(被删点的位置)
                        KATTreeNode *grand=parent->parent;//祖父节点
                        
                        //NSLog(@"左节点连接模式");
                        
                        if(node->color==TREE_COLOR_RED)//被删点为红色
                        {
                            if(new->color==TREE_COLOR_RED)//连接点为红色，不可能的情况
                            {
                                //NSLog(@"连接点为红色，不可能的情况");
                            }
                            else//连接点为黑色
                            {
                                //NSLog(@"连接点为黑色");
                                
                                if(new->left)//连接点有左红子节点
                                {
                                    //连接点变删除点颜色
                                    new->color=TREE_COLOR_RED;
                                    
                                    //子节点变黑色
                                    new->left->color=TREE_COLOR_BLACK;
                                }
                                else//连接点无子节点
                                {
                                    if(brother->color==TREE_COLOR_RED)//兄弟节点为红色，不可能的情况
                                    {
                                        //NSLog(@"兄弟节点为红色，不可能的情况");
                                    }
                                    else//兄弟节点为黑色
                                    {
                                        //NSLog(@"兄弟节点为黑色");
                                        
                                        if(brother->left)//兄弟节点右左红子节点
                                        {
                                            //NSLog(@"兄弟节点右左红子节点");
                                            
                                            KATTreeNode *nephew=brother->left;
                                            
                                            //父节点变黑
                                            parent->color=TREE_COLOR_BLACK;
                                            
                                            //本来就红
                                            nephew->color=TREE_COLOR_RED;
                                            
                                            //父节点(左连接节点)必非根节点
                                            
                                            //侄替父位，父为侄左子
                                            if(grand->left==parent)
                                            {
                                                grand->left=nephew;
                                            }
                                            else
                                            {
                                                grand->right=nephew;
                                            }
                                                
                                            nephew->parent=grand;
                                            nephew->left=parent;
                                            nephew->right=brother;
                                            
                                            parent->parent=nephew;
                                            parent->left=nil;
                                            parent->right=nil;
                                            
                                            brother->parent=nephew;
                                            brother->left=nil;
                                            brother->right=nil;
                                        }
                                        else//兄弟节点无子节点
                                        {
                                            //NSLog(@"兄弟节点无子节点");
                                            
                                            //交换父兄颜色，再左转
                                            parent->color=TREE_COLOR_BLACK;
                                            brother->color=TREE_COLOR_RED;
                                            
                                            [self checkBalanceWithNode:parent];
                                        }
                                    }
                                }
                            }
                        }
                        else//被删点为黑色
                        {
                            if(new->color==TREE_COLOR_RED)//连接点为红色，理论上没有子节点
                            {
                                //NSLog(@"连接点为红色");
                                
                                //直接改变连接点颜色
                                new->color=TREE_COLOR_BLACK;
                            }
                            else//连接点为黑色
                            {
                                if(new->left)//连接点有左红子节点
                                {
                                    //NSLog(@"连接点有左红子节点");
                                    
                                    //直接把左红节点变黑
                                    new->left->color=TREE_COLOR_BLACK;
                                }
                                else//连接点没有子节点
                                {
                                    //NSLog(@"连接点没有子节点");
                                    
                                    if(brother->color==TREE_COLOR_RED)//兄弟节点为红色
                                    {
                                        //NSLog(@"兄弟节点为红色");
                                        
                                        if(brother->left && brother->right)//必有两个黑色子节点
                                        {
                                            KATTreeNode *nephewL=brother->left;//左侄子
                                            KATTreeNode *nephewR=brother->right;//右侄子
                                            
                                            if(nephewL->left)//左侄还有左子节点
                                            {
                                                //NSLog(@"左侄有孙子");
                                                
                                                KATTreeNode *grandson=nephewL->left;//该孙子必为红色
                                                
                                                //改变兄弟颜色
                                                brother->color=TREE_COLOR_BLACK;
                                                
                                                //兄替父位，孙至左子位，父变左孙，左侄变右孙
                                                
                                                //父节点非根
                                                if(grand->left==parent)
                                                {
                                                    grand->left=brother;
                                                }
                                                else
                                                {
                                                    grand->right=brother;
                                                }
                                                
                                                brother->parent=grand;
                                                brother->left=grandson;
                                                brother->right=nephewR;
                                                
                                                parent->parent=grandson;
                                                parent->left=nil;
                                                parent->right=nil;
                                                
                                                grandson->parent=brother;
                                                grandson->left=parent;
                                                grandson->right=nephewL;
                                                
                                                nephewL->parent=grandson;
                                                nephewL->left=nil;
                                                nephewL->right=nil;
                                            }
                                            else//没有孙子
                                            {
                                                //NSLog(@"没有孙子");
                                                
                                                //父兄换色
                                                parent->color=TREE_COLOR_RED;
                                                brother->color=TREE_COLOR_BLACK;
                                                
                                                //兄替父位，父置左侄下
                                                
                                                //父节点非根
                                                if(grand->left==parent)
                                                {
                                                    grand->left=brother;
                                                }
                                                else
                                                {
                                                    grand->right=brother;
                                                }
                                                
                                                brother->parent=grand;
                                                brother->left=nephewL;
                                                brother->right=nephewR;
                                                
                                                parent->parent=nephewL;
                                                parent->left=nil;
                                                parent->right=nil;
                                                
                                                nephewL->parent=brother;
                                                nephewL->left=parent;
                                            }
                                        }
                                    }
                                    else//兄弟节点为黑色
                                    {
                                        //NSLog(@"兄弟节点为黑色");
                                        
                                        if(brother->left)//兄弟有左红子节点
                                        {
                                            //NSLog(@"兄弟有左红子节点");
                                            
                                            KATTreeNode *nephew=brother->left;
                                            
                                            //左侄变色
                                            nephew->color=TREE_COLOR_BLACK;
                                            
                                            //左侄替父位，父回原位
                                            
                                            //父非根
                                            if(grand->left==parent)
                                            {
                                                grand->left=nephew;
                                            }
                                            else
                                            {
                                                grand->right=nephew;
                                            }
                                            
                                            nephew->parent=grand;
                                            nephew->left=parent;
                                            nephew->right=brother;
                                            
                                            parent->parent=nephew;
                                            parent->left=nil;
                                            parent->right=nil;
                                            
                                            brother->parent=nephew;
                                            brother->left=nil;
                                            brother->right=nil;
                                        }
                                        else//兄弟无子节点
                                        {
                                            //NSLog(@"兄弟无子节点");
                                            
                                            //兄弟节点变红
                                            brother->color=TREE_COLOR_RED;
                                            
                                            //左转
                                            [self checkBalanceWithNode:parent];
                                            
                                            //左转后兄弟节点在上
                                            //NSLog(@"左转后平衡点:%@",brother->key);
                                            
                                            //再平衡
                                            [self deleteBalanceWithNode:brother];
                                            
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
                //释放内存
                [node->key release];
                [node->value release];
                free(node);
                node=nil;
            }
            else//node为根节点
            {
                //NSLog(@"根节点");
                
                if(node->left!=new)
                {
                    new->left=node->left;
                    
                    if(new->left)
                    {
                        new->left->parent=new;
                    }
                }
                
                if(node->right!=new)
                {
                    new->right=node->right;
                    
                    if(new->right)
                    {
                        new->right->parent=new;
                    }
                }
                
                new->parent=node->parent;
                
                _root=new;
                
                
                if(_balance)//红黑树
                {
                    if(replace)//左节点最右端节点替换模式，该模式下删除点必有与左节点子树平衡的右子树
                    {
                        //NSLog(@"左节点最右端节点替换模式");
                        
                        //替换点改为被删点颜色
                        new->color=node->color;
                        
                        if(replaceLeft)//替换点有左红子节点
                        {
                            //NSLog(@"替换点有左红子节点");
                            
                            //左红子节点变黑
                            replaceLeft->color=TREE_COLOR_BLACK;
                        }
                        else//替换点为独立黑点
                        {
                            //NSLog(@"替换点为独立黑点");
                            
                            if(replaceBrother)//必有左兄弟
                            {
                                KATTreeNode *parent=replaceBrother->parent;//父节点(不会是根节点)
                                KATTreeNode *grand=parent->parent;//祖父节点
                                
                                BOOL isLeftSon=NO;
                                
                                if(grand && grand->left==parent)
                                {
                                    isLeftSon=YES;
                                }
                                
                                if(parent->color==TREE_COLOR_RED)//父节点为红色
                                {
                                    //NSLog(@"父节点为红色");
                                    
                                    if(replaceBrother->color==TREE_COLOR_RED)//兄弟节点为红色，不可能出现这种情况！
                                    {
                                        //NSLog(@"兄弟节点为红色，不可能出现这种情况！");
                                    }
                                    else//兄弟节点为黑色
                                    {
                                        //NSLog(@"兄弟节点为黑色");
                                        
                                        if(replaceBrother->left)//兄弟节点有左红子节点
                                        {
                                            //NSLog(@"兄弟节点有左红子节点");
                                            
                                            KATTreeNode *nephew=replaceBrother->left;
                                            
                                            //三点换色
                                            replaceBrother->color=TREE_COLOR_RED;
                                            parent->color=TREE_COLOR_BLACK;
                                            nephew->color=TREE_COLOR_BLACK;
                                            
                                            //兄弟替父位（相当于右转）
                                            //父非根
                                            if(grand->left==parent)
                                            {
                                                grand->left=replaceBrother;
                                            }
                                            else
                                            {
                                                grand->right=replaceBrother;
                                            }
                                            
                                            replaceBrother->parent=grand;
                                            replaceBrother->left=nephew;
                                            replaceBrother->right=parent;
                                            
                                            parent->parent=replaceBrother;
                                            parent->left=nil;
                                            parent->right=nil;
                                            
                                            nephew->parent=replaceBrother;
                                            nephew->left=nil;
                                            nephew->right=nil;
                                        }
                                        else//兄弟节点无子节点
                                        {
                                            //NSLog(@"兄弟节点无子节点");
                                            
                                            //父兄换色
                                            parent->color=TREE_COLOR_BLACK;
                                            replaceBrother->color=TREE_COLOR_RED;
                                        }
                                    }
                                }
                                else//父节点为黑色
                                {
                                    //NSLog(@"父节点为黑色");
                                    
                                    if(replaceBrother->color==TREE_COLOR_RED)//兄弟节点为红色
                                    {
                                        //NSLog(@"兄弟节点为红色");
                                        
                                        if(replaceBrother->left && replaceBrother->right)//必有两个黑色子节点
                                        {
                                            KATTreeNode *nephewL=replaceBrother->left;//左侄
                                            KATTreeNode *nephewR=replaceBrother->right;//右侄
                                            
                                            if(nephewR->left)//有右孙子
                                            {
                                                //NSLog(@"有右孙子");
                                                
                                                KATTreeNode *grandson=nephewR->left;
                                                
                                                //兄变黑，右侄和孙换色
                                                replaceBrother->color=TREE_COLOR_BLACK;
                                                nephewR->color=TREE_COLOR_RED;
                                                grandson->color=TREE_COLOR_BLACK;
                                                
                                                //兄替父位，右侄替删点，父在右侄右
                                                //父非根
                                                if(grand->left==parent)
                                                {
                                                    grand->left=replaceBrother;
                                                }
                                                else
                                                {
                                                    grand->right=replaceBrother;
                                                }
                                                
                                                replaceBrother->parent=grand;
                                                replaceBrother->left=nephewL;
                                                replaceBrother->right=nephewR;
                                                
                                                nephewR->parent=replaceBrother;
                                                nephewR->left=grandson;
                                                nephewR->right=parent;
                                                
                                                parent->parent=nephewR;
                                                parent->left=nil;
                                                parent->right=nil;
                                                
                                                nephewL->parent=replaceBrother;
                                                
                                                grandson->parent=nephewR;
                                            }
                                            else//没有孙子
                                            {
                                                //NSLog(@"没有孙子");
                                                
                                                //右侄变红，兄变黑
                                                nephewR->color=TREE_COLOR_RED;
                                                replaceBrother->color=TREE_COLOR_BLACK;
                                                
                                                //兄替父位，父替删点
                                                //父非根
                                                if(grand->left==parent)
                                                {
                                                    grand->left=replaceBrother;
                                                }
                                                else
                                                {
                                                    grand->right=replaceBrother;
                                                }
                                                
                                                replaceBrother->parent=grand;
                                                replaceBrother->left=nephewL;
                                                replaceBrother->right=parent;
                                                
                                                parent->parent=replaceBrother;
                                                parent->left=nephewR;
                                                parent->right=nil;
                                                
                                                nephewR->parent=parent;
                                                nephewR->left=nil;
                                                nephewR->right=nil;
                                                
                                                nephewL->parent=replaceBrother;
                                            }
                                            
                                        }
                                    }
                                    else//兄弟节点为黑色
                                    {
                                        //NSLog(@"兄弟节点为黑色");
                                        
                                        if(replaceBrother->left)//兄弟有左红子节点
                                        {
                                            //NSLog(@"兄弟有左红子节点");
                                            
                                            KATTreeNode *nephew=replaceBrother->left;
                                            
                                            //侄子变黑
                                            nephew->color=TREE_COLOR_BLACK;
                                            
                                            //兄替父位，父替删点（相当于右转）
                                            //父非根
                                            if(grand->left==parent)
                                            {
                                                grand->left=replaceBrother;
                                            }
                                            else
                                            {
                                                grand->right=replaceBrother;
                                            }
                                            
                                            replaceBrother->parent=grand;
                                            replaceBrother->left=nephew;
                                            replaceBrother->right=parent;
                                            
                                            parent->parent=replaceBrother;
                                            parent->left=nil;
                                            parent->right=nil;
                                            
                                            nephew->parent=replaceBrother;
                                            nephew->left=nil;
                                            nephew->right=nil;
                                        }
                                        else//兄弟无子节点
                                        {
                                            //NSLog(@"兄弟无子节点");
                                            
                                            //兄弟变红
                                            replaceBrother->color=TREE_COLOR_RED;
                                            
                                            //再平衡
                                            [self deleteBalanceWithNode:parent];
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else//左节点连接模式，该模式下，左节点无右分支，只能为独立红节点(无兄弟)，或者为最多带一个红左子节点的黑节点(有兄弟)
                    {
                        //NSLog(@"左节点连接模式");
                        
                        //被删点的家族成员
                        KATTreeNode *brother=new->right;//兄弟节点(连接后，兄弟节点为右子节点)
                        KATTreeNode *parent=new;//父节点(被删点的位置)
                        KATTreeNode *grand=parent->parent;//祖父节点
                        
                        //NSLog(@"左节点连接模式");
                        
                        if(node->color==TREE_COLOR_RED)//被删点为红色，该点为root，不可能为红色
                        {
                            //NSLog(@"root为红色，不可能的情况");
                        }
                        else//被删点为黑色
                        {
                            if(new->color==TREE_COLOR_RED)//连接点为红色，理论上没有子节点
                            {
                                //NSLog(@"连接点为红色");
                                
                                //直接改变连接点颜色
                                new->color=TREE_COLOR_BLACK;
                            }
                            else//连接点为黑色
                            {
                                if(new->left)//连接点有左红子节点
                                {
                                    //NSLog(@"连接点有左红子节点");
                                    
                                    //直接把左红节点变黑
                                    new->left->color=TREE_COLOR_BLACK;
                                }
                                else//连接点没有子节点
                                {
                                    //NSLog(@"连接点没有子节点");
                                    
                                    if(brother->color==TREE_COLOR_RED)//兄弟节点为红色
                                    {
                                        //NSLog(@"兄弟节点为红色");
                                        
                                        if(brother->left && brother->right)//必有两个黑色子节点
                                        {
                                            KATTreeNode *nephewL=brother->left;//左侄子
                                            KATTreeNode *nephewR=brother->right;//右侄子
                                            
                                            if(nephewL->left)//左侄还有左子节点
                                            {
                                                //NSLog(@"左侄有孙子");
                                                
                                                KATTreeNode *grandson=nephewL->left;//该孙子必为红色
                                                
                                                //改变兄弟颜色
                                                brother->color=TREE_COLOR_BLACK;
                                                
                                                //兄替父位，孙至左子位，父变左孙，左侄变右孙
                                                
                                                //父节点为根
                                                if(grand->left==parent)
                                                {
                                                    grand->left=brother;
                                                }
                                                else
                                                {
                                                    grand->right=brother;
                                                }
                                                
                                                _root=brother;
                                                
                                                brother->parent=nil;
                                                brother->left=grandson;
                                                brother->right=nephewR;
                                                
                                                parent->parent=grandson;
                                                parent->left=nil;
                                                parent->right=nil;
                                                
                                                grandson->parent=brother;
                                                grandson->left=parent;
                                                grandson->right=nephewL;
                                                
                                                nephewL->parent=grandson;
                                                nephewL->left=nil;
                                                nephewL->right=nil;
                                            }
                                            else//没有孙子
                                            {
                                                //NSLog(@"没有孙子");
                                                
                                                //父兄换色
                                                parent->color=TREE_COLOR_RED;
                                                brother->color=TREE_COLOR_BLACK;
                                                
                                                //兄替父位，父置左侄下
                                                
                                                //父节点为根
                                                _root=brother;
                                                
                                                brother->parent=nil;
                                                brother->left=nephewL;
                                                brother->right=nephewR;
                                                
                                                parent->parent=nephewL;
                                                parent->left=nil;
                                                parent->right=nil;
                                                
                                                nephewL->parent=brother;
                                                nephewL->left=parent;
                                            }
                                        }
                                    }
                                    else//兄弟节点为黑色
                                    {
                                        //NSLog(@"兄弟节点为黑色");
                                        
                                        if(brother->left)//兄弟有左红子节点
                                        {
                                            //NSLog(@"兄弟有左红子节点");
                                            
                                            KATTreeNode *nephew=brother->left;
                                            
                                            //左侄变色
                                            nephew->color=TREE_COLOR_BLACK;
                                            
                                            //左侄替父位，父回原位
                                            
                                            //父为根
                                            _root=nephew;
                                            
                                            nephew->parent=nil;
                                            nephew->left=parent;
                                            nephew->right=brother;
                                            
                                            parent->parent=nephew;
                                            parent->left=nil;
                                            parent->right=nil;
                                            
                                            brother->parent=nephew;
                                            brother->left=nil;
                                            brother->right=nil;
                                        }
                                        else//兄弟无子节点
                                        {
                                            //NSLog(@"兄弟无子节点");
                                            
                                            //兄弟节点变红
                                            brother->color=TREE_COLOR_RED;
                                            
                                            //左转
                                            [self checkBalanceWithNode:parent];
                                            
                                            //左转后兄弟节点在上
                                            //NSLog(@"左转后平衡点:%@",brother->key);
                                            
                                            //再平衡
                                            [self deleteBalanceWithNode:brother];
                                            
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                //释放内存
                [node->key release];
                [node->value release];
                free(node);
                node=nil;
            }
            
        }
        else if(node->right)//没有左节点，但有右节点(右单枝)
        {
            //NSLog(@"非叶子节点，无左节点，但有右节点，在红黑树中不可能有这种情况!");
            
            KATTreeNode *new=node->right;
            
            BOOL replace=NO;//是否是替换被删节点
            
            //找到最左边的节点
            while(new->left)
            {
                new=new->left;
            }
            
            if(new->parent!=node)//如果new是node的子节点，则无需替换
            {
                replace=YES;
                
                if(new->right)//最左节点存在右节点，则右节点替换最左节点的位置
                {
                    new->parent->left=new->right;
                    new->right->parent=new->parent;
                }
                else
                {
                    new->parent->left=nil;
                }
            }
            
            //最左节点替换被删除节点的位置
            if(node->parent)//非根节点
            {
                if(node->parent->left==node)
                {
                    node->parent->left=new;
                }
                else
                {
                    node->parent->right=new;
                }
                
                if(node->left!=new)
                {
                    new->left=node->left;
                    
                    if(new->left)
                    {
                        new->left->parent=new;
                    }
                }
                
                if(node->right!=new)
                {
                    new->right=node->right;
                    
                    if(new->right)
                    {
                        new->right->parent=new;
                    }
                }
                
                new->parent=node->parent;
                
                //释放内存
                [node->key release];
                [node->value release];
                free(node);
                node=nil;
            }
            else//node为根节点
            {
                if(node->left!=new)
                {
                    new->left=node->left;
                    
                    if(new->left)
                    {
                        new->left->parent=new;
                    }
                }
                
                if(node->right!=new)
                {
                    new->right=node->right;
                    
                    if(new->right)
                    {
                        new->right->parent=new;
                    }
                }
                
                new->parent=node->parent;
                
                _root=new;
                
                //释放内存
                [node->key release];
                [node->value release];
                free(node);
                node=nil;
            }
        }
        else//没有子节点
        {
            //NSLog(@"叶子节点");
            
            if(node->parent)//非根节点
            {
                //NSLog(@"非根叶子");
                
                if(_balance)//红黑树
                {
                    //被删点的家族成员
                    KATTreeNode *brother=[self brotherWithNode:node];//兄弟节点
                    KATTreeNode *parent=node->parent;//父节点
                    KATTreeNode *grand=parent->parent;//祖父节点
                    
                    BOOL isLeftSon=NO;//被删点是否在左
                    
                    if(parent->left==node)
                    {
                        isLeftSon=YES;
                    }
                    
                    //与父节点打断
                    if(parent->left==node)
                    {
                        parent->left=nil;
                    }
                    else
                    {
                        parent->right=nil;
                    }
                    
                    
                    if(node->color==TREE_COLOR_RED)//红色叶子，直接删除
                    {
                        //NSLog(@"红色叶子，直接删除");
                    }
                    else if(brother)//黑色叶子，则必有兄弟
                    {
                        //NSLog(@"黑色叶子");
                        
                        if(parent->color==TREE_COLOR_RED)//父节点为红色(不可能为根节点，祖父节点必存在)
                        {
                            //NSLog(@"父节点红色");
                            
                            if(brother->color==TREE_COLOR_RED)//兄弟节点红色，不可能的情况!
                            {
                                //NSLog(@"兄弟节点红色，不可能的情况!");
                            }
                            else//兄弟节点黑色
                            {
                                //NSLog(@"兄弟节点黑色");
                                
                                if(brother->left)//兄弟节点有左红子节点
                                {
                                    //NSLog(@"兄弟节点有左红子节点");
                                    
                                    KATTreeNode *nephew=brother->left;//侄子
                                    
                                    if(isLeftSon)//被删点在左
                                    {
                                        //NSLog(@"被删点在左");
                                        
                                        //父色变黑
                                        parent->color=TREE_COLOR_BLACK;
                                        
                                        //侄子本来就红
                                        nephew->color=TREE_COLOR_RED;
                                        
                                        if(grand)//祖父节点必存在
                                        {
                                            //侄移父位，父替删点
                                            if(grand->left==parent)
                                            {
                                                grand->left=nephew;
                                            }
                                            else
                                            {
                                                grand->right=nephew;
                                            }
                                            
                                            nephew->parent=grand;
                                            nephew->left=parent;
                                            nephew->right=brother;
                                            
                                            parent->parent=nephew;
                                            parent->left=nil;
                                            parent->right=nil;
                                            
                                            brother->parent=nephew;
                                            brother->left=nil;
                                            brother->right=nil;
                                        }
                                    }
                                    else//被删点在右
                                    {
                                        //NSLog(@"被删点在右");
                                        
                                        //父兄交换颜色，再右转变色
                                        parent->color=TREE_COLOR_BLACK;
                                        brother->color=TREE_COLOR_RED;
                                        
                                        [self checkBalanceWithNode:brother];
                                    }
                                }
                                else//兄弟节点无子节点
                                {
                                    //NSLog(@"兄弟节点无子节点");
                                    
                                    //父兄交换颜色，可能左转
                                    parent->color=TREE_COLOR_BLACK;
                                    brother->color=TREE_COLOR_RED;
                                    
                                    [self checkBalanceWithNode:parent];
                                }
                            }
                        }
                        else//父节点为黑色
                        {
                            //NSLog(@"父节点黑色");
                            
                            if(brother->color==TREE_COLOR_RED)//兄弟节点为红色
                            {
                                //NSLog(@"兄弟节点为红色");
                                
                                if(brother->left && brother->right)//兄弟节点必有两个黑色子节点
                                {
                                    KATTreeNode *nephewL=brother->left;//左侄子
                                    KATTreeNode *nephewR=brother->right;//右侄子
                                    
                                    if(isLeftSon)//被删点在左
                                    {
                                        //NSLog(@"被删点在左");
                                        
                                        if(nephewL->left)//有左孙子，必为红色
                                        {
                                            KATTreeNode *grandson=nephewL->left;
                                            
                                            //孙子变黑
                                            grandson->color=TREE_COLOR_BLACK;
                                            
                                            //孙替父位，父替删位
                                            if(grand)//父非根
                                            {
                                                if(grand->left==parent)
                                                {
                                                    grand->left=grandson;
                                                }
                                                else
                                                {
                                                    grand->right=grandson;
                                                }
                                                
                                                grandson->parent=grand;
                                                grandson->left=parent;
                                                grandson->right=brother;
                                                
                                                parent->parent=grandson;
                                                parent->left=nil;
                                                parent->right=nil;
                                                
                                                brother->parent=grandson;
                                            }
                                            else//父为根
                                            {
                                                _root=grandson;
                                                
                                                grandson->parent=nil;
                                                grandson->left=parent;
                                                grandson->right=brother;
                                                
                                                parent->parent=grandson;
                                                parent->left=nil;
                                                parent->right=nil;
                                                
                                                brother->parent=grandson;
                                            }
                                        }
                                        else//没有孙子
                                        {
                                            //NSLog(@"没有孙子");
                                            
                                            //先左转
                                            [self checkBalanceWithNode:parent];
                                            
                                            //交换父节点与左侄子的颜色(左转后父节点变红色)
                                            parent->color=TREE_COLOR_BLACK;
                                            nephewL->color=TREE_COLOR_RED;
                                            
                                            //再左转
                                            [self checkBalanceWithNode:parent];
                                        }
                                    }
                                    else//被删点在右
                                    {
                                        //NSLog(@"被删点在右");
                                        
                                        if(nephewR->left)//有右孙子
                                        {
                                            //NSLog(@"有右孙子");
                                            
                                            KATTreeNode *grandson=nephewR->left;
                                            
                                            //兄变黑，右侄和孙换色
                                            brother->color=TREE_COLOR_BLACK;
                                            nephewR->color=TREE_COLOR_RED;
                                            grandson->color=TREE_COLOR_BLACK;
                                            
                                            //兄替父位，右侄替删点，父在右侄右
                                            if(grand)//父非根
                                            {
                                                if(grand->left==parent)
                                                {
                                                    grand->left=brother;
                                                }
                                                else
                                                {
                                                    grand->right=brother;
                                                }
                                                
                                                brother->parent=grand;
                                                brother->left=nephewL;
                                                brother->right=nephewR;
                                                
                                                nephewR->parent=brother;
                                                nephewR->left=grandson;
                                                nephewR->right=parent;
                                                
                                                parent->parent=nephewR;
                                                parent->left=nil;
                                                parent->right=nil;

                                                nephewL->parent=brother;
                                                
                                                grandson->parent=nephewR;
                                            }
                                            else//父为根
                                            {
                                                _root=brother;
                                                
                                                brother->parent=nil;
                                                brother->left=nephewL;
                                                brother->right=nephewR;
                                                
                                                nephewR->parent=brother;
                                                nephewR->left=grandson;
                                                nephewR->right=parent;
                                                
                                                parent->parent=nephewR;
                                                parent->left=nil;
                                                parent->right=nil;
                                                
                                                nephewL->parent=brother;
                                                
                                                grandson->parent=nephewR;
                                            }
                                        }
                                        else//没有孙子
                                        {
                                            //NSLog(@"没有孙子");
                                            
                                            //右侄变红，兄变黑
                                            nephewR->color=TREE_COLOR_RED;
                                            brother->color=TREE_COLOR_BLACK;
                                            
                                            //兄替父位，父替删点
                                            if(grand)//父非根
                                            {
                                                if(grand->left==parent)
                                                {
                                                    grand->left=brother;
                                                }
                                                else
                                                {
                                                    grand->right=brother;
                                                }
                                                
                                                brother->parent=grand;
                                                brother->left=nephewL;
                                                brother->right=parent;
                                                
                                                parent->parent=brother;
                                                parent->left=nephewR;
                                                parent->right=nil;
                                                
                                                nephewR->parent=parent;
                                                nephewR->left=nil;
                                                nephewR->right=nil;
                                                
                                                nephewL->parent=brother;
                                            }
                                            else//父为根
                                            {
                                                _root=brother;
                                                
                                                brother->parent=nil;
                                                brother->left=nephewL;
                                                brother->right=parent;
                                                
                                                parent->parent=brother;
                                                parent->left=nephewR;
                                                parent->right=nil;
                                                
                                                nephewR->parent=parent;
                                                nephewR->left=nil;
                                                nephewR->right=nil;
                                                
                                                nephewL->parent=brother;
                                            }

                                        }
                                        
                                    }
                                }
                            }
                            else//兄弟节点为黑色
                            {
                                //NSLog(@"兄弟节点为黑色");
                                
                                if(brother->left)//兄弟节点有左红子节点
                                {
                                    //NSLog(@"兄弟节点有左红子节点");
                                    
                                    KATTreeNode *nephew=brother->left;//左侄子
                                    
                                    if(isLeftSon)//被删点在左
                                    {
                                        //侄子变黑
                                        nephew->color=TREE_COLOR_BLACK;
                                        
                                        //侄替父位，父替删点
                                        if(grand)//父非根
                                        {
                                            if(grand->left==parent)
                                            {
                                                grand->left=nephew;
                                            }
                                            else
                                            {
                                                grand->right=nephew;
                                            }
                                            
                                            nephew->parent=grand;
                                            nephew->left=parent;
                                            nephew->right=brother;
                                            
                                            parent->parent=nephew;
                                            parent->left=nil;
                                            parent->right=nil;
                                            
                                            brother->parent=nephew;
                                            brother->left=nil;
                                            brother->right=nil;
                                        }
                                        else//父为根
                                        {
                                            _root=nephew;
                                            
                                            nephew->parent=nil;
                                            nephew->left=parent;
                                            nephew->right=brother;
                                            
                                            parent->parent=nephew;
                                            parent->left=nil;
                                            parent->right=nil;
                                            
                                            brother->parent=nephew;
                                            brother->left=nil;
                                            brother->right=nil;
                                        }
                                    }
                                    else//被删点在右
                                    {
                                        //侄子变黑
                                        nephew->color=TREE_COLOR_BLACK;
                                        
                                        //兄替父位，父替删点
                                        if(grand)//父非根
                                        {
                                            if(grand->left==parent)
                                            {
                                                grand->left=brother;
                                            }
                                            else
                                            {
                                                grand->right=brother;
                                            }
                                            
                                            brother->parent=grand;
                                            brother->left=nephew;
                                            brother->right=parent;
                                            
                                            parent->parent=brother;
                                            parent->left=nil;
                                            parent->right=nil;
                                            
                                            nephew->parent=brother;
                                            nephew->left=nil;
                                            nephew->right=nil;
                                        }
                                        else//父为根
                                        {
                                            _root=brother;
                                            
                                            brother->parent=nil;
                                            brother->left=nephew;
                                            brother->right=parent;
                                            
                                            parent->parent=brother;
                                            parent->left=nil;
                                            parent->right=nil;
                                            
                                            nephew->parent=brother;
                                            nephew->left=nil;
                                            nephew->right=nil;
                                        }
                                    }
                                }
                                else//兄弟节点无子节点
                                {
                                    //兄弟节点变红
                                    brother->color=TREE_COLOR_RED;
                                    
                                    if(isLeftSon)//被删点在左
                                    {
                                        //左转
                                        [self checkBalanceWithNode:parent];
                                        
                                        //左转后兄弟节点在上
                                        //NSLog(@"左转后平衡点:%@",brother->key);
                                        
                                        //再平衡
                                        [self deleteBalanceWithNode:brother];
                                    }
                                    else//被删点在右
                                    {
                                        //NSLog(@"平衡点:%@",parent->key);
                                        
                                        //再平衡
                                        [self deleteBalanceWithNode:parent];
                                    }
                                }
                            }
                        }
                    }
                    
                }
                else
                {
                    if(node->parent->left==node)
                    {
                        node->parent->left=nil;
                    }
                    else
                    {
                        node->parent->right=nil;
                    }
                }
                
                node->parent=nil;
                
                //释放内存
                [node->key release];
                [node->value release];
                free(node);
                node=nil;
            }
            else//node为根节点
            {
                //清除内容，释放内存
                [node->key release];
                node->key=nil;
                [node->value release];
                node->value=nil;
                node->left=nil;
                node->right=nil;
                node->parent=nil;
            }
        }
        
        _length--;
        
        //NSLog(@"==== 删除后:%@",self);
        
        return YES;
    }
    
}

/*
//获取所有节点的值
- (id *)getValues
{
    if(_length>0)
    {
        id *array = nil;
        
        array=(id *)malloc(sizeof(id)*_length);
        
        int index=0;//数组索引
        
        [self travelWithNode:_root forArray:array andIndex:&index];
        
        return array;
    }
    else
    {
        return nil;
    }
}


//中序遍历，输出内容到数组（内部方法）
- (void)travelWithNode:(KATTreeNode *)node forArray:(id *)array andIndex:(int *)index
{
    if(node)
    {
        [self travelWithNode:node->left forArray:array andIndex:index];
        
        array[*index]=[[node->value retain] autorelease];
        (*index)++;
        
        [self travelWithNode:node->right forArray:array andIndex:index];
    }
}
*/


//获取所有节点的值
- (KATArray *)allValues
{
    if(_length>0)
    {
        KATArray *array=[KATArray arrayWithCapacity:_length];
        
        [self travelWithNode:_root forArray:array];
        
        return array;
    }
    else
    {
        return nil;
    }
}


//中序遍历，输出内容到数组（内部方法）
- (void)travelWithNode:(KATTreeNode *)node forArray:(KATArray *)array
{
    if(node)
    {
        [self travelWithNode:node->left forArray:array];
        
        [array put:node->value];
        
        [self travelWithNode:node->right forArray:array];
    }
}



//获取所有节点的键
- (KATArray *)allKeys
{
    if(_length>0)
    {
        KATArray *array=[KATArray arrayWithCapacity:_length];
        
        [self travelKeysWithNode:_root forArray:array];
        
        return array;
    }
    else
    {
        return nil;
    }
}


//中序遍历，输出key到数组（内部方法）
- (void)travelKeysWithNode:(KATTreeNode *)node forArray:(KATArray *)array
{
    if(node)
    {
        [self travelKeysWithNode:node->left forArray:array];
        
        [array put:node->key];
        
        [self travelKeysWithNode:node->right forArray:array];
    }
}


//获取首个键
- (NSString *)firstKey
{
    KATTreeNode *node=_root;
    
    while(node && node->left)
    {
        node=node->left;
    }
    
    if(node)
    {
        return node->key;
    }
    else
    {
        return nil;
    }
}


//获取首个值
- (id)firstValue
{
    KATTreeNode *node=_root;
    
    while(node && node->left)
    {
        node=node->left;
    }
    
    if(node)
    {
        return node->value;
    }
    else
    {
        return nil;
    }
}


//获取最后一个键
- (NSString *)lastKey
{
    KATTreeNode *node=_root;
    
    while(node && node->right)
    {
        node=node->right;
    }
    
    if(node)
    {
        return node->key;
    }
    else
    {
        return nil;
    }

}


//获取最后一个值
- (id)lastValue
{
    KATTreeNode *node=_root;
    
    while(node && node->right)
    {
        node=node->right;
    }
    
    if(node)
    {
        return node->value;
    }
    else
    {
        return nil;
    }
}


/*
//获取一定范围的节点元素，返回id指针，并把长度作为参数返回
- (id *)getWithStart:(NSString *)start andEnd:(NSString *)end returnArrayLength:(int *)length
{
    id *array = nil;
    
    [self travelWithNode:_root withStart:start andEnd:end forLength:length];//获取范围内数组的节点个数
    
    array=(id *)malloc(sizeof(id)*(*length));//分配空间
    
    int index=0;//数组索引，从0开始
    
    [self travelWithNode:_root withStart:start andEnd:end forArray:array andIndex:&index];
    
    return array;
}

//中序遍历，获取该范围内的节点个数（内部方法）
- (void)travelWithNode:(KATTreeNode *)node withStart:(NSString *)start andEnd:(NSString *)end forLength:(int *)length
{
    if(node)
    {
        if([start compare:node->key]==NSOrderedAscending)//开始值比node索引小，则继续向左搜索
        {
            [self travelWithNode:node->left withStart:start andEnd:end forLength:length];
        }
                
        //当key>=start&&key<end时
        if(([start compare:node->key]==NSOrderedAscending||[start compare:node->key]==NSOrderedSame)&&[end compare:node->key]==NSOrderedDescending)
        {
            (*length)++;
        }
        
        if([end compare:node->key]==NSOrderedDescending)//结束值比node索引大，则继续向右搜索
        {
            [self travelWithNode:node->right withStart:start andEnd:end forLength:length];
        }

    }
}

//中序遍历，将该范围内的节点赋值到数组（内部方法）
- (void)travelWithNode:(KATTreeNode *)node withStart:(NSString *)start andEnd:(NSString *)end forArray:(id *)array andIndex:(int *)index
{
    if(node)
    {
        if([start compare:node->key]==NSOrderedAscending)//开始值比node索引小，则继续向左搜索
        {
            [self travelWithNode:node->left withStart:start andEnd:end forArray:array andIndex:index];
        }
        
        //当key>=start&&key<end时
        if(([start compare:node->key]==NSOrderedAscending||[start compare:node->key]==NSOrderedSame)&&[end compare:node->key]==NSOrderedDescending)
        {
            array[*index]=node->value;
            (*index)++;
        }
        
        if([end compare:node->key]==NSOrderedDescending)//结束值比node索引大，则继续向右搜索
        {
            [self travelWithNode:node->right withStart:start andEnd:end forArray:array andIndex:index];
        }
        
    }
}
*/


//获取一定范围的value数组(包含begin和end)
- (KATArray *)valuesFromKey:(NSString *)begin toKey:(NSString *)end
{
//    int length=0;
    
//    [self travelWithNode:_root withBegin:begin andEnd:end forLength:&length];//获取范围内数组的节点个数
    
    //自动扩容，不用先计算长度
    KATArray *array=[KATArray array];
    
    [self travelWithNode:_root withBegin:begin andEnd:end forArray:array];
    
    return array;
}


//获取从起点到key的value数组(包含key)
- (KATArray *)valuesToKey:(NSString *)key
{
    return [self valuesFromKey:nil toKey:key];
}


//获取从key到终点的value数组(包含key)
- (KATArray *)valuesFromKey:(NSString *)key
{
    return [self valuesFromKey:key toKey:nil];
}


//中序遍历，获取该范围内的节点个数（内部方法）(废弃，用数组自动扩容方法)
- (void)travelWithNode:(KATTreeNode *)node withBegin:(NSString *)begin andEnd:(NSString *)end forLength:(int *)length
{
    if(node)
    {
        if(begin)
        {
            if([begin compare:node->key]==NSOrderedAscending)//开始值比node索引小，则继续向左搜索
            {
                [self travelWithNode:node->left withBegin:begin andEnd:end forLength:length];
            }
        }
        else//begin为空,继续向左搜索
        {
            [self travelWithNode:node->left withBegin:begin andEnd:end forLength:length];
        }
        
        
        if(begin && end)
        {
            //当key>=start&&key<=end时
            if(([begin compare:node->key]==NSOrderedAscending || [begin compare:node->key]==NSOrderedSame) && ([end compare:node->key]==NSOrderedDescending || [end compare:node->key]==NSOrderedSame))
            {
                (*length)++;
            }
        }
        else if(!begin && end)//begin为空，end不为空
        {
            //当key<=end时
            if([end compare:node->key]==NSOrderedDescending || [end compare:node->key]==NSOrderedSame)
            {
                (*length)++;
            }
        }
        else if(begin && !end)//begin不为空，end为空
        {
            //当key>=start时
            if([begin compare:node->key]==NSOrderedAscending || [begin compare:node->key]==NSOrderedSame)
            {
                (*length)++;
            }
        }
        else if(!begin && !end)//begin和end都为空
        {
            (*length)++;
        }
        
        
        if(end)
        {
            if([end compare:node->key]==NSOrderedDescending)//结束值比node索引大，则继续向右搜索
            {
                [self travelWithNode:node->right withBegin:begin andEnd:end forLength:length];
            }
        }
        else//end为空，继续向右搜索
        {
            [self travelWithNode:node->right withBegin:begin andEnd:end forLength:length];
        }
        
    }
}

//中序遍历，将该范围内的节点赋值到数组（内部方法）
- (void)travelWithNode:(KATTreeNode *)node withBegin:(NSString *)begin andEnd:(NSString *)end forArray:(KATArray *)array
{
    if(node)
    {
        if(begin)
        {
            if([begin compare:node->key]==NSOrderedAscending)//开始值比node索引小，则继续向左搜索
            {
                [self travelWithNode:node->left withBegin:begin andEnd:end forArray:array];
            }
        }
        else//begin为空,继续向左搜索
        {
            [self travelWithNode:node->left withBegin:begin andEnd:end forArray:array];
        }
        
        
        if(begin && end)
        {
            //当key>=start&&key<=end时
            if(([begin compare:node->key]==NSOrderedAscending || [begin compare:node->key]==NSOrderedSame) && ([end compare:node->key]==NSOrderedDescending || [end compare:node->key]==NSOrderedSame))
            {
                [array put:node->value];
            }
        }
        else if(!begin && end)//begin为空，end不为空
        {
            //key<=end时
            if([end compare:node->key]==NSOrderedDescending || [end compare:node->key]==NSOrderedSame)
            {
                [array put:node->value];
            }
        }
        else if(begin && !end)//begin不为空，end为空
        {
            //当key>=start时
            if([begin compare:node->key]==NSOrderedAscending || [begin compare:node->key]==NSOrderedSame)
            {
                [array put:node->value];
            }
        }
        else if(!begin && !end)//begin和end都为空
        {
            [array put:node->value];
        }
        
        
        if(end)
        {
            if([end compare:node->key]==NSOrderedDescending)//结束值比node索引大，则继续向右搜索
            {
                [self travelWithNode:node->right withBegin:begin andEnd:end forArray:array];
            }
        }
        else//end为空，继续向右搜索
        {
            [self travelWithNode:node->right withBegin:begin andEnd:end forArray:array];
        }
    }
}


//用下标的方式获取
- (id)objectForKeyedSubscript:(id)key
{
    return [self getValueWithKey:key];
}


//用下标的方式设置
- (void)setObject:(id)object forKeyedSubscript:(id< NSCopying >)aKey
{
    if(object)
    {
        [self putWithKey:(NSString *)aKey andValue:object];
    }
    else
    {
        [self deleteValueWithKey:(NSString *)aKey];
    }
}


//描述
- (NSString *)description
{
    NSMutableString *ms=[NSMutableString stringWithFormat:@"KATTreeMap: len=%i\n{\n",_length];
    
    if(_root->key)//有元素
    {
        [self travelWithNode:_root andDescription:&ms];
    }
    
    [ms appendString:@"}"];
    
    return ms;
}

//中序遍历，输出描述内容（内部方法）
- (void)travelWithNode:(KATTreeNode *)node andDescription:(NSMutableString **)dsp
{
    if(node)
    {
        [self travelWithNode:node->left andDescription:dsp];
        
        if(node->parent)
        {
//            [*dsp appendFormat:@"   [%@] %@ (P->%@)(L->%@)(R->%@)<%i>\n",node->key,node->value,node->parent->key,(node->left?node->left->key:@"null"),(node->right?node->right->key:@"null"),node->color];
            
            [*dsp appendFormat:@"   [%@] %@ \n",node->key,node->value];
        }
        else
        {
//            [*dsp appendFormat:@"   [%@] %@ (root)(L->%@)(R->%@)<%i>\n",node->key,node->value,(node->left?node->left->key:@"null"),(node->right?node->right->key:@"null"),node->color];
            
            [*dsp appendFormat:@"   [%@] %@ (Root)\n",node->key,node->value];
        }
        
        [self travelWithNode:node->right andDescription:dsp];
    }
}



//二叉树复制
- (instancetype)copyWithZone:(NSZone *)zone
{
    KATTreeMap *treeMap=[[[self class] allocWithZone:zone] init];
    
    //初始化root
    KATTreeNode *root=(KATTreeNode *)malloc(sizeof(KATTreeNode));//分配空间
    
    if(_length>0)
    {
        [self travelWithNode:_root andCopyTo:root withParent:nil];
    }
    else//没有任何节点
    {
        root->key=nil;
        root->value=nil;
        root->parent=nil;
        root->left=nil;
        root->right=nil;
    }
    
    [treeMap setRoot:root];
    
    [treeMap setLength:_length];//节点个数
    
    treeMap.replace=_replace;
    treeMap.balance=_balance;
    
    return treeMap;
}


//先序遍历，复制内容到数组（内部方法）
- (void)travelWithNode:(KATTreeNode *)node andCopyTo:(KATTreeNode *)new withParent:(KATTreeNode *)parent
{
    if(node)
    {
        if(parent)//如果父节点不为空（非根节点）
        {
            new=nil;
            new=(KATTreeNode *)malloc(sizeof(KATTreeNode));
            new->key=[node->key retain];
            new->value=[node->value retain];
            new->left=nil;
            new->right=nil;
            
            new->parent=parent;
            
            //判断是父节点的左节点还是右节点
            NSComparisonResult r=[new->key compare:parent->key];//比较
            
            if(r==NSOrderedAscending)//new的索引比parent小
            {
                parent->left=new;
            }
            else//new的索引比parent大
            {
                parent->right=new;
            }
        }
        else//根节点
        {
            new->key=[node->key retain];
            new->value=[node->value retain];
            new->parent=nil;
            new->left=nil;
            new->right=nil;
        }
        
        [self travelWithNode:node->left andCopyTo:new->left withParent:new];
        
        [self travelWithNode:node->right andCopyTo:new->right withParent:new];
        
    }
}



//后序遍历，释放内存（内部方法）
- (void)travelReleaseWithNode:(KATTreeNode *)node
{
    if(node)
    {
        [self travelReleaseWithNode:node->left];
        
        [self travelReleaseWithNode:node->right];
        
        [node->key release];
        [node->value release];
        node->key=nil;
        node->value=nil;
        node->left=nil;
        node->right=nil;
        node->parent=nil;
        
        free(node);
        node=nil;
    }
}


//清空
- (void)clear
{
    [self travelReleaseWithNode:_root];
    
    //初始化root
    KATTreeNode *root=(KATTreeNode *)malloc(sizeof(KATTreeNode));//分配空间
    root->key=nil;
    root->value=nil;
    root->parent=nil;
    root->left=nil;
    root->right=nil;
    
    [self setRoot:root];
    
    [self setLength:0];//节点个数0
}



#pragma -mark 红黑树操作方法

//颜色转换(左右子节点都为红色的情况下，子节点颜色变黑，非根节点变红)
- (KATTreeNode *)flipColorWithNode:(KATTreeNode *)node
{
    if(node!=_root)
    {
        node->color=TREE_COLOR_RED;
    }
    
    if(node->left)
    {
        node->left->color=TREE_COLOR_BLACK;
    }
    
    if(node->right)
    {
        node->right->color=TREE_COLOR_BLACK;
    }
    
//    //NSLog(@"Flip color");
    
    return node;
}


//左旋转(右子节点为红色的情况下)
- (KATTreeNode *)rotateLeftWithNode:(KATTreeNode *)node
{
    if(node && node->right)
    {
        KATTreeNode *x=node->right;
        
        node->right=x->left;
        
        if(x->left)
        {
            x->left->parent=node;
        }
        
        x->left=node;
        
        //父节点
        if(node->parent)
        {
            KATTreeNode *parent=node->parent;
            
            if(parent->left==node)
            {
                parent->left=x;
            }
            else if(parent->right==node)
            {
                parent->right=x;
            }
            
            x->parent=parent;
            node->parent=x;
        }
        else//根节点
        {
            _root=x;
            x->parent=nil;
            node->parent=x;
        }
        
        //变色
        x->color=node->color;
        node->color=TREE_COLOR_RED;
        
    //    //NSLog(@"rotate Left");
        
        return x;
    }
    
    return nil;
}


//右旋转(连续两个左子节点为红色的情况下)
- (KATTreeNode *)rotateRightWithNode:(KATTreeNode *)node
{
    if(node && node->left)
    {
        KATTreeNode *x=node->left;
        
        node->left=x->right;
        
        if(x->right)
        {
            x->right->parent=node;
        }
        
        x->right=node;
        
        //父节点
        if(node->parent)
        {
            KATTreeNode *parent=node->parent;
            
            if(parent->left==node)
            {
                parent->left=x;
            }
            else if(parent->right==node)
            {
                parent->right=x;
            }
            
            x->parent=parent;
            node->parent=x;
        }
        else//根节点
        {
            _root=x;
            x->parent=nil;
            node->parent=x;
        }
        
        //变色
        x->color=node->color;
        
        node->color=TREE_COLOR_RED;
        
    //    //NSLog(@"rotate Right");
        
        return x;
    }
    
    return nil;
}


//获取兄弟节点
- (KATTreeNode *)brotherWithNode:(KATTreeNode *)node
{
    if(node)
    {
        if(node->parent)
        {
            if(node->parent->left==node)
            {
                return node->parent->right;
            }
            else
            {
                return node->parent->left;
            }
        }
    }
    
    return nil;
}


//红黑树平衡检测
- (void)checkBalanceWithNode:(KATTreeNode *)node
{
    if(_balance && node)
    {
        KATTreeNode *next=nil;//需要递归的下一个节点
        
        //左旋转检测
        if((node->right && node->right->color==TREE_COLOR_RED) && (!node->left || node->left->color==TREE_COLOR_BLACK))
        {
            next=[self rotateLeftWithNode:node];
        }
        
        //右旋转检测
        if((node->left && node->left->color==TREE_COLOR_RED) && (node && node->color==TREE_COLOR_RED) && (node->parent))
        {
            next=[self rotateRightWithNode:node->parent];
        }
        
        //颜色转变
        if((node->left && node->left->color==TREE_COLOR_RED) && (node->right && node->right->color==TREE_COLOR_RED))
        {
            next=[self flipColorWithNode:node];
            next=next->parent;
        }
        
        //递归
        if(next)
        {
            [self checkBalanceWithNode:next];
        }
    }
}


//红黑树删除再平衡(每层兄弟变红)
- (void)deleteBalanceWithNode:(KATTreeNode *)node
{
    //执行变红的节点数组
    KATTreeNode *arr[256];
    int len=0;
    
    while(node && node!=_root)
    {
        KATTreeNode *brother=[self brotherWithNode:node];
        
        if(brother)
        {
            arr[len]=brother;
            
            //NSLog(@"变红数组:%i(%@)",len,brother->key);
            
            len++;
            
            node=node->parent;
        }
        else
        {
            break;
        }
    }
    
    for(int i=0;i<len && i<256;i++)
    {
        KATTreeNode *br=arr[i];
        
        if(br)
        {
            KATTreeNode *parent=br->parent;
            
            //NSLog(@"删除轮回: brother=%@",br->key);
            
            if(br->color==TREE_COLOR_BLACK)//黑色变红
            {
                //NSLog(@"删除轮回: 兄弟变红");
                
                br->color=TREE_COLOR_RED;
                
                //同时check父节点和兄弟节点
                [self checkBalanceWithNode:br->parent];
                [self checkBalanceWithNode:parent];
            }
            else//红色，则将右子变红（必有左右子，且都为黑）
            {
                if(br->left && br->right)
                {
                    //NSLog(@"删除轮回: 侄子变红");
                    
                    br->left->color=TREE_COLOR_RED;
                    br->right->color=TREE_COLOR_RED;
                    
                    //同时check父节点和兄弟节点
                    [self checkBalanceWithNode:br];
                    [self checkBalanceWithNode:br];
                }
            }
        }
        
        //再次检测
        [self checkBalanceWithNode:br];
        
        //NSLog(@"轮回之后:%@",self);
    }
}




//内存释放
- (void)dealloc
{
    [self travelReleaseWithNode:_root];
    
//    NSLog(@"KATTreeMap is dealloc");
    
    [super dealloc];
}

@end
