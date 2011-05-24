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

+(NSString *) hostURL{
    return HOST_ADDR;
}

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

+(NSString *) writeSlogan:(NSString *)adId {
    return [NSString stringWithFormat:@"%@/slogans/write/%@.json", HOST_ADDR, adId];
}
+(NSString *) publishSlogan:(NSString *)sloganId andSnsType:(int)type{
    NSString *snsType = @"";
    if (type == TWITTER) {
        snsType = @"twitter";
    } else if (type == FACEBOOK) {
        snsType = @"facebook";
    } else if (type == ME2DAY) {
        snsType = @"me2day";
    }
    return [NSString stringWithFormat:@"%@/pubs/publish/%@/%@.json", HOST_ADDR, sloganId, snsType];
}

+(NSString *) connectSns:(int)type {
    NSString *snsType = @"";
    if (type == 2048) {
        snsType = @"twitter";
    } else if (type == 2049) {
        snsType = @"facebook";
    } else if (type == 2050) {
        snsType = @"me2day";
    }
    return [NSString stringWithFormat:@"%@/snas/add/%@.json", HOST_ADDR, snsType];
}

+(NSString *) disconnectSns:(int)type{
    NSString *snsType = @"";
    if (type == 2048) {
        snsType = @"twitter";
    } else if (type == 2049) {
        snsType = @"facebook";
    } else if (type == 2050) {
        snsType = @"me2day";
    }
    return [NSString stringWithFormat:@"%@/snas/delete/%@.json", HOST_ADDR, snsType];
}

+(NSString *) makeShortLink:(NSString *)hashId andLinkType:(int)type{
    NSString *linkType = @"";	
    if (type == 0) {
        linkType = @"adby.me";
    } else if (type == 1) {
        linkType = @"bit.ly";
    } else if (type == 2) {
        linkType = @"goo.gl";
    }
    return [NSString stringWithFormat:@"%@/pubs/makeShortLink/%@/%@.json", HOST_ADDR, hashId, linkType];
}

+(NSString *) earningURL{
    return [NSString stringWithFormat:@"%@/copy/earnings.json", HOST_ADDR];
}

+(NSString *) loginCheckURL{
    return [NSString stringWithFormat:@"%@/users/info.json",HOST_ADDR];
}

+(NSString *) termsURL {
    return [NSString stringWithFormat:@"%@/users/termAndService",HOST_ADDR];
}
-(void)dealloc{
    [super dealloc];
}
@end
