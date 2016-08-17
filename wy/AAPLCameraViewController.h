/*
Copyright (C) 2015 Apple Inc. All Rights Reserved.
See LICENSE.txt for this sample’s licensing information

Abstract:
View controller for camera interface.
*/
#import <UIKit/UIKit.h>
@import UIKit;

@protocol AAPLCameraViewDelegate <NSObject>

- (void)showImageDate:(NSData *) imageData;

@end

@interface AAPLCameraViewController : UIViewController

@property(assign,nonatomic) id<AAPLCameraViewDelegate> delegate;

@end
