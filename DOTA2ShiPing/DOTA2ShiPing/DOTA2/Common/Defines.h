//
//  Macro.h
//
//  Created by WangBo on 2017/5/5.
//  Copyright © 2017年 WangBo. All rights reserved.
//

#ifndef Macro_h
#define Macro_h

#define _YG_Concat(a, v, c , d) a #v c d
#define _YG_DEPRECATED(version,text) _YG_Concat("v:", version, "弃用,", text)

#define YG_AVAILABLE(v)  NS_AVAILABLE_IOS(8_0)
#define YG_DEPRECATED(version,text) __deprecated_msg( _YG_DEPRECATED(version,text) )
#define YG_UNAVAILABLE(text) NS_UNAVAILABLE

#define YG_ENUM_AVAILABLE(v) NS_ENUM_AVAILABLE_IOS(8_0)


#define YG_INLINE       static __inline__ __attribute__((always_inline))
#define YG_EXTERN       extern __attribute__((visibility ("default")))
#define YG_NOSUBCLASS   __attribute__((objc_subclassing_restricted))
#define YG_NEEDSUPER    NS_REQUIRES_SUPER
#define YG_BOXABLE      __attribute__((objc_boxable))
#define YG_Constructor  __attribute__((constructor))
#define YG_Destructor   __attribute__((destructor))



#endif /* Macro_h */
