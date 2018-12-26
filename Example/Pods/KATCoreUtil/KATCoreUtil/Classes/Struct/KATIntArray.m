//
//  KATIntArray.m
//  KATFramework
//
//  Created by Kantice on 13-11-18.
//  Copyright (c) 2013年 Kantice. All rights reserved.
//  

#import "KATIntArray.h"


@interface KATIntArray()
{
    @private
    int   *_member;
}

///数组中的最小值
@property(nonatomic,assign) int min;

///数组中的最大值
@property(nonatomic,assign) int max;

///数组中的和
@property(nonatomic,assign) long long sum;

@end



@implementation KATIntArray

#pragma mark - 类方法

//构造方法
+ (instancetype)intArray
{
    KATIntArray *array=[[[self alloc] init] autorelease];
    
    //初始化
    [array initData:INT_ARRAY_CAPACITY_DEFAULT];
    
    return array;
}

+ (instancetype)intArrayWithCapacity:(int)capacity
{
    KATIntArray *array=[[[self alloc] init] autorelease];
    
    //初始化
    if(capacity>0)
    {
        [array initData:capacity];
    }
    else
    {
        [array initData:INT_ARRAY_CAPACITY_DEFAULT];
    }
    
    return array;
}


#pragma mark - 私有方法

//初始化数据
- (void)initData:(int)capacity
{
    _capacity=capacity;
    _length=0;
    _autoExpand=YES;
    
    //给成员分配空间
    _member=(int *)malloc(sizeof(int)*capacity);
    
    //初始成员变量赋空值
    for(int i=0;i<_capacity;i++)
    {
        _member[i]=INT_ARRAY_VALUE_EMPTY;
    }
}


//设置_length
- (void)setLength:(int)value
{
    _length=value;
}


//获取member指针
- (int *)member
{
    return _member;
}




#pragma mark - 属性

//最小值
- (int)min
{
    if(_length<=0)
    {
        return 0;
    }
    else
    {
        int m=_member[0];
        
        for(int i=1;i<_length;i++)
        {
            if(m>_member[i])
            {
                m=_member[i];
            }
        }
        
        return m;
    }
}


//最大值
- (int)max
{
    if(_length<=0)
    {
        return 0;
    }
    else
    {
        int m=_member[0];
        
        for(int i=1;i<_length;i++)
        {
            if(m<_member[i])
            {
                m=_member[i];
            }
        }
        
        return m;
    }
}


//和
- (long long)sum
{
    if(_length<=0)
    {
        return 0;
    }
    else
    {
        long long s=0;
        
        for(int i=0;i<_length;i++)
        {
            s+=_member[i];
        }
        
        return s;
    }
}



#pragma mark - 对象方法

//添加数组成员，成功则返回YES
- (BOOL)put:(int)value
{
    if(value==INT_ARRAY_VALUE_EMPTY)
    {
        return NO;
    }
    
    //判断数组是否已经满员
    if(_length<_capacity)
    {
        //添加成员
        _member[_length]=value;
        _length++;
        
        return YES;
    }
    else
    {
        if(_autoExpand)//自动扩容
        {
            //保存原来的数据
            int len=_length;
            int *members=_member;
            
            //重新初始化
            [self initData:2*_capacity];
            _length=len;
            
            //转移
//            for(int i=0;i<_length;i++)
//            {
//                _member[i]=members[i];
//            }
            
            //拷贝内存
            memcpy(_member, members, sizeof(int)*_length);
            
            free(members);
            
            return [self put:value];//添加成员
        }
        
        return NO;
    }
}


//根据索引获取数组成员，失败则返回空值
- (int)get:(int)index
{
    //判断index的范围
    if(index>=0 && index<_length)
    {
        return _member[index];
    }
    else
    {
        return INT_ARRAY_VALUE_EMPTY;
    }
}


//设置成员数据
- (BOOL)set:(int)value withIndex:(int)index
{
    //判断index的范围
    if(index>=0 && index<_length)
    {
        if(value==INT_ARRAY_VALUE_EMPTY)
        {
            return [self deleteWithIndex:index];
        }
        
        _member[index]=value;
        
        return YES;
    }
    else
    {
        return NO;
    }
    
}


//从指定的位置插入数据，成功则返回YES
- (BOOL)put:(int)value withIndex:(int)index
{
    if(index<0 || index>_length || value==INT_ARRAY_VALUE_EMPTY)//容量已满或者index不在length范围内，则插入失败
    {
        return NO;
    }
    else if(_length>=_capacity)//容量不够
    {
        if(_autoExpand)//自动扩容
        {
            //保存原来的数据
            int len=_length;
            int *members=_member;
            
            //重新初始化
            [self initData:2*_capacity];
            _length=len;
            
            //转移
//            for(int i=0;i<_length;i++)
//            {
//                _member[i]=members[i];
//            }
            
            //拷贝内存
            memcpy(_member, members, sizeof(int)*_length);
            
            free(members);
            
            return [self put:value withIndex:index];//添加成员
        }
        
        return NO;
    }
    else
    {
        for(int i=_length;i>index;i--)
        {
            _member[i]=_member[i-1];
        }
        
        _member[index]=value;
        
        _length++;
        
        return YES;
    }
}


//从指定的位置添加数组，成功则返回YES
- (BOOL)putArray:(KATIntArray *)array withIndex:(int)index
{
    if(array==nil || array.length<=0 || index<0 || index>_length)//容量不够，空数组或者index不在length范围内，则插入失败
    {
        return NO;
    }
    else if(_length+array.length>_capacity)//容量不够
    {
        if(_autoExpand)//自动扩容
        {
            int capacity=_capacity+array.length;
            
            //保存原来的数据
            int len=_length;
            int *members=_member;
            
            //重新初始化
            [self initData:capacity];
            _length=len;
            
            //转移
//            for(int i=0;i<_length;i++)
//            {
//                _member[i]=members[i];
//            }
            
            //拷贝内存
            memcpy(_member, members, sizeof(int)*_length);
            
            free(members);
            
            return [self putArray:array withIndex:index];//添加成员
        }
        
        return NO;
    }
    else
    {
        for(int i=_length+array.length-1;i>=index+array.length;i--)
        {
            _member[i]=_member[i-array.length];
        }
        
        for(int i=index;i<index+array.length;i++)
        {
            _member[i]=[array get:i-index];
        }
        
        _length+=array.length;
        
        return YES;
    }
}


//根据range获取成员数组，失败则返回nil
- (KATIntArray *)getFormRange:(NSRange)range;
{
    //判断range的范围
    if((range.location+range.length)<=_length)
    {
        KATIntArray *array=[KATIntArray intArrayWithCapacity:(int)range.length];
        
        for(int i=(int)range.location,j=0;j<range.length;i++,j++)
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


//交换两个成员的位置
- (BOOL)changePositionWithIndexA:(int)a andIndexB:(int)b
{
    if(a>=0 && a<_length && b>=0 && b<_length && a!=b)//判断a，b下标范围
    {
        int tmp;
        
        tmp=_member[a];
        _member[a]=_member[b];
        _member[b]=tmp;
        
        return YES;
    }
    else
    {
        return NO;
    }
}



//获取第一个成员
- (int)firstMember
{
    if(_length>0)
    {
        return _member[0];
    }
    else
    {
        return INT_ARRAY_VALUE_EMPTY;
    }
}


//获取最后一个成员
- (int)lastMember
{
    if(_length>0)
    {
        return _member[_length-1];
    }
    else
    {
        return INT_ARRAY_VALUE_EMPTY;
    }
}


//获取随机的成员
- (int)randomMember
{
    if(_length>0)
    {
        return _member[arc4random()%_length];
    }
    else
    {
        return INT_ARRAY_VALUE_EMPTY;
    }
}


//删除数组成员，成功则返回YES
- (BOOL)deleteWithIndex:(int)index
{
    //判断index的范围
    if(index>=0 && index<_length)
    {
        //删除元素并前移数组
        for(int i=index;i<_length-1;i++)
        {
            _member[i]=_member[i+1];
        }
        
        _member[_length-1]=INT_ARRAY_VALUE_EMPTY;//最后的成员赋空值
        
        _length--;
        
        return YES;
    }
    else
    {
        return NO;
    }

}


///替换数组成员值，成功则返回YES
- (BOOL)replaceValue:(int)value withIndex:(int)index
{
    if(value==INT_ARRAY_VALUE_EMPTY)
    {
        return NO;
    }
    
    //判断index的范围
    if(index>=0 && index<_length)
    {
        _member[index]=value;
        
        return YES;
    }
    else
    {
        return NO;
    }
}


//根据range删除数组成员，成功则返回YES
- (BOOL)deleteFromRange:(NSRange)range
{
    //判断range的范围
    if((range.location-1+range.length)<_length)
    {
        //删除元素并前移数组
        for(int i=(int)range.location;i<_length-range.length;i++)
        {
            _member[i]=_member[i+range.length];
        }
        
        for(int i=_length-(int)range.length;i<_length;i++)
        {
            _member[i]=INT_ARRAY_VALUE_EMPTY;//最后的成员赋空值
        }
        
        _length-=range.length;
        
        return YES;
    }
    else
    {
        return NO;
    }

}


//所有成员向前移动
- (void)forwardByStep:(int)step
{
    if(_length>0)
    {
        step=step%_length;
        
        if(step>0)
        {
            int *tmp=(int *)malloc(sizeof(id)*step);//临时变量数组
            
            for(int i=0;i<step;i++)//前step个成员移动到临时数组
            {
                tmp[i]=_member[i];
            }
            
            for(int i=0;i<_length-step;i++)//从0～length-step移动
            {
                _member[i]=_member[i+step];
            }
            
            for(int i=_length-step;i<_length;i++)//把临时数组的内容移动到成员数组末尾
            {
                _member[i]=tmp[i-_length+step];
            }
            
            
            free(tmp);//临时数组释放内存
            tmp=nil;
        }
    }
}


//所有成员向后移动
- (void)backwardByStep:(int)step
{
    if(_length>0)
    {
        step=step%_length;
        
        if(step>0)
        {
            int *tmp=(int *)malloc(sizeof(id)*step);//临时变量数组
            
            for(int i=_length-1;i>=_length-step;i--)//后step个成员移动到临时数组
            {
                tmp[step+i-_length]=_member[i];
            }
            
            for(int i=_length-1;i>=step;i--)//从length~step移动
            {
                _member[i]=_member[i-step];
            }
            
            for(int i=0;i<step;i++)//把临时数组的内容移动到成员数组开头
            {
                _member[i]=tmp[i];
            }
            
            
            free(tmp);//临时数组释放内存
            tmp=nil;
        }
    }
}


//数组反序
- (void)reverse
{
    int tmp;
    
    for(int i=0;i<_length/2;i++)
    {
        tmp=_member[_length-1-i];
        _member[_length-1-i]=_member[i];
        _member[i]=tmp;
    }
}


//数组排序
- (void)sort
{
    intQuickSort(_member,0,_length-1);
//    intBubbleSort(_member,_length);
}


#pragma mark - 排序算法

//快速排序
void intQuickSort(int arr[],int s,int e)
{
    if(s<e)
    {
        int m=intPartion(arr,s,e);//交换，得到中间位置
        
        intQuickSort(arr,s,m-1);//左边部分排序
        
        intQuickSort(arr,m+1,e);//右边部分排序
    }
}


int intPartion(int arr[],int s,int e)
{
//    //rand
//    srand((unsigned)time( NULL));//随机数种子
//    int k=rand()%(e-s+1)+s;//随机产生数组下标，得到需要比较的数字
    int k=(e-s)/2+s;//中间数为需要比较的数字
    
    int key=arr[k];//存放需要比较的数字
    
    //将要比较的数存放在第一个位置
    arr[k]=arr[s];
    arr[s]=key;
    
    
//    int tmp;//交换用的临时变量
    
    while(s<e)
    {
        while(s<e)
        {
            //寻找右边比tmp小的数
            if(arr[e]<key)
            {
                arr[s]=arr[e];
                
                break;
            }
            else
            {
                e--;
            }
        }
        
        while(s<e)
        {
            //寻找左边比tmp大的数
            if(arr[s]>key)
            {
                arr[e]=arr[s];
                
                break;
            }
            else
            {
                s++;
            }

        }
            
    }
    
    arr[e]=key;
    
    return e;
}


//冒泡排序
void intBubbleSort(int arr[],int length)
{
    BOOL flag=NO;
    
    int tmp;
    int j;
    
    for (int i=0;i<length;i++)
    {
        flag=YES;
        
        for (j=length-1;j>i;j--)
        {
            if(arr[j]<arr[j-1])
            {
                tmp=arr[j-1];
                arr[j-1]=arr[j];
                arr[j]=tmp;
                
                flag=NO;
            }
        }
        
        if(flag)
        {
            break;
        }
    }
}


//数组乱序洗牌
- (void)shuffle
{
    //让每个成员进行一次随机交换位置
    for(int i=0;i<_length;i++)
    {
        int p=arc4random()%_length;//随机交换的位置
        
        [self changePositionWithIndexA:i andIndexB:p];
    }
    
    //二次随机换位置
    for(int i=_length-1;i>=0;i--)
    {
        int p=arc4random()%_length;//随机交换的位置
        
        [self changePositionWithIndexA:i andIndexB:p];
    }
}


//清空数组
- (void)clear
{
    //初始成员变量赋空值
    for(int i=0;i<_capacity;i++)
    {
        _member[i]=INT_ARRAY_VALUE_EMPTY;
    }
    
    _length=0;
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
    NSMutableString *ms=[NSMutableString stringWithFormat:@"KATIntArray: cap=%i, len=%i, sum=%lli, max=%i, min=%i\n{\n",_capacity,_length,self.sum,self.max,self.min];
    
    for(int i=0;i<_length;i++)
    {
        [ms appendFormat:@"   [%i] %i \n",i,_member[i]];
    }
    
    [ms appendString:@"}"];
    
    return ms;
}


//数组复制
- (id)copyWithZone:(NSZone *)zone
{
    KATIntArray *array=[[[self class] allocWithZone:zone] init];
    
    [array initData:_capacity];
    
    array.length=_length;
    array.autoExpand=_autoExpand;
    array.max=_max;
    array.min=_min;
    array.sum=_sum;
    
    int *p=[array member];//获取成员指针
    
    for(int i=0;i<_length;i++)
    {
        p[i]=_member[i];
    }
    
    return array;
}


//内存释放
- (void)dealloc
{
    free(_member);
    _member=nil;
    
//    NSLog(@"KATIntArray is dealloc");
    
    [super dealloc];
}



@end
