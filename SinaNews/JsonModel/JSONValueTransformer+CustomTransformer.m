//
//  JSONValueTransformer+CustomTransformer.m
//  SinaNews
//
//  Created by George She on 16/2/19.
//  Copyright © 2016年 Freedom. All rights reserved.
//

#import "JSONValueTransformer+CustomTransformer.h"
#define APIDateFormat @"EEE, dd MMM yyyy HH:mm:ss zzz"

@implementation JSONValueTransformer (CustomTransformer)
- (NSDate *)NSDateFromNSString:(NSString *)string {
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:APIDateFormat];
  formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
  formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
  return [formatter dateFromString:string];
}

- (NSString *)JSONObjectFromNSDate:(NSDate *)date {
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:APIDateFormat];
  return [formatter stringFromDate:date];
}
@end
