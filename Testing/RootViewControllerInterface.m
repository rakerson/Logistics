//
//  RootViewControllerInterface.m
//  cocosViewController
//
//  Created by toni on 25/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewControllerInterface.h"
#import "GameData.h"
#import "GameDataParser.h"

@implementation RootViewControllerInterface

@synthesize rootViewController;

#pragma mark -
#pragma mark Singleton Variables
static RootViewControllerInterface *rootViewControllerInterfaceSingletonDelegate = nil;

#pragma mark -
#pragma mark Singleton Methods
+ (RootViewControllerInterface *) rootViewControllerInterfaceSharedInstance {
	@synchronized(self) {
		if (rootViewControllerInterfaceSingletonDelegate == nil) {
			[[self alloc] init]; // assignment not done here
		}
	}
	return rootViewControllerInterfaceSingletonDelegate;
}

+ (id)allocWithZone:(NSZone *)zone {
	@synchronized(self) {
		if (rootViewControllerInterfaceSingletonDelegate == nil) {
			rootViewControllerInterfaceSingletonDelegate = [super allocWithZone:zone];
			// assignment and return on first allocation
			return rootViewControllerInterfaceSingletonDelegate;
		}
	}
	// on subsequent allocation attempts return nil
	return nil;
}

- (id)copyWithZone:(NSZone *)zone {
	return self;
}

- (id)retain {
	return self;
}

- (unsigned)retainCount {
	return UINT_MAX;  // denotes an object that cannot be released
}

//- (void)release {
	//do nothing
//}

- (id)autorelease {
	return self;
}

-(void) presentModalViewController:(UIViewController*)controller animated:(BOOL)animated {
    [rootViewController presentModalViewController:controller animated:animated];
}

-(void) sendContactMail {
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = rootViewController;
    
    // Recipient.
    NSString *recipient = @"game.logistics@gmail.com";
    NSArray *recipientsArray = [NSArray arrayWithObject:recipient];
    [picker setToRecipients:recipientsArray];
    
    // Subject.
    [picker setSubject:NSLocalizedString(@"Logistics 1.1 Feedback", "")];
    
    // Body.
    
    UIDevice *currentDevice = [UIDevice currentDevice];
    NSString *model = [currentDevice model];
    NSString *systemVersion = [currentDevice systemVersion];
    NSArray *languageArray = [NSLocale preferredLanguages];
    NSString *language = [languageArray objectAtIndex:0];
    NSLocale *locale = [NSLocale currentLocale];
    NSString *country = [locale localeIdentifier];
    
    NSString *appVersion = [[NSBundle mainBundle]
                            objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    GameData *gameData = [GameDataParser loadData];
    
    NSString *currentLevel = [NSString stringWithFormat:@"%i~%i", gameData.selectedChapter, gameData.selectedLevel];

    NSString *deviceSpecs = [NSString stringWithFormat:@"%@ - %@ - %@ - %@ - %@ - %@",model, systemVersion, language, country, appVersion, currentLevel];
    NSLog(@"Device Specs --> %@",deviceSpecs);
    
    NSString *emailBody = [NSString stringWithFormat:@"Device Info: %@", deviceSpecs];
    [picker setMessageBody:emailBody isHTML:NO];
    
    [rootViewController presentModalViewController:picker animated:YES];
    
    [picker release];
    NSLog(@"PICKER RELEASE");
    
    
}

@end