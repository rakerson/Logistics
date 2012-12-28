//
//  OptionsMenu.m
//  

#import "AboutMenu.h"

@implementation AboutMenu
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
        
        CCSprite * bg = [CCSprite spriteWithFile:[NSString stringWithFormat:@"aboutmenu-%@.png", self.device]];
        [bg setPosition:ccp(screenSize.width*0.5, screenSize.height*0.5)];

        [self addChild:bg z:0];

        
       
        
        // Calculate Large Font Size
        //int largeFont = screenSize.height / kFontScaleLarge;
        
        
        //create the menu
        // Calculate Large Font Size
        //int largeFont = screenSize.height / kFontScaleLarge;
        
        // Set font settings
        [CCMenuItemFont setFontName:@"Fontdinerdotcom"];
        [CCMenuItemFont setFontSize:65];

        CCMenuItemImage *exit = [CCMenuItemImage
                                  //itemFromNormalImage:@"menu-off-ipad-hd.png"
                                  //selectedImage:@"menu-on-ipad-hd.png"
                                 itemFromNormalImage:[NSString stringWithFormat:@"menu-off-%@.png", self.device]
                                 selectedImage:[NSString stringWithFormat:@"menu-on-%@.png", self.device]
                                  target:self
                                  selector:@selector(onMenu:)];
        

       
        CCMenu *menu = [CCMenu menuWithItems:exit, nil];
        if(self.device == @"iphone")
        {
            [menu setPosition:ccp(screenSize.width*0.5, screenSize.height*0.22)];
            
            exit.scale = 0.6;
        }
        else
        {
            [menu setPosition:ccp(screenSize.width*0.5, screenSize.height*0.27)];
            
           
        }
        
        
        [self addChild:menu z:1];
     
    }
    return self;
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
