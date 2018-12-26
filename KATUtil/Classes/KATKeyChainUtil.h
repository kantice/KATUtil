//
//  KATKeyChainUtil.h
//  KATFramework
//
//  Created by Yi Yu on 2017/6/5.
//  Copyright © 2017年 KatApp. All rights reserved.
//  钥匙串存取工具



#pragma mark- 密钥类型

//密钥类型键
//CFTypeRef kSecClass

//值
//CFTypeRef kSecClassGenericPassword            //一般密码
//CFTypeRef kSecClassInternetPassword           //网络密码
//CFTypeRef kSecClassCertificate                //证书
//CFTypeRef kSecClassKey                        //密钥
//CFTypeRef kSecClassIdentity                   //身份证书(带私钥的证书)


//不同类型的钥匙串项对应的属性不同

//一般密码
//kSecClassGenericPassword

//对应属性
//kSecAttrAccessible
//kSecAttrAccessGroup
//kSecAttrCreationDate
//kSecAttrModificationDate
//kSecAttrDescription
//kSecAttrComment
//kSecAttrCreator
//kSecAttrType
//kSecAttrLabel
//kSecAttrIsInvisible
//kSecAttrIsNegative
//kSecAttrAccount
//kSecAttrService
//kSecAttrGeneric

//网络密码
//kSecClassInternetPassword

//对应属性
//kSecAttrAccessible
//kSecAttrAccessGroup
//kSecAttrCreationDate
//kSecAttrModificationDate
//kSecAttrDescription
//kSecAttrComment
//kSecAttrCreator
//kSecAttrType
//kSecAttrLabel
//kSecAttrIsInvisible
//kSecAttrIsNegative
//kSecAttrAccount
//kSecAttrSecurityDomain
//kSecAttrServer
//kSecAttrProtocol
//kSecAttrAuthenticationType
//kSecAttrPort
//kSecAttrPath

//证书
//kSecClassCertificate

//对应属性
//kSecAttrAccessible
//kSecAttrAccessGroup
//kSecAttrCertificateType
//kSecAttrCertificateEncoding
//kSecAttrLabel
//kSecAttrSubject
//kSecAttrIssuer
//kSecAttrSerialNumber
//kSecAttrSubjectKeyID
//kSecAttrPublicKeyHash

//密钥
//kSecClassKey

//对应属性
//kSecAttrAccessible
//kSecAttrAccessGroup
//kSecAttrKeyClass
//kSecAttrLabel
//kSecAttrApplicationLabel
//kSecAttrIsPermanent
//kSecAttrApplicationTag
//kSecAttrKeyType
//kSecAttrKeySizeInBits
//kSecAttrEffectiveKeySize
//kSecAttrCanEncrypt
//kSecAttrCanDecrypt
//kSecAttrCanDerive
//kSecAttrCanSign
//kSecAttrCanVerify
//kSecAttrCanWrap
//kSecAttrCanUnwrap

//身份证书(带私钥的证书)
//kSecClassIdentity

//对应属性
//   证书属性
//   私钥属性


#pragma mark- 属性

//键
//CFTypeRef kSecAttrAccessible;                              //可访问性 类型透明
//值
//CFTypeRef kSecAttrAccessibleWhenUnlocked;                  //解锁可访问，备份
//CFTypeRef kSecAttrAccessibleAfterFirstUnlock;              //第一次解锁后可访问，备份
//CFTypeRef kSecAttrAccessibleAlways;                        //一直可访问，备份
//CFTypeRef kSecAttrAccessibleWhenUnlockedThisDeviceOnly;    //解锁可访问，不备份
//CFTypeRef kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly;//第一次解锁后可访问，不备份
//CFTypeRef kSecAttrAccessibleAlwaysThisDeviceOnly;          //一直可访问，不备份

//CFTypeRef kSecAttrCreationDate;      //创建日期 CFDateRef
//CFTypeRef kSecAttrModificationDate;  //最后一次修改日期 CFDateRef
//CFTypeRef kSecAttrDescription;       //描述 CFStringRef
//CFTypeRef kSecAttrComment;           //注释 CFStringRef
//CFTypeRef kSecAttrCreator;           //创建者 CFNumberRef(4字符，如'aLXY')
//CFTypeRef kSecAttrType;              //类型 CFNumberRef(4字符，如'aTyp')
//CFTypeRef kSecAttrLabel;             //标签(给用户看) CFStringRef
//CFTypeRef kSecAttrIsInvisible;       //是否隐藏 CFBooleanRef(kCFBooleanTrue,kCFBooleanFalse)
//CFTypeRef kSecAttrIsNegative;        //是否具有密码 CFBooleanRef(kCFBooleanTrue,kCFBooleanFalse)此项表示当前的item是否只是一个占位项，或者说是只有key没有value。
//CFTypeRef kSecAttrAccount;           //账户名(密码类型的主键) CFStringRef
//CFTypeRef kSecAttrService;           //所具有服务(密码类型的主键) CFStringRef
//CFTypeRef kSecAttrGeneric;           //用户自定义内容 CFDataRef
//CFTypeRef kSecAttrSecurityDomain;    //网络安全域 CFStringRef
//CFTypeRef kSecAttrServer;            //服务器域名或IP地址 CFStringRef

//键
//CFTypeRef kSecAttrProtocol;            //协议类型 CFNumberRef
//值
//CFTypeRef kSecAttrProtocolFTP;         //
//CFTypeRef kSecAttrProtocolFTPAccount;  //
//CFTypeRef kSecAttrProtocolHTTP;        //
//CFTypeRef kSecAttrProtocolIRC;         //
//CFTypeRef kSecAttrProtocolNNTP;        //
//CFTypeRef kSecAttrProtocolPOP3;        //
//CFTypeRef kSecAttrProtocolSMTP;        //
//CFTypeRef kSecAttrProtocolSOCKS;       //
//CFTypeRef kSecAttrProtocolIMAP;        //
//CFTypeRef kSecAttrProtocolLDAP;        //
//CFTypeRef kSecAttrProtocolAppleTalk;   //
//CFTypeRef kSecAttrProtocolAFP;         //
//CFTypeRef kSecAttrProtocolTelnet;      //
//CFTypeRef kSecAttrProtocolSSH;         //
//CFTypeRef kSecAttrProtocolFTPS;        //
//CFTypeRef kSecAttrProtocolHTTPS;       //
//CFTypeRef kSecAttrProtocolHTTPProxy;   //
//CFTypeRef kSecAttrProtocolHTTPSProxy;  //
//CFTypeRef kSecAttrProtocolFTPProxy;    //
//CFTypeRef kSecAttrProtocolSMB;         //
//CFTypeRef kSecAttrProtocolRTSP;        //
//CFTypeRef kSecAttrProtocolRTSPProxy;   //
//CFTypeRef kSecAttrProtocolDAAP;        //
//CFTypeRef kSecAttrProtocolEPPC;        //
//CFTypeRef kSecAttrProtocolIPP;         //
//CFTypeRef kSecAttrProtocolNNTPS;       //
//CFTypeRef kSecAttrProtocolLDAPS;       //
//CFTypeRef kSecAttrProtocolTelnetS;     //
//CFTypeRef kSecAttrProtocolIMAPS;       //
//CFTypeRef kSecAttrProtocolIRCS;        //
//CFTypeRef kSecAttrProtocolPOP3S;       //

//键
//CFTypeRef kSecAttrAuthenticationType;            //认证类型 CFNumberRef
//值
//CFTypeRef kSecAttrAuthenticationTypeNTLM;        //
//CFTypeRef kSecAttrAuthenticationTypeMSN;         //
//CFTypeRef kSecAttrAuthenticationTypeDPA;         //
//CFTypeRef kSecAttrAuthenticationTypeRPA;         //
//CFTypeRef kSecAttrAuthenticationTypeHTTPBasic;   //
//CFTypeRef kSecAttrAuthenticationTypeHTTPDigest;  //
//CFTypeRef kSecAttrAuthenticationTypeHTMLForm;    //
//CFTypeRef kSecAttrAuthenticationTypeDefault;     //

//键
//CFTypeRef kSecAttrPort;                 //网络端口 CFNumberRef
//CFTypeRef kSecAttrPath;                 //访问路径 CFStringRef
//CFTypeRef kSecAttrSubject;              //X.500主题名称 CFDataRef
//CFTypeRef kSecAttrIssuer;               //X.500发行者名称 CFDataRef
//CFTypeRef kSecAttrSerialNumber;         //序列号 CFDataRef
//CFTypeRef kSecAttrSubjectKeyID;         //主题ID CFDataRef
//CFTypeRef kSecAttrPublicKeyHash;        //公钥Hash值 CFDataRef
//CFTypeRef kSecAttrCertificateType;      //证书类型 CFNumberRef
//CFTypeRef kSecAttrCertificateEncoding;  //证书编码类型 CFNumberRef

//键
//CFTypeRef kSecAttrKeyClass;           //加密密钥类  CFTypeRef
//值
//CFTypeRef kSecAttrKeyClassPublic;     //公钥
//CFTypeRef kSecAttrKeyClassPrivate;    //私钥
//CFTypeRef kSecAttrKeyClassSymmetric;  //对称密钥

//键
//CFTypeRef kSecAttrApplicationLabel;  //标签(给程序使用) CFStringRef(通常是公钥的Hash值)
//CFTypeRef kSecAttrIsPermanent;       //是否永久保存加密密钥 CFBooleanRef
//CFTypeRef kSecAttrApplicationTag;    //标签(私有标签数据) CFDataRef

//键
//CFTypeRef kSecAttrKeyType;  //加密密钥类型(算法) CFNumberRef
//值
//extern const CFTypeRef kSecAttrKeyTypeRSA;

//键
//CFTypeRef kSecAttrKeySizeInBits;     //密钥总位数 CFNumberRef
//CFTypeRef kSecAttrEffectiveKeySize;  //密钥有效位数 CFNumberRef
//CFTypeRef kSecAttrCanEncrypt;        //密钥是否可用于加密 CFBooleanRef
//CFTypeRef kSecAttrCanDecrypt;        //密钥是否可用于加密 CFBooleanRef
//CFTypeRef kSecAttrCanDerive;         //密钥是否可用于导出其他密钥 CFBooleanRef
//CFTypeRef kSecAttrCanSign;           //密钥是否可用于数字签名 CFBooleanRef
//CFTypeRef kSecAttrCanVerify;         //密钥是否可用于验证数字签名 CFBooleanRef
//CFTypeRef kSecAttrCanWrap;           //密钥是否可用于打包其他密钥 CFBooleanRef
//CFTypeRef kSecAttrCanUnwrap;         //密钥是否可用于解包其他密钥 CFBooleanRef
//CFTypeRef kSecAttrAccessGroup;       //访问组 CFStringRef


#pragma mark- 搜索

//CFTypeRef kSecMatchPolicy;                 //指定策略 SecPolicyRef
//CFTypeRef kSecMatchItemList;               //指定搜索范围 CFArrayRef(SecKeychainItemRef, SecKeyRef, SecCertificateRef, SecIdentityRef,CFDataRef)数组内的类型必须唯一。仍然会搜索钥匙串，但是搜索结果需要与该数组取交集作为最终结果。
//CFTypeRef kSecMatchSearchList;             //
//CFTypeRef kSecMatchIssuers;                //指定发行人数组 CFArrayRef
//CFTypeRef kSecMatchEmailAddressIfPresent;  //指定邮件地址 CFStringRef
//CFTypeRef kSecMatchSubjectContains;        //指定主题 CFStringRef
//CFTypeRef kSecMatchCaseInsensitive;        //指定是否不区分大小写 CFBooleanRef(kCFBooleanFalse或不提供此参数,区分大小写;kCFBooleanTrue,不区分大小写)
//CFTypeRef kSecMatchTrustedOnly;            //指定只搜索可信证书 CFBooleanRef(kCFBooleanFalse或不提供此参数,全部证书;kCFBooleanTrue,只搜索可信证书)
//CFTypeRef kSecMatchValidOnDate;            //指定有效日期 CFDateRef(kCFNull表示今天)
//CFTypeRef kSecMatchLimit;                  //指定结果数量 CFNumberRef(kSecMatchLimitOne;kSecMatchLimitAll)
//CFTypeRef kSecMatchLimitOne;               //首条结果
//CFTypeRef kSecMatchLimitAll;               //全部结果


#pragma mark- 列表

//CFTypeRef kSecUseItemList;          //CFArrayRef(SecKeychainItemRef, SecKeyRef, SecCertificateRef, SecIdentityRef,CFDataRef)数组内的类型必须唯一。用户提供用于查询的列表。当这个列表被提供的时候，不会再搜索钥匙串。


#pragma mark- 返回值类型

//可以同时指定多种返回值类型
//CFTypeRef kSecReturnData;           //返回数据(CFDataRef) CFBooleanRef
//CFTypeRef kSecReturnAttributes;     //返回属性字典(CFDictionaryRef) CFBooleanRef
//CFTypeRef kSecReturnRef;            //返回实例(SecKeychainItemRef, SecKeyRef, SecCertificateRef, SecIdentityRef, or CFDataRef)         CFBooleanRef
//CFTypeRef kSecReturnPersistentRef;  //返回持久型实例(CFDataRef) CFBooleanRef


#pragma mark- 写入值类型

//CFTypeRef kSecValueData;
//CFTypeRef kSecValueRef;
//CFTypeRef kSecValuePersistentRef;





#import <Foundation/Foundation.h>
#import <Security/Security.h>


@interface KATKeyChainUtil : NSObject


///保存密码
+ (BOOL)savePassword:(NSString *)password forKey:(NSString *)key;

///获取密码
+ (NSString *)passwordForKey:(NSString *)key;

///删除密码
+ (BOOL)deletePasswordForKey:(NSString *)key;



@end




