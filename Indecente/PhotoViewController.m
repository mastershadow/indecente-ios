//
//  PhotoViewController.m
//  Indecente
//
//  Created by Eduard Roccatello on 06/10/14.
//  Copyright (c) 2014 Roccatello Eduard. All rights reserved.
//

#import "PhotoViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "Constants.h"

@interface PhotoViewController () {
    NSMutableArray *_photos;
}

@end

@implementation PhotoViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.delegate = self;
        self.alwaysShowControls = NO;
        self.displayActionButton = NO;
        self.displayNavArrows = NO;
        self.displaySelectionButtons = NO;
        self.enableGrid = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"%@%@", INDECENTE_BASE_URL, @"/gallery/gallery.json"]
      parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
          NSArray *res = (NSArray *)responseObject;
          _photos = [NSMutableArray arrayWithCapacity:res.count];
          for (NSDictionary *d in res) {
              NSString *url = [NSString stringWithFormat:@"%@/gallery/%@", INDECENTE_BASE_URL, [d objectForKey:@"url"]];
              [_photos addObject:[[MWPhoto alloc] initWithURL:[NSURL URLWithString:url]]];
          }
          [self reloadData];
          
          
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

}

-(NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return [_photos count];
}


-(id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < [_photos count]) {
        return [_photos objectAtIndex:index];
    }
    return nil;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}


@end
