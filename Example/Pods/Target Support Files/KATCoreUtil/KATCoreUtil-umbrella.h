#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "KATMacros.h"
#import "KATArray.h"
#import "KATBranch.h"
#import "KATFloatArray.h"
#import "KATHashMap.h"
#import "KATIntArray.h"
#import "KATQueue.h"
#import "KATStack.h"
#import "KATTreeMap.h"
#import "KATAppUtil.h"
#import "KATCodeUtil.h"
#import "KATColor.h"
#import "KATDateUtil.h"
#import "KATExpressionUtil.h"
#import "KATFileUtil.h"
#import "KATJsonUtil.h"
#import "KATMath.h"
#import "KATSystemInfo.h"
#import "KATTimer.h"

FOUNDATION_EXPORT double KATCoreUtilVersionNumber;
FOUNDATION_EXPORT const unsigned char KATCoreUtilVersionString[];

