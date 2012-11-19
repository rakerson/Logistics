//
//  OptionsMenu.m
//  

#import "ScoreMenu.h"

@implementation ScoreMenu
@synthesize iPad, device;




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
        int largeFont = screenSize.height / kFontScaleLarge; 
        
        // Create a label
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"Scores"
                                               fontName:@"Fontdinerdotcom" 
                                               fontSize:largeFont];
        label.color = ccc3(95,58,0);
		// Center label
		label.position = ccp( screenSize.width/2, screenSize.height*0.65);
        
        // Add label to this scene
		[self addChild:label z:0];
        
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
        [menu setPosition:ccp(screenSize.width*0.5, screenSize.height*0.45)];
        [menu alignItemsHorizontally];
        [self addChild:menu z:1];
     
    }
    return self;
}
- (void)onMenu: (id) sender {
    //[SceneManager goLevelSelectFromLevel];
    [self.parent removeChild:self cleanup:YES];
    }
-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
 
        return YES;
   
}
@end
