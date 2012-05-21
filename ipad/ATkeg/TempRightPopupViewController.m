//
//  TempRightPopupViewController.m
//  ATkeg
//
//  Created by Ned McClain on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TempRightPopupViewController.h"

@implementation TempRightPopupViewController
@synthesize TempRightImage;
@synthesize kegImageWebRequest;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
}


- (void)viewDidUnload
{
    [self setTempRightImage:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    self.kegImageWebRequest = [SMWebRequest requestWithURL:[NSURL URLWithString:@"http://prettygraph.com/blog/wp-content/themes/prettygraph/images/graph1.gif"]];
    [kegImageWebRequest addTarget:self action:@selector(kegWebRequestComplete:) forRequestEvents:SMWebRequestEventComplete];
    [kegImageWebRequest start];
}
- (void)kegWebRequestComplete:(NSData *)responseData {
    if(!responseData )    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Error fetching keg data." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alertView show];
        
        
        return;
    }
    
    self.TempRightImage.image = [UIImage imageWithData:responseData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}


@end
