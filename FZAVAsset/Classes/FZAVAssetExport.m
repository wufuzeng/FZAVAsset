//
//  FZAVAssetExport.m
//  FZAVAsset
//
//  Created by 吴福增 on 2019/8/16.
//

/**
 * 为一个视频添加边框、水印和动画:
 * 首先说明的是，这种边框和动画并不能直接修改视频的某一帧给他增加边框或者产生动画效果，
 * 这种动画更像是给视频的上面加一个Calayer，然后控制这个layer产生动画效果。
 * 因为具体到某一帧的这种操作不是iphone应该做的他也做不到。
 *
 * video增加动画的动画层原理:
 * AVVideoCompositionCoreAnimationTool
 *            ↓
 *        parentLayer
 *        ↓        ↓
 * videoLayer     animationLayer
 *
 * videoLayer这个东西，其实这个layer就是负责显示我们的视频，
 * 和他同级的是一个叫animationLayer的东西，
 * 我们能够掌控并且玩出花样的其实是这个叫animationLayer的东西，
 * 因为这个animationLayer可以由我们自己创建。
 */

#import "FZAVAssetExport.h"
#import "FZAVAssetAlbum.h"
@implementation FZAVAssetExport



/**
 * 导出视频中的音频
 *
 * @param videoAsset 视频
 * @param outPath xxx/xxx/xxx/xxx
 * @param completedHandler completedHandler
 */
+(void)exportAudioWithAsset:(AVAsset *)videoAsset
                   clipping:(CMTimeRange)timeRange
                    outPath:(NSString *)outPath
           completedHandler:(void(^)(NSString *path))completedHandler{
    //输出文件夹
    NSString *dirPath = [outPath stringByDeletingLastPathComponent];
    NSString *filePath = [outPath stringByAppendingPathExtension:@"m4a"];
    //新建文件夹
    [[NSFileManager defaultManager] createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
    //移除旧文件
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    //其中presetName这个参数,必须文件的后缀和这里设定的格式相互呼应才行,否则文件无法创建
    AVAssetExportSession *exportSession =
    [[AVAssetExportSession alloc]initWithAsset:videoAsset
                                    presetName:AVAssetExportPresetAppleM4A];
    exportSession.outputURL = [NSURL fileURLWithPath:filePath];
    exportSession.outputFileType = AVFileTypeAppleM4A;
    exportSession.timeRange = timeRange;
    //是否优化,属于可选,但是一般都选择YES
    exportSession.shouldOptimizeForNetworkUse = YES;
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        switch (exportSession.status) {
            case AVAssetExportSessionStatusUnknown :{
                
            } break;
            case AVAssetExportSessionStatusWaiting :{
                
            } break;
            case AVAssetExportSessionStatusExporting :{
                NSLog(@"当前压缩进度:%f",exportSession.progress);
            } break;
            case AVAssetExportSessionStatusCompleted :{
                [FZAVAssetAlbum saveVideo:dirPath toAlbum:@"Album" completion:^(NSURL *url, NSError *error) {
                    if (error) {
                        NSLog(@"save to album failed");
                    }else{
                        NSLog(@"save to album success");
                    }
                }];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completedHandler) {
                        completedHandler(exportSession.outputURL.relativePath);
                    }
                });
            } break;
            case AVAssetExportSessionStatusFailed :{
                NSLog(@"导出失败");
            } break;
            case AVAssetExportSessionStatusCancelled :{
                
            } break;
            default: break;
        }
    }];
}

/**
 * 导出裁剪视频
 *
 * @param asset asset
 * @param presetName AVAssetExportPresetxxxx
 * @param outPath xxx/xxx/xxx/xxx
 * @param completedHandler completedHandler
 */
+(void)exportVideoWithAsset:(AVAsset *)asset
                 presetName:(NSString *)presetName
                   clipping:(CMTimeRange)timeRange
                    outPath:(NSString *)outPath
           completedHandler:(void(^)(NSString *path))completedHandler{
    //输出文件夹
    NSString *dirPath = [outPath stringByDeletingLastPathComponent];
    NSString *filePath = [outPath stringByAppendingPathExtension:@"mp4"];
    //新建文件夹
    [[NSFileManager defaultManager] createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
    //移除旧文件
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    
    AVAssetExportSession *exportSession =
    [[AVAssetExportSession alloc]initWithAsset:asset
                                    presetName:presetName];
    exportSession.outputURL = [NSURL fileURLWithPath:filePath];
    exportSession.outputFileType = AVFileTypeMPEG4;
    exportSession.timeRange = timeRange;
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        switch (exportSession.status) {
            case AVAssetExportSessionStatusUnknown :{
                
            } break;
            case AVAssetExportSessionStatusWaiting :{
                
            } break;
            case AVAssetExportSessionStatusExporting :{
                NSLog(@"当前压缩进度:%f",exportSession.progress);
            } break;
            case AVAssetExportSessionStatusCompleted :{
                [FZAVAssetAlbum saveVideo:dirPath toAlbum:@"Album" completion:^(NSURL *url, NSError *error) {
                    if (error) {
                        NSLog(@"save to album failed");
                    }else{
                        NSLog(@"save to album success");
                    }
                }];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completedHandler) {
                        completedHandler(exportSession.outputURL.relativePath);
                    }
                });
            } break;
            case AVAssetExportSessionStatusFailed :{
                NSLog(@"导出失败");
            } break;
            case AVAssetExportSessionStatusCancelled :{
                
            } break;
            default: break;
        }
    }];
}

/**
 * 导出视频
 *
 * @param asset asset
 * @param presetName AVAssetExportPresetxxxx
 * @param outPath xxx/xxx/xxx/xxx
 * @param completedHandler completedHandler
 */
+(void)exportVideoWithAsset:(AVAsset *)asset
                 presetName:(NSString *)presetName
                    outPath:(NSString *)outPath
           completedHandler:(void(^)(NSString *path))completedHandler{
    [self exportVideoWithAsset:asset presetName:presetName clipping:CMTimeRangeMake(kCMTimeZero, asset.duration) outPath:outPath completedHandler:completedHandler];
}

/**
 * 导出合成视频
 *
 * @param paths 待合成视频路径数组
 * @param outPath 输出路径
 */
+(void)exportCompositeVideoWithPaths:(NSArray *)paths
                             outPath:(NSString *)outPath
                    completedHandler:(void(^)(NSString *path))completedHandler {
    //工程文件
    AVMutableComposition *composition = [AVMutableComposition composition];
    //音频
    AVMutableCompositionTrack *audioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    //视频
    AVMutableCompositionTrack *videoTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    CMTime totalDuration = kCMTimeZero;
    for (int i = 0; i < paths.count; i ++) {
        NSURL *url = [NSURL fileURLWithPath:paths[i]];
        NSDictionary* options = @{
                                  /** 提供更精确的时长和计时信息 */
                                  AVURLAssetPreferPreciseDurationAndTimingKey:@(YES)
                                  };
        AVAsset *asset = [AVURLAsset URLAssetWithURL:url options:options];
        
        //获取asset中的音频
        NSArray *audioArray = [asset tracksWithMediaType:AVMediaTypeAudio];
        AVAssetTrack *assetAudio = audioArray.firstObject;
        
        //向audioTrack中加入音频
        NSError *audioError = nil;
        BOOL isComplete_audio =
        [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                            ofTrack:assetAudio
                             atTime:totalDuration
                              error:&audioError];
        NSLog(@"加入音频%d  isComplete_audio：%d error：%@", i, isComplete_audio, audioError);
        
        //获取asset中的视频
        NSArray *videoArray = [asset tracksWithMediaType:AVMediaTypeVideo];
        AVAssetTrack *assetVideo = videoArray.firstObject;
        
        //向videoTrack中加入视频
        NSError *videoError = nil;
        BOOL isComplete_video =
        [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                            ofTrack:assetVideo
                             atTime:totalDuration
                              error:&videoError];
        NSLog(@"加入视频%d  isComplete_video：%d error：%@", i, isComplete_video, videoError);
        
        totalDuration = CMTimeAdd(totalDuration, asset.duration);
    }
    //这里可以加水印的，但在这里不做水印处理
    
    //视频导出处理
    [FZAVAssetExport exportVideoWithAsset:composition presetName:AVAssetExportPreset1280x720 outPath:outPath completedHandler:completedHandler];
}


/**
 * 导出合成水印视频
 *
 * @param asset  视频
 * @param outPath 输出路径
 */
+(void)exportWatermarkVideoWithAsset:(AVAsset *)asset
                          presetName:(NSString *)presetName
                             outPath:(NSString *)outPath
                    completedHandler:(void(^)(NSString *path))completedHandler {
    //工程文件
    AVMutableComposition *composition = [AVMutableComposition composition];
    //音频
    AVMutableCompositionTrack *audioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    //视频
    AVMutableCompositionTrack *videoTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    CMTime totalDuration = CMTimeAdd(kCMTimeZero, asset.duration);;
    
    {
        //获取asset中的音频
        NSArray *audioArray = [asset tracksWithMediaType:AVMediaTypeAudio];
        AVAssetTrack *assetAudio = audioArray.firstObject;
        
        //向audioTrack中加入音频
        NSError *audioError = nil;
        BOOL isComplete_audio =
        [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                            ofTrack:assetAudio
                             atTime:totalDuration
                              error:&audioError];
        NSLog(@"加入音频  isComplete_audio：%d error：%@", isComplete_audio, audioError);
    }
    
    {
        //获取asset中的视频
        NSArray *videoArray = [asset tracksWithMediaType:AVMediaTypeVideo];
        AVAssetTrack *assetVideo = videoArray.firstObject;
        
        //向videoTrack中加入视频
        NSError *videoError = nil;
        BOOL isComplete_video =
        [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                            ofTrack:assetVideo
                             atTime:totalDuration
                              error:&videoError];
        NSLog(@"加入视频  isComplete_video：%d error：%@", isComplete_video, videoError);
    }
    //视频工程
    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
    {
        //添加水印的
        if ([composition tracksWithMediaType:AVMediaTypeVideo].count) {
            
            //获取asset中的视频
            NSArray *videoArray = [asset tracksWithMediaType:AVMediaTypeVideo];
            AVAssetTrack *assetVideo = videoArray.firstObject;
            
            // build a pass through video composition
            // 构建一个通过视频合成的通道
            //AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
            videoComposition.frameDuration = CMTimeMake(1, 30); // 30 fps
            videoComposition.renderSize = assetVideo.naturalSize;
            
            AVAssetTrack *videoTrack = [[composition tracksWithMediaType:AVMediaTypeVideo] firstObject];
            //图层指令
            AVMutableVideoCompositionLayerInstruction *passThroughLayer =
            [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
            //工程指令
            AVMutableVideoCompositionInstruction *passThroughInstruction =
            [AVMutableVideoCompositionInstruction videoCompositionInstruction];
            passThroughInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, [composition duration]);
            passThroughInstruction.layerInstructions = @[passThroughLayer];
            
            videoComposition.instructions = @[passThroughInstruction];
            
            CGSize videoSize = videoComposition.renderSize;
            videoComposition.animationTool = [self watermarkWithFrame:CGRectMake(0, 0, 100, 30) renderSize:videoSize image:nil text:@"水印"];
        }
    }
    //音频工程
    AVMutableAudioMix *audioMix = [AVMutableAudioMix audioMix];
    {
        if ([composition tracksWithMediaType:AVMediaTypeAudio].count) {
            
            //获取asset中的视频
            NSArray *audioArray = [asset tracksWithMediaType:AVMediaTypeAudio];
            AVAssetTrack *assetAudio = audioArray.firstObject;
            
            AVMutableAudioMixInputParameters* mixParameters =
            [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:assetAudio];
            [mixParameters setVolumeRampFromStartVolume:1
                                            toEndVolume:0
                                              timeRange:CMTimeRangeMake(kCMTimeZero, composition.duration)];
            
            audioMix.inputParameters = @[mixParameters];
        }
    }
    
    
    
    //输出文件夹
    NSString *dirPath = [outPath stringByDeletingLastPathComponent];
    NSString *filePath = [outPath stringByAppendingPathExtension:@"mp4"];
    //新建文件夹
    [[NSFileManager defaultManager] createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
    //移除旧文件
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    
    AVAssetExportSession *exportSession =
    [[AVAssetExportSession alloc]initWithAsset:asset
                                    presetName:presetName];
    exportSession.outputURL = [NSURL fileURLWithPath:filePath];
    exportSession.outputFileType = AVFileTypeMPEG4;
    exportSession.videoComposition = videoComposition;//视频工程文件(添加水印)
    exportSession.audioMix = audioMix;
    //exportSession.timeRange = timeRange;
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        switch (exportSession.status) {
            case AVAssetExportSessionStatusUnknown :{
                
            } break;
            case AVAssetExportSessionStatusWaiting :{
                
            } break;
            case AVAssetExportSessionStatusExporting :{
                NSLog(@"当前压缩进度:%f",exportSession.progress);
            } break;
            case AVAssetExportSessionStatusCompleted :{
                [FZAVAssetAlbum saveVideo:dirPath toAlbum:@"Album" completion:^(NSURL *url, NSError *error) {
                    if (error) {
                        NSLog(@"save to album failed");
                    }else{
                        NSLog(@"save to album success");
                    }
                }];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completedHandler) {
                        completedHandler(exportSession.outputURL.relativePath);
                    }
                });
            } break;
            case AVAssetExportSessionStatusFailed :{
                NSLog(@"导出失败");
            } break;
            case AVAssetExportSessionStatusCancelled :{
                
            } break;
            default: break;
        }
    }];
    
    
}

/**
 * 导出合成视频配音视频
 *
 * @param videoAsset 视频
 * @param audioAsset 音频
 * @param outPath 输出路径
 */
+(void)exportVideo:(AVAsset *)videoAsset
           dubbing:(AVAsset *)audioAsset
           outPath:(NSString *)outPath
  completedHandler:(void(^)(NSString *path))completedHandler{
    
    //工程文件
    AVMutableComposition *composition = [AVMutableComposition composition];
    //音轨工程文件
    AVMutableCompositionTrack *audioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    //视轨工程文件
    AVMutableCompositionTrack *videoTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    //视频时间范围（合成的音乐不能超过这个时间范围）
    CMTimeRange videoTimeRange = CMTimeRangeMake(kCMTimeZero, videoAsset.duration);
    
    //采集视频
    NSArray *videoArray = [videoAsset tracksWithMediaType:AVMediaTypeVideo];
    AVAssetTrack *assetVideo = videoArray.firstObject;
    //设置变形
    [videoTrack setPreferredTransform:assetVideo.preferredTransform];
    
    //采集的视频加入到视频通道工程文件
    /**
     * 依次加入每个asset
     *
     * param TimeRange 加入的asset持续时间
     * param Track 加入的asset类型,这里都是video
     * param Time 从哪个时间点加入asset,这里用了CMTime下面的CMTimeMakeWithSeconds(tmpDuration, 0),timesacle为0
     */
    NSError *videoError = nil;
    BOOL isComplete_video = [videoTrack insertTimeRange:videoTimeRange
                                                ofTrack:assetVideo
                                                 atTime:kCMTimeZero
                                                  error:&videoError];
    NSLog(@"加入视频isComplete_video：%d error：%@",isComplete_video,videoError);
    
    //采集音频
    NSArray *audioArray = [audioAsset tracksWithMediaType:AVMediaTypeAudio];
    AVAssetTrack *assetAudio = audioArray.firstObject;
    
    //音频的范围
    CMTimeRange audioTimeRange = CMTimeRangeMake(kCMTimeZero,audioAsset.duration);
    
    if (CMTimeCompare(audioAsset.duration, videoAsset.duration)) {
        //当音频时间大于视频时间
        audioTimeRange = CMTimeRangeMake(kCMTimeZero, videoAsset.duration);
    }
    
    //采集的音频加入到音频通道工程文件
    NSError *audioError = nil;
    BOOL isComplete_audio = [audioTrack insertTimeRange:audioTimeRange
                                                ofTrack:assetAudio
                                                 atTime:kCMTimeZero
                                                  error:&audioError];
    NSLog(@"加入音频isComplete_audio：%d error：%@",isComplete_audio, audioError);
    
    //因为要保存相册，所以设置高质量, 这里可以根据实际情况进行更改
    //视频导出处理
    [FZAVAssetExport exportVideoWithAsset:composition presetName:AVAssetExportPresetHighestQuality outPath:outPath completedHandler:completedHandler];
    
}

/**
 * 导出添加背景音乐视频
 *
 * @param videoAsset 视频
 * @param audioAsset 音频
 * @param outPath 输出路径
 */
+(void)exportVideo:(AVAsset *)videoAsset
        background:(AVAsset *)audioAsset
           outPath:(NSString *)outPath
  completedHandler:(void(^)(NSString *path))completedHandler{
    
    //工程文件
    AVMutableComposition *composition = [AVMutableComposition composition];
    //音轨工程文件
    AVMutableCompositionTrack *audioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    //视轨工程文件
    AVMutableCompositionTrack *videoTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    //视频时间范围（合成的音乐不能超过这个时间范围）
    CMTimeRange videoTimeRange = CMTimeRangeMake(kCMTimeZero, videoAsset.duration);
    
    //采集视频
    NSArray *videoArray = [videoAsset tracksWithMediaType:AVMediaTypeVideo];
    AVAssetTrack *assetVideo = videoArray.firstObject;
    //设置变形
    [videoTrack setPreferredTransform:assetVideo.preferredTransform];
    
    {
        //采集的视频加入到视频通道工程文件
        /**
         * 依次加入每个asset
         *
         * param TimeRange 加入的asset持续时间
         * param Track 加入的asset类型,这里都是video
         * param Time 从哪个时间点加入asset,这里用了CMTime下面的CMTimeMakeWithSeconds(tmpDuration, 0),timesacle为0
         */
        NSError *videoError = nil;
        BOOL isComplete_video = [videoTrack insertTimeRange:videoTimeRange
                                                    ofTrack:assetVideo
                                                     atTime:kCMTimeZero
                                                      error:&videoError];
        NSLog(@"加入视频isComplete_video：%d error：%@",isComplete_video,videoError);
    }
    
    {
        //采集音频
        NSArray *audioArray = [videoAsset tracksWithMediaType:AVMediaTypeAudio];
        AVAssetTrack *assetAudio = audioArray.firstObject;
        
        //采集的音频加入到音频通道工程文件
        NSError *audioError = nil;
        BOOL isComplete_audio = [audioTrack insertTimeRange:videoTimeRange
                                                    ofTrack:assetAudio
                                                     atTime:kCMTimeZero
                                                      error:&audioError];
        NSLog(@"加入音频isComplete_audio：%d error：%@",isComplete_audio, audioError);
    }
    
    {
        //采集背景音频
        NSArray *bgAudioArray = [audioAsset tracksWithMediaType:AVMediaTypeAudio];
        AVAssetTrack *bgAssetAudio = bgAudioArray.firstObject;
        //音频的范围
        CMTimeRange bgAudioTimeRange = CMTimeRangeMake(kCMTimeZero,audioAsset.duration);
        
        if (CMTimeCompare(audioAsset.duration, videoAsset.duration)) {
            //当音频时间大于视频时间
            bgAudioTimeRange = CMTimeRangeMake(kCMTimeZero, videoAsset.duration);
        }
        
        //采集的音频加入到音频通道工程文件
        NSError *bgAudioError = nil;
        BOOL isComplete_bg_audio = [audioTrack insertTimeRange:bgAudioTimeRange
                                                       ofTrack:bgAssetAudio
                                                        atTime:kCMTimeZero
                                                         error:&bgAudioError];
        NSLog(@"加入背景音频isComplete_audio：%d error：%@",isComplete_bg_audio, bgAudioError);
        
    }
    //因为要保存相册，所以设置高质量, 这里可以根据实际情况进行更改
    //视频导出处理
    [FZAVAssetExport exportVideoWithAsset:composition presetName:AVAssetExportPresetHighestQuality outPath:outPath completedHandler:completedHandler];
    
}


/**
 * @param frame 水印层frame
 * @param renderSize 视频层大小
 * @param image 水印图片
 * @param text 水印文字
 */
+(AVVideoCompositionCoreAnimationTool *)watermarkWithFrame:(CGRect)frame
                                                renderSize:(CGSize)renderSize
                                                     image:(UIImage *)image
                                                      text:(NSString *)text {
    //parentLayer
    CALayer *parentLayer = [CALayer layer];
    parentLayer.frame = CGRectMake(0, 0, renderSize.width, renderSize.height);
    //videoLayer
    CALayer *videoLayer = [CALayer layer];
    videoLayer.frame = CGRectMake(0, 0, renderSize.width, renderSize.height);
    [parentLayer addSublayer:videoLayer];
    //watermarkLayer
    CALayer* watermarkLayer = [CALayer layer];
    watermarkLayer.frame = frame;
    [parentLayer addSublayer:watermarkLayer];
    if (image) {
        //CFBridgingRelease把非OC的指针指向OC并且转换成ARC。
        watermarkLayer.contents = CFBridgingRelease(image.CGImage);
    }
    if (text) {
        // 文字水印
        CATextLayer *textLayer = [CATextLayer layer];
        textLayer.backgroundColor = [UIColor blueColor].CGColor;//背景颜色
        textLayer.string = text;
        textLayer.foregroundColor = [[UIColor whiteColor] CGColor];//文字颜色
        textLayer.shadowOpacity = 0.5;
        textLayer.alignmentMode = kCAAlignmentCenter;
        textLayer.frame = frame;
        [watermarkLayer addSublayer:textLayer];
    }
    
    return [AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
}





@end
