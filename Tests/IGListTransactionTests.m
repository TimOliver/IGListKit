/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <XCTest/XCTest.h>

#import "IGListBatchUpdateTransaction.h"
#import "IGListDataSourceChangeTransaction.h"
#import "IGListReloadTransaction.h"
#import "IGListAdapterUpdater.h"

@interface IGListTransactionTests : XCTestCase

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation IGListTransactionTests

- (IGListCollectionViewBlock)collectionViewBlock {
    return ^UICollectionView *{ return self.collectionView; };
}

- (IGListBatchUpdateTransaction *)makeBatchUpdateTransaction {
    IGListUpdateTransactationConfig config;
    memset(&config, 0, sizeof(IGListUpdateTransactationConfig));
    return [[IGListBatchUpdateTransaction alloc] initWithCollectionViewBlock:[self collectionViewBlock]
                                                                     updater:[IGListAdapterUpdater new]
                                                                    delegate:nil
                                                                      config:config
                                                                    animated:NO
                                                            sectionDataBlock:nil
                                                       applySectionDataBlock:nil
                                                            itemUpdateBlocks:@[]
                                                            completionBlocks:@[]];
}

- (IGListDataSourceChangeTransaction *)makeDataSourceChangeTransaction {
    return [[IGListDataSourceChangeTransaction alloc] initWithChangeBlock:^{}
                                                         itemUpdateBlocks:@[]
                                                         completionBlocks:@[]];
}

- (IGListReloadTransaction *)makeReloadTransaction {
    return [[IGListReloadTransaction alloc] initWithCollectionViewBlock:[self collectionViewBlock]
                                                                updater:[IGListAdapterUpdater new]
                                                               delegate:nil
                                                            reloadBlock:^{}
                                                       itemUpdateBlocks:@[]
                                                       completionBlocks:@[]];
}

- (void)setUp {
    [super setUp];

    self.window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.window.frame collectionViewLayout:layout];

    [self.window addSubview:self.collectionView];
}

- (void)tearDown {
    [super tearDown];

    self.collectionView = nil;
}

- (void)test_withBatchUpdateTransaction_thatNilCollectionViewBailsCorrectly {
    self.collectionView = nil;
    IGListBatchUpdateTransaction *batchUpdateTransaction = [self makeBatchUpdateTransaction];
    [batchUpdateTransaction begin];
    XCTAssertEqual(batchUpdateTransaction.state, IGListBatchUpdateStateIdle);
}

@end
