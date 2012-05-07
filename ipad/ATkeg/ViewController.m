//
//  ViewController.m
//  ATkeg
//
//  Created by Ned McClain on 11/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "SMWebRequest.h"
#import "SBJson.h"

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
@synthesize kegWebRequest;

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(webRequestError:) name:kSMWebRequestError object:nil];


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
    
    [UIScreen mainScreen].brightness = 0.5;
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


- (void)kegWebRequestComplete:(NSData *)responseData {
    if(!responseData )    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Error fetching keg data." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alertView show];
        
        self.navBar.topItem.title = @"Error fetching Keg Status";
        return;
    }
    
    // [UIScreen mainScreen].brightness = 0.5;
    
    NSString *MyString;
	NSDate *now = [NSDate date];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
	MyString = [dateFormatter stringFromDate:now];
    
    self.navBar.topItem.title = @"On Tap @ AppliedTrust - Monday, May 6, 2012";
    
    return;
}


- (void)doKegDataRefresh
{
	// configurables
    NSString       *kegbotURL = @"http://bull.atrust.com/kegbot/check.php";
    NSString       *wikiURL = @"http://bajafur.atrust.com/keg_wikidata.php";
    
    // NSLog(@"Refresh started...");
    self.navBar.topItem.title = @"Loading...";
    
    self.kegWebRequest = [SMWebRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.camelspit.org/atguest/api/?seallist"]]];
    [kegWebRequest addTarget:self action:@selector(kegWebRequestComplete:) forRequestEvents:SMWebRequestEventComplete];
    [kegWebRequest start];
    
    
    
}

@end
