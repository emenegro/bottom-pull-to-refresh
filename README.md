MNMBottomPullToRefresh is a solution to add pull-to-refresh feature to the bottom of an UITableView instead of the top, as usual. This view can be used to retrieve more values, or pages, of a large list.

This solution has its basis on the Mediator design pattern (http://en.wikipedia.org/wiki/Mediator_pattern). `MNMBottomPullToRefreshManager` acts as a Mediator between the pull-to-refresh view and its container table view, decoupling the view and the scroll management.

In order to maintain this decoupling, there is no `UITableView` subclass, allowing developers to add this behavior as an aggregate of its own subclasses of `UITableView` without creating an intermediate class or adding directly in the UIViewController that manages table delegate and data source.

Installation instructions:
-------------------------

1) Copy the whole `MNMBottomPullToRefresh` folder into your project

2) In your UIViewController class, create a `MNMBottomPullToRefreshManager` to link an `UITableView` and the `MNMPullToRefreshView`. Use a sentence like this:

       pullToRefreshManager_ = [[MNMBottomPullToRefreshManager alloc] initWithPullToRefreshViewHeight:60.0f
                                                                                            tableView:table_
                                                                                           withClient:self];
    
3) Implement `MNMBottomPullToRefreshManagerClient` selectors on your UIViewController in order to inform to delegate about the correct offset of the table

4) You can see a this usage in `MNMBPTRViewController`

Documentation
=============

1) Execute  `appledoc appledoc.plist` in the root of the project path to generate documentation. 