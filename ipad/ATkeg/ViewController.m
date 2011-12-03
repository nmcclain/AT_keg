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
    [self setKeg1name:nil];
    [self setKeg2name:nil];
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
	// configurables
    NSString       *kegbotURL = @"http://localhost/check.php";
    NSString       *wikiURL = @"http://camelspit.org/keg_wikipage_sample.html";
    
    //
    NSLog(@"Refresh started...");
    self.navBar.topItem.title = @"Loading...";
    
    
    NSLog(@"Fetching wiki page..."); //wikiURL
    NSError        *urlerror = nil;
    NSURLResponse  *response = nil;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:wikiURL]];
    self.responseData = [NSURLConnection sendSynchronousRequest:request returningResponse: &response error: &urlerror];
    if (urlerror) { 
        self.navBar.topItem.title = @"Error Fetching Keg Status";
        NSLog(@"Refresh from wiki failed!");
        
    } else {
        NSString       *kegdata =    [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
        NSLog(@"got the wiki page! %@", kegdata);
        
        NSError *matchError = nil;
        // match the table we care about
        NSRegularExpression* regex = [[NSRegularExpression alloc] initWithPattern:@"Currently on Tap(.*)</table>" options:NSRegularExpressionDotMatchesLineSeparators error:&matchError];
        NSString *kegOnTapTable = @"";
        NSRange rangeOfFirstMatch = [regex rangeOfFirstMatchInString:kegdata options:0 range:NSMakeRange(0, [kegdata length])];
        if (NSEqualRanges(rangeOfFirstMatch, NSMakeRange(NSNotFound, 0))) {
            NSLog(@"error matching the kegOnTapTable in the keg wiki page! %@", kegdata);

        } else {
            kegOnTapTable = [kegdata substringWithRange:rangeOfFirstMatch];
            NSLog(@"got the kegOnTapTable! %@", kegOnTapTable);
            
        }
        
        // match the stuff inside
        /*
        regex = [[NSRegularExpression alloc] initWithPattern:@"Currently on Tap(.*)</table><hr />" options:NSRegularExpressionCaseInsensitive error:nil];
        NSString *kegOnTapTable = @"";
        NSRange rangeOfFirstMatch = [regex rangeOfFirstMatchInString:kegdata options:0 range:NSMakeRange(0, [kegdata length])];
        if (!NSEqualRanges(rangeOfFirstMatch, NSMakeRange(NSNotFound, 0))) {
            kegOnTapTable = [kegdata substringWithRange:rangeOfFirstMatch];
        }*/
        
        
        NSLog(@"got the wiki data! %@", kegOnTapTable);
    }
    
    /*
    NSLog(@"Fetching arduino data...");

    // fetch the data
    urlerror = nil;
    response = nil;
    request = [NSURLRequest requestWithURL:[NSURL URLWithString:kegbotURL]];
    self.responseData = [NSURLConnection sendSynchronousRequest:request returningResponse: &response error: &urlerror];
    urlerror = nil; // XXX remove this after debugging
    if (urlerror) { 
        self.navBar.topItem.title = @"Error Fetching Keg Status";
        NSLog(@"Refresh from arduino failed!");

    } else {
        NSString       *kegdata =    [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
        kegdata = @"32,31.5,99.96,2.65,811"; // XXX remove this after debugging

        //NSLog(@"kegdata: %@", kegdata);
        //temp1,temp2,%remaining_left_side,%remaining_right_side,freemem_in_bits    
        NSArray* kegdataparts = [kegdata componentsSeparatedByString: @","];
    
        self.keg1temp.text = [NSMutableString stringWithFormat:@"%@ \u00B0F", [kegdataparts objectAtIndex: 0] ]; 
        self.keg1pct.text = [NSMutableString stringWithFormat:@"%@ %%", [kegdataparts objectAtIndex: 2] ]; 
        self.keg2temp.text = [NSMutableString stringWithFormat:@"%@ \u00B0F", [kegdataparts objectAtIndex: 1] ]; 
        self.keg2pct.text = [NSMutableString stringWithFormat:@"%@ %%", [kegdataparts objectAtIndex: 3] ]; 

        NSLog(@"got the arduino data!");

    }
     
     */
    self.navBar.topItem.title = @"AppliedTrust Keg Status";
    NSLog(@"Refresh finished!");
    
}

@end
