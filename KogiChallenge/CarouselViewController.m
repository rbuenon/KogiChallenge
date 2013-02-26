//
//  SecondViewController.m
//  KogiChallenge
//
//  Created by Ruben Bueno on 25/02/2013.
//  Copyright (c) 2013 admin. All rights reserved.
//

#import "CarouselViewController.h"
#import "AFNetworking.h"
#import "ImagesObject.h"

@interface CarouselViewController () {
    iCarousel *carouselView;
    UILabel *captionLabel;
    
    NSArray *images;
    
}


//@property (nonatomic, retain) NSArray *images;
//@property (nonatomic, retain) NSArray *captions;
@end

@implementation CarouselViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Carousel";
        self.tabBarItem.image = [UIImage imageNamed:@"User"];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    

    
    carouselView = [[iCarousel alloc]initWithFrame:self.view.frame];
    carouselView.type = iCarouselTypeRotary;
    carouselView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [carouselView setBackgroundColor:[UIColor colorWithRed:0.040 green:0.230 blue:0.427 alpha:1.000]];
    carouselView.dataSource = self;
    carouselView.delegate = self;
    
    [self.view addSubview:carouselView];
    
    captionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, carouselView.frame.size.width, 20)];
    [captionLabel setBackgroundColor:[UIColor clearColor]];
    [captionLabel setFont:[UIFont boldSystemFontOfSize:20]];
    captionLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [captionLabel setTextColor:[UIColor colorWithWhite:0.90 alpha:1.0]];
    [captionLabel setTextAlignment:NSTextAlignmentCenter];
    
    [self.view addSubview:captionLabel];
    

    [self getJson];
}


-(void)getJson {
    
    NSURL * url = [NSURL URLWithString:@"http://kogimobile.com/rm-carousel.json"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        images =  [self mapArrays:[JSON objectForKey:@"images"]];
        [carouselView reloadData];
        
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"error getting JSON => %@", error.localizedDescription);
    }];
     
    [operation start];

}

- (NSArray*)mapArrays:(NSArray*)array {
    NSMutableArray *retArray = [NSMutableArray new];
    
    for (NSDictionary *dict in array) {
        ImagesObject *io = [ImagesObject new];
        io.url = [dict objectForKey:@"image_url"];
        io.caption = [dict objectForKey:@"caption"];
        
        NSLog(@"Caption: %@\nurl: %@", [dict objectForKey:@"caption"], [dict objectForKey:@"image_url"]);
        
        [retArray addObject:io];
    }
    
    return  retArray;
}

#pragma mark -
#pragma mark iCarousel datasource methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return [images count];
}




-(UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view {
    if (view) {
        return view;
    }
    
    ImagesObject *io = images[index];
    
    NSLog(@"image %d: %@", index, io.caption);
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    [imageView setImageWithURL:[NSURL URLWithString:io.url] placeholderImage:[UIImage imageNamed:@"Exclamation Mark"]];
    
    return imageView;
    
}



#pragma mark -
#pragma mark iCarousel delegate methods

- (void)carouselDidEndScrollingAnimation:(iCarousel *)aCarousel {
    ImagesObject *io = images[carouselView.currentItemIndex];
    
    [captionLabel setText:io.caption];
}






- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotate {
    return true;
}
- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
