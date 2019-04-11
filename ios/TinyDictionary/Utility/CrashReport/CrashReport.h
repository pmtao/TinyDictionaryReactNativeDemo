//
//  CrashReport.h
//  TinyDictionary
//
//  Created by Meler Paine on 2019/1/13.
//  Copyright © 2019 Sinking Soul. All rights reserved.
//

#ifndef SDFileToolClass_h
#define SDFileToolClass_h


#endif /* SDFileToolClass_h */

@interface CrashReport : NSObject

+ (BOOL)writeCrashFileOnDocumentsException:(NSDictionary *)exception;
+ (nullable NSArray *)getCrashLogs;
+ (nullable NSArray *)getCrashFileNames;
+ (nullable NSArray *)getCrashFileCreateTimes;
+ (BOOL)clearCrashLogs;

@end
