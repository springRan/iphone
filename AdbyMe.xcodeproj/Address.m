//
//  Config.m
//  AdbyMe
//
//  Created by Baekjoon Choi on 4/3/11.
//  Copyright 2011 Megalusion. All rights reserved.
//

#import "Address.h"

#define TWITTER 1024
#define FACEBOOK 1025
#define ME2DAY 1026

@implementation Address

+(NSString *) loginURL {
    return [NSString stringWithFormat:@"%@/users/login.json",HOST_ADDR];
}

+(NSString *) logoutURL {
    return [NSString stringWithFormat:@"%@/users/logout.json",HOST_ADDR];
}

+(NSString *) checkEmailURL {
    return [NSString stringWithFormat:@"%@/users/checkRegister/email.json",HOST_ADDR];
}

+(NSString *) checkUsernameURL {
    return [NSString stringWithFormat:@"%@/users/checkRegister/username.json", HOST_ADDR];
}

+(NSString *) registerURL {
    return [NSString stringWithFormat:@"%@/users/register.json", HOST_ADDR];
}

+(NSString *) adListURL {
    return [NSString stringWithFormat:@"%@/copy/cover.json", HOST_ADDR];
}

+(NSString *) adUrl:(NSString *)adId{
    return [NSString stringWithFormat:@"%@/copy/ad/%@.json", HOST_ADDR, adId];
}

+(NSString *) makeUrl:(NSString *)rest{
    return [NSString stringWithFormat:@"%@%@", HOST_ADDR, rest];
}

+(NSString *) likeUrl:(NSString *)linkId{
    return [NSString stringWithFormat:@"%@/links/likeOrDislike/%@/like.json",HOST_ADDR,linkId];
}

+(NSString *) dislikeUrl:(NSString *)linkId{
    return [NSString stringWithFormat:@"%@/links/likeOrDislike/%@/dislike.json",HOST_ADDR,linkId];
}

+(NSString *) writeCopy:(NSString *)adId andSnsType:(int)type{
    NSString *snsType = @"";
    if (type == TWITTER) {
        snsType = @"twitter";
    } else if (type == FACEBOOK) {
        snsType = @"facebook";
    } else if (type == ME2DAY) {
        snsType = @"me2day";
    }
    return [NSString stringWithFormat:@"%@/slogans/write/%@/%@.json", HOST_ADDR, adId, snsType];
}

-(void)dealloc{
    [super dealloc];
}
@end
