//
//  SPLogHelper.m
//  SPUpdater
//
//  Created by Jay on 2017/12/8.
//  Copyright © 2017年 tiny. All rights reserved.
//

#import "SPLogHelper.h"
#import <AppKit/NSTextView.h>
#import "SPPathManager.h"

@interface SPLogHelper ()
@property (strong, nonatomic) NSTextView *textView;
@property (strong, nonatomic) NSFileHandle *file;
@end

void SPLog(NSString *format, ...){
    @try{
        va_list args;
        va_start(args, format);
        NSLogv(format, args);
        NSString *text = [[NSString alloc] initWithFormat:format arguments:args];
        va_end(args);
        [[SPLogHelper helper] log:text];
    }@catch(NSException *e){
        
    }
}

@implementation SPLogHelper

+ (instancetype)helper
{
    static SPLogHelper *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [SPLogHelper new];
        NSString *path = [[SPPathManager rootPath] stringByAppendingPathComponent:@"log.txt"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
            [[NSFileManager defaultManager] createFileAtPath:path contents:[NSData data] attributes:nil];
        }
        NSFileHandle *file = [NSFileHandle fileHandleForWritingAtPath:path];
        instance.file = file;
    });
    return instance;
}

- (void)setFile:(NSFileHandle *)file
{
    _file = file;
    [file seekToEndOfFile];
}

- (void)log:(NSString *)text
{
    text = [text stringByAppendingString:@"\n"];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.textView.string = [text stringByAppendingString:self.textView.string];;
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.file writeData:[text dataUsingEncoding:NSUTF8StringEncoding]];
    });
}

+ (void)setLogOutputTextView:(NSTextView *)textView
{
    [SPLogHelper helper].textView = textView;
}

@end
