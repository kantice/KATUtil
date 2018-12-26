//
//  KATValueObserver.m
//  KATFramework
//
//  Created by Kantice on 2018/10/2.
//  Copyright © 2018年 KatApp. All rights reserved.
//

#import "KATValueObserver.h"
#import "KATMacros.h"
#import "KATCodeUtil.h"



#define OBSERVER_VERIFICATION_CODE @"_KAT_OBSERVER_VER_"


@interface KATValueObserver ()

///被观察的对象
@property(nonatomic,retain) id observedObject;

///被观察的属性的验证码
@property(nonatomic,retain) KATHashMap<NSString *> *verifications;

@end


@implementation KATValueObserver


#pragma -mark 类方法

//获取实例，并绑定观察对象
+ (instancetype)observerForObject:(id)object
{
    if(object)
    {
        KATValueObserver *observer=[[[self alloc] init] autorelease];
        
        observer.observedObject=object;
    
        return observer;
    }
    
    return nil;
}


#pragma -mark 对象方法

//初始化
- (instancetype)init
{
    if(self=[super init])
    {
        self.observedObject=nil;
        self.verifications=[KATHashMap hashMap];
        self.eventDelegate=nil;
    }
    
    return self;
}


//设置观察对象(仅一次)
- (void)setObservedObject:(id)observedObject
{
    if(!_observedObject && observedObject)
    {
        _observedObject=[observedObject retain];
    }
}


//添加需要观察的属性(路径)数组
- (void)addObservedKeys:(KATArray<NSString *> *)keys
{
    if(_observedObject)
    {
        for(NSString *key in keys)
        {
            if(key && key.length>0)
            {
                @try
                {
                    //KVC取值(可能会有异常)
                    id value=[_observedObject valueForKey:key];
                    
                    //验证码设置
                    _verifications[key]=[KATCodeUtil MD5WithContent:[NSString stringWithFormat:@"%@%@",OBSERVER_VERIFICATION_CODE,value] andBit:MD5_BIT_32 andCase:MD5_CASE_UPPER];
                    
                    //设置监听
                    [_observedObject addObserver:self forKeyPath:key options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
                }
                @catch(NSException *exception)
                {
                    //异常不处理
                }
            }
        }
    }
}


//添加需要观察的属性(路径)
- (void)addObservedKey:(NSString *)key
{
    [self addObservedKeys:ARRAY(key)];
}


//删除观察的属性(路径)数组
- (void)removeObservedKeys:(KATArray<NSString *> *)keys
{
    if(_observedObject)
    {
        for(NSString *key in keys)
        {
            if(key && key.length>0)
            {
                if(_verifications[key])//存在该key
                {
                    //删除校验码
                    _verifications[key]=nil;
                    
                    //移除监听
                    [_observedObject removeObserver:self forKeyPath:key];
                }
            }
        }
    }
}


//删除观察的属性(路径)
- (void)removeObservedKey:(NSString *)key
{
    [self removeObservedKeys:ARRAY(key)];
}


//清除所有的观察属性(路径)
- (void)clearObservedKeys
{
    [self removeObservedKeys:_verifications.allKeys];
}


//校验属性是否非法(不监听的属性都是合法的)
- (BOOL)isIllegalForKey:(NSString *)key
{
    if(key && _verifications[key])
    {
        @try
        {
            //KVC取值(可能会有异常)
            id value=[_observedObject valueForKey:key];
            
            if([_verifications[key] isEqualToString:[KATCodeUtil MD5WithContent:[NSString stringWithFormat:@"%@%@",OBSERVER_VERIFICATION_CODE,value] andBit:MD5_BIT_32 andCase:MD5_CASE_UPPER]])
            {
                return NO;
            }
            else//校验结果不一样
            {
                return YES;
            }
        }
        @catch(NSException *exception)
        {
            return NO;
        }
    }
    
    return NO;
}


//监听回调
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if(object==_observedObject)
    {
        id oldValue=change[NSKeyValueChangeOldKey];
        id newValue=change[NSKeyValueChangeNewKey];
        
        //旧值校验码
        NSString *ver=[KATCodeUtil MD5WithContent:[NSString stringWithFormat:@"%@%@",OBSERVER_VERIFICATION_CODE,oldValue] andBit:MD5_BIT_32 andCase:MD5_CASE_UPPER];
        
        //校验码判断
        if(![ver isEqualToString:_verifications[keyPath]])
        {
            //发生属性篡改
            if(_eventDelegate && [_eventDelegate respondsToSelector:@selector(valueObserver:didFindIllegalAlteration:)])
            {
                [_eventDelegate valueObserver:self didFindIllegalAlteration:keyPath];
            }
        }
        
        //新校验码
        _verifications[keyPath]=[KATCodeUtil MD5WithContent:[NSString stringWithFormat:@"%@%@",OBSERVER_VERIFICATION_CODE,newValue] andBit:MD5_BIT_32 andCase:MD5_CASE_UPPER];
    }
}


//释放内存
- (void)dealloc
{
    [self clearObservedKeys];
    
    [_observedObject release];
    [_verifications release];
    
    [super dealloc];
}

@end
