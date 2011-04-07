//
//  Config.h
//  AdbyMe
//
//  Created by Baekjoon Choi on 4/3/11.
//  Copyright 2011 Megalusion. All rights reserved.
//

#import <Foundation/Foundation.h>

#define HOST_ADDR @"http://exp.siwonred.adby.me"

@interface Address : NSObject {

}


+(NSString *) loginURL;
+(NSString *) logoutURL;
+(NSString *) checkEmailURL;
+(NSString *) checkUsernameURL;
+(NSString *) registerURL;
+(NSString *) adListURL;
+(NSString *) adUrl:(NSString *)adId;
+(NSString *) makeUrl:(NSString *)rest;
@end
