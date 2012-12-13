//
//  HelpMenu.m
//  Logistics
//
//  Created by Robert Akerson on 12/7/12.
//  Copyright (c) 2012 Robb Akerson. All rights reserved.
//

#import "HelpMenu.h"

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
        
        CCMenuItemImage *exit = [CCMenuItemImage
                                 itemFromNormalImage:[NSString stringWithFormat:@"help-mask-%@.png", self.device]
                                 selectedImage:[NSString stringWithFormat:@"help-mask-%@.png", self.device]
                                 target:self
                                 selector:@selector(onMenu:)];
        
        
        
        menu = [CCMenu menuWithItems:exit, nil];
        [menu setPosition:ccp(screenSize.width*0.5, screenSize.height*0.5)];
        [menu alignItemsHorizontally];
        [self addChild:menu z:1];
        
        
        help1 = [CCSprite spriteWithFile:[NSString stringWithFormat:@"help1-%@.png", self.device]];
        [help1 setPosition:ccp(screenSize.width*0.5, screenSize.height*0.5)];
        [help1 runAction:[CCFadeIn actionWithDuration:1]];
        [help1 setOpacity:0];
        [self addChild:help1 z:2];
        
        
        
        [self performSelector:@selector(helpIn2) withObject:nil afterDelay:2.0];
        [self performSelector:@selector(helpIn3) withObject:nil afterDelay:4.0];
        [self performSelector:@selector(helpIn4) withObject:nil afterDelay:6.0];
        [self performSelector:@selector(helpFade) withObject:nil afterDelay:11.0];
        [self performSelector:@selector(helpDone) withObject:nil afterDelay:11.5];
        
        
        
        
        
    }
    return self;
}
- (void)helpIn2{
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    help2 = [CCSprite spriteWithFile:[NSString stringWithFormat:@"help2-%@.png", self.device]];
    [help2 setPosition:ccp(screenSize.width*0.5, screenSize.height*0.5)];
    [help2 runAction:[CCFadeIn actionWithDuration:1]];
    [help2 setOpacity:0];
    [self addChild:help2 z:3];
}

- (void)helpIn3{
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    help3 = [CCSprite spriteWithFile:[NSString stringWithFormat:@"help3-%@.png", self.device]];
    [help3 setPosition:ccp(screenSize.width*0.5, screenSize.height*0.5)];
    [help3 runAction:[CCFadeIn actionWithDuration:1]];
    [help3 setOpacity:0];
    [self addChild:help3 z:4];
}
- (void)helpIn4{
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    help4 = [CCSprite spriteWithFile:[NSString stringWithFormat:@"help4-%@.png", self.device]];
    [help4 setPosition:ccp(screenSize.width*0.5, screenSize.height*0.5)];
    [help4 runAction:[CCFadeIn actionWithDuration:1]];
    [help4 setOpacity:0];
    [self addChild:help4 z:5];
}
- (void)helpFade{
    [help1 runAction:[CCFadeOut actionWithDuration:0.5]];
    [help2 runAction:[CCFadeOut actionWithDuration:0.5]];
    [help3 runAction:[CCFadeOut actionWithDuration:0.5]];
    [help4 runAction:[CCFadeOut actionWithDuration:0.5]];
    [menu runAction:[CCFadeOut actionWithDuration:0.5]];
}
- (void)helpDone{
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
