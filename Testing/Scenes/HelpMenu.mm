//
//  HelpMenu.m
//  Logistics
//
//  Created by Robert Akerson on 12/7/12.
//  Copyright (c) 2012 Robb Akerson. All rights reserved.
//

#import "HelpMenu.h"
#import "GameBoardLayer.h"
@implementation HelpMenu
@synthesize iPad, device;

- (void)onBack: (id) sender {
    /*
     This is where you choose where clicking 'back' sends you.
     */
    [SceneManager goMainMenu];
}


- (id)init {
    
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
                                 itemFromNormalImage:[NSString stringWithFormat:@"help-mask-%@.png", self.device]
                                 selectedImage:[NSString stringWithFormat:@"help-mask-%@.png", self.device]
                                 target:self
                                 selector:@selector(onResume:)];
        
        
        
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
            [menu setPosition:ccp(screenSize.width*0.5, screenSize.height*0.22)];
            
            exit.scale = 0.6;
        }
        else
        {
            [menu setPosition:ccp(screenSize.width*0.5, screenSize.height*0.27)];
            
            
        }
        
        menu.opacity = 0;
        [self addChild:menu z:10];
        
        help0 = [CCSprite spriteWithFile:[NSString stringWithFormat:@"drop0-%@.png", self.device]];
        [help0 setPosition:ccp(screenSize.width*0.5, screenSize.height*0.5)];
        [help0 runAction:[CCFadeIn actionWithDuration:1]];
        [help0 setOpacity:0];
        [self addChild:help0 z:20];
        
        
        [self performSelector:@selector(helpIn1) withObject:nil afterDelay:3.0];
        [self performSelector:@selector(helpIn2) withObject:nil afterDelay:5.0];
        [self performSelector:@selector(helpIn3) withObject:nil afterDelay:7.0];
        [self performSelector:@selector(helpIn4) withObject:nil afterDelay:11.0];
        [self performSelector:@selector(helpIn5) withObject:nil afterDelay:13.0];
        [self performSelector:@selector(helpIn6) withObject:nil afterDelay:15.0];
        [self performSelector:@selector(helpIn7) withObject:nil afterDelay:15.5];
        //[self performSelector:@selector(helpFade) withObject:nil afterDelay:19.0];
        //[self performSelector:@selector(helpDone) withObject:nil afterDelay:19.5];
        
        
        
        
        
    }
    return self;
}

- (void)helpIn1{
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    help1 = [CCSprite spriteWithFile:[NSString stringWithFormat:@"place1-%@.png", self.device]];
    [help1 setPosition:ccp(screenSize.width*0.5, screenSize.height*0.5)];
    [help1 runAction:[CCFadeIn actionWithDuration:0.5]];
    [help1 setOpacity:0];
    [self addChild:help1 z:19];
    [help0 runAction:[CCFadeOut actionWithDuration:1]];
}
- (void)helpIn2{
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    help2 = [CCSprite spriteWithFile:[NSString stringWithFormat:@"place2-%@.png", self.device]];
    [help2 setPosition:ccp(screenSize.width*0.5, screenSize.height*0.5)];
    [help2 runAction:[CCFadeIn actionWithDuration:0.5]];
    [help2 setOpacity:0];
    [self addChild:help2 z:18];
    [help1 runAction:[CCFadeOut actionWithDuration:1]];
}

- (void)helpIn3{
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    help3 = [CCSprite spriteWithFile:[NSString stringWithFormat:@"place3-%@.png", self.device]];
    [help3 setPosition:ccp(screenSize.width*0.5, screenSize.height*0.5)];
    [help3 runAction:[CCFadeIn actionWithDuration:0.5]];
    [help3 setOpacity:0];
    [self addChild:help3 z:17];
    [help2 runAction:[CCFadeOut actionWithDuration:1]];
}
- (void)helpIn4{
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    help4 = [CCSprite spriteWithFile:[NSString stringWithFormat:@"drop1-%@.png", self.device]];
    [help4 setPosition:ccp(screenSize.width*0.5, screenSize.height*0.5)];
    [help4 runAction:[CCFadeIn actionWithDuration:0.5]];
    [help4 setOpacity:0];
    [self addChild:help4 z:16];
    [help3 runAction:[CCFadeOut actionWithDuration:1]];
}
- (void)helpIn5{
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    help5 = [CCSprite spriteWithFile:[NSString stringWithFormat:@"drop2-%@.png", self.device]];
    [help5 setPosition:ccp(screenSize.width*0.5, screenSize.height*0.5)];
    [help5 runAction:[CCFadeIn actionWithDuration:0.5]];
    [help5 setOpacity:0];
    [self addChild:help5 z:15];
    [help4 runAction:[CCFadeOut actionWithDuration:1]];
}
- (void)helpIn6{
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    help6 = [CCSprite spriteWithFile:[NSString stringWithFormat:@"drop3-%@.png", self.device]];
    [help6 setPosition:ccp(screenSize.width*0.5, screenSize.height*0.5)];
    [help6 runAction:[CCFadeIn actionWithDuration:0.5]];
    [help6 setOpacity:0];
    [self addChild:help6 z:14];
    [help5 runAction:[CCFadeOut actionWithDuration:1]];
}
- (void)helpIn7{

    [menu runAction:[CCFadeIn actionWithDuration:1]];
}
- (void)helpFade{
    //[help1 runAction:[CCFadeOut actionWithDuration:0.5]];
    //[help2 runAction:[CCFadeOut actionWithDuration:0.5]];
    //[help3 runAction:[CCFadeOut actionWithDuration:0.5]];
    //[help4 runAction:[CCFadeOut actionWithDuration:0.5]];
    //[help5 runAction:[CCFadeOut actionWithDuration:0.5]];
    [help6 runAction:[CCFadeOut actionWithDuration:0.5]];
    [menu runAction:[CCFadeOut actionWithDuration:0.5]];
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
- (void)onResume: (id) sender {
    GameBoardLayer *gameParent = (GameBoardLayer *)self.parent;
    [gameParent resumeGame];
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
