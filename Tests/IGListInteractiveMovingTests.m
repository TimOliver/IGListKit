/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <XCTest/XCTest.h>

#import "IGTestObject.h"
#import "IGListTestCase.h"
#import "IGTestDelegateDataSource.h"
#import "UICollectionViewLayout+InteractiveReordering.h"

@interface IGListInteractiveMovingTests : IGListTestCase

@end

@implementation IGListInteractiveMovingTests

- (void)setUp {
    self.workingRangeSize = 2;
    self.dataSource = [IGTestDelegateDataSource new];
    [super setUp];
}

- (void)test_withDetachedLayout_whenQueryingForInteractiveMovingItem_thatOriginalIndexPathIsReturned {
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:1 inSection:1];
    NSIndexPath *targetIndexPath = [layout targetIndexPathForInteractivelyMovingItem:indexPath
                                                                        withPosition:CGPointMake(100, 100)];
    XCTAssertEqual(indexPath.item, targetIndexPath.item);
    XCTAssertEqual(indexPath.section, targetIndexPath.section);
}

- (void)test_whenCollectionViewIsSet_thatTargetIndexPathIsValid {
    [self setupWithObjects:@[genTestObject(@1, @2)]];
    UICollectionViewLayout *layout = self.collectionView.collectionViewLayout;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:1 inSection:1];
    NSIndexPath *targetIndexPath = [layout targetIndexPathForInteractivelyMovingItem:indexPath
                                                                        withPosition:CGPointMake(100, 100)];
    XCTAssertEqual(indexPath.item, targetIndexPath.item);
    XCTAssertEqual(indexPath.section, targetIndexPath.section);
}

- (void)test_whenSettingUpTest_thenCollectionViewIsLoaded {
    [self setupWithObjects:@[genTestObject(@1, @2)]];
    UICollectionViewLayout *layout = self.collectionView.collectionViewLayout;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:1 inSection:1];
    NSIndexPath *targetIndexPath = [layout targetIndexPathForInteractivelyMovingItem:indexPath
                                                                        withPosition:CGPointMake(100, 100)];
    XCTAssertEqual(indexPath.item, targetIndexPath.item);
    XCTAssertEqual(indexPath.section, targetIndexPath.section);
}

@end
