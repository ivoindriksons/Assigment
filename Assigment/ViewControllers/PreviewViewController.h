//
//  PreviewViewController.h
//  Assigment
//
//  Created by Ivo Indriksons on 05/02/16.
//  Copyright © 2016 Ivo Indriksons. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@interface PreviewViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *activityView;
@property (weak, nonatomic) IBOutlet UIImageView *largeImageView;
@property (weak, nonatomic) NSString *largeImageURL;

@end
