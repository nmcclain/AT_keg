//
//  ViewController.m
//  ATkeg
//
//  Created by Ned McClain on 11/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "SMWebRequest.h"
#import "SBJson.h"

@implementation MainViewController
@synthesize mainView;
@synthesize navBar;

@synthesize kegWebRequest;
@synthesize kegImageLeftWebRequest;
@synthesize kegImageRightWebRequest;

@synthesize leftKegName;
@synthesize leftKegType;
@synthesize leftKegABV;
@synthesize leftKegBrewer;
@synthesize leftKegDesc;
@synthesize leftKegPct;
@synthesize leftKegTemp;
@synthesize leftKegImage;
@synthesize rightKegName;
@synthesize rightKegType;
@synthesize rightKegABV;
@synthesize rightKegBrewer;
@synthesize rightKegDesc;
@synthesize rightKegPct;
@synthesize rightKegTemp;
@synthesize rightKegImage;

NSDate *lasttouch;
int const ScreenDimSeconds = 300;

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

    lasttouch = [NSDate date];
    
    /*
     UITapGestureRecognizer *tapRecognizer =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    [tapRecognizer setNumberOfTapsRequired:1];
    [tapRecognizer setNumberOfTouchesRequired:1];
    [[self view] addGestureRecognizer:tapRecognizer];
     */
    
    UISwipeGestureRecognizer *oneFingerSwipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDetected:)];
    [oneFingerSwipeRight setDirection: UISwipeGestureRecognizerDirectionRight];
    [[self view] addGestureRecognizer:oneFingerSwipeRight];
    UISwipeGestureRecognizer *oneFingerSwipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDetected:)];
    [oneFingerSwipeLeft setDirection: UISwipeGestureRecognizerDirectionLeft];
    [[self view] addGestureRecognizer:oneFingerSwipeLeft];
    UISwipeGestureRecognizer *oneFingerSwipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDetected:)];
    [oneFingerSwipeUp setDirection: UISwipeGestureRecognizerDirectionUp];
    [[self view] addGestureRecognizer:oneFingerSwipeUp];
    UISwipeGestureRecognizer *oneFingerSwipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDetected:)];
    [oneFingerSwipeDown setDirection: UISwipeGestureRecognizerDirectionDown];
    [[self view] addGestureRecognizer:oneFingerSwipeDown];
    
    UITapGestureRecognizer *adminSwipeGestureRecognizer =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(adminTapDetected:)];
    [adminSwipeGestureRecognizer setNumberOfTapsRequired:3];
    [adminSwipeGestureRecognizer setNumberOfTouchesRequired:2];
    [[self view] addGestureRecognizer:adminSwipeGestureRecognizer];

    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshView:) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshLocalView:) userInfo:nil repeats:NO];
    
}
- (void)tapDetected:(UITapGestureRecognizer *)recognizer
{
    lasttouch = [NSDate date];
}
- (void)swipeDetected:(UISwipeGestureRecognizer *)recognizer
{
    lasttouch = [NSDate date];
}
- (void)adminTapDetected:(UITapGestureRecognizer *)recognizer
{
    [self performSegueWithIdentifier:@"showAdminPageSegue" sender:self];
}

-(void)refreshView:(NSNotification *) notification {
    [self doKegDataRefresh ];
    
}
-(void)refreshLocalView:(NSNotification *) notification {
    [self doLocalRefresh ];
    
}

- (void)viewDidUnload
{
    [self setNavBar:nil];
    [self setLeftKegName:nil];
    [self setLeftKegType:nil];
    [self setLeftKegABV:nil];
    [self setLeftKegBrewer:nil];
    [self setLeftKegDesc:nil];
    [self setLeftKegPct:nil];
    [self setLeftKegTemp:nil];
    [self setRightKegName:nil];
    [self setRightKegType:nil];
    [self setRightKegABV:nil];
    [self setRightKegBrewer:nil];
    [self setRightKegDesc:nil];
    [self setRightKegPct:nil];
    [self setRightKegTemp:nil];
    [self setMainView:nil];
    [self setLeftKegImage:nil];
    [self setLeftKegImage:nil];
    [self setRightKegImage:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
    
    lasttouch = [NSDate date];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [UIScreen mainScreen].brightness = 1;

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
    //NSString       *kegdataURL = @"http://bajafur.atrust.com/atkeg/atkeg_data.php";
    NSString       *kegdataURL = @"http://www.camelspit.org/atkeg";
    
    // NSLog(@"Refresh started...");
    //self.navBar.topItem.title = @"Loading...";
    
    self.kegWebRequest = [SMWebRequest requestWithURL:[NSURL URLWithString:kegdataURL]];
    [kegWebRequest addTarget:self action:@selector(kegWebRequestComplete:) forRequestEvents:SMWebRequestEventComplete];
    [kegWebRequest start];
}

- (void)kegWebRequestComplete:(NSData *)responseData {
    if(!responseData )    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Error fetching keg data." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alertView show];
        
        self.navBar.topItem.title = @"Error fetching Keg Status";
        return;
    }
    NSDictionary *jsonResponse = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] JSONValue];
    self.leftKegName.text = [[jsonResponse objectForKey:@"left"] objectForKey:@"name"];
    self.rightKegName.text = [[jsonResponse objectForKey:@"right"] objectForKey:@"name"];
    self.leftKegDesc.text = [[jsonResponse objectForKey:@"left"] objectForKey:@"description"];
    self.rightKegDesc.text = [[jsonResponse objectForKey:@"right"] objectForKey:@"description"];
    self.leftKegType.text = [NSString stringWithFormat:@"Type: %@", [[jsonResponse objectForKey:@"left"] objectForKey:@"type"]];
    self.rightKegType.text = [NSString stringWithFormat:@"Type: %@", [[jsonResponse objectForKey:@"right"] objectForKey:@"type"]];
    self.leftKegABV.text = [NSString stringWithFormat:@"ABV: %@", [[jsonResponse objectForKey:@"left"] objectForKey:@"abv"]];
    self.rightKegABV.text = [NSString stringWithFormat:@"ABV: %@", [[jsonResponse objectForKey:@"right"] objectForKey:@"abv"]];
    self.leftKegBrewer.text = [NSString stringWithFormat:@"Brewer: %@", [[jsonResponse objectForKey:@"left"] objectForKey:@"brewer"]];
    self.rightKegBrewer.text = [NSString stringWithFormat:@"Brewer: %@", [[jsonResponse objectForKey:@"right"] objectForKey:@"brewer"]];
    self.leftKegPct.text = [NSString stringWithFormat:@"%@%%", [[jsonResponse objectForKey:@"left"] objectForKey:@"pctremaining"]];
    self.rightKegPct.text = [NSString stringWithFormat:@"%@%%", [[jsonResponse objectForKey:@"right"] objectForKey:@"pctremaining"]];
    self.leftKegTemp.text = [NSString stringWithFormat:@"%@F", [[jsonResponse objectForKey:@"left"] objectForKey:@"tempF"]];
    self.rightKegTemp.text = [NSString stringWithFormat:@"%@F", [[jsonResponse objectForKey:@"right"] objectForKey:@"tempF"]];
    
    self.kegImageLeftWebRequest = [SMWebRequest requestWithURL:[NSURL URLWithString:[[jsonResponse objectForKey:@"left"] objectForKey:@"imageurl"]]];
    [kegImageLeftWebRequest addTarget:self action:@selector(kegImageLeftWebRequestComplete:) forRequestEvents:SMWebRequestEventComplete];
    [kegImageLeftWebRequest start];
    self.kegImageRightWebRequest = [SMWebRequest requestWithURL:[NSURL URLWithString:[[jsonResponse objectForKey:@"right"] objectForKey:@"imageurl"]]];
    [kegImageRightWebRequest addTarget:self action:@selector(kegImageRightWebRequestComplete:) forRequestEvents:SMWebRequestEventComplete];
    [kegImageRightWebRequest start];
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshView:) userInfo:nil repeats:NO];
    
    return;
}

- (void)kegImageLeftWebRequestComplete:(NSData *)responseData {
    if(!responseData )    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Error fetching keg data." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alertView show];
        
        self.navBar.topItem.title = @"Error fetching Keg Status";
        return;
    }
    [self.leftKegImage setImage:[UIImage imageWithData:responseData] forState:UIControlStateNormal];
    return;
}

- (void)kegImageRightWebRequestComplete:(NSData *)responseData {
    if(!responseData )    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Error fetching keg data." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alertView show];
        
        self.navBar.topItem.title = @"Error fetching Keg Status";
        return;
    }
    [self.rightKegImage setImage:[UIImage imageWithData:responseData] forState:UIControlStateNormal];
    return;
}

- (void)doLocalRefresh
{
    
	NSDate *now = [NSDate date];
    NSTimeInterval theinterval = [now timeIntervalSinceDate:lasttouch];
    if ((theinterval >= ScreenDimSeconds) && ([UIScreen mainScreen].brightness == 1)){
        [UIScreen mainScreen].brightness = 0.1;
        //NSLog(@"dimmed the screen!");
    } else if ((theinterval < ScreenDimSeconds) && ([UIScreen mainScreen].brightness < 1)){
        [UIScreen mainScreen].brightness = 1;
        //NSLog(@"UNdimmed the screen!");
    }
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"EEEE, MMM dd, yyyy"];
    
    self.navBar.topItem.title = [NSString stringWithFormat:@"On Tap @ AppliedTrust - %@", [dateFormatter stringFromDate:now] ];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshLocalView:) userInfo:nil repeats:NO];
    
    return;
}

- (IBAction)leftKegImageClicked:(id)sender {
   /*
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"POW!" message:@"POW....." delegate:self cancelButtonTitle:@"INDEED!!" otherButtonTitles:nil];
    [alertView show];
    */
}
- (IBAction)backgroundClicked:(id)sender {
    lasttouch = [NSDate date];
}
@end
