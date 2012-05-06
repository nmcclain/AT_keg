//
//  ViewController.m
//  ATkeg
//
//  Created by Ned McClain on 11/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController
@synthesize keg1name;
@synthesize keg1temp;
@synthesize keg1pct;
@synthesize keg2name;
@synthesize keg2temp;
@synthesize keg2pct;
@synthesize navBar;
@synthesize keg1desc;
@synthesize keg2desc;
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
    [self doKegDataRefresh ];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshView:) name:@"refreshView" object:nil];
}

-(void)refreshView:(NSNotification *) notification {
    [self doKegDataRefresh ];

}

- (void)viewDidUnload
{
    [self setKeg1temp:nil];
    [self setKeg1pct:nil];
    [self setNavBar:nil];
    [self setKeg2temp:nil];
    [self setKeg2pct:nil];
    [self setKeg1name:nil];
    [self setKeg2name:nil];
    [self setKeg1desc:nil];
    [self setKeg2desc:nil];
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
    [self doKegDataRefresh ];
}



- (void)doKegDataRefresh
{
	// configurables
    NSString       *kegbotURL = @"http://bull.atrust.com/kegbot/check.php";
    NSString       *wikiURL = @"http://bajafur.atrust.com/keg_wikidata.php";
    
    // NSLog(@"Refresh started...");
    self.navBar.topItem.title = @"Loading...";
    
    // first, the data from our wiki
    // NSLog(@"Fetching wiki page..."); //wikiURL
    NSError* urlerror = nil;
    
    NSString* kegdata = [NSString stringWithContentsOfURL:[NSURL URLWithString:wikiURL] encoding:NSASCIIStringEncoding error:&urlerror];
    if(!kegdata )    {
        //NSLog(@"error fetching the keg wiki page!");
        self.navBar.topItem.title = @"error fetching the keg wiki page!";
        return; 
    }

    NSArray* kegdataparts = [kegdata componentsSeparatedByString: @","];
    self.keg1name.text = [NSMutableString stringWithFormat:@"%@", [kegdataparts objectAtIndex: 0] ]; 
    self.keg1desc.text = [NSMutableString stringWithFormat:@"%@", [kegdataparts objectAtIndex: 2] ]; 
    self.keg2name.text = [NSMutableString stringWithFormat:@"%@", [kegdataparts objectAtIndex: 1] ]; 
    self.keg2desc.text = [NSMutableString stringWithFormat:@"%@", [kegdataparts objectAtIndex: 3] ]; 
    // NSLog(@"got the wiki data!");
    
    // NSLog(@"Fetching arduino data...");
    // fetch the data
    kegdata = [NSString stringWithContentsOfURL:[NSURL URLWithString:kegbotURL] encoding:NSASCIIStringEncoding error:&urlerror];
    if(!kegdata )    {
        //NSLog(@"error fetching the keg wiki page!");
        self.navBar.topItem.title = @"error fetching the keg arduino data!";
        return; 
    }
    //temp1,temp2,%remaining_left_side,%remaining_right_side,freemem_in_bits    
    kegdataparts = [kegdata componentsSeparatedByString: @","];
    self.keg1temp.text = [NSMutableString stringWithFormat:@"%@ \u00B0F", [kegdataparts objectAtIndex: 0] ]; 
    self.keg1pct.text = [NSMutableString stringWithFormat:@"%@ %%", [kegdataparts objectAtIndex: 2] ]; 
    self.keg2temp.text = [NSMutableString stringWithFormat:@"%@ \u00B0F", [kegdataparts objectAtIndex: 1] ]; 
    self.keg2pct.text = [NSMutableString stringWithFormat:@"%@ %%", [kegdataparts objectAtIndex: 3] ]; 
    // NSLog(@"got the arduino data!");
    
    self.navBar.topItem.title = @"AppliedTrust Keg Status";
    // NSLog(@"Refresh finished!");

}

@end
