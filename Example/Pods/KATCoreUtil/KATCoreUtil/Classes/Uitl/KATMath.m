//
//  KATMath.m
//  KATFramework
//
//  Created by Kantice on 16/3/27.
//  Copyright © 2016年 KatApp. All rights reserved.
//

#import "KATMath.h"

@implementation KATMath


//矩形周长
+ (double)perimeterOfRectWithWidth:(double)width height:(double)height
{
    return width*2+height*2;
}


//矩形面积
+ (double)areaOfRectWithWidth:(double)width height:(double)height
{
    return width*height;
}


//三角形周长
+ (double)perimeterOfTriangleWithLengthA:(double)a lengthB:(double)b lengthC:(double)c
{
    return a+b+c;
}


//三角形面积
+ (double)areaOfTriangleWithBottomWidth:(double)width height:(double)height
{
    return width*height/2.0;
}


//圆形周长
+ (double)perimeterOfCircleWithRadius:(double)radius
{
    return radius*2*M_PI;
}


//圆形面积
+ (double)areaOfCircleWithRadius:(double)radius
{
    return radius*radius*M_PI;
}


//计算两点间的距离
+ (double)distanceWithPointA:(CGPoint)pa andPointB:(CGPoint)pb
{
    return sqrt((pa.x-pb.x)*(pa.x-pb.x)+(pa.y-pb.y)*(pa.y-pb.y));
}


//计算两点的中心点
+ (CGPoint)centerWithPointA:(CGPoint)pa andPointB:(CGPoint)pb
{    
    return CGPointMake((pa.x+pb.x)/2.0, (pa.y+pb.y)/2.0);
}


//已知三角形3边(a,b,c)长度，计算其中一边a对应的夹角A
+ (double)angleAWithSideA:(double)a sideB:(double)b sideC:(double)c
{
    return acos((b*b+c*c-a*a)/(2*b*c));
}

//已知三角形3边(a,b,c)长度，计算其中一边b对应的夹角B
+ (double)angleBWithSideA:(double)a sideB:(double)b sideC:(double)c
{
    return acos((a*a+c*c-b*b)/(2*a*c));
}


//已知三角形3边(a,b,c)长度，计算其中一边c对应的夹角C
+ (double)angleCWithSideA:(double)a sideB:(double)b sideC:(double)c
{
    return acos((a*a+b*b-c*c)/(2*a*b));
}


//已知边长和外接圆半径，计算角度（正弦定理）
+ (double)angelWithSide:(double)side andRadius:(double)radius
{
    return asin(side/(2.0*radius));
}


//已知角度和外接圆半径，计算边长（正弦定理）
+ (double)sidelWithAngle:(double)angle andRadius:(double)radius
{
    return sin(angle)*radius*2.0;
}

//已知两边和夹角，求另一边
+ (double)sideCWithAngle:(double)angle sideA:(double)a sideB:(double)b
{
    return sqrt(a*a+b*b-2*a*b*cos(angle));
}


//等差数列求和（已经知首数、末数和项数）
+ (double)sumOfArithmeticSequenceWithFirstNumber:(double)first andLastNumber:(double)last andCount:(long long)count
{
    return (first+last)*count/2.0;
}


//等差数列求和（已经知首数、差和项数）
+ (double)sumOfArithmeticSequenceWithFirstNumber:(double)first andDifference:(double)dif andCount:(long long)count
{
    return first*count+count*(count-1)*dif/2.0;
}


//等比数列求和（已经知首数、末数和项数）
+ (double)sumOfGeometricSequenceWithFirstNumber:(double)first andLastNumber:(double)last andRatio:(double)ratio
{
    if(ratio!=1.0)
    {
        return (first-last*ratio)/(1.0-ratio);
    }
    else
    {
        return 0;
    }
}

//等比数列求和（已经知首数、比和项数）
+ (double)sumOfGeometricSequenceWithFirstNumber:(double)first andRatio:(double)ratio andCount:(long long)count
{
    if(ratio!=1.0)
    {
        return (first*(1.0-pow(ratio, count)))/(1.0-ratio);
    }
    else
    {
        return first*count;
    }

}


//数字阶乘
+ (long long)factorialOfNumber:(long long)number
{
    if(number<0)
    {
        return 0;
    }
    
    long result=1;
    
    for(int i=1;i<=number;i++)
    {
        result*=i;
    }
    
    return result;
}


//排列
+ (long long)permutationWithNumber:(long long)number fromCount:(long long)count
{
    if(number>count || count<=0 || number<0)
    {
        return 0;
    }
    
    return [self factorialOfNumber:count]/[self factorialOfNumber:count-number];
}


//组合
+ (long long)combinationWithNumber:(long long)number fromCount:(long long)count
{
    if(number>count || count<=0 || number<0)
    {
        return 0;
    }
    
    return [self factorialOfNumber:count]/([self factorialOfNumber:count-number]*[self factorialOfNumber:number]);
}


//斐波纳吉数
+ (long long)numberOfFibonacciSequenceWithIndex:(long long)index
{
    if(index<=0)
    {
        return 0;
    }
    else if(index<=1)
    {
        return 1;
    }
    
    long f0=0;
    long f1=1;
    long f2=0;
    
    for(int i=2;i<=index;i++)
    {
        f2=f0+f1;
        f0=f1;
        f1=f2;
    }
    
    return f2;
}




//计算两个GPS坐标之际的直线距离(单位：千米)
+ (double)distanceWithLatitudeA:(double)latA latitudeB:(double)latB longitudeA:(double)lngA longitudeB:(double)lngB
{
    double radLatA=latA*M_PI/180.0;
    double radLatB=latB*M_PI/180.0;
    
    double a=radLatA-radLatB;
    double b=lngA*M_PI/180.0-lngB*M_PI/180.0;
    
    double s=2.0*asin(sqrt(pow(sin(a/2.0),2.0)+cos(radLatA)*cos(radLatB)*pow(sin(b/2.0),2.0)));
    
    return s*MATH_EARTH_RADIUS;
}




@end



