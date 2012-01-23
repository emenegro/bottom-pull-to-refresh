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

#import "MNMBottomPullToRefreshView.h"

/**
 * Defines the localized strings table
 */
#define MNM_BOTTOM_PTR_LOCALIZED_STRINGS_TABLE                          @"MNMBottomPullToRefresh"

/**
 * Texts to show in different states
 */
#define MNM_BOTTOM_PTR_PULL_TEXT_KEY                                    @"MNM_BOTTOM_PTR_PULL_TEXT"
#define MNM_BOTTOM_PTR_RELEASE_TEXT_KEY                                 @"MNM_BOTTOM_PTR_RELEASE_TEXT"
#define MNM_BOTTOM_PTR_LOADING_TEXT_KEY                                 @"MNM_BOTTOM_PTR_LOADING_TEXT"

/**
 * Defines arrow image
 */
#define MNM_BOTTOM_PTR_ARROW_BOTTOM_IMAGE                               @"MNMBottomPullToRefreshArrow.png"

@implementation MNMBottomPullToRefreshView

@dynamic isLoading;

#pragma mark -
#pragma mark Memory management

/**
 * Deallocates used memory
 */
- (void)dealloc {
    [arrowImageView_ release];
    arrowImageView_ = nil;
    
    [loadingActivityIndicator_ release];
    loadingActivityIndicator_ = nil;
    
    [messageLabel_ release];
    messageLabel_ = nil;
    
    [super dealloc];
}

#pragma mark -
#pragma mark Initialization

/**
 * Initializes and returns a newly allocated view object with the specified frame rectangle.
 *
 * @param aRect: The frame rectangle for the view, measured in points.
 * @return An initialized view object or nil if the object couldn't be created.
 */
- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithWhite:0.75f alpha:1.0f];        
        
        UIImage *arrowImage = [UIImage imageNamed:MNM_BOTTOM_PTR_ARROW_BOTTOM_IMAGE];
        
        arrowImageView_ = [[UIImageView alloc] initWithFrame:CGRectMake(30.0f, round(CGRectGetHeight(frame) / 2.0f) - round(arrowImage.size.height / 2.0f), arrowImage.size.width, arrowImage.size.height)];
        arrowImageView_.contentMode = UIViewContentModeCenter;
        arrowImageView_.image = arrowImage;
        
        [self addSubview:arrowImageView_];
        
        loadingActivityIndicator_ = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        loadingActivityIndicator_.center = arrowImageView_.center;
        loadingActivityIndicator_.hidesWhenStopped = YES;
        
        [self addSubview:loadingActivityIndicator_];
        
        messageLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(arrowImageView_.frame) + 20.0f, 10.0f, CGRectGetWidth(frame) - CGRectGetMaxX(arrowImageView_.frame) - 40.0f, CGRectGetHeight(frame) - 20.0f)];
        messageLabel_.backgroundColor = [UIColor clearColor];
        messageLabel_.textColor = [UIColor whiteColor];
        
        [self addSubview:messageLabel_];
        
        rotateArrowWhileBecomingVisible_ = YES;
        
        [self changeStateOfControl:MNMBottomPullToRefreshViewStateIdle withOffset:CGFLOAT_MAX];
    }
    
    return self;
}

#pragma mark -
#pragma mark Visuals

/*
 * Changes the state of the control depending on state_ value
 */
- (void)changeStateOfControl:(MNMBottomPullToRefreshViewState)state withOffset:(CGFloat)offset {
    
    state_ = state;
    
    switch (state_) {
        
        case MNMBottomPullToRefreshViewStateIdle: {
            
            arrowImageView_.transform = CGAffineTransformIdentity;
            arrowImageView_.hidden = NO;
            
            [loadingActivityIndicator_ stopAnimating];
            
            messageLabel_.text = NSLocalizedStringFromTable(MNM_BOTTOM_PTR_PULL_TEXT_KEY, MNM_BOTTOM_PTR_LOCALIZED_STRINGS_TABLE, nil);
            
            break;
            
        } case MNMBottomPullToRefreshViewStatePull: {
            
            if (rotateArrowWhileBecomingVisible_) {
            
                CGFloat angle = (-offset * M_PI) / CGRectGetHeight(self.frame);
                
                arrowImageView_.transform = CGAffineTransformRotate(CGAffineTransformIdentity, angle);
                
            } else {
            
                arrowImageView_.transform = CGAffineTransformIdentity;
            }
            
            messageLabel_.text = NSLocalizedStringFromTable(MNM_BOTTOM_PTR_PULL_TEXT_KEY, MNM_BOTTOM_PTR_LOCALIZED_STRINGS_TABLE, nil);
            
            break;
            
        } case MNMBottomPullToRefreshViewStateRelease: {
            
            arrowImageView_.transform = CGAffineTransformMakeRotation(M_PI);
            
            messageLabel_.text = NSLocalizedStringFromTable(MNM_BOTTOM_PTR_RELEASE_TEXT_KEY, MNM_BOTTOM_PTR_LOCALIZED_STRINGS_TABLE, nil);
            
            break;
            
        } case MNMBottomPullToRefreshViewStateLoading: {
            
            arrowImageView_.hidden = YES;
            
            [loadingActivityIndicator_ startAnimating];
            
            messageLabel_.text = NSLocalizedStringFromTable(MNM_BOTTOM_PTR_LOADING_TEXT_KEY, MNM_BOTTOM_PTR_LOCALIZED_STRINGS_TABLE, nil);
            
            break;
            
        } default:
            break;
    }
}

#pragma mark -
#pragma mark Properties

/**
 * Returns state of activity indicator
 *
 * @return YES if activity indicator is animating
 */
- (BOOL)isLoading {
    return loadingActivityIndicator_.isAnimating;
}

@end
