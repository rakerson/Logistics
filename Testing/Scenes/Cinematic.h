//
//  Cinematic.h
//  Logistics
//
//  Created by Robert Akerson on 1/26/13.
//  Copyright (c) 2012 Robb Akerson. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Constants.h"
#import "SceneManager.h"

@interface Cinematic : CCLayer {
    CCMenu *exitMenu;
    CCMenu *menu;

    CCSprite * cin1;
    CCSprite * cin2;
    CCSprite * cin3;
    CCSprite * cin4;

}



@property (nonatomic, assign) BOOL iPad;
@property (nonatomic, assign) NSString *device;
@property (nonatomic, assign) NSString *cinLabel;

-(id) initWithLabel: (NSString*) templabel;

@end
