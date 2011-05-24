//

@interface NSDateFormatter (Extras)
+ (NSString *)dateDifferenceStringFromTimestamp:(long long)timestamp;
+ (NSString *)dateDifferenceStringFromString:(NSString *)dateString
                                  withFormat:(NSString *)dateFormat;

@end
