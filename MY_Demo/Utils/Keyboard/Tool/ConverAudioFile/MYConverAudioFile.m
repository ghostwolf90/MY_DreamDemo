//
//  MYConverAudioFile.m
//  MY_Demo
//
//  Created by magic on 2018/10/28.
//  Copyright © 2018 magic. All rights reserved.
//

#import "MYConverAudioFile.h"
#import <lame/lame.h>
@interface MYConverAudioFile ()

@property (nonatomic, assign) BOOL stopRecord;
@property (nonatomic, assign) BOOL cancelRecord;
    
@end

static MYConverAudioFile *_instance = nil;

@implementation MYConverAudioFile
    
+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[MYConverAudioFile alloc] init];
    });
    return _instance;
}
    
    
- (void)conventToMp3WithCafFilePath:(NSString *)cafFilePath mp3FilePath:(NSString *)mp3FilePath sampleRate:(int)sampleRate callback:(void(^)(MYConverAudioFileResult *result))callback {
    self.cancelRecord = NO;
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        weakself.stopRecord = NO;
        MYConverAudioFileResult *result = [[MYConverAudioFileResult alloc]init];
        result.resultPath = mp3FilePath;
        result.cafPath = cafFilePath;
        @try {
            
            int read, write;
            
            FILE *pcm = fopen([cafFilePath cStringUsingEncoding:NSASCIIStringEncoding], "rb");
            FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:NSASCIIStringEncoding], "wb+");
            
            const int PCM_SIZE = 8192;
            const int MP3_SIZE = 8192;
            short int pcm_buffer[PCM_SIZE * 2];
            unsigned char mp3_buffer[MP3_SIZE];
            
            lame_t lame = lame_init();
            lame_set_in_samplerate(lame, sampleRate);
            lame_set_VBR(lame, vbr_default);
            lame_init_params(lame);
            
            long curpos;
            BOOL isSkipPCMHeader = NO;
            
            do {
                if (pcm == NULL) {
                    return ;
                }
                curpos = ftell(pcm);
                long startPos = ftell(pcm);
                fseek(pcm, 0, SEEK_END);
                long endPos = ftell(pcm);
                long length = endPos - startPos;
                fseek(pcm, curpos, SEEK_SET);
                
                if (length > PCM_SIZE * 2 * sizeof(short int)) {
                    
                    if (!isSkipPCMHeader) {
                        //Uump audio file header, If you do not skip file header
                        //you will heard some noise at the beginning!!!
                        fseek(pcm, 4 * 1024, SEEK_CUR);
                        isSkipPCMHeader = YES;
                        
                    }
                    
                    read = (int)fread(pcm_buffer, 2 * sizeof(short int), PCM_SIZE, pcm);
                    write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
                    fwrite(mp3_buffer, write, 1, mp3);
                    
                } else {
                    [NSThread sleepForTimeInterval:0.05];
                    
                }
                
            } while (! weakself.stopRecord);
            
            read = (int)fread(pcm_buffer, 2 * sizeof(short int), PCM_SIZE, pcm);
            write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            
            lame_mp3_tags_fid(lame, mp3);
            
            lame_close(lame);
            fclose(mp3);
            fclose(pcm);
        }
        @catch (NSException *exception) {
            if (callback) {
                
                result.isCancel = NO;
                result.isSuccess = NO;
                callback(result);
            }
        }
        @finally {
            if (self.cancelRecord) {
                if (callback) {
                    
                    result.isCancel = YES;
                    result.isSuccess = NO;
                    callback(result);
                }
            }else{
                if (callback) {
                    
                    result.isCancel = NO;
                    result.isSuccess = YES;
                    callback(result);
                }
            }
            
        }
    });
    
}
    
    /**
     send end record signal
     */
- (void)sendEndRecord {
    self.stopRecord = YES;
}
    
- (void)cancelSendEndRecord{
    self.stopRecord = YES;
    self.cancelRecord = YES;
}
    

@end
