//
//  RootViewControllerInterface.h
//  cocosViewController
//
//  Created by toni on 25/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface RootViewControllerInterface : NSObject  {
    UIViewController *rootViewController;
}

@property (nonatomic, retain) UIViewController *rootViewController;

#pragma mark -
#pragma mark Singleton Methods
+ (RootViewControllerInterface *) rootViewControllerInterfaceSharedInstance;

-(void) presentModalViewController:(UIViewController*)controller animated:(BOOL)animated;
-(void) sendContactMail;

@end
