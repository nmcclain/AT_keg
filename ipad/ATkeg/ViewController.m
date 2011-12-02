//
//  ViewController.m
//  ATkeg
//
//  Created by Ned McClain on 11/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController
@synthesize keg1temp;
@synthesize keg1pints;
@synthesize navBar;
@synthesize  responseData;

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
    [self setKeg1temp:nil];
    [self setKeg1pints:nil];
    [self setNavBar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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

- (IBAction)refreshPushed:(id)sender {
    NSLog(@"Refresh pushed!");
    
    
    self.navBar.topItem.title = @"Loading...";
    
    // fetch the data
    NSError        *error = nil;
    NSURLResponse  *response = nil;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://bull/kegbot/check.php"]];
    self.responseData = [NSURLConnection sendSynchronousRequest:request returningResponse: &response error: &error];
    if (error) { NSLog(@"Handle this fetch error.");}
    NSString       *kegdata =    [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    kegdata = @"32,32,99.96,2.65,811"; 
    //temp1,temp2,%remaining_left_side,%remaining_right_side,freemem_in_bits
    NSLog(@"kegdata: %@", kegdata);
    
    self.keg1temp.text = @"99 *F";
    self.keg1pints.text = [NSMutableString stringWithFormat:@"%@ Pints", kegdata ]; 

    self.navBar.topItem.title = @"AppliedTrust Keg Status";
    NSLog(@"Refresh finished!");
}
@end
