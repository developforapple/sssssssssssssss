//
//  SPGamepediaSerializer.m
//  DOTA2ShiPing
//
//  Created by Jay on 2017/10/30.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPGamepediaSerializer.h"
#import "TFHpple.h"
#import "SPGamepediaImage.h"

static NSError * AFErrorWithUnderlyingError(NSError *error, NSError *underlyingError) {
    if (!error) {
        return underlyingError;
    }
    
    if (!underlyingError || error.userInfo[NSUnderlyingErrorKey]) {
        return error;
    }
    
    NSMutableDictionary *mutableUserInfo = [error.userInfo mutableCopy];
    mutableUserInfo[NSUnderlyingErrorKey] = underlyingError;
    
    return [[NSError alloc] initWithDomain:error.domain code:error.code userInfo:mutableUserInfo];
}

static BOOL AFErrorOrUnderlyingErrorHasCodeInDomain(NSError *error, NSInteger code, NSString *domain) {
    if ([error.domain isEqualToString:domain] && error.code == code) {
        return YES;
    } else if (error.userInfo[NSUnderlyingErrorKey]) {
        return AFErrorOrUnderlyingErrorHasCodeInDomain(error.userInfo[NSUnderlyingErrorKey], code, domain);
    }
    
    return NO;
}

@implementation SPGamepediaSerializer

+ (instancetype)serializer
{
    return [[[self class] alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (id)responseObjectForResponse:(NSURLResponse *)response data:(NSData *)data error:(NSError *__autoreleasing  _Nullable *)error
{
    if (![self validateResponse:(NSHTTPURLResponse *)response data:data error:error]) {
        if (!error || AFErrorOrUnderlyingErrorHasCodeInDomain(*error, NSURLErrorCannotDecodeContentData, AFURLResponseSerializationErrorDomain)) {
            return nil;
        }
    }
    
    @try {
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:error];
        if (jsonObject && [jsonObject isKindOfClass:[NSDictionary class]]) {
            NSString *html = [jsonObject valueForKeyPath:@"parse.text.*"];
            NSData *data = [html dataUsingEncoding:NSUTF8StringEncoding];
            TFHpple *root = [TFHpple hppleWithHTMLData:data];
            NSArray<TFHppleElement *> *galleryboxes = [root searchWithXPathQuery:@"//li[@class='gallerybox']//img"];
            NSMutableArray *images = [NSMutableArray array];
            for (TFHppleElement *element in galleryboxes) {
                NSString *src = [element objectForKey:@"src"];
                SPGamepediaImage *image = [SPGamepediaImage gamepediaImage:src];
                if (image) {
                    image.width = [[element objectForKey:@"width"] integerValue];
                    image.height = [[element objectForKey:@"height"] integerValue];
                    [images addObject:image];
                }
            }
            return images;
        }
        return nil;
    }@catch (NSException *ex){
        return nil;
    }
}

@end
