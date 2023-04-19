/**
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <XCTest/XCTest.h>

#import "IGTestCell.h"
#import "IGListTestCase.h"
#import "IGListAdapterInternal.h"
#import "IGTestCell.h"
#import "IGListBindingSingleSectionController.h"
#import "IGTestBindingSingleItemDataSource.h"

@interface IGListBindingSingleSectionControllerTests : IGListTestCase

@end

@implementation IGListBindingSingleSectionControllerTests

- (void)setUp {
    self.dataSource = [IGTestBindingSingleItemDataSource new];
    self.frame = CGRectMake(0, 0, 100, 1000);
    [super setUp];
}

- (void)test_withDefaultClass_thatCellOverrideMethodsFallThroughCorrectly {
    IGListBindingSingleSectionController *controller = [IGListBindingSingleSectionController new];

    id<IGListDiffable> viewModel = genTestObject(@1, @"Foo");

    UICollectionViewCell *cell = [UICollectionViewCell new];
    XCTAssertNoThrow([controller didSelectItemWithCell:cell]);
    XCTAssertNoThrow([controller didDeselectItemWithCell:cell]);
    XCTAssertNoThrow([controller didHighlightItemWithCell:cell]);
    XCTAssertNoThrow([controller didUnhighlightItemWithCell:cell]);

    @try {
        [controller cellClass];
    } @catch (NSException *e) {}

    @try {
        [controller configureCell:cell withViewModel:viewModel];
    } @catch (NSException *e) {}

    @try {
        [controller sizeForViewModel:viewModel];
    } @catch (NSException *e) {}
}

- (void)test_whenSetupWithObjects_collectionViewHasSections {
    [self setupWithObjects:@[
                             genTestObject(@1, @"Foo"),
                             genTestObject(@2, @"Bar"),
                             genTestObject(@3, @"Baz"),
                             ]];
    XCTAssertEqual([self.collectionView numberOfSections], 3);
    XCTAssertEqual([self.collectionView numberOfItemsInSection:0], 1);
    XCTAssertEqual([self.collectionView numberOfItemsInSection:1], 1);
    XCTAssertEqual([self.collectionView numberOfItemsInSection:2], 1);
}

- (void)test_whenSetupWithObjects_sizeIsCalled {
    [self setupWithObjects:@[
                             genTestObject(@1, @"Foo"),
                             genTestObject(@2, @"Bar"),
                             genTestObject(@3, @"Baz"),
                             ]];
    IGTestCell *cell1 = (IGTestCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    IGTestCell *cell2 = (IGTestCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]];
    IGTestCell *cell3 = (IGTestCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:2]];

    // Check the size is set in `IGTestBindingSingleSectionController`
    XCTAssertEqual(cell1.frame.size.height, 44);
    XCTAssertEqual(cell2.frame.size.height, 44);
    XCTAssertEqual(cell3.frame.size.height, 44);
    XCTAssertEqual(cell1.frame.size.width, 100);
    XCTAssertEqual(cell2.frame.size.width, 100);
    XCTAssertEqual(cell3.frame.size.width, 100);
}

- (void)test_whenSetupWithObjects_cellsAreConfigured {
    [self setupWithObjects:@[
                             genTestObject(@1, @"Foo"),
                             genTestObject(@2, @"Bar"),
                             genTestObject(@3, @"Baz"),
                             ]];
    IGTestCell *cell1 = (IGTestCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    IGTestCell *cell2 = (IGTestCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]];
    IGTestCell *cell3 = (IGTestCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:2]];

    // Check the cell is configured in `IGTestBindingSingleSectionController`
    XCTAssertEqualObjects(cell1.label.text, @"Foo");
    XCTAssertEqualObjects(cell2.label.text, @"Bar");
    XCTAssertEqualObjects(cell3.label.text, @"Baz");
}

- (void)test_whenSetupWithObjects_cellClassIsExpected {
    [self setupWithObjects:@[
                             genTestObject(@1, @"Foo"),
                             genTestObject(@2, @"Bar"),
                             genTestObject(@3, @"Baz"),
                             ]];
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    XCTAssertTrue([cell isKindOfClass:[IGTestCell class]]);

}

- (void)test_whenDidSelectIsCalled_subclassIsCalled {
    [self setupWithObjects:@[
                             genTestObject(@1, @"Foo"),
                             ]];
    IGListSectionController *controller = [self.adapter sectionControllerForSection:0];
    [controller didSelectItemAtIndex:0];
    IGTestCell *cell1 = (IGTestCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];

    // Check the cell is being displayed
    IGListBindingSingleSectionController *singleSectionController = (IGListBindingSingleSectionController *)controller;
    XCTAssertTrue([singleSectionController isDisplayingCell]);

    // Check the cell label is updated in `IGTestBindingSingleSectionController`
    XCTAssertEqualObjects(cell1.label.text, @"did-select");
}

- (void)test_whenDidDeselectIsCalled_subclassIsCalled {
    [self setupWithObjects:@[
                             genTestObject(@1, @"Foo"),
                             ]];
    IGListSectionController *controller = [self.adapter sectionControllerForSection:0];
    [controller didDeselectItemAtIndex:0];
    IGTestCell *cell1 = (IGTestCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];

    // Check the cell label is updated in `IGTestBindingSingleSectionController`
    XCTAssertEqualObjects(cell1.label.text, @"did-deselect");
}

- (void)test_whenDidHighlightIsCalled_subclassIsCalled {
    [self setupWithObjects:@[
                             genTestObject(@1, @"Foo"),
                             ]];
    IGListSectionController *controller = [self.adapter sectionControllerForSection:0];
    [controller didHighlightItemAtIndex:0];
    IGTestCell *cell1 = (IGTestCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];

    // Check the cell label is updated in `IGTestBindingSingleSectionController`
    XCTAssertEqualObjects(cell1.label.text, @"did-highlight");
}

- (void)test_whenDidUnhighlightIsCalled_subclassIsCalled {
    [self setupWithObjects:@[
                             genTestObject(@1, @"Foo"),
                             ]];
    IGListSectionController *controller = [self.adapter sectionControllerForSection:0];
    [controller didUnhighlightItemAtIndex:0];
    IGTestCell *cell1 = (IGTestCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];

    // Check the cell label is updated in `IGTestBindingSingleSectionController`
    XCTAssertEqualObjects(cell1.label.text, @"did-unhighlight");
}

@end
