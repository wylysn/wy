//
//  ELCAssetTablePicker.m
//
//  Created by ELC on 2/15/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import "ELCAssetTablePicker.h"
#import "ELCAsset.h"
#import "ELCAlbumPickerController.h"
#import "ELCConsole.h"
#import "AAPLGridViewCell.h"
#import "ELCOverlayImageView.h"
@import PhotosUI;
#import "NSIndexSet+Convenience.h"
#import "UICollectionView+Convenience.h"

@interface ELCAssetTablePicker ()<PHPhotoLibraryChangeObserver>

@property (nonatomic, assign) int columns;
@property (nonatomic, strong) PHCachingImageManager *imageManager;
@property CGRect previousPreheatRect;

@end

@implementation ELCAssetTablePicker

static NSString * const CellReuseIdentifier = @"Cell";
static CGSize AssetGridThumbnailSize;

//Using auto synthesizers

- (void)awakeFromNib {
    self.imageManager = [[PHCachingImageManager alloc] init];
    [self resetCachedAssets];
    
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
}

- (void)viewDidLoad
{
//    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
//	[self.tableView setAllowsSelection:NO];

    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    self.elcAssets = tempArray;
    for (PHAsset *phasset in self.assetsFetchResults) {
        ELCAsset *asset = [[ELCAsset alloc] initWithAsset:phasset];
        [self.elcAssets addObject:asset];
    }
	
    if (self.immediateReturn) {
        
    } else {
        UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction:)];
        [self.navigationItem setRightBarButtonItem:doneButtonItem];
        [self.navigationItem setTitle:NSLocalizedString(@"选择图片", nil)];
    }

	[self performSelectorInBackground:@selector(preparePhotos) withObject:nil];
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize cellSize = ((UICollectionViewFlowLayout *)self.collectionViewLayout).itemSize;
    AssetGridThumbnailSize = CGSizeMake(cellSize.width * scale, cellSize.height * scale);
    // Register for notifications when the photo library has changed
//    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
}

- (void)dealloc {
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Begin caching assets in and around collection view's visible rect.
    [self updateCachedAssets];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.columns = self.view.bounds.size.width / 80;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[ELCConsole mainConsole] removeAllIndex];
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Update cached assets for the new visible area.
    [self updateCachedAssets];
}

#pragma mark - Asset Caching

- (void)resetCachedAssets {
    [self.imageManager stopCachingImagesForAllAssets];
    self.previousPreheatRect = CGRectZero;
}

- (void)updateCachedAssets {
    BOOL isViewVisible = [self isViewLoaded] && [[self view] window] != nil;
    if (!isViewVisible) { return; }
    
    // The preheat window is twice the height of the visible rect.
    CGRect preheatRect = self.collectionView.bounds;
    preheatRect = CGRectInset(preheatRect, 0.0f, -0.5f * CGRectGetHeight(preheatRect));
    
    /*
     Check if the collection view is showing an area that is significantly
     different to the last preheated area.
     */
    CGFloat delta = ABS(CGRectGetMidY(preheatRect) - CGRectGetMidY(self.previousPreheatRect));
    if (delta > CGRectGetHeight(self.collectionView.bounds) / 3.0f) {
        
        // Compute the assets to start caching and to stop caching.
        NSMutableArray *addedIndexPaths = [NSMutableArray array];
        NSMutableArray *removedIndexPaths = [NSMutableArray array];
        
        [self computeDifferenceBetweenRect:self.previousPreheatRect andRect:preheatRect removedHandler:^(CGRect removedRect) {
            NSArray *indexPaths = [self.collectionView aapl_indexPathsForElementsInRect:removedRect];
            [removedIndexPaths addObjectsFromArray:indexPaths];
        } addedHandler:^(CGRect addedRect) {
            NSArray *indexPaths = [self.collectionView aapl_indexPathsForElementsInRect:addedRect];
            [addedIndexPaths addObjectsFromArray:indexPaths];
        }];
        
        NSArray *assetsToStartCaching = [self assetsAtIndexPaths:addedIndexPaths];
        NSArray *assetsToStopCaching = [self assetsAtIndexPaths:removedIndexPaths];
        
        // Update the assets the PHCachingImageManager is caching.
        [self.imageManager startCachingImagesForAssets:assetsToStartCaching
                                            targetSize:AssetGridThumbnailSize
                                           contentMode:PHImageContentModeAspectFill
                                               options:nil];
        [self.imageManager stopCachingImagesForAssets:assetsToStopCaching
                                           targetSize:AssetGridThumbnailSize
                                          contentMode:PHImageContentModeAspectFill
                                              options:nil];
        
        // Store the preheat rect to compare against in the future.
        self.previousPreheatRect = preheatRect;
    }
}

- (void)computeDifferenceBetweenRect:(CGRect)oldRect andRect:(CGRect)newRect removedHandler:(void (^)(CGRect removedRect))removedHandler addedHandler:(void (^)(CGRect addedRect))addedHandler {
    if (CGRectIntersectsRect(newRect, oldRect)) {
        CGFloat oldMaxY = CGRectGetMaxY(oldRect);
        CGFloat oldMinY = CGRectGetMinY(oldRect);
        CGFloat newMaxY = CGRectGetMaxY(newRect);
        CGFloat newMinY = CGRectGetMinY(newRect);
        
        if (newMaxY > oldMaxY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, oldMaxY, newRect.size.width, (newMaxY - oldMaxY));
            addedHandler(rectToAdd);
        }
        
        if (oldMinY > newMinY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, newMinY, newRect.size.width, (oldMinY - newMinY));
            addedHandler(rectToAdd);
        }
        
        if (newMaxY < oldMaxY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, newMaxY, newRect.size.width, (oldMaxY - newMaxY));
            removedHandler(rectToRemove);
        }
        
        if (oldMinY < newMinY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, oldMinY, newRect.size.width, (newMinY - oldMinY));
            removedHandler(rectToRemove);
        }
    } else {
        addedHandler(newRect);
        removedHandler(oldRect);
    }
}

- (NSArray *)assetsAtIndexPaths:(NSArray *)indexPaths {
    if (indexPaths.count == 0) { return nil; }
    
    NSMutableArray *assets = [NSMutableArray arrayWithCapacity:indexPaths.count];
    for (NSIndexPath *indexPath in indexPaths) {
        PHAsset *asset = self.assetsFetchResults[indexPath.item];
        [assets addObject:asset];
    }
    
    return assets;
}

#pragma mark - PHPhotoLibraryChangeObserver

- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    // Check if there are changes to the assets we are showing.
    
//    PHFetchResultChangeDetails *collectionChanges = [changeInstance changeDetailsForFetchResult:self.assetsFetchResults];
//    if (collectionChanges == nil) {
//        return;
//    }
//    
//    /*
//     Change notifications may be made on a background queue. Re-dispatch to the
//     main queue before acting on the change as we'll be updating the UI.
//     */
//    dispatch_async(dispatch_get_main_queue(), ^{
//        // Get the new fetch result.
//        self.assetsFetchResults = [collectionChanges fetchResultAfterChanges];
//        
//        UICollectionView *collectionView = self.collectionView;
//        
//        if (![collectionChanges hasIncrementalChanges] || [collectionChanges hasMoves]) {
//            // Reload the collection view if the incremental diffs are not available
//            [collectionView reloadData];
//            
//        } else {
//            /*
//             Tell the collection view to animate insertions and deletions if we
//             have incremental diffs.
//             */
//            [collectionView performBatchUpdates:^{
//                NSIndexSet *removedIndexes = [collectionChanges removedIndexes];
//                if ([removedIndexes count] > 0) {
//                    [collectionView deleteItemsAtIndexPaths:[removedIndexes aapl_indexPathsFromIndexesWithSection:0]];
//                }
//                
//                NSIndexSet *insertedIndexes = [collectionChanges insertedIndexes];
//                if ([insertedIndexes count] > 0) {
//                    [collectionView insertItemsAtIndexPaths:[insertedIndexes aapl_indexPathsFromIndexesWithSection:0]];
//                }
//                
//                NSIndexSet *changedIndexes = [collectionChanges changedIndexes];
//                if ([changedIndexes count] > 0) {
//                    [collectionView reloadItemsAtIndexPaths:[changedIndexes aapl_indexPathsFromIndexesWithSection:0]];
//                }
//            } completion:NULL];
//        }
//        
//        [self resetCachedAssets];
//    });
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    self.columns = self.view.bounds.size.width / 80;
    [self.collectionView reloadData];
}

- (void)preparePhotos
{
    @autoreleasepool {
        /*
        [self.elcAssets removeAllObjects];
        [self.assetGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            
            if (result == nil) {
                return;
            }
            
            ELCAsset *elcAsset = [[ELCAsset alloc] initWithAsset:result];
            [elcAsset setParent:self];
            
            BOOL isAssetFiltered = NO;
            if (self.assetPickerFilterDelegate &&
               [self.assetPickerFilterDelegate respondsToSelector:@selector(assetTablePicker:isAssetFilteredOut:)])
            {
                isAssetFiltered = [self.assetPickerFilterDelegate assetTablePicker:self isAssetFilteredOut:(ELCAsset*)elcAsset];
            }

            if (!isAssetFiltered) {
                [self.elcAssets addObject:elcAsset];
            }

         }];

        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            // scroll to bottom
            long section = [self numberOfSectionsInTableView:self.tableView] - 1;
            long row = [self tableView:self.tableView numberOfRowsInSection:section] - 1;
            if (section >= 0 && row >= 0) {
                NSIndexPath *ip = [NSIndexPath indexPathForRow:row
                                                     inSection:section];
                        [self.tableView scrollToRowAtIndexPath:ip
                                              atScrollPosition:UITableViewScrollPositionBottom
                                                      animated:NO];
            }
            
            [self.navigationItem setTitle:self.singleSelection ? NSLocalizedString(@"Pick Photo", nil) : NSLocalizedString(@"Pick Photos", nil)];
        });
         */
    }
}


- (void)doneAction:(id)sender
{	
	NSMutableArray *selectedAssetsImages = [[NSMutableArray alloc] init];
	    
	for (ELCAsset *elcAsset in self.elcAssets) {
		if ([elcAsset selected]) {
			[selectedAssetsImages addObject:elcAsset];
		}
	}
    if ([[ELCConsole mainConsole] onOrder]) {
        [selectedAssetsImages sortUsingSelector:@selector(compareWithIndex:)];
    }
        [self.parent selectedAssets:selectedAssetsImages];
    
//    for (ELCAsset *elcAsset in self.elcAssets) {
////        if ([elcAsset selected]) {
////            [selectedAssetsImages addObject:elcAsset];
////        }
//        PHAsset *asset = elcAsset.asset;
//        NSMutableDictionary *workingDictionary = [[NSMutableDictionary alloc] init];
//        [workingDictionary setObject:[NSString stringWithFormat:@"%li", asset.mediaType] forKey:UIImagePickerControllerMediaType];
//        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
//        options.synchronous = YES;
//        [self.imageManager requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
//            ClipImageVC *controller = [[ClipImageVC alloc] initWithImage:result];
//            [controller setClipImageBlock:^(UIImage *image) {
//                
//                //关闭相册界面
//                //        if(self.callback){
//                //            self.callback(self.images);
//                //        }
//                //[self cancel:nil];
//            }];
//            
//            [controller setGoBackBlock:^{
//                //[self cancel:nil];
//            }];
//            [self.navigationController pushViewController:controller animated:YES];
//        }];
//    }
//    if ([[ELCConsole mainConsole] onOrder]) {
//        [selectedAssetsImages sortUsingSelector:@selector(compareWithIndex:)];
//    }
//    [self.parent selectedAssets:selectedAssetsImages];
}


- (BOOL)shouldSelectAsset:(ELCAsset *)asset
{
    NSUInteger selectionCount = 0;
    for (ELCAsset *elcAsset in self.elcAssets) {
        if (elcAsset.selected) selectionCount++;
    }
    BOOL shouldSelect = YES;
    if ([self.parent respondsToSelector:@selector(shouldSelectAsset:previousCount:)]) {
        shouldSelect = [self.parent shouldSelectAsset:asset previousCount:selectionCount];
    }
    return shouldSelect;
}

- (void)assetSelected:(ELCAsset *)asset
{
    if (self.singleSelection) {

        for (ELCAsset *elcAsset in self.elcAssets) {
            if (asset != elcAsset) {
                elcAsset.selected = NO;
            }
        }
    }
    if (self.immediateReturn) {
        NSArray *singleAssetArray = @[asset];
        [(NSObject *)self.parent performSelector:@selector(selectedAssets:) withObject:singleAssetArray afterDelay:0];
    }
}

- (BOOL)shouldDeselectAsset:(ELCAsset *)asset
{
    if (self.immediateReturn){
        return NO;
    }
    return YES;
}

- (void)assetDeselected:(ELCAsset *)asset
{
    if (self.singleSelection) {
        for (ELCAsset *elcAsset in self.elcAssets) {
            if (asset != elcAsset) {
                elcAsset.selected = NO;
            }
        }
    }

    if (self.immediateReturn) {
        NSArray *singleAssetArray = @[asset.asset];
        [(NSObject *)self.parent performSelector:@selector(selectedAssets:) withObject:singleAssetArray afterDelay:0];
    }
    
    /*
    int numOfSelectedElements = [[ELCConsole mainConsole] numOfSelectedElements];
    if (asset.index < numOfSelectedElements - 1) {
        NSMutableArray *arrayOfCellsToReload = [[NSMutableArray alloc] initWithCapacity:1];
        
        for (int i = 0; i < [self.elcAssets count]; i++) {
            ELCAsset *assetInArray = [self.elcAssets objectAtIndex:i];
            if (assetInArray.selected && (assetInArray.index > asset.index)) {
                assetInArray.index -= 1;
                
                int row = i / self.columns;
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
                BOOL indexExistsInArray = NO;
                for (NSIndexPath *indexInArray in arrayOfCellsToReload) {
                    if (indexInArray.row == indexPath.row) {
                        indexExistsInArray = YES;
                        break;
                    }
                }
                if (!indexExistsInArray) {
                    [arrayOfCellsToReload addObject:indexPath];
                }
            }
        }
        [self.collectionView reloadRowsAtIndexPaths:arrayOfCellsToReload withRowAnimation:UITableViewRowAnimationNone];
    }
     */
}

#pragma mark UITableViewDataSource Delegate Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.elcAssets.count;
}


//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    if (self.columns <= 0) { //Sometimes called before we know how many columns we have
//        self.columns = 4;
//    }
//    NSInteger numRows = ceil([self.elcAssets count] / (float)self.columns);
//    return numRows;
//}

//- (NSArray *)assetsForIndexPath:(NSIndexPath *)path
//{
//    long index = path.row * self.columns;
//    long length = MIN(self.columns, [self.elcAssets count] - index);
//    return [self.elcAssets subarrayWithRange:NSMakeRange(index, length)];
//}

// Customize the appearance of table view cells.
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{    
//    static NSString *CellIdentifier = @"Cell";
//        
//    ELCAssetCell *cell = (ELCAssetCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//
//    if (cell == nil) {		        
//        cell = [[ELCAssetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }
//    
//    [cell setAssets:[self assetsForIndexPath:indexPath]];
//    
//    return cell;
//}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ELCAsset *elcasset = self.elcAssets[indexPath.item];
    PHAsset *asset = elcasset.asset;//self.assetsFetchResults[indexPath.item];
    
    // Dequeue an AAPLGridViewCell.
    AAPLGridViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellReuseIdentifier forIndexPath:indexPath];
    cell.representedAssetIdentifier = asset.localIdentifier;
    
    // Add a badge to the cell if the PHAsset represents a Live Photo.
    if (asset.mediaSubtypes & PHAssetMediaSubtypePhotoLive) {
        // Add Badge Image to the cell to denote that the asset is a Live Photo.
        UIImage *badge = [PHLivePhotoView livePhotoBadgeImageWithOptions:PHLivePhotoBadgeOptionsOverContent];
        cell.livePhotoBadgeImage = badge;
    }
    
    // Request an image for the asset from the PHCachingImageManager.
    [self.imageManager requestImageForAsset:asset
                                 targetSize:AssetGridThumbnailSize
                                contentMode:PHImageContentModeAspectFill
                                    options:nil
                              resultHandler:^(UIImage *result, NSDictionary *info) {
                                  // Set the cell's thumbnail image if it's still showing the same asset.
                                  if ([cell.representedAssetIdentifier isEqualToString:asset.localIdentifier]) {
                                      cell.thumbnailImage = result;
                                  }
                              }];
    
    cell.selectedImageView.hidden = !elcasset.selected;
   
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ELCAsset *asset = self.elcAssets[indexPath.item];
    AAPLGridViewCell *cell = (AAPLGridViewCell *)[collectionView cellForItemAtIndexPath:indexPath];

    if (cell.selectedImageView.hidden && ![self shouldSelectAsset:asset]) {
        return;
    }
    if (cell.selectedImageView.hidden) {
        if ([self shouldSelectAsset:asset]) {
            [self assetSelected:asset];
        }
    } else {
        if ([self shouldDeselectAsset:asset]) {
            [self assetDeselected:asset];
        }
    }
    cell.selectedImageView.hidden = !cell.selectedImageView.hidden;
    asset.selected = !asset.selected;
//    if (asset.selected) {
//        asset.index = [[ELCConsole mainConsole] numOfSelectedElements];
//        [[ELCConsole mainConsole] addIndex:asset.index];
//    }
//    else
//    {
//        NSInteger lastElement = [[ELCConsole mainConsole] numOfSelectedElements] - 1;
//        [[ELCConsole mainConsole] removeIndex:lastElement];
//    }
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.f/[UIScreen mainScreen].scale;
}

- (int)totalSelectedAssets
{
    int count = 0;
    
    for (ELCAsset *asset in self.elcAssets) {
		if (asset.selected) {
            count++;	
		}
	}
    
    return count;
}


@end
