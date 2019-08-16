//
//  FZAVAssetInfo.m
//  FZAVAsset
//
//  Created by 吴福增 on 2019/8/16.
//

#import "FZAVAssetInfo.h"

@implementation FZAVAssetInfo

/**
 * 视频的旋转角度
 *
 * @param asset 视频
 * @return 角度
 */
+(NSUInteger)degressFromVideoFileWithAsset:(AVAsset *)asset {
    NSUInteger degress = 0;
    NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    if([tracks count] > 0) {
        AVAssetTrack *videoTrack = [tracks objectAtIndex:0];
        CGAffineTransform t = videoTrack.preferredTransform;
        if(t.a == 0 && t.b == 1.0 && t.c == -1.0 && t.d == 0){
            // Portrait
            degress = 90;
        }else if(t.a == 0 && t.b == -1.0 && t.c == 1.0 && t.d == 0){
            // PortraitUpsideDown
            degress = 270;
        }else if(t.a == 1.0 && t.b == 0 && t.c == 0 && t.d == 1.0){
            // LandscapeRight
            degress = 0;
        }else if(t.a == -1.0 && t.b == 0 && t.c == 0 && t.d == -1.0){
            // LandscapeLeft
            degress = 180;
        }
    }
    return degress;
}



/** 输出媒体信息 */
+(void)printMediaInfoWithAsset:(AVAsset*)asset{
    
    AVAssetTrack *assetVideoTrack = nil;
    AVAssetTrack *assetAudioTrack = nil;
    
    if ([[asset tracksWithMediaType:AVMediaTypeVideo] count] != 0) {
        assetVideoTrack = [asset tracksWithMediaType:AVMediaTypeVideo][0];
    }
    if ([[asset tracksWithMediaType:AVMediaTypeAudio] count] != 0) {
        assetAudioTrack = [asset tracksWithMediaType:AVMediaTypeAudio][0];
    }
    
    FZAVAssetInfo* info = [[FZAVAssetInfo alloc] init];
    info.videoWidth         = assetVideoTrack.naturalSize.width;
    info.videoHeight        = assetVideoTrack.naturalSize.height;
    info.videoFrameRate     = assetVideoTrack.nominalFrameRate;
    info.videoOutputBitrate = assetVideoTrack.estimatedDataRate;
    info.videoDuration      = assetVideoTrack.timeRange.duration;
    info.videoByte          = assetVideoTrack.totalSampleDataLength + assetAudioTrack.totalSampleDataLength;
    
    CGAffineTransform t = assetVideoTrack.preferredTransform;
    FZVideoOrientation orientation = FZVideoOrientationPortrait;
    
    if(t.a == 0 && t.b == 1.0 && t.c == -1.0 && t.d == 0){
        orientation = FZVideoOrientationPortraitUpsideDown;
    }else if(t.a == 0 && t.b == -1.0 && t.c == 1.0 && t.d == 0){
        orientation = FZVideoOrientationLandscapeRight;
    }else if(t.a == 1.0 && t.b == 0 && t.c == 0 && t.d == 1.0){
        orientation = FZVideoOrientationPortrait;
    }else if(t.a == -1.0 && t.b == 0 && t.c == 0 && t.d == -1.0){
        orientation = FZVideoOrientationLandscapeLeft;
    }
    info.videoOrientation = orientation;
    
    NSLog(@"______%@",info);
}



-(NSString *)description{
    
    NSString* descriptions = [NSString stringWithFormat:@"\n videoWidth = %f \n videoHeight = %f \n videoFrameRate = %f \n videoOutputBitrate = %f \n videoOrientation = %lu \n videoDuration = %lld \n videoByte = %lld \n",self.videoWidth,self.videoHeight,self.videoFrameRate,self.videoOutputBitrate,(unsigned long)self.videoOrientation,self.videoDuration.value/self.videoDuration.timescale,self.videoByte];
    return descriptions;
}

@end
