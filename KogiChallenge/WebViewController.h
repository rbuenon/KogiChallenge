//
//  WebViewController.h
//  KogiChallenge
//
//  Created by Ruben Bueno on 25/02/2013.
//  Copyright (c) 2013 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController <UIWebViewDelegate>
@property (unsafe_unretained, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, assign) NSURL *url;
@property (nonatomic, assign) NSString *viewTitle;

@end
