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
#import "SimpleAudioEngine.h"
#import "CDAudioManager.h"
#import "CocosDenshion.h"
#import "RootViewControllerInterface.h"


#import "GAI.h"


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
-(void)toggleSound{
    if ([[SimpleAudioEngine sharedEngine] backgroundMusicVolume] == 0) {
        // This will unmute the sound
        //hide unmute
        unmuteButton.visible = false;
        //show mute
        muteButton.visible = true;
       [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.5];
        [[SimpleAudioEngine sharedEngine] setEffectsVolume:0.5];
        
    }
    else {
        //This will mute the sound
        //show unmute
        unmuteButton.visible = true;
        //hide mute
        muteButton.visible = false;
        [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.0];
        [[SimpleAudioEngine sharedEngine] setEffectsVolume:0.0];
    }
}

- (id)init {
    
    if( (self=[super init])) {
        
        id tracker = [GAI sharedInstance].defaultTracker;
        [tracker sendEventWithCategory:@"Scene"
                            withAction:@"Go"
                             withLabel:@"Main"
                             withValue:[NSNumber numberWithInt:100]];
        
        
        [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
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
        [logo setPosition:ccp(screenSize.width*0.51, screenSize.height*0.58)];
        [self addChild:logo z:3];
    
        //animate the logo
        [logo runAction:[CCRotateTo actionWithDuration:1 angle:0]];
        CCRotateTo * rotLeft = [CCRotateBy actionWithDuration:1 angle:-0.5];
        CCMoveBy * moveLeft = [CCMoveBy actionWithDuration:2 position:ccp(-5,-2)];
        CCMoveBy * moveRight = [CCMoveBy actionWithDuration:2 position:ccp(5,2)];
        CCMoveBy * moveUp = [CCMoveBy actionWithDuration:2 position:ccp(-2,5)];
        CCMoveBy * moveDown = [CCMoveBy actionWithDuration:2 position:ccp(2,-5)];
        CCRotateTo * rotCenter = [CCRotateBy actionWithDuration:1 angle:0.0];
        CCRotateTo * rotRight = [CCRotateBy actionWithDuration:1 angle:0.5];
        CCSequence * rotSeq = [CCSequence actions:rotLeft,rotCenter, rotRight, rotCenter, rotRight, rotCenter, rotLeft, nil];
        CCSequence * moveSeq = [CCSequence actions:moveUp, moveLeft, moveDown, moveRight, nil];
        [logo runAction:[CCRepeatForever actionWithAction:rotSeq]];
        [logo runAction:[CCRepeatForever actionWithAction:moveSeq]];
        
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
        CCMenuItemImage *feedbackButton = [CCMenuItemImage
                                         itemFromNormalImage:[NSString stringWithFormat:@"feedback-off-%@.png", self.device]
                                           selectedImage:[NSString stringWithFormat:@"feedback-on-%@.png", self.device]
                                           target:self
                                    selector:@selector(feedbackForm:)];
       
        
        //CCMenuItemFont *item1 = [CCMenuItemFont itemFromString:@"Play" target:self selector:@selector(onPlay:)];
        //CCMenuItemFont *item2 = [CCMenuItemFont itemFromString:@"Options" target:self selector:@selector(onOptions:)];

        // Add font based items to CCMenu
        if([self.device isEqualToString: @"ipad"])
        {
        CCMenu *menu = [CCMenu menuWithItems:aboutButton, playButton, feedbackButton, nil];
            [menu setPosition:ccp(screenSize.width*0.5, screenSize.height*0.22)];
            [menu alignItemsHorizontally];
            [self addChild:menu];
        }
        else
        {
            CCMenu *menu = [CCMenu menuWithItems:aboutButton, playButton, nil];
            [menu setPosition:ccp(screenSize.width*0.5, screenSize.height*0.22)];
            [menu alignItemsHorizontally];
            [self addChild:menu];
        }
        
        NSLog(@"Screen width %f", screenSize.width);
        // Align the menu 
        

        // Add the menu to the scene
        
        CCParticleSystem *snow = [[CCParticleSnow alloc]init];
        
        snow.texture = [[CCTextureCache sharedTextureCache] addImage:@"snowflakepart.png"];
        snow.speed = 20;
        snow.scale = 2;
        snow.emissionRate = 7;
        //snow.position  = ccp(screenSize.width, screenSize.height);
        //snow.gravity = ccp(0,0);
        
        [self addChild:snow];
        
        
        
        //place the mute button
        muteButton = [CCSprite spriteWithFile:[NSString stringWithFormat:@"mute-%@.png", self.device]];
        [self addChild: muteButton];
        muteButton.scale = 0.80;
        [muteButton setPosition:ccp(screenSize.width*0.92, screenSize.height*0.08)];
        
        //place the unmute button
        unmuteButton = [CCSprite spriteWithFile:[NSString stringWithFormat:@"unmute-%@.png", self.device]];
        [self addChild: unmuteButton];
        unmuteButton.scale = 0.80;
        [unmuteButton setPosition:ccp(screenSize.width*0.92, screenSize.height*0.08)];
        unmuteButton.visible = false;
        //[self launchFirework];
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

-(void) feedbackForm:(id)sender {
    NSLog(@"Show the Feedback From");
    [[RootViewControllerInterface rootViewControllerInterfaceSharedInstance] sendContactMail];
    NSLog(@"Should've Showed the Feedback From");
}
-(void)launchFirework
{
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    CCParticleSystem *snow = [[CCParticleMeteor alloc]init];
    
    snow.texture = [[CCTextureCache sharedTextureCache] addImage:@"spark.png"];
    snow.speed = 50;
    snow.scale = 2.0;
    snow.emissionRate = 3;
    snow.position  = ccp(screenSize.width*0.5, screenSize.height*0.22);
    snow.gravity = ccp(0,0);
    
    [self addChild:snow];
    
    
    //int xrange = screenSize.width*0.5;
    //int yrange = screenSize.height*0.3;
    //int xPos = arc4random() % xrange;
    //int yPos = arc4random() % yrange;
    //firework.position = ccp(xPos+(screenSize.width*0.25),yPos+(screenSize.height*0.5));
   // firework.gravity = ccp(0,-100);
    //[firework setTexture:[[CCTextureCache sharedTextureCache] addImage:@"spark.png"]];
    //[self performSelector:@selector(launchFirework) withObject:nil afterDelay:1.5f];
}
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
    if (CGRectContainsPoint (muteButton.boundingBox,touchLocation))
    {
        [self toggleSound];
    }
    else if (CGRectContainsPoint (unmuteButton.boundingBox,touchLocation))
    {
        [self toggleSound];
    }
return NO;
}
@end
