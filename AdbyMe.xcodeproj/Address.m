//
//  Config.m
//  AdbyMe
//
//  Created by Baekjoon Choi on 4/3/11.
//  Copyright 2011 Megalusion. All rights reserved.
//

#import "Address.h"


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

-(void)dealloc{
    [super dealloc];
}
@end
