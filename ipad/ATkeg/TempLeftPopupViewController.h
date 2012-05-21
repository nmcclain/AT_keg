//
//  TempPopupViewController.h
//  ATkeg
//
//  Created by Ned McClain on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMWebRequest.h"

@interface TempLeftPopupViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *TempLeftImage;

@property (nonatomic, retain) SMWebRequest *kegImageWebRequest;

@end
