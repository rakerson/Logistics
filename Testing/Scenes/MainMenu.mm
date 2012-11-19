//
//  MainMenu.m
//  

#import "MainMenu.h"  
#import "GameData.h"
#import "GameDataParser.h"
#import "CCDirector.h"
#import "ChapterSelect.h"
#import "AboutMenu.h"
#import "ScoreMenu.h"

@implementation MainMenu
@synthesize iPad, device;

- (void)onPlay: (id) sender {
    [SceneManager goChapterSelect];
     
}

- (void)onOptions: (id) sender {
    [SceneManager goOptionsMenu];
}
-(void)showAboutMenu: (id) sender
{
    AboutMenu * p = [[[AboutMenu alloc]init]autorelease];
    [self addChild:p z:10];
    
}
-(void)showScoreMenu: (id) sender
{
    ScoreMenu * p = [[[ScoreMenu alloc]init]autorelease];
    [self addChild:p z:10];
    
}

- (void)addBackButton {
    
    NSString *normal = [NSString stringWithFormat:@"Arrow-Normal-%@.png", self.device];
    NSString *selected = [NSString stringWithFormat:@"Arrow-Selected-%@.png", self.device];        
    CCMenuItemImage *goBack = [CCMenuItemImage itemFromNormalImage:normal 
                                                     selectedImage:selected
                                                            target:self 
                                                          selector:@selector(onBack:)];
    CCMenu *back = [CCMenu menuWithItems: goBack, nil];
    
    if (self.iPad) {
        back.position = ccp(64, 64);
        
    }
    else {
        back.position = ccp(32, 32);
    }
    
    [self addChild:back];        
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
        NSLog(@"MAIN MENU");
        // Determine Screen Size
        CGSize screenSize = [CCDirector sharedDirector].winSize;  
        
    
        //CCSprite * bg = [CCSprite spriteWithFile:@"titlescreen-back.jpg"];
        CCSprite * bg = [CCSprite spriteWithFile:[NSString stringWithFormat:@"titlescreen-back-%@.jpg", self.device]];
        [bg setPosition:ccp(screenSize.width*0.5, screenSize.height*0.5)];
        [self addChild:bg z:0];
        
        CCSprite * logo = [CCSprite spriteWithFile:[NSString stringWithFormat:@"title-%@.png", self.device]];
        [logo setPosition:ccp(screenSize.width*0.5, screenSize.height*0.58)];
        [self addChild:logo z:3];
    
        // Calculate Large Font Size
        int largeFont = screenSize.height / kFontScaleLarge; 

        // Set font settings
        [CCMenuItemFont setFontName:@"Marker Felt"];
        [CCMenuItemFont setFontSize:largeFont];
        
        //NSString *normal =   [NSString stringWithFormat:@"%@-Normal-%@.png", selectedChapterName, self.device];
        //NSString *selected = [NSString stringWithFormat:@"%@-Selected-%@.png", selectedChapterName, self.device];
        
        // Create font based items ready for CCMenu
        CCMenuItemImage *aboutButton = [CCMenuItemImage
                                        itemFromNormalImage:[NSString stringWithFormat:@"about-off-%@.png", self.device]
                                        //itemFromNormalImage:@"about-off-ipad.png"
                                        selectedImage:[NSString stringWithFormat:@"about-on-%@.png", self.device]
                                        //selectedImage:@"about-on-ipad.png"
                                        target:self
                                        selector:@selector(showAboutMenu:)];
        CCMenuItemImage *playButton = [CCMenuItemImage
                                       itemFromNormalImage:[NSString stringWithFormat:@"play-off-%@.png", self.device]
                                        //itemFromNormalImage:@"play-off-ipad.png"
                                       selectedImage:[NSString stringWithFormat:@"play-on-%@.png", self.device]
                                        //selectedImage:@"play-on-ipad.png"
                                        target:self
                                        selector:@selector(onPlay:)];
        CCMenuItemImage *scoresButton = [CCMenuItemImage
                                         itemFromNormalImage:[NSString stringWithFormat:@"scores-off-%@.png", self.device]
                                        //itemFromNormalImage:@"scores-off-ipad.png"
                                         selectedImage:[NSString stringWithFormat:@"scores-on-%@.png", self.device]
                                        //selectedImage:@"scores-on-ipad.png"
                                        target:self
                                        selector:@selector(showScoreMenu:)];
        
        //CCMenuItemFont *item1 = [CCMenuItemFont itemFromString:@"Play" target:self selector:@selector(onPlay:)];
        //CCMenuItemFont *item2 = [CCMenuItemFont itemFromString:@"Options" target:self selector:@selector(onOptions:)];

        // Add font based items to CCMenu
        CCMenu *menu = [CCMenu menuWithItems:aboutButton, playButton, scoresButton, nil];
        [menu setPosition:ccp(screenSize.width*0.5, screenSize.height*0.22)];
        NSLog(@"Screen width %f", screenSize.width);
        // Align the menu 
        [menu alignItemsHorizontally];

        // Add the menu to the scene
        [self addChild:menu];
        
        // Testing GameData
        /*
        GameData *gameData = [GameDataParser loadData];

        CCLOG(@"Read from XML 'Selected Chapter' = %i", gameData.selectedChapter);
        CCLOG(@"Read from XML 'Selected Level' = %i", gameData.selectedLevel);
        CCLOG(@"Read from XML 'Music' = %i", gameData.music);
        CCLOG(@"Read from XML 'Sound' = %i", gameData.sound);
        
        gameData.selectedChapter = 7;
        gameData.selectedLevel = 4;
        gameData.music = 0;
        gameData.sound = 0;
        
        [GameDataParser saveData:gameData];
        */
    }
    return self;

}


@end
