//
//  SPGamepediaAPI.m
//  DOTA2ShiPing
//
//  Created by Jay on 2017/10/30.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

#import "SPGamepediaAPI.h"
#import "SPGamepediaSerializer.h"
#import "SPItem.h"
#import "SPGamepediaImage.h"
#import "SPGamepediaPlayable.h"
#import "SPGamepediaData.h"
@import Hpple;

//https://dota2.gamepedia.com/api.php?action=parse&format=json&prop=text&page=Aria_of_the_Wild_Wind_Set

@interface SPGamepediaAPI ()
@property (strong, nonatomic) AFHTTPSessionManager *manager;
@end

@implementation SPGamepediaAPI

+ (instancetype)shared
{
    static SPGamepediaAPI *shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [SPGamepediaAPI new];
        
        NSURL *baseURL = [NSURL URLWithString:@"https://dota2.gamepedia.com"];
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
        [manager.requestSerializer setValue:@"dota2.gamepedia.com" forHTTPHeaderField:@"Host"];
        [manager.requestSerializer setValue:@"Mozilla/5.0 (iPhone; CPU iPhone OS 9_3 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13E188a Safari/601.1" forHTTPHeaderField:@"User-Agent"];
        [manager.requestSerializer setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
        [manager.requestSerializer setValue:@"zh-cn" forHTTPHeaderField:@"Accept-Language"];
        [manager.requestSerializer setValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];

        shared.manager = manager;
    });
    return shared;
}

- (NSDictionary *)defaultWebAPIParams
{
    return @{@"action":@"parse",
             @"format":@"json",
             @"prop":@"text|parsetree|wikitext"};
}

- (void)fetchItemInfo:(SPItem *)item
           completion:(SPGamepediaAPICompletion)completion
{
    if (!completion) return;
    
    NSLog(@"Begin load Gamepedia content of item: %@",item.name);
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[self defaultWebAPIParams]];
    dict[@"page"] = item.name;
    
    AsyncBenchmarkTestBegin(SPGamepediaAPI)
    
    ygweakify(self);
    [self.manager GET:@"api.php" parameters:dict progress:^(NSProgress *downloadProgress) {
        NSLog(@"GamepediaAPI progress: %@",downloadProgress.localizedAdditionalDescription);
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        AsyncBenchmarkTestEnd(SPGamepediaAPI)
        ygstrongify(self);
        NSLog(@"Did load Gamepedia content");
        [self handleFetchResult:responseObject ofItem:item completion:completion];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        AsyncBenchmarkTestEnd(SPGamepediaAPI)
        NSLog(@"Failed load Gamepedia content. error: %@",error);
        completion(NO,[SPGamepediaData error:error]);
    }];
}

- (void)handleFetchResult:(id)responseObject ofItem:(SPItem *)item completion:(SPGamepediaAPICompletion)completion
{
    if (!completion) return;
    
    if (!responseObject || ![responseObject isKindOfClass:[NSDictionary class]]) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:SPGamepediaAPIErrorCodeUnexpectedResponse
                                         userInfo:nil];
        completion(NO,[SPGamepediaData error:error]);
        return;
    }
    
    SPGamepediaData *data = [SPGamepediaData new];
    
    NSString *html = [responseObject valueForKeyPath:@"parse.text.*"];
    
    NSLog(@"抓取Gamepedia图片资源开始");
    YYBenchmark(^{
        data.images = [self getGamepediaImages:html];
    }, ^(double ms) {
        NSLog(@"抓取Gamepedia图片资源结束，耗时 %.1f ms",ms);
    });
    
    if ([item isPlayable]) {
        NSLog(@"抓取Gamepedia可播放资源开始");
        YYBenchmark(^{
            data.playables = [self getGamepediaPlables:html];
        }, ^(double ms) {
            NSLog(@"抓取Gamepedia可播放资源结束，耗时 %.1f ms",ms);
        });
    }
    completion(YES,data);
}

- (NSArray *)getGamepediaImages:(NSString *)html
{
    NSMutableArray *images = [NSMutableArray array];
    @try {
        NSData *data = [html dataUsingEncoding:NSUTF8StringEncoding];
        TFHpple *root = [TFHpple hppleWithHTMLData:data];
        NSArray<TFHppleElement *> *effectsBoxes = [root searchWithXPathQuery:@"//table[@class='wikitable']//a[@class='image']//img"];
        NSArray<TFHppleElement *> *galleryboxes = [root searchWithXPathQuery:@"//li[@class='gallerybox']//a[@class='image']//img"];
        
        NSLog(@"Gamepedia content contain %d effect boxes",(int)effectsBoxes.count);
        NSLog(@"Gamepedia content contain %d gallery boxes",(int)galleryboxes.count);

        for (TFHppleElement *element in effectsBoxes) {
            NSString *src = [element objectForKey:@"src"];
            SPGamepediaImage *image = [SPGamepediaImage gamepediaImage:src];
            if (image) {
                image.width = [[element objectForKey:@"width"] integerValue];
                image.height = [[element objectForKey:@"height"] integerValue];
                [images addObject:image];
            }
        }
        
        for (TFHppleElement *element in galleryboxes) {
            NSString *src = [element objectForKey:@"src"];
            SPGamepediaImage *image = [SPGamepediaImage gamepediaImage:src];
            if (image) {
                image.width = [[element objectForKey:@"width"] integerValue];
                image.height = [[element objectForKey:@"height"] integerValue];
                [images addObject:image];
            }
        }
    }@catch (NSException *e){
        NSLog(@"SPGamepediaAPI Exception : %@",e);
    }@finally{
        NSLog(@"抓取到 SPGamepedia %d 张图片",(int)images.count);
        return images;
    }
}

- (NSString *)plainTextOfElement:(TFHppleElement *)element
{
    if (element.isTextNode) {
        return [element.content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    
    if ([[element objectForKey:@"title"] isEqualToString:@"Play"]) {
        return @"";
    }
    
    if ([element.tagName isEqualToString:@"small"]) {
        return @"";
    }
    
    NSArray<TFHppleElement *> *children = element.children;
    NSMutableArray *childrenTexts = [NSMutableArray array];
    for (TFHppleElement *aChild in children) {
        NSString *txt = [self plainTextOfElement:aChild];
        if (txt.length > 0) {
            [childrenTexts addObject:txt];
        }
    }
    NSString *plainText = [[childrenTexts componentsJoinedByString:@" "] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return plainText;
}

- (NSArray *)getGamepediaPlables:(NSString *)html
{
    NSMutableArray<SPGamepediaPlayable *> *contents = [NSMutableArray array];
    NSArray *result;
    @try {
        NSData *data = [html dataUsingEncoding:NSUTF8StringEncoding];
        TFHpple *root = [TFHpple hppleWithHTMLData:data];
        NSArray<TFHppleElement *> *playableElements = [root searchWithXPathQuery:@"//a[@title='Play']/parent::*"];
        NSLog(@"Gamepedia content contain %d playable elements",(int)playableElements.count);
        for (TFHppleElement *element in playableElements) {
            NSString *text = [self plainTextOfElement:element];
            TFHppleElement *playNode = [element searchWithXPathQuery:@"//a[@title='Play']"].firstObject;
            if (text && playNode) {
                NSString *URL = [playNode objectForKey:@"href"];
                SPGamepediaPlayable *aPlayable = [[SPGamepediaPlayable alloc] initWithURL:URL title:text];
//                NSLog(@"Playable: %@ : %@",text,URL);
                [contents addObject:aPlayable];
            }
        }
        //去重
        NSMutableSet *tmp = [NSMutableSet set];
        NSIndexSet *indexes = [contents indexesOfObjectsPassingTest:^BOOL(SPGamepediaPlayable *obj, NSUInteger idx, BOOL *stop) {
            if ([tmp containsObject:obj.resource]) {
                return NO;
            }
            [tmp addObject:obj.resource];
            return YES;
        }];
        NSLog(@"Gamepedia content 去重前 %d 个内容",(int)contents.count);
        result = [contents objectsAtIndexes:indexes];
        
    }@catch (NSException *e){
        NSLog(@"SPGamepediaAPI Exception : %@",e);
    }@finally{
        NSLog(@"抓取到 SPGamepedia %d 张音频",(int)result.count);
        return result;
    }
}

@end
