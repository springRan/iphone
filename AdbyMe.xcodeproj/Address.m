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

+(NSString *) checkEmail {
    return [NSString stringWithFormat:@"%@/users/checkRegister/email.json",HOST_ADDR];
}

+(NSString *) checkUsername {
    return [NSString stringWithFormat:@"%@/users/checkRegister/username.json", HOST_ADDR];
}

-(void)dealloc{
    [super dealloc];
}
@end
