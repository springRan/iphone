//
//  Config.h
//  AdbyMe
//
//  Created by Baekjoon Choi on 4/3/11.
//  Copyright 2011 Megalusion. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 #define HOST_ADDR @"https://www.adby.me"
 */
#define HOST_ADDR @"http://exp.hooni.adby.me"

@interface Address : NSObject {

}

+(NSString *) hostURL;
+(NSString *) loginURL;
+(NSString *) logoutURL;
+(NSString *) checkEmailURL;
+(NSString *) checkUsernameURL;
+(NSString *) registerURL;
+(NSString *) adListURL;
+(NSString *) adUrl:(NSString *)adId;
+(NSString *) makeUrl:(NSString *)rest;
+(NSString *) writeSlogan:(NSString *)adId;
+(NSString *) publishSlogan:(NSString *)sloganId andSnsType:(int)type;
+(NSString *) connectSns:(int)type;
+(NSString *) disconnectSns:(int)type;
+(NSString *) makeShortLink:(NSString *)hashId andLinkType:(int)type;
+(NSString *) earningURL;
+(NSString *) loginCheckURL;
+(NSString *) termsURL;
@end
