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

@interface IGListBatchUpdateTransaction (Tests)

- (NSInteger)mode;

@end

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
    config.allowsBackgroundDiffing = YES;
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

- (void)test_withBatchUpdateTransaction_thatCancellingTransactionBetweenRunLoopsIsCaptured {
    IGListBatchUpdateTransaction *batchUpdateTransaction = [self makeBatchUpdateTransaction];
    [batchUpdateTransaction begin];
    [batchUpdateTransaction cancel];

    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    dispatch_async(dispatch_get_main_queue(), ^{
        XCTAssertEqual(batchUpdateTransaction.mode, 2); // Check mode is cancelled
        [expectation fulfill];
    });

    [self waitForExpectationsWithTimeout:30 handler:nil];
}

- (void)test_withDataSourceChangeTransaction_thatAllStubbedMethodsNoOpCorrectly {
    IGListDataSourceChangeTransaction *transaction = [self makeDataSourceChangeTransaction];

    XCTAssertFalse([transaction cancel]);

    NSIndexPath *from = [NSIndexPath indexPathForItem:0 inSection:0];
    NSIndexPath *to = [NSIndexPath indexPathForItem:0 inSection:1];

    [transaction insertItemsAtIndexPaths:@[]];
    [transaction deleteItemsAtIndexPaths:@[]];
    [transaction moveItemFromIndexPath:from toIndexPath:to];
    [transaction reloadSections:[NSIndexSet indexSet]];
}

- (void)test_withReloadTransaction_thatAllStubbedMethodsNoOpCorrectly {
    IGListReloadTransaction *transaction = [self makeReloadTransaction];

    XCTAssertFalse([transaction cancel]);

    NSIndexPath *from = [NSIndexPath indexPathForItem:0 inSection:0];
    NSIndexPath *to = [NSIndexPath indexPathForItem:0 inSection:1];

    [transaction insertItemsAtIndexPaths:@[]];
    [transaction deleteItemsAtIndexPaths:@[]];
    [transaction moveItemFromIndexPath:from toIndexPath:to];
    [transaction reloadSections:[NSIndexSet indexSet]];
}

@end
