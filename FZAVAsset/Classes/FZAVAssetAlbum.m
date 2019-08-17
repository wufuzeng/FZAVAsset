//
//  FZAVAssetAlbum.m
//  FZAVAsset
//
//  Created by 吴福增 on 2019/8/16.
//

#import "FZAVAssetAlbum.h"
#import "FZAVAssetInfo.h"
@implementation FZAVAssetAlbum
/** 影集已存在 */
+ (BOOL)isAlbumExist:(NSString *)name{
    PHFetchResult* fetchResult = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    __block BOOL isExist = NO;
    [fetchResult enumerateObjectsUsingBlock:^(PHAssetCollection* assetCollection, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([assetCollection.localizedTitle isEqualToString:name]) {
            isExist = YES;
            *stop = YES;
        }
    }];
    return isExist;
}
/** 新建影集 */
+ (BOOL)createAlbum:(NSString *)name{
    if (![self isAlbumExist:name]) {
        NSError* error;
        [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
            [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:name];
        } error:&error];
        if (error) {
            return NO;
        }else{
            return YES;
        }
    }else{
        return YES;
    }
}

/**
 * 保存视频到指定相册
 *
 * @param videoUrl videoUrl
 * @param albumName albumName
 * @param block block
 */
+ (void)saveVideo:(NSString *)videoUrl
          toAlbum:(NSString *)albumName
       completion:(void (^)(NSURL* url, NSError* error))block{
    
    NSURL* url = [NSURL fileURLWithPath:videoUrl];
    
    AVAsset* asset = [AVAsset assetWithURL:url];
    [FZAVAssetInfo printMediaInfoWithAsset:asset];
    
    if ([self createAlbum:albumName]) {
        
        PHFetchResult *fetchResult = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
        
        [fetchResult enumerateObjectsUsingBlock:^(PHAssetCollection* assetCollection, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([assetCollection.localizedTitle isEqualToString:albumName]) {
                
                *stop = YES;
                
                NSError* saveVideoError = nil;
                [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
                    
                    PHAssetChangeRequest* assetReq =
                    [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:url];
                    
                    PHAssetCollectionChangeRequest* collectionReq =
                    [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
                    
                    PHObjectPlaceholder* placeHolder =
                    [assetReq placeholderForCreatedAsset];
                    
                    [collectionReq addAssets:@[placeHolder]];
                    
                } error:&saveVideoError];
                
                if (saveVideoError) {
                    if (block) {
                        block(nil, saveVideoError);
                    }
                }else {
                    if (block) {
                        block(url, nil);
                    }
                }
            }
        }];
    }
}



@end
