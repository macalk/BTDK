//
//  MethodDefine.h
//  KaiXinQianDai
//
//  Created by xiaoning on 2018/11/26.
//  Copyright © 2018年 xiaoning. All rights reserved.
//

#ifndef MethodDefine_h
#define MethodDefine_h

#define BTDKImage(name)                       [UIImage imageNamed:name]
#define BTDKString(string,args...)            [NSString stringWithFormat:string, args]
#define BTDKHexColor(string)                  [UIColor colorWithHexString:string]
#define BTDKHexColorAlpha(string, value)      [UIColor colorWithHexString:string alpha:value]
#define BTDKFont(size)                        [UIFont systemFontOfSize:size]
#define BTDKBoldFont(size)                    [UIFont boldSystemFontOfSize:size]
#define BTDKUrl(string)                       [NSURL URLWithString:string]


#define Strong                                @property (nonatomic, strong)
#define Weak                                  @property (nonatomic, weak)
#define Copy                                  @property (nonatomic, copy)
#define Assign                                @property (nonatomic, assign)

#define NULLString(string) ((![string isKindOfClass:[NSString class]])||[string isEqualToString:@""] || (string == nil) || [string isEqualToString:@""] || [string isKindOfClass:[NSNull class]]||[[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0 || [string isEqualToString:@"(null)"])


#ifndef weakify
# define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#endif

#ifndef strongify
# define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#endif



#endif /* MethodDefine_h */
