//
//  FirstViewController.m
//  MNMBottomPullToRefreshDemo
//
//  Created by Andrew Romanov on 05.04.13.
//
//

#import "FirstViewController.h"
#import "MNMBPTRViewController.h"

@interface FirstViewController ()

- (IBAction)pushAction:(id)sender;

@end

@implementation FirstViewController

+ (FirstViewController*)controller
{
	FirstViewController* controller = [[FirstViewController alloc] initWithNibName:@"FirstViewController" bundle:nil];
	return controller;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	self.title = @"First";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Actions
- (IBAction)pushAction:(id)sender
{
	MNMBPTRViewController* controller = [MNMBPTRViewController controller];
	[self.navigationController pushViewController:controller animated:YES];
}


@end
