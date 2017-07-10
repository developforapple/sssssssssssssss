//
//  Warning.h
//  CDT
//
//  Created by Jay on 2017/7/6.
//  Copyright © 2017年 ailaidian,Inc. All rights reserved.
//

#ifndef Warning_h
#define Warning_h

// 不要修改下面的宏
#define N_W_MACRO_CAT(a,b)  a b
#define N_W_MACRO_STR_(text) # text
#define N_W_MACRO_STR(text) N_W_MACRO_STR_(text)
#define N_W_MACRO_PREFIX_   clang diagnostic ignored
#define N_W_MACRO_PREFIX    N_W_MACRO_PREFIX_
#define N_W_MACRO_(text)    N_W_MACRO_CAT(N_W_MACRO_PREFIX,N_W_MACRO_STR(text))
#define N_W_MACRO(text)     N_W_MACRO_STR(N_W_MACRO_(text))

#define NO_WARNING_BEGIN(text)\
    _Pragma("clang diagnostic push")\
    _Pragma(N_W_MACRO(text))


#define NO_WARNING_END \
    _Pragma("clang diagnostic pop")

// 不要修改上面的宏



// 用法与示例

// 请将 WARNING_DEMO 设为 1 打开示例
#define WARNING_DEMO 0

#if DEBUG && WARNING_DEMO

/*
 正常情况下，test1会有三个警告：
 a: Unused function 'test1'
 b: Undeclared selector 'theSELName'
 c: PerformSelector may cause a leak because its selector is unknown
 
 按 command + 5 打开警告列表。找到a,b,c对应的警告，右键选择 Reveal in log。
 可以看到这样的文本：
     Common/Warning.h:51:17: warning: undeclared selector 'theSELName' [-Wundeclared-selector]
     SEL aSEL = @selector(theSELName);
     ^
     /Users/jay/iOS/CDT/CDT/CDT2017/Common/Warning.h:54:14: warning: performSelector may cause a leak because its selector is unknown [-Warc-performSelector-leaks]
     [obj performSelector:aSEL];
     ^
     Common/Warning.h:48:13: warning: unused function 'test1' [-Wunused-function]
     static void test1(void){
     ^
 其中可以找到
 a 的警告类型：-Wunused-function
 b 的警告类型：-Wundeclared-selector
 c 的警告类型：-Warc-performSelector-leaks
 
 在发出警告的代码前使用消除警告代码宏即可消除这些警告。
 忘了在消除了警告的代码之后使用结束宏。消除开始宏可以写多个。结束宏只需要写一个就可以使得结束宏后面的代码的警告再次出现。
 
 你也可以在 http://fuckingclangwarnings.com 找到这些警告列表
 */

// 这个函数没有消除警告
static void test1(void){
    id obj = [NSObject new];
    SEL aSEL = @selector(theSELName);
    if ([obj respondsToSelector:aSEL]) {
        [obj performSelector:aSEL];
    }
}

// 使用消除警告宏消除警告
NO_WARNING_BEGIN(-Wunused-function)
NO_WARNING_BEGIN(-Wundeclared-selector)
NO_WARNING_BEGIN(-Warc-performSelector-leaks)

// 不消除警告时，Xcode会在这一行显示警告：Unused function 'test2'
static void test2(void){
    
    id obj = [NSObject new];
    
    // 不消除警告时，Xcode会在这一行显示警告：Undeclared selector 'theSELName'
    SEL aSEL = @selector(theSELName);
    
    if ([obj respondsToSelector:aSEL]) {
        
        // 不消除警告时，Xcode会在这一行显示警告：PerformSelector may cause a leak because its selector is unknown
        [obj performSelector:aSEL];
    }
}
NO_WARNING_END

#endif



#endif /* Warning_h */
