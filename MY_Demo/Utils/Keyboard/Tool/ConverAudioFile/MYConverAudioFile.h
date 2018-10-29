//
//  MYConverAudioFile.h
//  MY_Demo
//
//  Created by magic on 2018/10/28.
//  Copyright © 2018 magic. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class MYConverAudioFileResult;
@interface MYConverAudioFile : NSObject

+ (instancetype)sharedInstance;

- (void)conventToMp3WithCafFilePath:(NSString *)cafFilePath
                        mp3FilePath:(NSString *)mp3FilePath
                         sampleRate:(int)sampleRate
                           callback:(void(^)(MYConverAudioFileResult *result))callback;
- (void)sendEndRecord;

- (void)cancelSendEndRecord;

@end


@interface MYConverAudioFileResult : NSObject

/** 储存的本地路径*/
@property (nonatomic, copy) NSString *resultPath;
/** caf路径*/
@property (nonatomic,copy) NSString *cafPath;
/** 是否取消*/
@property (nonatomic, assign) BOOL isCancel;
/** 是否转化失败*/
@property (nonatomic, assign) BOOL isSuccess;

@end

NS_ASSUME_NONNULL_END
