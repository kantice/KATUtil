//
//  KATStack.m
//  KATFramework
//
//  Created by Kantice on 13-11-19.
//  Copyright (c) 2013年 Kantice. All rights reserved.
//

#import "KATStack.h"



@interface KATStack ()
{
    @private
    id   *_member;//节点成员
    int _top;//栈顶节点下标
}

@end



@implementation KATStack


#pragma mark - 类方法

//构造方法
+ (instancetype)stack
{
    KATStack *stack=[[[self alloc] init] autorelease];
    
    //初始化
    [stack initData:STACK_CAPACITY_DEFAULT];
    
    return stack;
}


//设置数组容量的构造方法
+ (instancetype)stackWithCapacity:(int)capacity
{
    KATStack *stack=[[[self alloc] init] autorelease];
    
    //初始化
    if(capacity>0)
    {
        [stack initData:capacity];
    }
    else
    {
        [stack initData:STACK_CAPACITY_DEFAULT];
    }
    
    return stack;
}



#pragma mark - 私有方法

//初始化数据
- (void)initData:(int)capacity
{
    _capacity=capacity;
    _autoExpand=YES;
    _length=0;
    _top=0;
    
    //给成员分配空间
    _member=(id *)malloc(sizeof(id)*capacity);
    
    //初始成员变量赋空值
    for(int i=0;i<_capacity;i++)
    {
        _member[i]=nil;
    }
}


//设置_length
- (void)setLength:(int)value
{
    _length=value;
}


//获取member指针
- (id *)member
{
    return _member;
}


//获取栈顶节点下标
- (int)top
{
    return _top;
}


//设置栈顶节点下标
- (void)setTop:(int)value
{
    _top=value;
}



#pragma mark - 对象方法

//在栈顶节点，成功则返回YES
- (BOOL)put:(id)value
{
    if(!value)
    {
        return NO;
    }
    
    //判断数组是否已经满员
    if(_length<_capacity)
    {
        //添加成员
        _member[_top]=[value retain];
        
        _top++;
        
        _length++;
        
        return YES;
    }
    else
    {
        if(_autoExpand)//自动扩容
        {
            //保存原来的数据
            int len=_length;
            int top=_top;
            id *members=_member;
            
            //重新初始化
            [self initData:2*_capacity];
            _length=len;
            _top=top;
            
            //拷贝内存
            memcpy(_member, members, sizeof(id)*_length);
            
            free(members);
            
            return [self put:value];//添加成员
        }
        
        return NO;
    }
    
    return NO;
}


//获取栈顶节点，得到后将从堆栈中删除该节点，失败则返回nil
- (id)get
{
    if(_length>0)
    {
        id tmp=_member[_top-1];
        
        _member[_top-1]=nil;//置空
        
        _top--;
        
        _length--;
        
        return [tmp autorelease];//不需要外面接收的代码释放内存
    }
    else
    {
        return nil;
    }
}


//获取栈顶节点，但不在堆栈中删除
- (id)toper
{
    if(_top>0)
    {
        return _member[_top-1];
    }
    else
    {
        return nil;
    }
}


//判断堆栈是否为空
- (BOOL)isEmpty
{
    if(_length>0)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}


//是否包含成员
- (BOOL)hasMember:(id)member
{
    if(member)
    {
        for(int i=0;i<_top;i++)
        {
            if(_member[i]==member)//找到
            {
                return YES;
            }
            else if(_member[i] && [_member[i] isKindOfClass:[NSString class]] && [member isKindOfClass:[NSString class]] && [member isEqualToString:_member[i]])//字符串
            {
                return YES;
            }
        }
    }
    
    return NO;
}


//从指定成员的低下插入元素
- (BOOL)insert:(id)value toMember:(id)member
{
    if(value && member)
    {
        int position=-1;//插入位置
        
        //从后往前遍历
        for(int i=_top-1;i>=0;i--)
        {
            if(_member[i]==member)//找到
            {
                position=i;
                
                break;
            }
            else if(_member[i] && [_member[i] isKindOfClass:[NSString class]] && [member isKindOfClass:[NSString class]] && [member isEqualToString:_member[i]])//字符串
            {
                position=i;
                
                break;
            }
        }
        
        if(position>=0)//找到插入点
        {
            //先放置元素(方便扩容)
            if([self put:value])
            {
                //移动
                for(int i=_top-1;i>position;i--)
                {
                    _member[i]=_member[i-1];
                }
                
                _member[position]=value;
                
                return YES;
            }
        }
    }
    
    return NO;
}


//从指定成员的上面添加元素
- (BOOL)append:(id)value toMember:(id)member
{
    if(value && member)
    {
        int position=-1;//插入位置
        
        //从后往前遍历
        for(int i=_top-1;i>=0;i--)
        {
            if(_member[i]==member)//找到
            {
                position=i;
                
                break;
            }
            else if(_member[i] && [_member[i] isKindOfClass:[NSString class]] && [member isKindOfClass:[NSString class]] && [member isEqualToString:_member[i]])//字符串
            {
                position=i;
                
                break;
            }
        }
        
        if(position>=0)//找到插入点
        {
            //先放置元素(方便扩容)
            if([self put:value])
            {
                //移动
                for(int i=_top-1;i>position+1;i--)
                {
                    _member[i]=_member[i-1];
                }
                
                _member[position+1]=value;
                
                return YES;
            }
        }
    }
    
    return NO;
}


//删除指定的成员
- (BOOL)deleteMember:(id)member
{
    if(member)
    {
        int position=-1;//删除位置
        
        //从后往前遍历
        for(int i=_top-1;i>=0;i--)
        {
            if(_member[i]==member)//找到
            {
                position=i;
                
                break;
            }
            else if(_member[i] && [_member[i] isKindOfClass:[NSString class]] && [member isKindOfClass:[NSString class]] && [member isEqualToString:_member[i]])//字符串
            {
                position=i;
                
                break;
            }
        }
        
        if(position>=0)//找到删除点
        {
            //置空
            [_member[position] release];
            _member[position]=nil;
            
            //移动
            for(int i=position;i<_length-1;i++)
            {
                _member[i]=_member[i+1];
            }
            
            _top--;
            _length--;
            
            return YES;
        }
    }
    
    return NO;
}


//获取所有成员(从栈顶开始排序)
- (KATArray *)allMembers
{
    if(_length>0)
    {
        KATArray *array=[KATArray arrayWithCapacity:_length];
        
        //从后往前遍历
        for(int i=_top-1;i>=0;i--)
        {
            [array put:_member[i]];
        }
        
        return array;
    }
    else
    {
        return nil;
    }
}


//获取从栈顶开始的N个成员
- (KATArray *)topers:(int)count
{
    return [[self allMembers] fristMembers:count];
}


//清除堆栈
- (void)clear
{
    for(int i=0;i<_top;i++)
    {
        [_member[i] release];
        _member[i]=nil;
    }
    
    _length=0;
    _top=0;
}


//是否已经存满
- (BOOL)isFull
{
    if(_length<_capacity)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}


#pragma mark - 重载方法

//描述
- (NSString *)description
{
    NSMutableString *ms=[NSMutableString stringWithFormat:@"KATStack: cap=%i, len=%i top=%i\n{\n",_capacity,_length,_top];
    
    for(int i=0;i<_top;i++)
    {
        if(i==_top-1)
        {
            [ms appendFormat:@"   [Top] %@ \n",_member[i]];
        }
        else
        {
            [ms appendFormat:@"   [%i] %@ \n",i,_member[i]];
        }
    }
    
    [ms appendString:@"}"];
    
    return ms;

}


//堆栈复制
- (instancetype)copyWithZone:(NSZone *)zone
{
    KATStack *stack=[[[self class] allocWithZone:zone] init];
    
    [stack initData:_capacity];
    
    stack.length=_length;
    [stack setTop:_top];
    
    id *p=[stack member];//获取成员指针
    
    for(int i=0;i<_top;i++)
    {
        p[i]=[_member[i] retain];
    }
    
    return stack;
}


//内存释放
- (void)dealloc
{
    for(int i=0;i<_top;i++)
    {
        [_member[i] release];
        _member[i]=nil;
    }
    
    free(_member);
    _member=nil;
    
//    NSLog(@"KATStack is dealloc");
    
    [super dealloc];
}


@end
