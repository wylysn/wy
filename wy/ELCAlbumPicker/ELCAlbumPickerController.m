//
//  AlbumPickerController.m
//
//  Created by ELC on 2/15/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import "ELCAlbumPickerController.h"
#import "ELCImagePickerController.h"
#import "ELCAssetTablePicker.h"
#import <MobileCoreServices/UTCoreTypes.h>

@interface ELCAlbumPickerController ()<PHPhotoLibraryChangeObserver>

@property (nonatomic, strong) PHPhotoLibrary *library;

@property (nonatomic, strong) NSArray *sectionFetchResults;

@end

@implementation ELCAlbumPickerController

//Using auto synthesizers

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
	
	[self.navigationItem setTitle:NSLocalizedString(@"图片", nil)];

    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self.parent action:@selector(cancelImagePicker)];
	[self.navigationItem setRightBarButtonItem:cancelButton];

//    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
//	self.assetGroups = tempArray;
//    
//    PHPhotoLibrary *assetLibrary = [[PHPhotoLibrary alloc] init];
//    self.library = assetLibrary;
//
//    // Load Albums into assetGroups
//    dispatch_async(dispatch_get_main_queue(), ^
//    {
//        @autoreleasepool {
//        
//        // Group enumerator Block
//            void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop) 
//            {
//                if (group == nil) {
//                    return;
//                }
//                
//                // added fix for camera albums order
//                NSString *sGroupPropertyName = (NSString *)[group valueForProperty:ALAssetsGroupPropertyName];
//                NSUInteger nType = [[group valueForProperty:ALAssetsGroupPropertyType] intValue];
//                
//                if ([[sGroupPropertyName lowercaseString] isEqualToString:@"camera roll"] && nType == ALAssetsGroupSavedPhotos) {
//                    [self.assetGroups insertObject:group atIndex:0];
//                }
//                else {
//                    [self.assetGroups addObject:group];
//                }
//
//                // Reload albums
//                [self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:YES];
//            };
//            
//            // Group Enumerator Failure Block
//            void (^assetGroupEnumberatorFailure)(NSError *) = ^(NSError *error) {
//              
//                if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusDenied) {
//                    NSString *errorMessage = NSLocalizedString(@"This app does not have access to your photos or videos. You can enable access in Privacy Settings.", nil);
//                    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Access Denied", nil) message:errorMessage delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil] show];
//                  
//                } else {
//                    NSString *errorMessage = [NSString stringWithFormat:@"Album Error: %@ - %@", [error localizedDescription], [error localizedRecoverySuggestion]];
//                    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:errorMessage delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil] show];
//                }
//
//                [self.navigationItem setTitle:nil];
//                NSLog(@"A problem occured %@", [error description]);	                                 
//            };	
//                    
//            // Enumerate Albums
//            [self.library enumerateGroupsWithTypes:ALAssetsGroupAll
//                                   usingBlock:assetGroupEnumerator 
//                                 failureBlock:assetGroupEnumberatorFailure];
//        
//        }
//    });
    
    // Create a PHFetchResult object for each section in the table view.
    PHFetchOptions *allPhotosOptions = [[PHFetchOptions alloc] init];
    allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    PHFetchResult *allPhotos = [PHAsset fetchAssetsWithOptions:allPhotosOptions];
    
    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    
    self.sectionFetchResults = @[allPhotos, topLevelUserCollections];
    
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
}

#pragma mark - PHPhotoLibraryChangeObserver

- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    /*
     Change notifications may be made on a background queue. Re-dispatch to the
     main queue before acting on the change as we'll be updating the UI.
     */
    dispatch_async(dispatch_get_main_queue(), ^{
        // Loop through the section fetch results, replacing any fetch results that have been updated.
        NSMutableArray *updatedSectionFetchResults = [self.sectionFetchResults mutableCopy];
        __block BOOL reloadRequired = NO;
        
        [self.sectionFetchResults enumerateObjectsUsingBlock:^(PHFetchResult *collectionsFetchResult, NSUInteger index, BOOL *stop) {
            PHFetchResultChangeDetails *changeDetails = [changeInstance changeDetailsForFetchResult:collectionsFetchResult];
            
            if (changeDetails != nil) {
                [updatedSectionFetchResults replaceObjectAtIndex:index withObject:[changeDetails fetchResultAfterChanges]];
                reloadRequired = YES;
            }
        }];
        
        if (reloadRequired) {
            self.sectionFetchResults = updatedSectionFetchResults;
            [self.tableView reloadData];
        }
        
    });
}

- (void)dealloc {
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

//- (void)viewWillAppear:(BOOL)animated {
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView) name:ALAssetsLibraryChangedNotification object:nil];
//    [self.tableView reloadData];
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:ALAssetsLibraryChangedNotification object:nil];
//}

- (void)reloadTableView
{
	[self.tableView reloadData];
	[self.navigationItem setTitle:NSLocalizedString(@"选择图片", nil)];
}

- (BOOL)shouldSelectAsset:(ELCAsset *)asset previousCount:(NSUInteger)previousCount
{
    return [self.parent shouldSelectAsset:asset previousCount:previousCount];
}

- (BOOL)shouldDeselectAsset:(ELCAsset *)asset previousCount:(NSUInteger)previousCount
{
    return [self.parent shouldDeselectAsset:asset previousCount:previousCount];
}

- (void)selectedAssets:(NSArray*)assets
{
	[_parent selectedAssets:assets];
}

//- (ALAssetsFilter *)assetFilter
//{
//    if([self.mediaTypes containsObject:(NSString *)kUTTypeImage] && [self.mediaTypes containsObject:(NSString *)kUTTypeMovie])
//    {
//        return [ALAssetsFilter allAssets];
//    }
//    else if([self.mediaTypes containsObject:(NSString *)kUTTypeMovie])
//    {
//        return [ALAssetsFilter allVideos];
//    }
//    else
//    {
//        return [ALAssetsFilter allPhotos];
//    }
//}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionFetchResults.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 0;
    
    if (section == 0) {
        // The "All Photos" section only ever has a single row.
        numberOfRows = 1;
    } else {
        PHFetchResult *fetchResult = self.sectionFetchResults[section];
        numberOfRows = fetchResult.count;
    }
    
    return numberOfRows;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Get count
//    ALAssetsGroup *g = (ALAssetsGroup*)[self.assetGroups objectAtIndex:indexPath.row];
//    [g setAssetsFilter:[self assetFilter]];
//    NSInteger gCount = [g numberOfAssets];
//
//    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%ld)",[g valueForProperty:ALAssetsGroupPropertyName], (long)gCount];
//    UIImage* image = [UIImage imageWithCGImage:[g posterImage]];
//
//    image = [self resize:image to:CGSizeMake(78, 78)];
//    [cell.imageView setImage:image];
//	[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    PHFetchResult *fetchResult = self.sectionFetchResults[indexPath.section];
    PHAssetCollection *collection;
    PHFetchResult *fetchRs;
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    if (indexPath.section == 0) {
        fetchRs = fetchResult;
        cell.textLabel.text = [NSString stringWithFormat:@"%@ (%ld)",@"所有图片", [fetchResult count]];
    } else {
        collection = fetchResult[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ (%ld)",collection.localizedTitle, collection.estimatedAssetCount];//collection.localizedTitle;
        if ([collection isKindOfClass:[PHAssetCollection class]]) {
            fetchRs = [PHAsset fetchKeyAssetsInAssetCollection:collection options:fetchOptions];
        }
    }
//    [cell.imageView setFrame:CGRectMake(0, 0, 78, 78)];
    if (fetchRs.count>0) {
        PHAsset *asset = [fetchRs firstObject];
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.resizeMode = PHImageRequestOptionsResizeModeExact;
        
        CGFloat scale = [UIScreen mainScreen].scale;
        CGFloat dimension = 78.0f;
        CGSize size = CGSizeMake(dimension*scale, dimension*scale);
        
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage *result, NSDictionary *info) {
            cell.imageView.image = [self resize:result to:CGSizeMake(78, 78)];
        }];
    } else {
        UIImage *image = [UIImage imageNamed:@"nopic.png"];
        cell.imageView.image = image;
    }
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	
    return cell;
}

// Resize a UIImage. From http://stackoverflow.com/questions/2658738/the-simplest-way-to-resize-an-uiimage
- (UIImage *)resize:(UIImage *)image to:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
//    [cell setSelected:NO animated:NO];
//    [cell setHighlighted:YES animated:NO];
    
    UIStoryboard* assetPickerSB = [UIStoryboard storyboardWithName:@"AssetPicker" bundle:[NSBundle mainBundle]];
    
	ELCAssetTablePicker *picker = [assetPickerSB instantiateViewControllerWithIdentifier:@"assetPicker"];
	picker.parent = self;
    
    PHFetchResult *fetchResult = self.sectionFetchResults[indexPath.section];
    if (indexPath.section == 0) {
        picker.assetsFetchResults = fetchResult;
    } else {
        // Get the PHAssetCollection for the selected row.
        PHCollection *collection = fetchResult[indexPath.row];
        if (![collection isKindOfClass:[PHAssetCollection class]]) {
            return;
        }
        
        // Configure the AAPLAssetGridViewController with the asset collection.
        PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
        PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
        
        picker.assetsFetchResults = assetsFetchResult;
        picker.assetCollection = assetCollection;
    }
    

    
//    [picker.assetGroup setAssetsFilter:[self assetFilter]];
    
	picker.assetPickerFilterDelegate = self.assetPickerFilterDelegate;
	
	[self.navigationController pushViewController:picker animated:YES];
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell setHighlighted:YES animated:NO];
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell setHighlighted:NO animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 95;
}

@end

