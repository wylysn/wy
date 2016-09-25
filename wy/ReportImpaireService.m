//
//  ReportImpaireService.m
//  wy
//
//  Created by 王益禄 on 16/9/25.
//  Copyright © 2016年 ___PURANG___. All rights reserved.
//

#import "ReportImpaireService.h"
#import "UIImage+Resolution.h"

@implementation ReportImpaireService

- (void)submitImpaire:(NSMutableDictionary *)dataDic withImage:(NSArray *)ImageArray success:(void (^)())success failure:(void (^)(NSString *message))failure {
    PRHTTPSessionManager *manager = [PRHTTPSessionManager sharePRHTTPSessionManager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userName = [userDefaults objectForKey:@"userName"];
    NSString *url = [NSString stringWithFormat:@"%@?action=posttrouble&tick=%@&imei=%@&username=%@", [[URLManager getSharedInstance] getURL:@""], [DateUtil getCurrentTimestamp], [NSString getDeviceId], userName];
    [manager POST:url parameters:dataDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (UIImage* image in ImageArray)
        {
            NSData* data;
            NSString* mimeType;
            NSString* name;
            CGSize newSize = image.size;
            UIImage* newImage;
            
            if (newSize.width > 1000 || image.size.height > 1000)
            {
                newImage = [image imageScaledToSize:CGSizeMake(newSize.width*0.5, newSize.height*0.5)];
            }
            else
            {
                newImage = image;
            }
            
            if (UIImagePNGRepresentation(newImage))
            {
                //返回为png图像。
                data = UIImagePNGRepresentation(newImage);
                
                name = [NSString stringWithFormat:@"Image%ld.png",(unsigned long)[ImageArray indexOfObject:image]];
                mimeType = @"image/png";
            }
            else
            {
                
                //返回为JPEG图像。
                data = UIImageJPEGRepresentation(newImage, 0.7);
                mimeType = @"image/jpg";
                name = [NSString stringWithFormat:@"Image%ld.jpg",(unsigned long)[ImageArray indexOfObject:image]];
            }
            [formData appendPartWithFileData:data name:@"files" fileName:name mimeType:mimeType];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject[@"success"]) {
            success();
        } else {
            failure(responseObject[@"message"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
}

@end
