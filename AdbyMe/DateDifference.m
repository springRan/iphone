
@implementation NSDateFormatter (Extras)


+ (NSString *)dateDifferenceStringFromTimestamp:(long long)timestamp
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDate *now = [NSDate date];
    double time = [date timeIntervalSinceDate:now];
    time *= -1;
    if (time > 0) {
        if (time < 60) {
            return @"less than a minute ago";
        } else if (time < 3600) {
            int diff = round(time / 60);
            if (diff == 1) 
                return [NSString stringWithFormat:@"1 minute ago", diff];
            return [NSString stringWithFormat:@"%d minutes ago", diff];
        } else if (time < 86400) {
            int diff = round(time / 60 / 60);
            if (diff == 1)
                return [NSString stringWithFormat:@"1 hour ago", diff];
            return [NSString stringWithFormat:@"%d hours ago", diff];
        }
    }
    NSDateFormatter *formatter = [[[NSDateFormatter alloc]init]autorelease];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [formatter stringFromDate:date];
}

+ (NSString *)dateDifferenceStringFromString:(NSString *)dateString
                                  withFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [dateFormatter setDateFormat:dateFormat];
    NSDate *date = [dateFormatter dateFromString:dateString];
    [dateFormatter release];
    NSDate *now = [NSDate date];
    double time = [date timeIntervalSinceDate:now];
    time *= -1;
    if (time > 0) {
        if (time < 60) {
            return @"less than a minute ago";
        } else if (time < 3600) {
            int diff = round(time / 60);
            if (diff == 1) 
                return [NSString stringWithFormat:@"1 minute ago", diff];
            return [NSString stringWithFormat:@"%d minutes ago", diff];
        } else if (time < 86400) {
            int diff = round(time / 60 / 60);
            if (diff == 1)
                return [NSString stringWithFormat:@"1 hour ago", diff];
            return [NSString stringWithFormat:@"%d hours ago", diff];
        }
    }
    NSDateFormatter *formatter = [[[NSDateFormatter alloc]init]autorelease];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [formatter stringFromDate:date];
}

@end