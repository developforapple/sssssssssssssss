//
//  IDMPhoto.m
//  IDMPhotoBrowser
//
//  Created by Michael Waterfall on 17/10/2010.
//  Copyright 2010 d3i. All rights reserved.
//

#import "IDMPhoto.h"
#import "IDMPhotoBrowser.h"
#import "YYWebImage+Add.h"

@interface IDMPhoto ()
@property (nonatomic, strong) UIImage *underlyingImage;
@property (nonatomic, strong) NSString *photoPath;
@property (nonatomic, assign) BOOL loadingInProgress;

@property (nonatomic, strong) YYWebImageOperation *operation;
@end

@implementation IDMPhoto

#pragma mark Class Methods
+ (IDMPhoto *)photoWithImage:(UIImage *)image {
	return [[IDMPhoto alloc] initWithImage:image];
}

+ (IDMPhoto *)photoWithFilePath:(NSString *)path {
	return [[IDMPhoto alloc] initWithFilePath:path];
}

+ (IDMPhoto *)photoWithURL:(NSURL *)url {
	return [[IDMPhoto alloc] initWithURL:url];
}

+ (NSArray *)photosWithImages:(NSArray *)imagesArray {
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:imagesArray.count];
    
    for (UIImage *image in imagesArray) {
        if ([image isKindOfClass:[UIImage class]]) {
            IDMPhoto *photo = [IDMPhoto photoWithImage:image];
            [photos addObject:photo];
        }
    }
    
    return photos;
}

+ (NSArray *)photosWithFilePaths:(NSArray *)pathsArray {
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:pathsArray.count];
    
    for (NSString *path in pathsArray) {
        if ([path isKindOfClass:[NSString class]]) {
            IDMPhoto *photo = [IDMPhoto photoWithFilePath:path];
            [photos addObject:photo];
        }
    }
    
    return photos;
}

+ (NSArray *)photosWithURLs:(NSArray *)urlsArray {
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:urlsArray.count];
    
    for (id url in urlsArray) {
        if ([url isKindOfClass:[NSURL class]]) {
            IDMPhoto *photo = [IDMPhoto photoWithURL:url];
            [photos addObject:photo];
        }
        else if ([url isKindOfClass:[NSString class]]) {
            IDMPhoto *photo = [IDMPhoto photoWithURL:[NSURL URLWithString:url]];
            [photos addObject:photo];
        }
    }
    
    return photos;
}

#pragma mark NSObject

- (id)initWithImage:(UIImage *)image {
	if ((self = [super init])) {
		self.underlyingImage = image;
	}
	return self;
}

- (id)initWithFilePath:(NSString *)path {
	if ((self = [super init])) {
		_photoPath = [path copy];
	}
	return self;
}

- (id)initWithURL:(NSURL *)url {
	if ((self = [super init])) {
		_photoURL = [url copy];
	}
	return self;
}

#pragma mark IDMPhoto Protocol Methods

- (UIImage *)underlyingImage {
    return _underlyingImage;
}

- (void)loadUnderlyingImageAndNotify {
    NSAssert([[NSThread currentThread] isMainThread], @"This method must be called on the main thread.");
    _loadingInProgress = YES;
    if (self.underlyingImage) {
        // Image already loaded
        [self imageLoadingComplete];
    } else {
        if (_photoPath) {
            YYImage *image = [YYImage imageWithContentsOfFile:_photoPath];
            self.underlyingImage = image;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self imageLoadingComplete];
            });
        } else if (_photoURL) {
            
            YYWebImageManager *manager = [YYWebImageManager sharedManager];
            
            // 检查缓存
            NSString *cacheKey = [manager cacheKeyForURL:_photoURL];
            UIImage *image = [manager.cache getImageForKey:cacheKey];
            if (image) {
                self.underlyingImage = image;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self imageLoadingComplete];
                });
                return;
            }
            
            __weak typeof(self) weakSelf = self;
            self.operation =
            [manager requestImageWithURL:_photoURL options:YYWebImageOptionAllowBackgroundTask | YYWebImageOptionProgressiveBlur | YYWebImageOptionNotBeCanceled progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                CGFloat progress = ((CGFloat)receivedSize)/((CGFloat)expectedSize);
                if (strongSelf.progressUpdateBlock) {
                    strongSelf.progressUpdateBlock(progress);
                }
            } transform:nil completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                if (image) {
                    __strong typeof(weakSelf) strongSelf = weakSelf;
                    strongSelf.underlyingImage = image;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [strongSelf imageLoadingComplete];
                    });
                }
            }];

        } else {
            // Failed - no source
            self.underlyingImage = nil;
            [self imageLoadingComplete];
        }
    }
}

- (void)unloadUnderlyingImage {
    _loadingInProgress = NO;

	if (self.underlyingImage && (_photoPath || _photoURL)) {
		self.underlyingImage = nil;
	}
}

- (id)shareImageContent
{
    if (self.underlyingImage) {
        NSData *data = [self.underlyingImage yy_imageDataRepresentation];
        return data;
    }else if (self.photoPath){
        return self.photoPath;
    }else{
        return self.photoURL;
    }
}

#pragma mark - Async Loading
// Called on main
- (void)imageLoadingComplete {
    NSAssert([[NSThread currentThread] isMainThread], @"This method must be called on the main thread.");
    // Complete so notify
    _loadingInProgress = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:IDMPhoto_LOADING_DID_END_NOTIFICATION
                                                        object:self];
}

@end
