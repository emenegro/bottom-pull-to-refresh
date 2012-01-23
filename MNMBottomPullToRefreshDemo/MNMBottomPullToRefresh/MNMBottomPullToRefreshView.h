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

#import <Foundation/Foundation.h>

/**
 * Enumerates control state
 */
typedef enum {
    MNMBottomPullToRefreshViewStateIdle = 0, //<! The control is invisible right after being created or after a reloading was completed
    MNMBottomPullToRefreshViewStatePull, //<! The control is becoming visible and shows "pull to refresh" message
    MNMBottomPullToRefreshViewStateRelease, //<! The control is whole visible and shows "release to load" message
    MNMBottomPullToRefreshViewStateLoading //<! The control is loading and shows activity indicator
} MNMBottomPullToRefreshViewState;

/**
 * Pull to refresh view. Its state is managed by an instance of MNMBottomPullToRefreshManager
 */
@interface MNMBottomPullToRefreshView : UIView {
@private
    /**
     * Image with the arrow that changes with states
     */
    UIImageView *arrowImageView_;
    
    /**
     * Activiry indicator to show while loading
     */
    UIActivityIndicatorView *loadingActivityIndicator_;
    
    /**
     * Label to set state message
     */
    UILabel *messageLabel_;
    
    /**
     * Current state of the control
     */
    MNMBottomPullToRefreshViewState state_;
    
    /**
     * YES to apply rotation to the arrow while view is in MNMBottomPullToRefreshViewStatePull state
     */
    BOOL rotateArrowWhileBecomingVisible_;
}

/**
 * Provides readonly access to the isLoading flag.
 * Returns YES if activity indicator is animating
 */
@property (nonatomic, readonly, assign) BOOL isLoading;

/**
 * Changes the state of the control depending on state value.
 * Receives the current ofsset of the scroll to rotate arrow
 *
 * @param state The state to set
 * @param offset The offset of the table scroll
 */
- (void)changeStateOfControl:(MNMBottomPullToRefreshViewState)state withOffset:(CGFloat)offset;

@end
