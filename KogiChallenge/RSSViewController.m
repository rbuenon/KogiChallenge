//
//  FirstViewController.m
//  KogiChallenge
//
//  Created by Ruben Bueno on 25/02/2013.
//  Copyright (c) 2013 admin. All rights reserved.
//

#import "RSSViewController.h"

#import "WebViewController.h"

#import "RSSParser.h"


@interface RSSViewController () {
    NSArray *items;
    WebViewController *web;
}

@end

@implementation RSSViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"RSS Feed";
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}

							
- (void)viewDidLoad
{
    [super viewDidLoad];

    NSURL *url = [NSURL URLWithString:@"http://webassets.scea.com/pscomauth/groups/public/documents/webasset/rss/playstation/Games_PS3.rss"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [RSSParser parseRSSFeedForRequest:request success:^(NSArray *feedItems) {
        items = feedItems;
        [_rssFeed reloadData];
    } failure:^(NSError *error) {
        NSLog(@"error: %@", error.localizedDescription);
        
    }];
    

}

#pragma mark TableView protocols
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return items.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [UITableViewCell new];
    
    RSSItem *item = items[indexPath.row];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, cell.frame.size.width-40, 18)];
    [title setBackgroundColor:[UIColor clearColor]];
    [title setFont:[UIFont boldSystemFontOfSize:16]];
    [title setText:item.title];
    
    UILabel *content = [[UILabel alloc]initWithFrame:CGRectMake(5, 18, cell.frame.size.width-10, cell.frame.size.height-18)];
    [content setBackgroundColor:[UIColor clearColor]];
    [content setLineBreakMode:NSLineBreakByWordWrapping];
    content.numberOfLines = 0;
    [content setFont:[UIFont systemFontOfSize:12]];
    content.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleHeight;
    
    [content setText:[[item.itemDescription componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"."]] objectAtIndex:0]];
    
    
    [cell addSubview:title];
    [cell addSubview:content];
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    RSSItem *item = items[indexPath.row];
    int charCount = ((NSString*)[[item.itemDescription componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"."]] objectAtIndex:0]).length;
    return 28 + 18 * charCount/ 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RSSItem *item = items[indexPath.row];
    
    web = nil;
    web = [WebViewController new];
    
    web.url = item.link;
    web.title = item.title;
    
    [self.navigationController pushViewController:web animated:true];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setRssFeed:nil];
    [super viewDidUnload];
}
@end
