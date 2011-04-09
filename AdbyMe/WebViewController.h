//
//  WebViewController.h
//  AdbyMe
//
//  Created by Baekjoon Choi on 4/9/11.
//  Copyright 2011 Megalusion. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WebViewController : UIViewController <UIWebViewDelegate> {
    NSString *requestURL;
    UIWebView *webView;
    UIActivityIndicatorView *activityView;
}
@property (nonatomic, retain) NSString *requestURL;
@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityView;

@end
