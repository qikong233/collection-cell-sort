//
//  movingCell.h
//  movingCell
//
//  Created by Apple on 2018/12/12.
//  Copyright © 2018 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface movingCell : UICollectionViewCell

- (UIImage *)snapshotView;

- (void)shakingView;

@end

NS_ASSUME_NONNULL_END
