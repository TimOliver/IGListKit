/*
 * Copyright (c) Meta Platforms, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <XCTest/XCTest.h>

#import <IGListDiffKit/IGListDiff.h>
#import <IGListDiffKit/IGListBatchUpdateData.h>

#import "IGListMoveIndexInternal.h"
#import "IGListMoveIndexPathInternal.h"
#import "IGListIndexPathResultInternal.h"
#import "IGListIndexSetResultInternal.h"

@interface IGListDiffDescriptionStringTests : XCTestCase

@end

@implementation IGListDiffDescriptionStringTests

- (void)test_withBatchUpdateData_thatDescriptionStringIsValid {
    NSMutableIndexSet *insertSections = [NSMutableIndexSet indexSet];
    [insertSections addIndex:0];
    [insertSections addIndex:1];
    
    NSIndexSet *deleteSections = [NSIndexSet indexSetWithIndex:5];
    IGListMoveIndex *moveSections = [[IGListMoveIndex alloc] initWithFrom:3 to:4];
    NSIndexPath *insertIndexPaths = [NSIndexPath indexPathForRow:0 inSection:0];
    NSIndexPath *deleteIndexPaths = [NSIndexPath indexPathForRow:0 inSection:0];
    IGListMoveIndexPath *moveIndexPaths = [[IGListMoveIndexPath alloc] initWithFrom:[NSIndexPath indexPathForRow:0 inSection:6]
                                                                                 to:[NSIndexPath indexPathForRow:1 inSection:6]];
    
    IGListBatchUpdateData *result = [[IGListBatchUpdateData alloc] initWithInsertSections:insertSections
                                                                           deleteSections:deleteSections
                                                                             moveSections:[NSSet setWithObject:moveSections]
                                                                         insertIndexPaths:@[insertIndexPaths]
                                                                         deleteIndexPaths:@[deleteIndexPaths]
                                                                         updateIndexPaths:@[]
                                                                           moveIndexPaths:@[moveIndexPaths]];
    NSString *expectedDescription = [NSString stringWithFormat:@"<IGListBatchUpdateData %p; "
                                                                "deleteSections: 1; "
                                                                "insertSections: 2; "
                                                                "moveSections: 1; "
                                                                "deleteIndexPaths: 1; "
                                                                "insertIndexPaths: 1; "
                                                                "updateIndexPaths: 0>", result];
    XCTAssertTrue([result.description isEqualToString:expectedDescription]);
}

@end
