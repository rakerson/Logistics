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
#import "Cinematic.h"

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
        GameData *gameData = [GameDataParser loadData];
        NSString *successMessage;
        if(gameData.selectedLevel == 12)
        {
        successMessage = @"Chapter Complete";
        }
        else
        {
        successMessage = @"Level Complete";
        }
        
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
        _currentLevel = gameData.selectedLevel;
        _currentChapter = gameData.selectedChapter;
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
        CCMenuItemImage *playCinematic = [CCMenuItemImage
                                      itemFromNormalImage:[NSString stringWithFormat:@"next-off-%@.png", self.device]
                                      selectedImage:[NSString stringWithFormat:@"next-on-%@.png", self.device]
                                      target:self
                                      selector:@selector(onCinematicB:)];
        
        
        CCMenu *menu;
        NSLog(@"TTTT:%i",tempScore);
        if(gameData.selectedLevel == 12)
        {
        menu = [CCMenu menuWithItems:exit, restart,playCinematic, nil];
        }
        else
        {
        menu = [CCMenu menuWithItems:exit, restart, nextLevel, nil];
        }
        [menu setPosition:ccp(screenSize.width/2, menuYPos)];
        [menu alignItemsHorizontally];
        [self addChild:menu z:1];
        
        //fireworks
        [self launchFirework];
        
    }
    return self;
}
-(void)onCinematicA: (id) sender
{
    Cinematic * p = [[[Cinematic alloc]initWithLabel:[NSString stringWithFormat:@"%ia", self.currentChapter]]autorelease];
    [self addChild:p z:10];
    
}
-(void)onCinematicB: (id) sender
{
    Cinematic * p = [[[Cinematic alloc]initWithLabel:[NSString stringWithFormat:@"%ib", self.currentChapter]]autorelease];
    [self addChild:p z:10];
    
}

-(void)launchFirework
{
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    CCParticleSystem *firework = [[CCParticleExplosion alloc] initWithTotalParticles:75];
    [self addChild:firework z:101];
    int xrange = screenSize.width*0.5;
    int yrange = screenSize.height*0.3;
    int xPos = arc4random() % xrange;
    int yPos = arc4random() % yrange;
    firework.position = ccp(xPos+(screenSize.width*0.25),yPos+(screenSize.height*0.5));
    firework.gravity = ccp(0,-100);
    if(self.currentChapter == 1)
    {
    [firework setTexture:[[CCTextureCache sharedTextureCache] addImage:@"spark.png"]];
    }
    else if(self.currentChapter == 2)
    {
        // color of particles
        ccColor4F startColor = {2.0f, 2.0f, 2.0f, 1.0f};
        firework.startColor = startColor;
        firework.totalParticles = 30;
        ccColor4F startColorVar = {0.0f, 0.0f, 0.0f, 0.0f};
        firework.startColorVar = startColorVar;
        
        ccColor4F endColor = {1.0f, 1.0f, 1.0f, 0.0f};
        firework.endColor = endColor;
        
        ccColor4F endColorVar = {0.0f, 0.0f, 0.0f, 0.0f};
        firework.endColorVar = endColorVar;
    [firework setTexture:[[CCTextureCache sharedTextureCache] addImage:@"snowflakepart.png"]];
    }
    else
    {
    [firework setTexture:[[CCTextureCache sharedTextureCache] addImage:@"spark.png"]];
    }
    [self performSelector:@selector(launchFirework) withObject:nil afterDelay:1.5f];
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

