/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <XCTest/XCTest.h>

#import <IGListKit/IGListKit.h>

#import "IGListAdapterInternal.h"
#import "IGListAdapterUpdaterInternal.h"
#import "IGListDebugger.h"
#import "IGListMoveIndexInternal.h"
#import "IGListMoveIndexPathInternal.h"
#import "IGListTestAdapterDataSource.h"

@interface IGListDebuggerTests : XCTestCase

@end

@implementation IGListDebuggerTests

- (void)test_whenSearchingAdapterInstances_thatCorrectCountReturned {
    // purge any leftover tracking
    [IGListDebugger clear];

    UIViewController *controller = [UIViewController new];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0,320,480)
                                                          collectionViewLayout:[UICollectionViewFlowLayout new]];

    IGListTestAdapterDataSource *dataSource1 = [IGListTestAdapterDataSource new];
    dataSource1.objects = @[@1, @2, @3];
    IGListAdapter *adapter1 = [[IGListAdapter alloc] initWithUpdater:[IGListAdapterUpdater new] viewController:nil workingRangeSize:0];
    [adapter1.registeredCellIdentifiers addObject:@"IGCellIdentifier"];
    [adapter1.registeredNibNames addObject:@"IGCellNibName"];
    adapter1.collectionView = collectionView;
    adapter1.dataSource = dataSource1;

    IGListTestAdapterDataSource *dataSource2 = [IGListTestAdapterDataSource new];
    dataSource2.objects = @[@1, @2, @3];
    IGListAdapter *adapter2 = [[IGListAdapter alloc] initWithUpdater:[IGListAdapterUpdater new] viewController:controller workingRangeSize:2];
    [adapter1.registeredSupplementaryViewIdentifiers addObject:@"IGSupplementaryViewIdentifier"];
    [adapter1.registeredSupplementaryViewNibNames addObject:@"IGSupplementaryNibName"];
    adapter2.collectionView = collectionView;
    adapter2.dataSource = dataSource2;

    IGListTestAdapterDataSource *dataSource3 = [IGListTestAdapterDataSource new];
    dataSource3.objects = @[@1, @2, @3];
    IGListAdapter *adapter3 = [[IGListAdapter alloc] initWithUpdater:[IGListAdapterUpdater new] viewController:controller workingRangeSize:2];
    adapter3.previousSectionMap = [[IGListSectionMap alloc] initWithMapTable:[[NSMapTable alloc] init]];
    adapter3.collectionView = collectionView;
    adapter3.dataSource = dataSource3;

    [collectionView setNeedsLayout];
    [collectionView layoutIfNeeded];

    NSArray *descriptions = [IGListDebugger adapterDescriptions];
    XCTAssertEqual(descriptions.count, 3);
    XCTAssertTrue([[IGListDebugger dump] length] > 0);
}

@end
