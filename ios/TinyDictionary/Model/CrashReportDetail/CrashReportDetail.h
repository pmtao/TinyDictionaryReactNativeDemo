//
//  CrashReportDetail.h
//  TinyDictionary
//
//  Created by Meler Paine on 2019/1/15.
//  Copyright © 2019 Sinking Soul. All rights reserved.
//

#ifndef CrashReportDetail_h
#define CrashReportDetail_h


#endif /* CrashReportDetail_h */
#import "CardsProtocol.h"
#import "CardsViewController.h"

@interface CrashReportDetail : NSObject <CardsDataSource>

@property (nonatomic, copy) NSString *cardsTotalTitle;
@property (nonatomic, copy) NSString *detail;


- (instancetype)initWithTitle:(NSString *)title Detail:(NSString *)detail;

@end
