//
//  TextTool.m
//  TinyDictionary
//
//  Created by Meler Paine on 2019/1/17.
//  Copyright © 2019 Sinking Soul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NaturalLanguage/NaturalLanguage.h>
#import <Speech/Speech.h>
#import "TextTool.h"

@implementation TextTool

+ (NSString *)decideTextLanguage:(NSString *)text {
    if (@available(iOS 12.0, *)) {
        NLLanguageRecognizer * recog = [NLLanguageRecognizer new];
        [recog processString:text];
        return recog.dominantLanguage;
    } else {
        NSLinguisticTagger *tagger = [[NSLinguisticTagger alloc] initWithTagSchemes:@[NSLinguisticTagSchemeLanguage] options:0];
        tagger.string = text;
        NSString *tag = [tagger tagAtIndex:0 scheme:NSLinguisticTagSchemeLanguage tokenRange:nil sentenceRange:nil];
        return tag;
    }
}

+ (void)readText:(NSString *)text {
    NSString *textLanguage = [TextTool decideTextLanguage:text];
    
    NSArray<AVSpeechSynthesisVoice *> *voices = [AVSpeechSynthesisVoice speechVoices];
    AVSpeechSynthesizer *syntesizer = [AVSpeechSynthesizer new];
    AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:text];
    
    NSMutableArray<AVSpeechSynthesisVoice *> *zh_voices = [NSMutableArray array];
    NSMutableArray<AVSpeechSynthesisVoice *> *enGB_voices = [NSMutableArray array];
    for (AVSpeechSynthesisVoice *voice in voices) {
        if ([voice.language isEqual:@"en-GB"] && [voice.name hasPrefix:@"Daniel"]) {
            [enGB_voices addObject:voice];
        }
        if ([voice.language hasPrefix:@"zh"]) {
            [zh_voices addObject:voice];
        }
    }
    AVSpeechSynthesisVoice *voice = [AVSpeechSynthesisVoice new];
    if ([textLanguage hasPrefix:@"zh"]) {
        voice = zh_voices[0];
    } else if ([textLanguage hasPrefix:@"en"]) {
        voice = enGB_voices[0];
    }
    utterance.voice = voice;
    // 语音的速度
    utterance.rate = 0.5;
    // 开始朗读
    [syntesizer speakUtterance:utterance];
}


+ (NSArray *)getTypeSuggestionAfterText:(NSString *)text {
    UITextChecker *textChecker = [[UITextChecker alloc] init];
    NSRange range = NSMakeRange(0, text.length);
    NSMutableArray *suggestions = [NSMutableArray array];
    
    for (NSString *language in [NSLocale preferredLanguages]) {
        NSArray *completions = [textChecker completionsForPartialWordRange:range
                                                                  inString:text
                                                                  language:language];
        for (NSString *suggestion in completions) {
            [suggestions addObject:suggestion];
        }
    }
    NSComparator comparator = ^(NSString *obj1, NSString *obj2) {
        return [TextTool compareWord:obj1 to:obj2];
    };
    [suggestions sortUsingComparator:comparator];
    return suggestions;
}

+ (NSComparisonResult)compareWord:(NSString *)wordOne to:(NSString *)wordTwo {
    NSUInteger lengthOne = wordOne.length;
    NSUInteger lengthTwo = wordTwo.length;
    NSUInteger minLength = lengthOne < lengthTwo ? lengthOne : lengthTwo;
    for (NSUInteger i = 0; i < minLength; ++i) {
        unichar charOne = [wordOne characterAtIndex:i];
        unichar charTwo = [wordTwo characterAtIndex:i];
        if (charOne < charTwo) {
            return NSOrderedAscending;
        }
        if (charOne > charTwo) {
            return NSOrderedDescending;
        }
    }
    if (lengthOne < lengthTwo) {
        return NSOrderedAscending;
    } else {
        return NSOrderedDescending;
    }
}


@end
