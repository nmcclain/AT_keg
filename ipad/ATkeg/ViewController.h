//
//  ViewController.h
//  ATkeg
//
//  Created by Ned McClain on 11/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
- (IBAction)refreshPushed:(id)sender;
- (void)doKegDataRefresh;

@property (weak, nonatomic) IBOutlet UILabel *keg1temp;
@property (weak, nonatomic) IBOutlet UILabel *keg1pct;
@property (weak, nonatomic) IBOutlet UILabel *keg2temp;
@property (weak, nonatomic) IBOutlet UILabel *keg2pct;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;

@property (nonatomic, retain) NSData *responseData;

@end
