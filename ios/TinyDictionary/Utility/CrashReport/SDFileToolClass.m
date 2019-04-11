//
//  CrashReport.m
//  TinyDictionary
//
//  Created by Meler Paine on 2019/1/13.
//  Copyright © 2019 Sinking Soul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CrashReport.h"

// https://www.jianshu.com/p/09b6084bcd01
@implementation CrashReport

//写入缓存中: 以下提供三个API，分别是：写入，获取，清空
NSString * const SDCrashFileDirectory = @"SDMapHomeCrashFileDirectory"; //你的项目中自定义文件夹名

+ (NSString *)sd_getCachesPath{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
}

+ (BOOL)writeCrashFileOnDocumentsException:(NSDictionary *)exception{
    NSString *time = @"20190101120100";
//    [[NSDate date] formattedDateWithFormat:@"yyyyMMddHHmmss" locale:[NSLocale currentLocale]];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *crashname = [NSString stringWithFormat:@"%@_%@Crashlog.plist",time,infoDictionary[@"CFBundleName"]];
    NSString *crashPath = [[self sd_getCachesPath] stringByAppendingPathComponent:SDCrashFileDirectory];
    NSFileManager *manager = [NSFileManager defaultManager];
    //设备信息
    NSMutableDictionary *deviceInfos = [NSMutableDictionary dictionary];
    [deviceInfos setObject:[infoDictionary objectForKey:@"DTPlatformVersion"] forKey:@"DTPlatformVersion"];
    [deviceInfos setObject:[infoDictionary objectForKey:@"CFBundleShortVersionString"] forKey:@"CFBundleShortVersionString"];
    [deviceInfos setObject:[infoDictionary objectForKey:@"UIRequiredDeviceCapabilities"] forKey:@"UIRequiredDeviceCapabilities"];
    
    BOOL isSuccess = [manager createDirectoryAtPath:crashPath withIntermediateDirectories:YES attributes:nil error:nil];
    if (isSuccess) {
        NSLog(@"文件夹创建成功");
        NSString *filepath = [crashPath stringByAppendingPathComponent:crashname];
        NSMutableDictionary *logs = [NSMutableDictionary dictionaryWithContentsOfFile:filepath];
        if (!logs) {
            logs = [[NSMutableDictionary alloc] init];
        }
        //日志信息
        NSDictionary *infos = @{@"Exception":exception,@"DeviceInfo":deviceInfos};
        [logs setObject:infos forKey:[NSString stringWithFormat:@"%@_crashLogs",infoDictionary[@"CFBundleName"]]];
        BOOL writeOK = [logs writeToFile:filepath atomically:YES];
        NSLog(@"write result = %d,filePath = %@",writeOK,filepath);
        return writeOK;
    }else{
        return NO;
    }
}

+ (nullable NSArray *)sd_getCrashLogs{
    NSString *crashPath = [[self sd_getCachesPath] stringByAppendingPathComponent:SDCrashFileDirectory];
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *array = [manager contentsOfDirectoryAtPath:crashPath error:nil];
    NSMutableArray *result = [NSMutableArray array];
    if (array.count == 0) return nil;
    for (NSString *name in array) {
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[crashPath stringByAppendingPathComponent:name]];
        [result addObject:dict];
    }
    return result;
}

+ (BOOL)sd_clearCrashLogs{
    NSString *crashPath = [[self sd_getCachesPath] stringByAppendingPathComponent:SDCrashFileDirectory];
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:crashPath]) return YES; //如果不存在,则默认为删除成功
    NSArray *contents = [manager contentsOfDirectoryAtPath:crashPath error:NULL];
    if (contents.count == 0) return YES;
    NSEnumerator *enums = [contents objectEnumerator];
    NSString *filename;
    BOOL success = YES;
    while (filename = [enums nextObject]) {
        if(![manager removeItemAtPath:[crashPath stringByAppendingPathComponent:filename] error:NULL]){
            success = NO;
            break;
        }
    }
    return success;
}

@end
