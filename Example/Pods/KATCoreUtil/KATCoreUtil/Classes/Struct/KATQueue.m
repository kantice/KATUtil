//
//  KATQueue.m
//  KATFramework
//
//  Created by Kantice on 13-11-19.
//  Copyright (c) 2013年 Kantice. All rights reserved.
//

#import "KATQueue.h"



@interface KATQueue ()
{
    @private
    id   *_member;//节点成员
    int _head;//头节点下标
    int _tail;//尾节点下标
}

@end



@implementation KATQueue


#pragma mark - 类方法

//构造方法
+ (instancetype)queue
{
    KATQueue *queue=[[[self alloc] init] autorelease];
    
    //初始化
    [queue initData:QUEUE_CAPACITY_DEFAULT];
    
    return queue;
}


//设置数组容量的构造方法
+ (instancetype)queueWithCapacity:(int)capacity
{
    KATQueue *queue=[[[self alloc] init] autorelease];
    
    //初始化
    if(capacity>0)
    {
        [queue initData:capacity];
    }
    else
    {
        [queue initData:QUEUE_CAPACITY_DEFAULT];
    }
    
    return queue;
}



#pragma mark - 私有方法

//初始化数据
- (void)initData:(int)capacity
{
    _capacity=capacity;
    _autoExpand=YES;
    _length=0;
    _head=0;
    _tail=0;
    
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


//获取头节点下标
- (int)head
{
    return _head;
}


//获取尾节点下标
- (int)tail
{
    return _tail;
}


//设置头节点下标
- (void)setHead:(int)value
{
    _head=value;
}


//设置尾节点下标
- (void)setTail:(int)value
{
    _tail=value;
}



#pragma mark - 对象方法

//在队尾添加节点，成功则返回YES
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
        _member[_tail]=[value retain];
        
        _tail++;
        
        if(_tail>=_capacity)//队列已经到了数组末尾
        {
            _tail=0;
        }
        
        _length++;
        
        return YES;
    }
    else
    {
        if(_autoExpand)//自动扩容
        {
            //保存原来的数据
            int len=_length;
            int head=_head;
            id *members=_member;
            
            //重新初始化
            [self initData:2*_capacity];
            _length=len;
            _head=0;
            _tail=_length;
            
            //转移
            for(int i=0,j=head;i<_length;i++,j++)
            {
                if(j>=_length)
                {
                    j=0;
                }
                
                _member[i]=members[j];
            }
            
            free(members);
            
            return [self put:value];//添加成员
        }
        
        return NO;
    }
    
    return NO;
}


//获取头节点，得到后将从队列中删除该头节点，失败则返回nil
- (id)get
{
    if(_length>0)
    {
        id tmp=_member[_head];
        
        _member[_head]=nil;//置空
        
        _head++;
        
        if(_head==_capacity)//队列已经到了数组末尾
        {
            _head=0;
        }
        
        _length--;
        
        return [tmp autorelease];//不需要外面接收的代码释放内存
    }
    else
    {
        return nil;
    }
}


//获取头节点，但不在队列中删除
- (id)header
{
    //如果没有任何节点，也会返回nil
    return _member[_head];
}


//判断队列是否为空
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
        if(_length>0)
        {
            if(_head<_tail)
            {
                for(int i=_head;i<_tail;i++)
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
            else
            {
                for(int i=_head;i<_capacity;i++)
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
                
                for(int i=0;i<_tail;i++)
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
        }
    }
    
    return NO;
}


//从指定成员的前面插入元素
- (BOOL)insert:(id)value toMember:(id)member
{
    if(value && member)
    {
        if([self hasMember:member])//存在该成员
        {
            //先放置元素(方便扩容)
            if([self put:value])
            {
                //重组队列，从0开始
                //保存原来的数据
                int len=_length;
                int head=_head;
                id *members=_member;
                
                //重新初始化
                [self initData:_capacity];
                _length=len;
                _head=0;
                _tail=_length;
                
                //转移
                for(int i=0,j=head;i<_length;i++,j++)
                {
                    if(j>=_length)
                    {
                        j=0;
                    }
                    
                    _member[i]=members[j];
                }
                
                free(members);
                
                int position=-1;//插入位置
                
                //从前往后遍历
                for(int i=_head;i<_tail-1;i++)
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
                
                if(position>=0)
                {
                    //移动
                    for(int i=_tail-1;i>position;i--)
                    {
                        _member[i]=_member[i-1];
                    }
                    
                    _member[position]=value;
                    
                    return YES;
                }
            }
            
        }
    }
    
    return NO;
}


//从指定成员的后面添加元素
- (BOOL)append:(id)value toMember:(id)member
{
    if(value && member)
    {
        if([self hasMember:member])//存在该成员
        {
            //先放置元素(方便扩容)
            if([self put:value])
            {
                //重组队列，从0开始
                //保存原来的数据
                int len=_length;
                int head=_head;
                id *members=_member;
                
                //重新初始化
                [self initData:_capacity];
                _length=len;
                _head=0;
                _tail=_length;
                
                //转移
                for(int i=0,j=head;i<_length;i++,j++)
                {
                    if(j>=_length)
                    {
                        j=0;
                    }
                    
                    _member[i]=members[j];
                }
                
                free(members);
                
                int position=-1;//插入位置
                
                //从前往后遍历
                for(int i=_head;i<_tail-1;i++)
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
                
                if(position>=0)
                {
                    //移动
                    for(int i=_tail-1;i>position+1;i--)
                    {
                        _member[i]=_member[i-1];
                    }
                    
                    _member[position+1]=value;
                    
                    return YES;
                }
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
        if([self hasMember:member])//存在该成员
        {
            //重组队列，从0开始
            //保存原来的数据
            int len=_length;
            int head=_head;
            id *members=_member;
            
            //重新初始化
            [self initData:_capacity];
            _length=len;
            _head=0;
            _tail=_length;
            
            //转移
            for(int i=0,j=head;i<_length;i++,j++)
            {
                if(j>=_length)
                {
                    j=0;
                }
                
                _member[i]=members[j];
            }
            
            free(members);
            
            int position=-1;//插入位置
            
            //从前往后遍历
            for(int i=_head;i<_tail;i++)
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
            
            if(position>=0)
            {
                //置空
                [_member[position] release];
                _member[position]=nil;
                
                //移动
                for(int i=position;i<_length-1;i++)
                {
                    _member[i]=_member[i+1];
                }
                
                _tail--;
                _length--;
                
                return YES;
            }
        }
    }
    
    return NO;
}


//获取所有成员(从队列头开始排序)
- (KATArray *)allMembers
{
    if(_length>0)
    {
        KATArray *array=[KATArray arrayWithCapacity:_length];
        
        if(_head<_tail)
        {
            for(int i=_head;i<_tail;i++)
            {
                [array put:_member[i]];
            }
        }
        else
        {
            for(int i=_head;i<_capacity;i++)
            {
                [array put:_member[i]];
            }
            
            for(int i=0;i<_tail;i++)
            {
                [array put:_member[i]];
            }
            
        }
        
        return array;
    }
    else
    {
        return nil;
    }
}


//获取从栈顶开始的N个成员
- (KATArray *)headers:(int)count
{
    return [[self allMembers] fristMembers:count];
}


//清除队列
- (void)clear
{
    if(_length>0)
    {
        if(_head<_tail)
        {
            for(int i=_head;i<_tail;i++)
            {
                [_member[i] release];
                _member[i]=nil;
            }
            
        }
        else
        {
            for(int i=_head;i<_capacity;i++)
            {
                [_member[i] release];
                _member[i]=nil;
            }
            
            for(int i=0;i<_tail;i++)
            {
                [_member[i] release];
                _member[i]=nil;
            }
            
        }
    }
    
    _length=0;
    _head=0;
    _tail=0;
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
    NSMutableString *ms=[NSMutableString stringWithFormat:@"KATQueue: cap=%i, len=%i head=%i tail=%i\n{\n",_capacity,_length,_head,_tail];
    
    if(_length>0)
    {
        if(_head<_tail)
        {
            for(int i=_head;i<_tail;i++)
            {
                if(i==_head)
                {
                    [ms appendFormat:@"   [Head] %@ \n",_member[i]];
                }
                else
                {
                    [ms appendFormat:@"   [%i] %@ \n",i,_member[i]];
                }
            }

        }
        else
        {
            for(int i=_head;i<_capacity;i++)
            {
                if(i==_head)
                {
                    [ms appendFormat:@"   [Head] %@ \n",_member[i]];
                }
                else
                {
                    [ms appendFormat:@"   [%i] %@ \n",i,_member[i]];
                }
            }
            
            for(int i=0;i<_tail;i++)
            {
                [ms appendFormat:@"   [%i] %@ \n",i,_member[i]];
            }

        }
    }
    
    [ms appendString:@"}"];
    
    return ms;

}


//队列复制（数组成员指向的对象地址还是同一个）
- (instancetype)copyWithZone:(NSZone *)zone
{
    KATQueue *queue=[[[self class] allocWithZone:zone] init];
    
    [queue initData:_capacity];
    
    queue.length=_length;
    [queue setHead:_head];
    [queue setTail:_tail];
    
    id *p=[queue member];//获取成员指针
    
    if(_length>0)
    {
        if(_head<_tail)
        {
            for(int i=_head;i<_tail;i++)
            {
                p[i]=[_member[i] retain];
            }
            
        }
        else
        {
            for(int i=_head;i<_capacity;i++)
            {
                p[i]=[_member[i] retain];
            }
            
            for(int i=0;i<_tail;i++)
            {
                p[i]=[_member[i] retain];
            }
            
        }
    }

    
    return queue;
}


//内存释放
- (void)dealloc
{
    if(_length>0)
    {
        if(_head<_tail)
        {
            for(int i=_head;i<_tail;i++)
            {
                [_member[i] release];
                _member[i]=nil;
            }
            
        }
        else
        {
            for(int i=_head;i<_capacity;i++)
            {
                [_member[i] release];
                _member[i]=nil;
            }
            
            for(int i=0;i<_tail;i++)
            {
                [_member[i] release];
                _member[i]=nil;
            }
            
        }
    }

    
    free(_member);
    _member=nil;
    
//    NSLog(@"KATQueue is dealloc");
    
    [super dealloc];
    
}


@end
