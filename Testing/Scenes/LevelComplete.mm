//
//  LevelComplete.m
//  Logistics
//
//  Created by Robert Akerson on 11/3/12.
//  Copyright (c) 2012 Robb Akerson. All rights reserved.
//




#import "LevelComplete.h"
#import "GameBoardLayer.h"
#import "GameData.h"
#import "GameDataParser.h"
#import "LevelParser.h"
@implementation LevelComplete
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
        
        
               
        
        
        int largeFont = 0;
        float yPos = screenSize.height*0.65;
        float starYPos = screenSize.height*0.53;
        float menuYPos = screenSize.height*0.4;
        // Create a label
        if (self.iPad) {
            largeFont = screenSize.height / kFontScaleLarge;
            yPos = screenSize.height*0.65;
            starYPos = screenSize.height*0.53;
            menuYPos = screenSize.height*0.4;
        }
        else{
            largeFont = screenSize.height / kFontScaleHuge;
            yPos = screenSize.height*0.70;
            starYPos = screenSize.height*0.55;
            menuYPos = screenSize.height*0.35;
        }

        
        // Create a label
        NSString *successMessage = @"Level Complete";
        GameData *gameData = [GameDataParser loadData];
        NSMutableArray *currentLevelArray = [LevelParser loadLevelsForChapter:gameData.selectedChapter];
        int tempScore =0;
        int tempStars = 0;
        for (Level *level in currentLevelArray) {
            if ([[NSNumber numberWithInt:level.number] intValue] == gameData.selectedLevel) {
                tempScore = level.userLastScore;
                tempStars = level.userLastStars;
                //tempStars = level.stars;
                if(tempScore == level.userHighScore)
                {
                 successMessage = @"New High Score";
                }
                
            }
        }
        CCLabelTTF *label = [CCLabelTTF labelWithString:successMessage
                                               fontName:@"Fontdinerdotcom"
                                               fontSize:largeFont];
        NSString *tImage = [NSString stringWithFormat:@"%@Star-Normal-%@.png",[[NSNumber numberWithInt:tempStars] stringValue], self.device];
        CCSprite *starImage = [CCSprite spriteWithFile:tImage];
        
        
        [starImage setPosition:ccp(screenSize.width*0.61, starYPos)];
        starImage.scale = 1.0f;
        [self addChild:starImage z:1];

        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSString *formattedNumberString = [numberFormatter stringFromNumber:[NSNumber numberWithInt:tempScore]];
        //NSLog(@"formattedNumberString: %@", formattedNumberString);
        
        CCLabelTTF *scorelabel = [CCLabelTTF labelWithString:formattedNumberString
                                               fontName:@"Fontdinerdotcom"
                                               fontSize:largeFont];
        
        label.color = ccc3(95,58,0);
		// Center label
		label.position = ccp( screenSize.width/2, yPos);
       
        
        
        scorelabel.color = ccc3(95,58,0);
		// Center label
        
		scorelabel.position = ccp( screenSize.width*0.43, starYPos);
        
        // Add label to this scene
		[self addChild:label z:0];
        [self addChild:scorelabel z:0];
        //create the menu
        // Calculate Large Font Size
        //int largeFont = screenSize.height / kFontScaleLarge;
        
        // Set font settings
        [CCMenuItemFont setFontName:@"Fontdinerdotcom"];
        [CCMenuItemFont setFontSize:65  ];
        
        
       

        
        /*CCMenuItemImage *resume = [CCMenuItemImage

                                   itemFromNormalImage:[NSString stringWithFormat:@"resume-off-%@.png", self.device]

                                   selectedImage:[NSString stringWithFormat:@"resume-on-%@.png", self.device]
                                   target:self
                                   selector:@selector(onResume:)];*/
        CCMenuItemImage *restart = [CCMenuItemImage

                                    itemFromNormalImage:[NSString stringWithFormat:@"replay-off-%@.png", self.device]
                                    selectedImage:[NSString stringWithFormat:@"replay-on-%@.png", self.device]
                                    target:self
                                    selector:@selector(onRestart:)];
        CCMenuItemImage *exit = [CCMenuItemImage

                                 itemFromNormalImage:[NSString stringWithFormat:@"menu-off-%@.png", self.device]
                                 selectedImage:[NSString stringWithFormat:@"menu-on-%@.png", self.device]
                                 target:self
                                 selector:@selector(onMenu:)];
        
        CCMenuItemImage *nextLevel = [CCMenuItemImage
                                      itemFromNormalImage:[NSString stringWithFormat:@"next-off-%@.png", self.device]
                                      selectedImage:[NSString stringWithFormat:@"next-on-%@.png", self.device]
                                      target:self
                                      selector:@selector(nextLevel:)];
        
        
        

        CCMenu *menu = [CCMenu menuWithItems:exit, restart, nextLevel, nil];
        [menu setPosition:ccp(screenSize.width/2, menuYPos)];
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
    [gameParent retryGame];
    [self.parent removeChild:self cleanup:YES];
}
- (void)onRestart: (id) sender {
    GameBoardLayer *gameParent = (GameBoardLayer *)self.parent;
    [gameParent resetGame];
    [self.parent removeChild:self cleanup:YES];
}
- (void) nextLevel: (CCMenuItemImage*) sender {
    // store the selected level in GameData
    GameData *gameData = [GameDataParser loadData];
    if(gameData.selectedLevel == 12)
    {
    gameData.selectedChapter = gameData.selectedChapter+1;
    gameData.selectedLevel = 1;
    }
    else
    {
    gameData.selectedLevel = gameData.selectedLevel+1;
    }
    [GameDataParser saveData:gameData];
    
    // load the game scene
    //[SceneManager goGameScene];
    [SceneManager goGameScene];
}
@end

