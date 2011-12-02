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
@synthesize keg1pct;
@synthesize keg2temp;
@synthesize keg2pct;
@synthesize navBar;
@synthesize responseData;

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
    [self setKeg1pct:nil];
    [self setNavBar:nil];
    [self setKeg2temp:nil];
    [self setKeg2pct:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self doKegDataRefresh ];

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
    [self doKegDataRefresh ];
}

- (void)doKegDataRefresh
{
	//
    NSLog(@"Refresh started...");
    self.navBar.topItem.title = @"Loading...";
    
    // fetch the data
    NSError        *urlerror = nil;
    NSURLResponse  *response = nil;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://bull/kegbot/check.php"]];
    self.responseData = [NSURLConnection sendSynchronousRequest:request returningResponse: &response error: &urlerror];
    //urlerror = nil; // XXX remove this after debugging
    if (urlerror) { 
        NSLog(@"Handle this fetch error.");
        self.navBar.topItem.title = @"Error Fetching Keg Status";

    } else {
        NSString       *kegdata =    [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
       // kegdata = @"32,31.5,99.96,2.65,811"; // XXX remove this after debugging

        //temp1,temp2,%remaining_left_side,%remaining_right_side,freemem_in_bits
        NSLog(@"kegdata: %@", kegdata);
    
    /*
     NSRegularExpression *regex = [NSRegularExpression 
     regularExpressionWithPattern:@"^...."
     options:0
     error:&error];
     
     NSRange range   = [regex rangeOfFirstMatchInString:kegdata options:0 range:NSMakeRange(0, [kegdata length])];
     NSString *output = [kegdata substringWithRange:range];
     NSLog(@"parse result: %@", output);
     */
    
    NSArray* kegdataparts = [kegdata componentsSeparatedByString: @","];
    
    /*
     NSLog(@"temp1: %@", [kegdataparts objectAtIndex: 0]);
     NSLog(@"temp2: %@", [kegdataparts objectAtIndex: 1]);
     NSLog(@"pct_remaining_left_side: %@", [kegdataparts objectAtIndex: 2]);
     NSLog(@"pct_remaining_right_side: %@", [kegdataparts objectAtIndex: 3]);
     */
    
    self.keg1temp.text = [NSMutableString stringWithFormat:@"%@ *F", [kegdataparts objectAtIndex: 0] ]; 
    self.keg1pct.text = [NSMutableString stringWithFormat:@"%@ %%", [kegdataparts objectAtIndex: 2] ]; 
    self.keg2temp.text = [NSMutableString stringWithFormat:@"%@ *F", [kegdataparts objectAtIndex: 1] ]; 
    self.keg2pct.text = [NSMutableString stringWithFormat:@"%@ %%", [kegdataparts objectAtIndex: 3] ]; 
    
        self.navBar.topItem.title = @"AppliedTrust Keg Status";
    }
    NSLog(@"Refresh finished!");
}


@end
