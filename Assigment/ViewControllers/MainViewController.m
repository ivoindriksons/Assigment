//
//  MainViewController.m
//  Assigment
//
//  Created by Ivo Indriksons on 05/02/16.
//  Copyright © 2016 Ivo Indriksons. All rights reserved.
//

#import "MainViewController.h"
#import <AFNetworking.h>
#import "UIImageView+WebCache.h"
#import "PreviewViewController.h"

@interface MainViewController () {
    NSArray *parsedData;
    NSString *largeImageURL;
}

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getNetworkPullRequest];
    // Do any additional setup after loading the view.
}

- (void)getNetworkPullRequest {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:@"https://s3-us-west-2.amazonaws.com/wirestorm/assets/response.json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            parsedData = responseObject;
            NSLog(@"Parsed data: %@", parsedData);
            [self.tableView reloadData];
        }
    }];
    [dataTask resume];
}

#pragma TableView methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [parsedData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:MyIdentifier];
    }
    
    cell.textLabel.text = [[parsedData objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.detailTextLabel.text = [[parsedData objectAtIndex:indexPath.row] objectForKey:@"position"];
    NSString *imageUrlString = [[parsedData objectAtIndex: indexPath.row] objectForKey:@"smallpic"];
    
    cell.imageView.frame = CGRectMake(0, 0, 55, 55);
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrlString]
                      placeholderImage:nil
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                 
                                 NSArray* indexArray = [NSArray arrayWithObjects:indexPath,nil];
                                 [self.tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
                             }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    largeImageURL = [[parsedData objectAtIndex:indexPath.row] objectForKey:@"lrgpic"];
    [self performSegueWithIdentifier:@"showLargeImage" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"showLargeImage"])
    {
        // Get reference to the destination view controller
        PreviewViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        [vc setLargeImageURL:largeImageURL];
    }
}


@end
