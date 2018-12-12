//
//  movingCell.m
//  movingCell
//
//  Created by Apple on 2018/12/12.
//  Copyright © 2018 Apple. All rights reserved.
//

#import "movingCell.h"

@implementation movingCell

- (UIImage *)snapshotView {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0f);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *cellImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return cellImage;
}

@end
