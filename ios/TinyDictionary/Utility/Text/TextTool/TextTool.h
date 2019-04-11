//
//  TextTool.h
//  TinyDictionary
//
//  Created by Meler Paine on 2019/1/17.
//  Copyright © 2019 Sinking Soul. All rights reserved.
//

@interface TextTool : NSObject

+ (NSString *)decideTextLanguage:(NSString *)text;
+ (void)readText:(NSString *)text;
+ (NSArray *)getTypeSuggestionAfterText:(NSString *)text;

@end
