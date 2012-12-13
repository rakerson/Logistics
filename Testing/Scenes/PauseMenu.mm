//
//  OptionsMenu.m
//  

#import "PauseMenu.h"
#import "GameBoardLayer.h"
@implementation PauseMenu
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
        
        CCSprite * bg = [CCSprite spriteWithFile:[NSString stringWithFormat:@"pausemenu-%@.png", self.device]];
        [bg setPosition:ccp(screenSize.width*0.5, screenSize.height*0.5)];

        [self addChild:bg z:0];

        
       
        
        // Calculate Large Font Size
        
        int largeFont = 0;
        float yPos = screenSize.height*0.65;
        // Create a label
        if (self.iPad) {
           largeFont = screenSize.height / kFontScaleLarge; 
            yPos = screenSize.height*0.65;
        }
        else{
            largeFont = screenSize.height / kFontScaleHuge;
            yPos = screenSize.height*0.70;
        }
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"Pause Menu" fontName:@"Fontdinerdotcom" fontSize:largeFont];
        label.color = ccc3(95,58,0);
		// Center label
		label.position = ccp( screenSize.width/2, yPos);
        
        // Add label to this scene
		[self addChild:label z:0];
        
        //create the menu
        // Calculate Large Font Size
        //int largeFont = screenSize.height / kFontScaleLarge;
        
        // Set font settings
        [CCMenuItemFont setFontName:@"Fontdinerdotcom"];
        //[CCMenuItemFont setFontSize:65];

        
        CCMenuItemImage *resume = [CCMenuItemImage
                                        //itemFromNormalImage:@"resume-off-ipad-hd.png"
                                        itemFromNormalImage:[NSString stringWithFormat:@"resume-off-%@.png", self.device]
                                        //selectedImage:@"resume-on-ipad-hd.png"
                                        selectedImage:[NSString stringWithFormat:@"resume-on-%@.png", self.device]
                                        target:self
                                        selector:@selector(onResume:)];
        CCMenuItemImage *restart = [CCMenuItemImage
                                  //itemFromNormalImage:@"replay-off-ipad-hd.png"
                                  //selectedImage:@"replay-on-ipad-hd.png"
                                    itemFromNormalImage:[NSString stringWithFormat:@"replay-off-%@.png", self.device]
                                    selectedImage:[NSString stringWithFormat:@"replay-on-%@.png", self.device]
                                  target:self
                                  selector:@selector(onRestart:)];
        CCMenuItemImage *exit = [CCMenuItemImage
                                  //itemFromNormalImage:@"menu-off-ipad-hd.png"
                                  //selectedImage:@"menu-on-ipad-hd.png"
                                 itemFromNormalImage:[NSString stringWithFormat:@"menu-off-%@.png", self.device]
                                 selectedImage:[NSString stringWithFormat:@"menu-on-%@.png", self.device]
                                  target:self
                                  selector:@selector(onMenu:)];
        

       
        CCMenu *menu = [CCMenu menuWithItems:exit, resume, restart, nil];
        [menu setPosition:ccp(screenSize.width*0.5, screenSize.height*0.45)];
        [menu alignItemsHorizontally];
        [self addChild:menu z:1];
     
    }
    return self;
}
- (void)onMenu: (id) sender {
    [SceneManager goLevelSelectFromLevel];
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
