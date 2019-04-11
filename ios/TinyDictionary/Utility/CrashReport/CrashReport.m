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
NSString * const TDCrashFileDirectory = @"TinyDictionaryCrashFileDirectory"; //你的项目中自定义文件夹名

+ (NSString *)getCachesPath {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
}

+ (BOOL)writeCrashFileOnDocumentsException:(NSDictionary *)exception {
    NSString *time = [self getFormatedDateString];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *crashname = [NSString stringWithFormat:@"%@_%@Crashlog.plist",time,infoDictionary[@"CFBundleName"]];
    NSString *crashPath = [[self getCachesPath] stringByAppendingPathComponent:TDCrashFileDirectory];
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

+ (nullable NSArray *)getCrashLogs {
    NSString *crashPath = [[self getCachesPath] stringByAppendingPathComponent:TDCrashFileDirectory];
    NSArray *array = [self getCrashFileNames];
    NSMutableArray *result = [NSMutableArray array];
    if (array.count == 0) return nil;
    for (NSString *name in array) {
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[crashPath stringByAppendingPathComponent:name]];
        [result addObject:dict];
    }
    return result;
}

+ (nullable NSArray *)getCrashFileNames {
    NSString *crashPath = [[self getCachesPath] stringByAppendingPathComponent:TDCrashFileDirectory];
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *array = [manager contentsOfDirectoryAtPath:crashPath error:nil];
    if (array.count == 0) return nil;
    return array;
}

+ (nullable NSArray *)getCrashFileCreateTimes {
    NSArray<NSString *> *array = [self getCrashFileNames];
    if (array.count == 0) return nil;
    NSMutableArray *result = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(NSString * _Nonnull name, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *time = [name substringWithRange:NSMakeRange(0, 14)];
        [result addObject:[[NSString alloc] initWithFormat:@"%@-%@-%@-%@",
                           [time substringWithRange:NSMakeRange(0, 4)],
                           [time substringWithRange:NSMakeRange(4, 4)],
                           [time substringWithRange:NSMakeRange(8, 4)],
                           [time substringWithRange:NSMakeRange(12, 2)]
                           ]];
    }];
    return result;
}

+ (BOOL)clearCrashLogs {
    NSString *crashPath = [[self getCachesPath] stringByAppendingPathComponent:TDCrashFileDirectory];
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:crashPath]) return NO; //如果不存在,则默认为删除成功
    NSArray *contents = [manager contentsOfDirectoryAtPath:crashPath error:NULL];
    if (contents.count == 0) return NO;
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

+ (NSString *)getFormatedDateString {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyyMMddHHmmss";
    format.locale = [NSLocale currentLocale];
    NSString *time = [format stringFromDate:[NSDate date]];
    return time;
}

@end
