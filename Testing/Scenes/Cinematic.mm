//
//  HelpMenu.m
//  Logistics
//
//  Created by Robert Akerson on 12/7/12.
//  Copyright (c) 2012 Robb Akerson. All rights reserved.
//

#import "Cinematic.h"
#import "LevelSelect.h"
@implementation Cinematic
@synthesize iPad, device, cinLabel ;

- (void)onBack: (id) sender {
    /*
     This is where you choose where clicking 'back' sends you.
     */
    [SceneManager goLevelSelect];
}

- (id)initWithLabel: (NSString*) templabel {
    self.cinLabel = [templabel copy];
    if( (self=[super init])) {
        
        // Determine Device
        self.iPad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
        if (self.iPad) {
            self.device = @"ipad";
        }
        else {
            self.device = @"iphone";
        }
        
        

        // Determine Screen Size
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        
        
        
        // Calculate Large Font Size
        int largeFont = screenSize.height / kFontScaleLarge;
        
        // Create a label
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"About"
                                               fontName:@"Fontdinerdotcom"
                                               fontSize:largeFont];
        label.color = ccc3(95,58,0);
		// Center label
		label.position = ccp( screenSize.width/2, screenSize.height*0.65);
        
        // Add label to this scene
		//[self addChild:label z:0];
        
        // Set font settings
        [CCMenuItemFont setFontName:@"Fontdinerdotcom"];
        [CCMenuItemFont setFontSize:65];
        
        CCMenuItemImage *exitMenuItem = [CCMenuItemImage
                                         itemFromNormalImage:[NSString stringWithFormat:@"cinematic-matte-%@.png", self.device]
                                         selectedImage:[NSString stringWithFormat:@"cinematic-matte-%@.png", self.device]
                                         target:self
                                         selector:@selector(onMenu:)];
        
        
        
        exitMenu = [CCMenu menuWithItems:exitMenuItem, nil];
        [exitMenu setPosition:ccp(screenSize.width*0.5, screenSize.height*0.5)];
        [exitMenu alignItemsHorizontally];
        [self addChild:exitMenu z:1];
        
        
        CCMenuItemImage *exit = [CCMenuItemImage
                                 //itemFromNormalImage:@"menu-off-ipad-hd.png"
                                 //selectedImage:@"menu-on-ipad-hd.png"
                                 itemFromNormalImage:[NSString stringWithFormat:@"ok-off-%@.png", self.device]
                                 selectedImage:[NSString stringWithFormat:@"ok-on-%@.png", self.device]
                                 target:self
                                 selector:@selector(onMenu:)];
        
        
        
        menu = [CCMenu menuWithItems:exit, nil];
        if(self.device == @"iphone")
        {
            [menu setPosition:ccp(screenSize.width*0.5, screenSize.height*0.09)];
            
            exit.scale = 0.6;
        }
        else
        {
            [menu setPosition:ccp(screenSize.width*0.5, screenSize.height*0.14)];
            
            
        }
        menu.visible = false;
        
        [self addChild:menu z:30];

        
        
        [self performSelector:@selector(cinIn1) withObject:nil afterDelay:0.0];
        [self performSelector:@selector(cinIn2) withObject:nil afterDelay:3.0];
        [self performSelector:@selector(cinIn3) withObject:nil afterDelay:6.0];
        [self performSelector:@selector(cinIn4) withObject:nil afterDelay:9.0];
        [self performSelector:@selector(cinIn5) withObject:nil afterDelay:9.5];
        //[self performSelector:@selector(helpFade) withObject:nil afterDelay:19.0];
        //[self performSelector:@selector(helpDone) withObject:nil afterDelay:19.5];
        
        
        
        
        
    }
    
    return self;
}
- (void) setArt: (NSString *) type{
    
    NSLog(@"type of Cinematic:  %@", type);
    
    }
- (void)cinIn1{
    NSLog(@"THE LABEL IS %@", self.device);
    CGSize screenSize = [CCDirector sharedDirector].winSize;
     NSLog(@"type of Cinematic:  %@", self.cinLabel);
    cin1 = [CCSprite spriteWithFile:[NSString stringWithFormat:@"cin-%@-1-%@.jpg", self.cinLabel, self.device]];
    cin1.position = ccp(screenSize.width*.32,screenSize.height*.7);
    [cin1 runAction:[CCFadeIn actionWithDuration:0.4]];
    [self addChild:cin1 z:20];
    }
- (void)cinIn2{
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    cin2 = [CCSprite spriteWithFile:[NSString stringWithFormat:@"cin-%@-2-%@.jpg", cinLabel, self.device]];
    [self addChild:cin2 z:20];
    cin2.position = ccp(screenSize.width*.67,screenSize.height*.7);
    [cin2 runAction:[CCFadeIn actionWithDuration:0.4]];
}
- (void)cinIn3{
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    cin3 = [CCSprite spriteWithFile:[NSString stringWithFormat:@"cin-%@-3-%@.jpg", cinLabel, self.device]];
    //cin3.position= ccp(screenSize.width,0);
    [self addChild:cin3 z:20];
    //[cin3 runAction:[CCMoveTo actionWithDuration:0.5 position:ccp(screenSize.width*.32,screenSize.height*.33)]];
    cin3.position = ccp(screenSize.width*.32,screenSize.height*.33);
    [cin3 runAction:[CCFadeIn actionWithDuration:0.4]];
}
- (void)cinIn4{
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    cin4 = [CCSprite spriteWithFile:[NSString stringWithFormat:@"cin-%@-4-%@.jpg", cinLabel, self.device]];
    cin4.position = ccp(screenSize.width*.67,screenSize.height*.33);
    [cin4 runAction:[CCFadeIn actionWithDuration:0.4]];
    [self addChild:cin4 z:20];
    //[cin4 runAction:[CCMoveTo actionWithDuration:0.5 position:ccp(screenSize.width*.67,screenSize.height*.33)]];
}
- (void)cinIn5{
    menu.visible = true;
    [menu runAction:[CCFadeIn actionWithDuration:0.5]];
}
- (void)helpFade{
    //[help1 runAction:[CCFadeOut actionWithDuration:0.5]];
    //[help2 runAction:[CCFadeOut actionWithDuration:0.5]];
    //[help3 runAction:[CCFadeOut actionWithDuration:0.5]];
    //[help4 runAction:[CCFadeOut actionWithDuration:0.5]];
    //[help5 runAction:[CCFadeOut actionWithDuration:0.5]];
    //[help6 runAction:[CCFadeOut actionWithDuration:0.5]];
    //[menu runAction:[CCFadeOut actionWithDuration:0.5]];
}
- (void)helpDone{
    GameBoardLayer *gameParent = (GameBoardLayer *)self.parent;
    [gameParent resumeGame];
    [self.parent removeChild:self cleanup:YES];
    
}
- (void)onMenu: (id) sender {
    //[SceneManager goLevelSelectFromLevel];
    [self.parent removeChild:self cleanup:YES];
}


- (void)onRestart: (id) sender {
    
    GameBoardLayer *gameParent = (GameBoardLayer *)self.parent;
    [gameParent resetGame];
    [self.parent removeChild:self cleanup:YES];
}
-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    
    return YES;
    
}
@end
