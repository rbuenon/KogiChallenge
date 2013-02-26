//
//  FirstViewController.h
//  KogiChallenge
//
//  Created by Ruben Bueno on 25/02/2013.
//  Copyright (c) 2013 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSSViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (unsafe_unretained, nonatomic) IBOutlet UITableView *rssFeed;

@end
