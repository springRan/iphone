//
//  SnsWebViewController.h
//  AdbyMe
//
//  Created by Baekjoon Choi on 4/10/11.
//  Copyright 2011 Megalusion. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SnsWebViewControllerDelegate;

@interface SnsWebViewController : UIViewController <UIWebViewDelegate> {
    NSString *requestURL;
    UIWebView *webView;
    UIActivityIndicatorView *activityView;
    id <SnsWebViewControllerDelegate> delegate;
}
@property (nonatomic, retain) NSString *requestURL;
@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityView;
@property (nonatomic, assign) id <SnsWebViewControllerDelegate> delegate;



@end



@protocol SnsWebViewControllerDelegate 

- (void)connectFinished:(NSString *)json;

@end