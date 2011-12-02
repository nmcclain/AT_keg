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
@property (weak, nonatomic) IBOutlet UILabel *keg1temp;
@property (weak, nonatomic) IBOutlet UILabel *keg1pints;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;

@property (nonatomic, retain) NSData *responseData;


@end
