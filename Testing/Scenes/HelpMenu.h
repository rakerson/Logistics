//
//  HelpMenu.h
//  Logistics
//
//  Created by Robert Akerson on 12/7/12.
//  Copyright (c) 2012 Robb Akerson. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Constants.h"
#import "SceneManager.h"

@interface HelpMenu : CCLayer {
    CCMenu *exitMenu;
    CCMenu *menu;
    CCSprite * help0;
    CCSprite * help1;
    CCSprite * help2;
    CCSprite * help3;
    CCSprite * help4;
    CCSprite * help5;
    CCSprite * help6;
    float verticalPos;
}

@property (nonatomic, assign) BOOL iPad;
@property (nonatomic, assign) NSString *device;

@end
