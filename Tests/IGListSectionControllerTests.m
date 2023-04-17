/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <XCTest/XCTest.h>

#import <IGListKit/IGListSectionController.h>

@interface IGListSectionControllerTests : XCTestCase

@end

@implementation IGListSectionControllerTests

- (void)test_withBaseSectionContoller_thatDefaultValuesAreCorrect {
    NSObject *object = [NSObject new];
    IGListSectionController *sectionController = [[IGListSectionController alloc] init];
    XCTAssertNotNil(sectionController);

    XCTAssertEqual([sectionController numberOfItems], 1);
    XCTAssertTrue(CGSizeEqualToSize([sectionController sizeForItemAtIndex:0], CGSizeZero));
    XCTAssertTrue([sectionController shouldSelectItemAtIndex:0]);
    XCTAssertTrue([sectionController shouldDeselectItemAtIndex:0]);
    XCTAssertFalse([sectionController canMoveItemAtIndex:0]);

    [sectionController didUpdateToObject:object];

    [sectionController didSelectItemAtIndex:0];
    [sectionController didDeselectItemAtIndex:0];
    [sectionController didHighlightItemAtIndex:0];
    [sectionController didUnhighlightItemAtIndex:0];

#if !defined(NS_BLOCK_ASSERTIONS) || !defined(BUCK_BUILD)
    XCTAssertThrows([sectionController cellForItemAtIndex:0]);
    XCTAssertThrows([sectionController moveObjectFromIndex:0 toIndex:1]);
#else
    [sectionController cellForItemAtIndex:0];
    [sectionController moveObjectFromIndex:0 toIndex:1];
#endif
}

@end
