/*
 * Copyright (c) 2012 Mario Negro Martín
 * 
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 * 
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. 
 */

#import "MNMBPTRViewController.h"

@interface MNMBPTRViewController()

/**
 * Loads the table
 *
 * @private
 */
- (void)loadTable;

@end

@implementation MNMBPTRViewController

@synthesize table = table_;

#pragma mark -
#pragma mark View cycle

/**
 * Called after the controller’s view is loaded into memory.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    reloads_ = -1;
    
    pullToRefreshManager_ = [[MNMBottomPullToRefreshManager alloc] initWithPullToRefreshViewHeight:60.0f tableView:table_ withClient:self];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self loadTable];
}

#pragma mark -
#pragma mark Aux view methods

/*
 * Loads the table
 */
- (void)loadTable {
    
    reloads_++;
    
    [table_ reloadData];
    
    [pullToRefreshManager_ tableViewReloadFinished];
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    [pullToRefreshManager_ relocatePullToRefreshView];
}

#pragma mark -
#pragma mark UITableView methods

/**	
 * Asks the data source to return the number of sections in the table view
 *
 * @param An object representing the table view requesting this information.
 * @return The number of sections in tableView.
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

/**
 * Asks the data source for a cell to insert in a particular location of the table view
 *
 * @param tableView: A table-view object requesting the cell.
 * @param indexPath: An index path locating a row in tableView.
 * @return An object inheriting from UITableViewCellthat the table view can use for the specified row.
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *identifier = @"CellIdentifier";
    UITableViewCell* result = [tableView dequeueReusableCellWithIdentifier:identifier];
	
	if (result == nil) {
        
        result = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];        
        result.selectionStyle = UITableViewCellSelectionStyleNone;
        result.textLabel.backgroundColor = [UIColor clearColor];
    }
    
    result.textLabel.text = [NSString stringWithFormat:@"Row %i", indexPath.row];
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:result.frame];
    
    if (indexPath.row % 2 == 0) {
        
        backgroundView.backgroundColor = [UIColor colorWithWhite:0.8f alpha:1.0f];
        
    } else {
        
        backgroundView.backgroundColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
    }
    
    result.backgroundView = backgroundView;    
        
    return result;
}

/**
 * Tells the data source to return the number of rows in a given section of a table view
 *
 * @param tableView: The table-view object requesting this information.
 * @param section: An index number identifying a section in tableView.
 * @return The number of rows in section.
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5 + (5 * reloads_);
}

/**
 * Asks the delegate for the height to use for a row in a specified location.
 * 
 * @param The table-view object requesting this information.
 * @param indexPath: An index path that locates a row in tableView.
 * @return A floating-point value that specifies the height (in points) that row should be.
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return tableView.rowHeight;
}

#pragma mark -
#pragma mark MNMBottomPullToRefreshManagerClient

/**
 * This is the same delegate method as UIScrollView but required in MNMBottomPullToRefreshManagerClient protocol
 * to warn about its implementation. Here you have to call [MNMBottomPullToRefreshManager tableViewScrolled]
 *
 * Tells the delegate when the user scrolls the content view within the receiver.
 *
 * @param scrollView: The scroll-view object in which the scrolling occurred.
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [pullToRefreshManager_ tableViewScrolled];
}

/**
 * This is the same delegate method as UIScrollView but required in MNMBottomPullToRefreshClient protocol
 * to warn about its implementation. Here you have to call [MNMBottomPullToRefreshManager tableViewReleased]
 *
 * Tells the delegate when dragging ended in the scroll view.
 *
 * @param scrollView: The scroll-view object that finished scrolling the content view.
 * @param decelerate: YES if the scrolling movement will continue, but decelerate, after a touch-up gesture during a dragging operation.
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [pullToRefreshManager_ tableViewReleased];
}

/**
 * Tells client that refresh has been triggered
 * After reloading is completed must call [MNMBottomPullToRefreshManager tableViewReloadFinished]
 *
 * @param manager PTR manager
 */
- (void)bottomPullToRefreshTriggered:(MNMBottomPullToRefreshManager *)manager {
    
    [self performSelector:@selector(loadTable) withObject:nil afterDelay:1.0f];
}

@end