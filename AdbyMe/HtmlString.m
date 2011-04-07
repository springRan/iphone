//
//  HtmlString.m
//  AdbyMe
//
//  Created by Baekjoon Choi on 4/7/11.
//  Copyright 2011 Megalusion. All rights reserved.
//

#import "HtmlString.h"


@implementation HtmlString

+ (NSString *) sloganString{
    return [NSString stringWithFormat:@"<html>\
<head>\
<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" />\
<meta name=\"viewport\" content=\"width=220.0, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no, target-densitydpi=medium-dpi\" />\
<style type=\"text/css\">\
#slogan{\
font-family: \"Helvetica\";\
font-size: 14px;\
}\
.blue{\
color: #019fcf;\
}\
a{\
color: #019fcf;\
text-decoration: none;\
}\
</style>\
</head>\
<body>\
<div id=\"slogan\">\
<span class=\"blue\">Onasup12</span> 눈동자의 검은부위가 긴머리,가슴이 풍만,허리는 가늘고~ 중국의 미인기준이네요!!<br /><a href = \"http://adby.me/U7qlyA\">http://adby.me/U7qlyA</a>\
</div>\
</body>\
</html>"];
}
@end
