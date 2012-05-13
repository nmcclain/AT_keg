//
//  ViewController.h
//  ATkeg
//
//  Created by Ned McClain on 11/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMWebRequest.h"

@interface ViewController : UIViewController
- (void)doKegDataRefresh;
- (void)doLocalRefresh;


@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;

@property (nonatomic, retain) SMWebRequest *kegWebRequest;
@property (weak, nonatomic) IBOutlet UILabel *leftKegName;
@property (weak, nonatomic) IBOutlet UILabel *leftKegType;
@property (weak, nonatomic) IBOutlet UILabel *leftKegABV;
@property (weak, nonatomic) IBOutlet UILabel *leftKegBrewer;
@property (weak, nonatomic) IBOutlet UILabel *leftKegDesc;
@property (weak, nonatomic) IBOutlet UILabel *leftKegPct;
@property (weak, nonatomic) IBOutlet UILabel *leftKegTemp;

@property (weak, nonatomic) IBOutlet UILabel *rightKegName;
@property (weak, nonatomic) IBOutlet UILabel *rightKegType;
@property (weak, nonatomic) IBOutlet UILabel *rightKegABV;
@property (weak, nonatomic) IBOutlet UILabel *rightKegBrewer;
@property (weak, nonatomic) IBOutlet UILabel *rightKegDesc;
@property (weak, nonatomic) IBOutlet UILabel *rightKegPct;
@property (weak, nonatomic) IBOutlet UILabel *rightKegTemp;

@end
