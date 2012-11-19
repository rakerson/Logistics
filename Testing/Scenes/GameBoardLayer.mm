//
//  HelloWorldLayer.mm
//  SantasWorkshop
//
//  Created by Robert Akerson on 9/5/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// Import the interfaces
#import "GameBoardLayer.h"
//#import "SceneManager.h"
#import "ChapterParser.h"
#import "Chapter.h"
#import "GameData.h"
#import "GameDataParser.h"
#import "PauseMenu.h"
#import "LevelComplete.h"
#import "LevelFail.h"
#import "LevelParser.h"
#import "Level.h"
#import "CCActionManager.h"


//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.
#define PTM_RATIO 32
//#define PTM_RATIO ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 100.0 : 50.0)
//#define PTM_

// enums that will be used as tags
enum {
	kTagTileMap = 1,
	kTagBatchNode = 1,
	kTagAnimation1 = 1,
};



// GameBoardLayer implementation
@implementation GameBoardLayer
@synthesize isPaused;
@synthesize gameScore;
@synthesize isPlaying;
@synthesize rewardArray;
@synthesize currentLevel;
@synthesize currentLevelArray;
@synthesize iPad, device;


+(CCScene *) scene
{
	
    // 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	//gameLayer = [CCLayer node];
	
   // CCLayer *buttonLayer = [CCLayer node];
	// add layer as a child to scene
	//[scene addChild: _gameLayer];
	//[scene addChild: buttonLayer];
	// return the scene
	return scene;
    
}

-(void)pauseGame{
    rotateTool.visible = true;
    [self stopAnimations];
    [rotateTool setPosition:ccp(selSprite.position.x,selSprite.position.y)];
    
    isPlaying = false;
    selSprite.opacity = 128;
}
-(void)resumeGame{
    self.isPlaying=true;
    self.isPaused = false;
    [self playAnimations];
}
-(void)retryGame{
    belts = currentLevel.belts;
    fans = currentLevel.fans;
    springs = currentLevel.springs;
    strikes = 0;
    //[self removeAllTools];
    [self restartGame];
}
-(void)resetGame{
    belts = currentLevel.belts;
    fans = currentLevel.fans;
    springs = currentLevel.springs;
    strikes = 0;
    gameTime = 0;
    [self removeAllTools];
    [self restartGame];
    
}
-(void)restartGame{
    self.isPlaying=true;
    self.isPaused = false;
    //[[CCDirector sharedDirector] replaceScene:[GameBoardLayer scene]];
    //pause
    //remove all the presents.
    //reset gift count
    gifts = 0;
    bells = 0;
    strikes = 0;
    giftsRemaining = 10;
    //re place the bells
    //self.isTouchEnabled = true;
    NSLog(@"Touch Re-enabled");
    
    [self pauseGame];
    [self removeAllPresents];

    [self replaceAwardsFromArray];
    [self updateHUD];
    rotateTool.visible = false;
    [rotateTool setPosition:ccp(-1000,-1000)];
    //[self playAnimations];
    
    
}

// on "init" you need to initialize your instance
-(id) init
{
    
	// always call "super" init
    self.iPad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
    if (self.iPad) {
        self.device = @"ipad";
    }
    else {
        self.device = @"iphone";
    }

	// Apple recommends to re-assign "self" with the "super" return value
	if((self=[super init])) {
       
        
        GameData *gameData = [GameDataParser loadData];
       //int selectedChapter = gameData.selectedChapter;
        int selectedLevel = gameData.selectedLevel;
        
        
        
        // Read in selected chapter levels
       //CCMenu *levelMenu = [CCMenu menuWithItems: nil];
         
       self.currentLevelArray = [LevelParser loadLevelsForChapter:gameData.selectedChapter];
        NSLog(@" Current Level Array %@", currentLevelArray);
        for (Level *level in currentLevelArray) {
            if ([[NSNumber numberWithInt:level.number] intValue] == selectedLevel) {
                self.currentLevel = level;
                
                belts = currentLevel.belts;
                fans = currentLevel.fans;
                springs = currentLevel.springs;
                background = currentLevel.background;
            }
        }
        
        // 'layer' is an autorelease object.
        gameLayer = [CCLayer node];
        isPaused = false;
        isPlaying = true;
        gameScore = 1;
        buttonLayer = [CCLayer node];
        // add layer as a child to scene
        [self addChild: gameLayer z:1];
        [self addChild: buttonLayer z:2];
        
        //CGSize winSize = [[CCDirector sharedDirector] winSize];
        
		[lh release];
		// enable touches
		gameLayer.isTouchEnabled = NO;
		buttonLayer.isTouchEnabled = NO;
        self.isTouchEnabled = NO;
		// enable accelerometer
		self.isAccelerometerEnabled = NO;
		
		CGSize screenSize = [CCDirector sharedDirector].winSize;
		CCLOG(@"Screen width %0.2f screen height %0.2f",screenSize.width,screenSize.height);
        
		// Define the gravity vector.
		b2Vec2 gravity;
		gravity.Set(0.0f, -10.0f);
		
		// Do we want to let bodies sleep?
		// This will speed up the physics simulation
		bool doSleep = true;
		
		// Construct a world object, which will hold and simulate the rigid bodies.
		world = new b2World(gravity, doSleep);
		
		world->SetContinuousPhysics(true);
		
		// Debug Draw functions
		//m_debugDraw = new GLESDebugDraw( [LevelHelperLoader pointsToMeterRatio]  );
		//world->SetDebugDraw(m_debugDraw);
		
		//uint32 flags = 0;
		//flags += b2DebugDraw::e_shapeBit;
//		flags += b2DebugDraw::e_jointBit;
//		flags += b2DebugDraw::e_aabbBit;
//		flags += b2DebugDraw::e_pairBit;
//		flags += b2DebugDraw::e_centerOfMassBit;
		//m_debugDraw->SetFlags(flags);
		
		
		// Define the ground body.
		b2BodyDef groundBodyDef;
		groundBodyDef.position.Set(0, 0); // bottom-left corner
		
		// Call the body factory which allocates memory for the ground body
		// from a pool and creates the ground box shape (also from a pool).
		// The body is also added to the world.
		b2Body* groundBody = world->CreateBody(&groundBodyDef);
		
		// Define the ground box shape.
		b2PolygonShape groundBox;		
		
		// bottom
		groundBox.SetAsEdge(b2Vec2(0,0), b2Vec2(screenSize.width/[LevelHelperLoader pointsToMeterRatio] ,0));
		groundBody->CreateFixture(&groundBox,0);
		
		// top
		groundBox.SetAsEdge(b2Vec2(0,screenSize.height/[LevelHelperLoader pointsToMeterRatio] ), b2Vec2(screenSize.width/[LevelHelperLoader pointsToMeterRatio] ,screenSize.height/[LevelHelperLoader pointsToMeterRatio] ));
		groundBody->CreateFixture(&groundBox,0);
		
		// left
		groundBox.SetAsEdge(b2Vec2(0,screenSize.height/[LevelHelperLoader pointsToMeterRatio] ), b2Vec2(0,0));
		groundBody->CreateFixture(&groundBox,0);
		
		// right
		groundBox.SetAsEdge(b2Vec2(screenSize.width/[LevelHelperLoader pointsToMeterRatio] ,screenSize.height/[LevelHelperLoader pointsToMeterRatio] ), b2Vec2(screenSize.width/[LevelHelperLoader pointsToMeterRatio] ,0));
		groundBody->CreateFixture(&groundBox,0);
		
				
		[self schedule: @selector(tick:)];
        
        //NSString* currentLevel = [[SimpleLevelManager sharedInstance] activeLevel];
        
        //GameData *gameData = [GameDataParser loadData];
    
        NSLog(@"activeLevel: %d", gameData.selectedLevel);
        NSString * levelToLoad = [NSString stringWithFormat:@"level%i-%i", gameData.selectedChapter, gameData.selectedLevel];
        //TUTORIAL - loading the active leve    l
        lh = [[LevelHelperLoader alloc] initWithContentOfFile:levelToLoad];
        

        //notification have to be added before creating the objects
        //if you dont want notifications - it is better to remove this lines
        //[lh registerNotifierOnAllPathEndPoints:self selector:@selector(spriteMoveOnPathEnded:pathUniqueName:)];
        //[lh registerNotifierOnAllAnimationEnds:self selector:@selector(spriteAnimHasEnded:animationName:)];
        //[lh enableNotifOnLoopForeverAnimations];
        
        //add in the background...
        //CCSprite * bg = [CCSprite spriteWithFile:@"level-back-small-1.jpg"];
        //NSString * tBackground = [NSString stringWithFormat:@"%@-%@.jpg", background, self.device];
        //NSString * tBackground = [NSString stringWithFormat:@"level-%i-back-%@.png", gameData.selectedChapter, self.device];
        NSString * tBackground = [NSString stringWithFormat:@"level-1-back-%@.png", self.device];
        hue = (gameData.selectedLevel*0.22);
        hue = fmodf(hue, 1.0f);
        shade = 0.75;
        value = 0.75;
        
        //h = h/360;
        
        [self HSVtoRGB];
        GLubyte rr = (red*255);
        GLubyte gg = (green*255);
        GLubyte bb = (blue*255);
         
        //NSString * tBackground = [background stringByAppendingString:@"@2x.jpg"];
        //s = [s stringByAppendingString:@" - après"];
        CCSprite * bg = [CCSprite spriteWithFile:tBackground];
        bg.color = ccc3(rr, gg,bb);
        [bg setPosition:ccp(screenSize.width/2, screenSize.height/2)];
        //bg.scale = 0.5;
        [self addChild:bg z:-10];

        
        //creating the objects
        [lh addObjectsToWorld:world cocos2dLayer:gameLayer];
        
        //add the menu buttons
        float buttonSpacing= 1.0;
        if(self.device == @"iphone")
        {
            buttonSpacing = 1.25;
        }
        //place the top matte
        topMatte = [CCSprite spriteWithFile:@"85.png"];
        

        topMatte.color = ccc3(rr, gg,bb);
        
        
        [buttonLayer addChild: topMatte];
        topMatte.scaleX = screenSize.width/topMatte.contentSize.width;
        topMatte.scaleY = (screenSize.height*0.08)/topMatte.contentSize.height;
        [topMatte setAnchorPoint:ccp(0,0)];
        [topMatte setPosition:ccp(0, screenSize.height-(topMatte.contentSize.height*topMatte.scaleY))];
        
        //place the bottom matte
        bottomMatte = [CCSprite spriteWithFile:@"85.png"];
        [buttonLayer addChild: bottomMatte];
        bottomMatte.scaleX = screenSize.width/bottomMatte.contentSize.width;
        bottomMatte.scaleY = (screenSize.height*0.08)/bottomMatte.contentSize.height;
        [bottomMatte setAnchorPoint:ccp(0,0)];
        [bottomMatte setPosition:ccp(0, 0)];
        bottomMatte.color = ccc3(rr, gg,bb);
        
        //place the pause button
        pauseButton = [CCSprite spriteWithFile:[NSString stringWithFormat:@"pause-on-%@.png", self.device]];
        [buttonLayer addChild: pauseButton];
        [pauseButton setPosition:ccp(screenSize.width*(0.07*buttonSpacing), screenSize.height*0.05)];

        //place belt button
        beltButton = [CCSprite spriteWithFile:[NSString stringWithFormat:@"belt-on-%@.png", self.device]];
        [buttonLayer addChild:  beltButton];
        [beltButton setPosition:ccp(screenSize.width*(0.17*buttonSpacing), screenSize.height*0.05)];
        
        //place fan button
        fanButton = [CCSprite spriteWithFile:[NSString stringWithFormat:@"fan-on-%@.png", self.device]];
        [buttonLayer addChild:  fanButton];
        [fanButton setPosition:ccp(screenSize.width*(0.27*buttonSpacing), screenSize.height*0.05)];
        
        //place spring button
        springButton = [CCSprite spriteWithFile:[NSString stringWithFormat:@"spring-on-%@.png", self.device]];
        [buttonLayer addChild:  springButton];
        [springButton setPosition:ccp(screenSize.width*(0.37*buttonSpacing), screenSize.height*0.05)];
              
        [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
        currentItemName = @"";
        currentSpriteSheet = @"Chapter1";
        currentTAG = FAN;
        currentFile = @"logistics-chapter1";
        
        [self setupCollisionHandling];
        [self initHUDLayer];
        [self initRewards];
    
	}
    
	return self;
}
-(void)showLevelFail
{
    NSLog(@"FAIL");
    isPlaying = false;
    isPaused = true;
    [self stopAnimations];
    LevelFail * lf = [[[LevelFail alloc]init]autorelease];
    [self addChild:lf z:12];
}
-(void)calculateScore{
    //calculate the score
    gameScore = 2;
    //levelScore = ((totalTools - usedTools)*100);
    //gift bonus
    int madeGifts = 10-strikes;
    //tool ponus

    int unusedTools = fans + belts;
    //bell bonus
    gameScore = (madeGifts+unusedTools+bells);
    if(strikes == 0)
    {
        gameScore+=5;
    }
    if(bells == 3)
    {
        gameScore+=5;
    }
    //calculate the stars
    //multiply the bonus amount
    //reduce the gameTime amount
    
    gameScore*=500;
    
    //return bonus;
    
    gameScore-=gameTime;
    //time Bonus??
    
    
    NSLog(@"Missed Gifts %i", madeGifts);
    NSLog(@"Unused Tools %i", unusedTools);
    NSLog(@"LEVEL SCORE %i", gameScore);
    NSLog(@"GAME TIME%f", gameTime);
    
    //
}
-(void)showLevelComplete
{

    isPlaying = false;
    isPaused = true;
    [self stopAnimations];
    [self calculateScore];
    NSLog(@" ----Current Level Array %@", currentLevelArray);
    
    currentLevel.userLastScore = gameScore;
    NSLog(@"CURRENT LEVEL SCORE %i", currentLevel.userLastScore);
    GameData *gameData = [GameDataParser loadData];
    //unlock the next level
    //gameData.levelScore = gameScore;
    for (Level *level in currentLevelArray) {
        if ([[NSNumber numberWithInt:level.number] intValue] == gameData.selectedLevel) {
            level.userLastScore = gameScore;
            if(level.stars < bells)
            {
                level.stars = bells;
            }
            if(gameScore >=level.userHighScore)
            {
                level.userHighScore = gameScore;
            }
        }
        
        if ([[NSNumber numberWithInt:level.number] intValue] == gameData.selectedLevel+1) {
            
            level.unlocked = 1;
        }
    }

    [LevelParser saveData:currentLevelArray forChapter:gameData.selectedChapter];
    
    LevelComplete * p = [[[LevelComplete alloc]init]autorelease];
    NSLog(@"LEVEL SCORE after alloc %i", gameData.levelScore);
    [self addChild:p z:11];
    
}
-(void)showPauseMenu
{
    isPlaying = false;
    isPaused = true;
    [self stopAnimations];
    [self deselectActors];
    PauseMenu * p = [[[PauseMenu alloc]init]autorelease];
    [self addChild:p z:10];
    
}
- (void)initRewards{
    rewardArray = [[NSMutableArray alloc] init];
   
    for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
    {
        
        if (b->GetUserData() != NULL) {
            //Synchronize the AtlasSprites position and rotation with the corresponding body
            LHSprite *myActor = (LHSprite*)b->GetUserData();
            if(myActor.tag == REWARD)
            {
               NSLog(@"initRewards");
                [rewardArray addObject:myActor];
            }
            
        }
    }
      
}

- (void)handleRotationFrom:(UIPanGestureRecognizer *)recognizer
{
   editMode = @"rotate";
    NSLog(@"GESTURE");
    //CGPoint translation = [recognizer translationInView:recognizer.view];
}

-(void) updateHUD
{   
    [bellCounter setString:[NSString stringWithFormat:@"Bells: %d", bells]];
    [giftCounter setString:[NSString stringWithFormat:@"Gifts: %d", gifts]];
    [beltCounter setString:[NSString stringWithFormat:@"%d", belts]];
    [fanCounter setString:[NSString stringWithFormat:@"%d", fans]];
    [springCounter setString:[NSString stringWithFormat:@"%d", springs]];
    [giftRemainingCounter setString:[NSString stringWithFormat:@"%d", giftsRemaining]];
    //update strikes
    NSString *strikeImage = [NSString stringWithFormat:@"%istrikes-%@.png",strikes, self.device];
    [buttonLayer removeChild:strikeSprite cleanup:TRUE];
    strikeSprite = [CCSprite spriteWithFile:strikeImage];
    [buttonLayer addChild:strikeSprite];
    CGSize winSize = [CCDirector sharedDirector].winSize;
    strikeSprite.position = ccp(winSize.width*0.9,winSize.height*0.95);
    strikeSprite.rotation = -90;
    
}
-(void) initHUDLayer
{
    float buttonSpacing= 1.0;
    if(self.device == @"iphone")
    {
        buttonSpacing = 1.25;
    }
    

    strikes = 0;
    bells =0;
    gifts =0;
    giftsRemaining = 10;
    fanAngle = 0;
    //belts = 5;
    //fans= 1;
    //add level title
   CGSize winSize = [CCDirector sharedDirector].winSize;
   int largeFont = winSize.height / kFontScaleLarge;
    int mediumFont = winSize.height / kFontScaleMedium;
    int smallFont = winSize.height / kFontScaleSmall;
    giftCounter = [CCLabelTTF labelWithString:@"Gifts: 0" fontName:@"Fontdinerdotcom" fontSize:32];
    
    giftCounter.position =  ccp(winSize.width*0.4,winSize.height-40);
    
    giftCounter.visible = false;
    [buttonLayer addChild: giftCounter];
    
    //add the gift remaining counter
    giftRemainingCounter = [CCLabelTTF labelWithString:@"10" fontName:@"Fontdinerdotcom" fontSize:largeFont];
    giftRemainingCounter.position =  ccp(winSize.width*0.093,winSize.height*0.88);
    [giftRemainingCounter setColor:ccc3 (0,0,0)];
    [buttonLayer addChild: giftRemainingCounter];
    
    //add belt counter
    beltCounter = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", belts] fontName:@"Fontdinerdotcom" fontSize:smallFont];
    [beltCounter setPosition:ccp(winSize.width*(0.2*buttonSpacing), winSize.height*0.04)];
    
    [beltCounter setColor:ccc3 (95,58,0)];
    [buttonLayer addChild: beltCounter];
    
    
    //add fan counter
    fanCounter = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", fans] fontName:@"Fontdinerdotcom" fontSize:smallFont];
    [fanCounter setPosition:ccp(winSize.width*(0.3*buttonSpacing), winSize.height*0.04)];
    
    
    [fanCounter setColor:ccc3 (95,58,0)];
    [buttonLayer addChild: fanCounter];
    
    
    //add spring counter
    springCounter = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", springs] fontName:@"Fontdinerdotcom" fontSize:smallFont];
    [springCounter setPosition:ccp(winSize.width*(0.4*buttonSpacing), winSize.height*0.04)];
    
    
    [springCounter setColor:ccc3 (95,58,0)];
    [buttonLayer addChild: springCounter];
    
    //add bell counter
    bellCounter = [CCLabelTTF labelWithString:@"Bells: 0" fontName:@"Fontdinerdotcom" fontSize:mediumFont];
    bellCounter.position =  ccp(winSize.width*0.6,winSize.height-40);
    bellCounter.visible = false;
    [buttonLayer addChild: bellCounter];
    
    
    //Add stike counter
    NSString *strikeImage = [NSString stringWithFormat:@"%istrikes-%@.png",strikes, self.device];
    strikeSprite = [CCSprite spriteWithFile:strikeImage];
    [buttonLayer addChild:strikeSprite];
    strikeSprite.position = ccp(winSize.width*0.9,winSize.height*0.95);
    strikeSprite.rotation = -90;
    
    //rotate tool
    rotateTool = [lh createSpriteWithName:@"rotate" fromSheet:currentSpriteSheet fromSHFile:currentFile  tag:ROTATOR];
    //rotateTool.zOrder = 10000;
    rotateTool.visible = false;
    [rotateTool setPosition:ccp(-1000,-1000)];
    
    
}
-(void) setupCollisionHandling
{
    
    
    [lh useLevelHelperCollisionHandling];
    NSLog(@"COllisions Setup");
    [lh registerBeginOrEndCollisionCallbackBetweenTagA:PRESENT andTagB:GOAL idListener:self selListener:@selector(presentGoalCollision:)];
    [lh registerBeginOrEndCollisionCallbackBetweenTagA:PRESENT_FAN andTagB:GOAL idListener:self selListener:@selector(presentGoalCollision:)];
    [lh registerBeginOrEndCollisionCallbackBetweenTagA:PRESENT_BELT andTagB:GOAL idListener:self selListener:@selector(presentGoalCollision:)];
    [lh registerBeginOrEndCollisionCallbackBetweenTagA:PRESENT andTagB:REWARD idListener:self selListener:@selector(presentRewardCollision:)];
    [lh registerBeginOrEndCollisionCallbackBetweenTagA:PRESENT_FAN andTagB:REWARD idListener:self selListener:@selector(presentRewardCollision:)];
    [lh registerBeginOrEndCollisionCallbackBetweenTagA:PRESENT_BELT andTagB:REWARD idListener:self selListener:@selector(presentRewardCollision:)];
    [lh registerBeginOrEndCollisionCallbackBetweenTagA:PRESENT andTagB:FAN idListener:self selListener:@selector(presentFanCollision:)];
    [lh registerBeginOrEndCollisionCallbackBetweenTagA:PRESENT_BELT andTagB:FAN idListener:self selListener:@selector(presentFanCollision:)];
    [lh registerBeginOrEndCollisionCallbackBetweenTagA:PRESENT_BELT andTagB:PRESENT_FAN idListener:self selListener:@selector(presentFanCollision:)];
    
    [lh registerBeginOrEndCollisionCallbackBetweenTagA:PRESENT_FAN andTagB:FAN idListener:self selListener:@selector(presentFanCollisionEnd:)];
    [lh registerBeginOrEndCollisionCallbackBetweenTagA:PRESENT andTagB:BELT idListener:self selListener:@selector(presentBeltCollision:)];
    [lh registerBeginOrEndCollisionCallbackBetweenTagA:PRESENT_BELT andTagB:BELT idListener:self selListener:@selector(presentBeltCollisionEnd:)];
    [lh registerBeginOrEndCollisionCallbackBetweenTagA:PRESENT andTagB:FLOOR idListener:self selListener:@selector(presentFloorCollision:)];
    [lh registerBeginOrEndCollisionCallbackBetweenTagA:PRESENT_FAN andTagB:FLOOR idListener:self selListener:@selector(presentFloorCollision:)];
    [lh registerBeginOrEndCollisionCallbackBetweenTagA:PRESENT_BELT andTagB:FLOOR idListener:self selListener:@selector(presentFloorCollision:)];
    
    [lh registerBeginOrEndCollisionCallbackBetweenTagA:PRESENT andTagB:SPRING idListener:self selListener:@selector(presentSpringCollision:)];
    
}
-(void)presentBeltCollision:(LHContactInfo*)contact
{
    contact.spriteA.tag = PRESENT_BELT;
}
-(void)presentBeltCollisionEnd:(LHContactInfo*)contact
{
    contact.spriteA.tag = PRESENT;
}

-(void)presentFanCollision:(LHContactInfo*)contact
{
    //NSLog(@"Present FAN Collision");
    contact.spriteA.tag = PRESENT_FAN;
}
-(void)presentFanCollisionEnd:(LHContactInfo*)contact
{
    
    contact.spriteA.tag = PRESENT;
}
-(void)presentSpringCollision:(LHContactInfo*)contact
{
    //Animate the spring
    //contact.S
    LHSprite * tSprite = contact.spriteB;
    [tSprite restartAnimation];
    //Apply force
    b2Vec2 force = b2Vec2(sinf (CC_DEGREES_TO_RADIANS(contact.spriteB.rotation))*50, cosf (CC_DEGREES_TO_RADIANS(contact.spriteB.rotation))*50);
    contact.bodyA->ApplyForce(force, contact.bodyA->GetWorldCenter());
    
    NSLog(@"SPRING");
}


+ (id)explodeInWorld:(b2World *)w onPosition:(b2Vec2)p withForce:(float)f excludeBody:(b2Body *)eb {
    if (f < 1.0f) f = 1.0f;
    b2Body* node = w->GetBodyList();
    while (node) {
        b2Body* b = node;
        node = node->GetNext();
        if (NULL != b && eb != b && nil != b->GetUserData()) {
            b2Vec2 direction = b->GetWorldCenter() - p;
            if (0.0f == direction.x) direction.x = 0.1f;
            if (0.0f == direction.y) direction.y = 0.1f;
            b2Vec2 impulse = b2Vec2(1.0f/direction.x * f, 1.0f/direction.y * f);
            if (b2_dynamicBody == b->GetType()) {  // Do this here only for dynamic bodies
                b->ApplyLinearImpulse(impulse, b->GetWorldCenter());
            }
        }
    }
    
    return [[[self alloc] init] autorelease];
}
-(void)presentGoalCollision:(LHContactInfo*)contact
{
    contact.spriteA.tag = 0;
    [[contact.spriteA parent] removeChild:contact.spriteA cleanup:YES];
    
    gifts+=1;
    [self updateHUD];  
}


-(void)presentFloorCollision:(LHContactInfo*)contact
{
    contact.spriteA.tag = 0;
    [[contact.spriteA parent] removeChild:contact.spriteA cleanup:YES];
    //gifts-=1;
    strikes+=1;
    [self updateHUD];
}
-(void)presentRewardCollision:(LHContactInfo*)contact
{
    //NSLog(@"Sprite A \"%@\" Sprite B \"%@\" ",  contact.spriteA, contact.spriteB);
    //remove spriteA
    contact.spriteB.tag = 0;
    [contact.spriteB removeSelf];
    //[contact.spriteB removeBodyFromWorld];
    
    //
    //[[contact.spriteB parent] removeChild:contact.spriteB cleanup:YES];
    
    bells+=1;
    [self updateHUD];
    
}


////////////////////////////////////////////////////////////////////////////////
-(void)spriteBALLMoveOnPathEnded:(LHSprite*)spr pathUniqueName:(NSString*)pathName
{
    NSLog(@"BALL Sprite \"%@\" movement on path \"%@\" has just ended.", [spr uniqueName], pathName);
}
////////////////////////////////////////////////////////////////////////////////
-(void)spriteMoveOnPathEnded:(LHSprite*)spr pathUniqueName:(NSString*)pathName
{
    NSLog(@"Sprite \"%@\" movement on path \"%@\" has just ended.", [spr uniqueName], pathName);
}
////////////////////////////////////////////////////////////////////////////////
-(void) spriteAnimHasEnded:(LHSprite*)spr animationName:(NSString*)animName
{
    NSLog(@"Animation with name %@ has ended on sprite %@", animName, [spr uniqueName]);
}
////////////////////////////////////////////////////////////////////////////////
-(void) spriteAnimOtherAnimHasEnded:(LHSprite*)spr animationName:(NSString*)animName
{
    NSLog(@"OTHER Animation with name %@ has ended on sprite %@", animName, [spr uniqueName]);
}
//////////////////////////////////////////////1
//////////////////////////////////

-(void)placeFan{
    currentItemName = @"fan0";
    currentSpriteSheet = @"Chapter1";
    currentTAG = FAN;
    currentFile = @"logistics-chapter1";
}
-(void)placeBelt{
    currentItemName = @"belt0";
    currentSpriteSheet = @"Chapter1";
    currentTAG = BELT;
    currentFile = @"logistics-chapter1";
}
-(void)removeItem{
    
    [selSprite removeSelf];
    [selSprite removeBodyFromWorld];
    //hide rotatation
    [rotateTool setPosition:ccp(-1000,-1000)];
    //[self deselectActors];
    [self updateHUD];
    
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
   NSLog(@"Touch Began 1111");
    if(!isPaused)
    {
    CGPoint touchLocation = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
    if (CGRectContainsPoint (beltButton.boundingBox,touchLocation) && belts > 0)
    {
        LHSprite* myNewSprite = [lh createSpriteWithName:@"belt0" fromSheet:currentSpriteSheet fromSHFile:currentFile  tag:BELT];
        [myNewSprite.parent reorderChild:myNewSprite z:-500];
        [myNewSprite prepareAnimationNamed:@"belt-anim" fromSHScene:@"logistics-chapter1"];
        [myNewSprite transformPosition:ccp(touchLocation.x,touchLocation.y)];
        [myNewSprite playAnimation];
        [self deselectActors];
        selSprite = myNewSprite;
        selSpriteBody = myNewSprite.body;
        rotateTool.position = myNewSprite.position;
        editMode = @"move";
        belts-=1;
        [self updateHUD];
        
    }
    else if (CGRectContainsPoint (fanButton.boundingBox,touchLocation) && fans > 0)
    {
        LHSprite* myNewSprite = [lh createSpriteWithName:@"fan0" fromSheet:currentSpriteSheet fromSHFile:currentFile  tag:FAN];
         [myNewSprite.parent reorderChild:myNewSprite z:-500];
        [myNewSprite prepareAnimationNamed:@"fan-anim" fromSHScene:@"logistics-chapter1"];
        [myNewSprite transformPosition:ccp(touchLocation.x,touchLocation.y)];
        [myNewSprite playAnimation];
       [self deselectActors];
        selSprite = myNewSprite;
        selSpriteBody = myNewSprite.body;
        editMode = @"move";
        fans-=1;
        [self updateHUD];
        
    }
    else if (CGRectContainsPoint (springButton.boundingBox,touchLocation) && springs > 0)
    {
        LHSprite* myNewSprite = [lh createSpriteWithName:@"spring0" fromSheet:currentSpriteSheet fromSHFile:currentFile  tag:SPRING];
        [myNewSprite.parent reorderChild:myNewSprite z:-500];
        [myNewSprite prepareAnimationNamed:@"spring-anim" fromSHScene:@"logistics-chapter1"];
        [myNewSprite transformPosition:ccp(touchLocation.x,touchLocation.y)];
        //[myNewSprite playAnimation];
        [self deselectActors];
        selSprite = myNewSprite;
        selSpriteBody = myNewSprite.body;
        editMode = @"move";
        springs-=1;
        [self updateHUD];
        
    }
    else if (CGRectContainsPoint (pauseButton.boundingBox,touchLocation))
    {
        [self showPauseMenu];
    }
    
    else if (CGRectContainsPoint (rotateTool.boundingBox,touchLocation))
    {
        editMode = @"rotate";    
    }
    else
    {
        [self deselectActors];
    }
    [self selectSpriteForTouch:touchLocation];
   
    return TRUE;
}
return FALSE;

}
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint location = [touch locationInView: [touch view]];
    location = [[CCDirector sharedDirector] convertToGL: location];
    if(shooterPull == true)
    {
        shooterPull = false;
        NSLog(@"  shooter points: %f-%f", shooterStartPoint.x,location.x);
        
        //NSLog(@"DROP THE PRESENT");
        giftsRemaining -=1;
        [self updateHUD];
        //int random = [self getRandomNumberBetweenMin:0 andMax:3];
        NSString *theGift = [NSString stringWithFormat:@"ball1"];
        LHSprite* myNewSprite = [lh createSpriteWithName:theGift fromSheet:currentSpriteSheet fromSHFile:currentFile  tag:PRESENT];
        [myNewSprite.parent reorderChild:myNewSprite z:-5];
        
        [myNewSprite transformPosition:ccp(shooterSprite.position.x,shooterSprite.position.y)];
        
        
       
        
        //Apply force
        //float xForce = (shooterStartPoint.x-location.x)*0.2;
        //float yForce = (shooterStartPoint.y-location.y)*0.2;
        //b2Vec2 force = b2Vec2(xForce,yForce);
        
        //Apply force
        b2Vec2 force = b2Vec2(sinf (CC_DEGREES_TO_RADIANS(shooterSprite.rotation-90))*100, cosf (CC_DEGREES_TO_RADIANS(shooterSprite.rotation-90))*100);
        //contact.bodyA->ApplyForce(force, contact.bodyA->GetWorldCenter());
        
        //b2Vec2 force = b2Vec2(shooterStartPoint,location);
        myNewSprite.body->ApplyForce(force, myNewSprite.body->GetWorldCenter());
        //contact.bodyA->ApplyForce(force, contact.bodyA->GetWorldCenter());
        //myNewSprite.zOrder = 1;
        
        
        
        [self playGame];
        
    }
    //NSLog(@"Touch 222  \"%f\" Ended:", location.x);
    if (CGRectContainsPoint (bottomMatte.boundingBox,location) && selSprite.tag == BELT)
    {
        NSLog(@"Remove Belt");
        belts+=1;
        [self removeItem];
    }
    if (CGRectContainsPoint (bottomMatte.boundingBox,location) && selSprite.tag == FAN)
    {
        NSLog(@"Remove FAN");
        fans+=1;
        [self removeItem];
    }
    if (CGRectContainsPoint (bottomMatte.boundingBox,location) && selSprite.tag == SPRING)
    {
        NSLog(@"Remove Spring");
        springs+=1;
        [self removeItem];
    }
}



-(void)playGame{
    NSLog(@"PlayGame");
    isPlaying = true;
    isPaused = false;
    rotateTool.visible = false;
    [rotateTool setPosition:ccp(-1000,-1000)];
    selSprite.opacity = 255;
    [self playAnimations];
    ///
}

-(void)toggleSound{
    
    ///
}


-(void)removeAllRewards{
    }

-(void)removeAllPresents{
    
    for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
    {
        
        if (b->GetUserData() != NULL) {
            //Synchronize the AtlasSprites position and rotation with the corresponding body
            LHSprite *myActor = (LHSprite*)b->GetUserData();
            if(myActor.tag == PRESENT_BELT || myActor.tag == PRESENT_FAN || myActor.tag == PRESENT)
            {
                [myActor removeSelf];
                [myActor removeBodyFromWorld];
            }
            
        }
    }
}


-(void)replaceAwardsFromArray{
    NSLog(@"REPLACE REWARDS FROM ARRAY \"%u\" :",rewardArray.count);
    for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
    {
        
        if (b->GetUserData() != NULL) {
            //Synchronize the AtlasSprites position and rotation with the corresponding body
            LHSprite *myActor = (LHSprite*)b->GetUserData();
            if(myActor.tag == REWARD)
            {
                NSLog(@"Remove");
            [myActor removeSelf];
            [myActor removeBodyFromWorld];
            }
            
        }
    }

    for (LHSprite *item in rewardArray)
        {
        NSLog(@"LOOP  %f", item.position.x);
       LHSprite* myNewSprite = [lh createSpriteWithName:@"bell" fromSheet:currentSpriteSheet fromSHFile:currentFile  tag:REWARD];
            
            [myNewSprite transformPosition:ccp(item.position.x,item.position.y)];
       //  firefox myNewSprite.position = item.position;
        }
    }
-(void)stopAnimations{
    
    for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
    {
        
        if (b->GetUserData() != NULL) {
            LHSprite *myActor = (LHSprite*)b->GetUserData();
            if(myActor.tag == FAN || myActor.tag == BELT)
            {
                //Synchronize the AtlasSprites position and rotation with the corresponding body
                //LHSprite *myActor = (LHSprite*)b->GetUserData();
                //[[CCActionManager sharedManager] pauseAllActionsForTarget:myActor];
                //[[CCActionManager sharedManager] pauseTarget:myActor];
                NSLog(@"PAUSE -- Anim");
                [myActor pauseAnimation];
            }
        }
    }
}
-(void)playAnimations{
    
    for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
    {
        
        if (b->GetUserData() != NULL) {
            LHSprite *myActor = (LHSprite*)b->GetUserData();
            if(myActor.tag == FAN || myActor.tag == BELT)
            {
                NSLog(@"PLayAnim");
                //Synchronize the AtlasSprites position and rotation with the corresponding body
                //LHSprite *myActor = (LHSprite*)b->GetUserData();
                //[[CCActionManager sharedManager] resumeAllActionsForTarget:myActor];
                //[[CCActionManager sharedManager] resumeTarget:myActor];
                
                [myActor restartAnimation];
                //[myActor playAnimation];
            }
        }
    }
}
-(void)removeAllTools{
    
    for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
    {
        
        if (b->GetUserData() != NULL) {
            LHSprite *myActor = (LHSprite*)b->GetUserData();
            if(myActor.tag == FAN || myActor.tag == BELT || myActor.tag == SPRING)
            {
            //Synchronize the AtlasSprites position and rotation with the corresponding body
            //LHSprite *myActor = (LHSprite*)b->GetUserData();
            [myActor removeSelf];
            [myActor removeBodyFromWorld];
            }
        }
    }
}
-(void)showLevelMenu{
   // [self removeAllItems];
    //[[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInT transitionWithDuration:0.2 scene:[LevelSelector node]]];
}

-(void) draw
{
	// Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	// Needed states:  GL_VERTEX_ARRAY, 
	// Unneeded states: GL_TEXTURE_2D, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_COLOR_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	
    
    //m_debugDraw = new GLESDebugDraw( [LevelHelperLoader pointsToMeterRatio] );
	//world->DrawDebugData();
	
	// restore default GL states
	glEnable(GL_TEXTURE_2D);
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);

}


-(void) tick: (ccTime) dt
{
	if(isPlaying)
    {
        gameTime+=.1;
    //It is recommended that a fixed time step is used with Box2D for stability
	//of the simulation, however, we are using a variable time step here.
	//You need to make an informed choice, the following URL is useful
	//http://gafferongames.com/game-physics/fix-your-timestep/
	
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
	
	// Instruct the world to perform a single step of simulation. It is
	// generally best to keep the time step and iterations fixed.
	world->Step(dt, velocityIterations, positionIterations);

       
	//Iterate over the bodies in the physics world
	for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
        {
            
            if (b->GetUserData() != NULL) {
                
                //Synchronize the AtlasSprites position and rotation with the corresponding body
                LHSprite *myActor = (LHSprite*)b->GetUserData();
                if(myActor.tag == FAN)
                {
                fanAngle = myActor.rotation;
                }
                if(myActor.tag != ROTATOR)
                {
                //myActor.position = CGPointMake( b->GetPosition().x * PTM_RATIO, b->GetPosition().y * PTM_RATIO);
                
                    
                myActor.position = [LevelHelperLoader metersToPoints:b->GetPosition()];
                myActor.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
                
                if(myActor.tag == PRESENT_BELT)
                    {
                    b2Vec2 force = b2Vec2(0.6, 0);
                    b->ApplyForce(force, b->GetWorldCenter());
                    }
                if(myActor.tag == PRESENT_FAN)
                {
                    b2Vec2 force = b2Vec2(sinf (CC_DEGREES_TO_RADIANS(fanAngle))*2, cosf (CC_DEGREES_TO_RADIANS(fanAngle))*2);
                    b->ApplyForce(force, b->GetWorldCenter());
                }
                }
            }
        }
    //check if level is complete
    if (strikes >= 3)
        {
            [self showLevelFail];
        }
   
    if (strikes+gifts >= 10)
        {
            [self showLevelComplete];
        }
    }
}
/*
- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"Touches began");

}
- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"Touches Ended");

}*/
- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{	
	static float prevX=0, prevY=0;
	
	//#define kFilterFactor 0.05f
#define kFilterFactor 1.0f	// don't use filter. the code is here just as an example
	
	float accelX = (float) acceleration.x * kFilterFactor + (1- kFilterFactor)*prevX;
	float accelY = (float) acceleration.y * kFilterFactor + (1- kFilterFactor)*prevY;
	
	prevX = accelX;
	prevY = accelY;
	
	// accelerometer values are in "Portrait" mode. Change them to Landscape left
	// multiply the gravity by 10
	b2Vec2 gravity( -accelY * 10, accelX * 10);
	
	world->SetGravity( gravity );
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	delete world;
	world = NULL;
	
	//delete m_debugDraw;

	// don't forget to call "super dealloc"
	[super dealloc];
}
-(int) getRandomNumberBetweenMin:(int)min andMax:(int)max
{
	return ( (arc4random() % (max-min+1)) + min );
}

- (void)selectSpriteForTouch:(CGPoint)touchLocation
{
   // Boolean needNewSprite = true;
    LHSprite * newSprite = nil;
    for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
    {
      
       if (b->GetUserData() != NULL)
        {
            //Synchronize the AtlasSprites position and rotation with the corresponding body
            LHSprite *myActor = (LHSprite*)b->GetUserData();
           
            //if(isPlaying)
            //{
                if(myActor.tag == SHOOTER && giftsRemaining > 0)
                {
                    if (CGRectContainsPoint(myActor.boundingBox, touchLocation))
                    {
                    shooterSprite = myActor;
                    //myActor.rotation = 45;
                    NSLog(@"Start Shooter");
                    shooterPull = true;
                    shooterStartPoint = touchLocation;
                    }
                    
                }
                else if(myActor.tag == PRESENT_DROP && giftsRemaining > 0)
                {
                    if (CGRectContainsPoint(myActor.boundingBox, touchLocation))
                    {
                        //animate the launcher
                       [myActor prepareAnimationNamed:@"launcher" fromSHScene:@"logistics-chapter1"];
                        
                        [myActor playAnimation];
                
                         //start the game
                        //NSLog(@"DROP THE PRESENT");
                        giftsRemaining -=1;
                        [self updateHUD];
                        int random = [self getRandomNumberBetweenMin:0 andMax:3];
                        NSString *theGift = [NSString stringWithFormat:@"ball%i", random];
                        LHSprite* myNewSprite = [lh createSpriteWithName:theGift fromSheet:currentSpriteSheet fromSHFile:currentFile  tag:PRESENT];
                        [myNewSprite.parent reorderChild:myNewSprite z:-5];
                       
                        [myNewSprite transformPosition:ccp(myActor.position.x,myActor.position.y-50)];
                        //myNewSprite.zOrder = 1;
                        
                        [myActor.parent reorderChild:myActor z:1000];
                        
                        
                        [self playGame];
                        break;
                    }
                }
            //}

            //else
            //{
            if (CGRectContainsPoint(myActor.boundingBox, touchLocation))
                {
                if(myActor.tag == BELT || myActor.tag == FAN || myActor.tag == SPRING)
                    {
                   
                    NSLog(@"BELT/Actor");
                    newSprite = myActor;
                    selSpriteBody = newSprite.body;
                    [self restartGame];
                    
                    [self setSelSprite :newSprite];
                    editMode = @"move";
                    rotateTool.visible = true;
                    [rotateTool setPosition:ccp(selSprite.position.x,selSprite.position.y)];
                    break;
                    }
                if(myActor.tag == ROTATOR)
                    {
                    [self restartGame];
                    
                    editMode = @"rotate";
                    rotateTool.visible = true;
                    [rotateTool setPosition:ccp(selSprite.position.x,selSprite.position.y)];
                    //NSLog(@"ROTATE");
                    break;
                    }
                }
            //}
        }
    }

}

-(void)deselectActors{
    NSLog(@"Deselect Actors");
    rotateTool.visible = false;
    [rotateTool setPosition:ccp(-1000,-1000)];
    for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
    {
        
    if (b->GetUserData() != NULL)
        {
        LHSprite *myActor = (LHSprite*)b->GetUserData();
        myActor.opacity = 255;
        }
    }
    selSprite = nil;
    selSpriteBody = nil;
}

-(void) setSelSprite:(LHSprite*)newSprite
    {
    if(newSprite != selSprite)
        {
        //unhighlight the rest
        //[self deselectActors];
        
            //highlight the selected sprite;
            newSprite.opacity = 128;
            rotateTool.visible = true;
            
            //add the rotate tool

            [newSprite retain];
            [selSprite release];
            selSprite = newSprite;
            rotateTool.position = newSprite.position;
            
        }
    }

-(LHSprite*)selSprite
    {
        
    return selSprite;
    }

- (CGPoint)boundLayerPos:(CGPoint)newPos {
    CGSize winSize = [CCDirector sharedDirector].winSize;
    CGPoint retval = newPos;
    retval.x = MIN(retval.x, 0);
    retval.x = MAX(retval.x, winSize.width);
    retval.y = self.position.y;
    return retval;
}

- (void)panForTranslation:(CGPoint)translation {
    if (selSprite && !isPlaying) {
        
        CGPoint newPos = ccpAdd(selSprite.position, translation);
        selSprite.position = newPos;
        rotateTool.position = newPos;
        //selSpriteBody.position = [LevelHelperLoader metersToPoints:selSprite->GetPosition()];
        //[LevelHelperLoader metersToPoints:b->GetPosition()];
        selSpriteBody->SetTransform(b2Vec2(selSprite.position.x/[LevelHelperLoader pointsToMeterRatio] , selSprite.position.y/[LevelHelperLoader pointsToMeterRatio] ), selSpriteBody->GetAngle());
        //selSpriteBody->SetTransform(b2Vec2(selSprite.position.x / PTM_RATIO * CC_CONTENT_SCALE_FACTOR(), selSprite.position.y / PTM_RATIO * CC_CONTENT_SCALE_FACTOR()), selSpriteBody->GetAngle());
    }
}
-(void) HSVtoRGB
{
    float tempvalue;
    tempvalue = (value <= 0.5) ? (value * (1.0 + shade)) : (value + shade - value * shade);
    NSLog(@" Value:%f", tempvalue);
    if (tempvalue > 0)
    {
        float m;
        float sv;
        int sextant;
        float fract, vsf, mid1, mid2;
        
        m = value + value - tempvalue;
        sv = (tempvalue - m) / tempvalue;
        hue *= 6.0;
        sextant = (int)hue;
        fract = hue - sextant;
        vsf = tempvalue * sv * fract;
        mid1 = m + vsf;
        mid2 = tempvalue - vsf;
        switch (sextant)
        {
            case 0:
                red = value;
                green = mid1;
                blue = m;
                break;
            case 1:
                red = mid2;
                green = value;
                blue = m;
                break;
            case 2:
                red = m;
                green = value;
                blue = mid1;
                break;
            case 3:
                red = m;
                green = mid2;
                blue = value;
                break;
            case 4:
                red = mid1;
                green = m;
                blue = value;
                break;
            case 5:
                red = value;
                green = m;
                blue = mid2;
                break;
        }
    }
    
}
- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    
    CGPoint oldTouchLocation = [touch previousLocationInView:touch.view];
    oldTouchLocation = [[CCDirector sharedDirector] convertToGL:oldTouchLocation];
    oldTouchLocation = [self convertToNodeSpace:oldTouchLocation];
    
    CGPoint translation = ccpSub(touchLocation, oldTouchLocation);
    
    //acquire the previous touch location
    CGPoint firstLocation = [touch previousLocationInView:[touch view]];
    CGPoint location = [touch locationInView:[touch view]];
    
    //preform all the same basic rig on both the current touch and previous touch
    CGPoint touchingPoint = [[CCDirector sharedDirector] convertToGL:location];
    CGPoint firstTouchingPoint = [[CCDirector sharedDirector] convertToGL:firstLocation];
    
    CGPoint firstVector = ccpSub(firstTouchingPoint, selSprite.position);
    CGFloat firstRotateAngle = -ccpToAngle(firstVector);
    CGFloat previousTouch = CC_RADIANS_TO_DEGREES(firstRotateAngle);
    
    CGPoint vector = ccpSub(touchingPoint, selSprite.position);
    CGFloat rotateAngle = -ccpToAngle(vector);
    CGFloat currentTouch = CC_RADIANS_TO_DEGREES(rotateAngle);

    if(isPlaying)
    {
        if(shooterPull)
        {
            CGPoint sfirstVector = ccpSub(firstTouchingPoint, shooterSprite.position);
            CGFloat sfirstRotateAngle = -ccpToAngle(sfirstVector);
            CGFloat spreviousTouch = CC_RADIANS_TO_DEGREES(sfirstRotateAngle);
            
            CGPoint svector = ccpSub(touchingPoint, shooterSprite.position);
            CGFloat srotateAngle = -ccpToAngle(svector);
            CGFloat scurrentTouch = CC_RADIANS_TO_DEGREES(srotateAngle);
            shooterSprite.rotation+=scurrentTouch - spreviousTouch;

            shooterSprite.body->SetTransform(b2Vec2(shooterSprite.position.x/[LevelHelperLoader pointsToMeterRatio] , shooterSprite.position.y/[LevelHelperLoader pointsToMeterRatio] ), CC_DEGREES_TO_RADIANS(-(shooterSprite.rotation)));
            //shooterSprite.rotation = 95;
           
        }
    }
    else if(!isPlaying)
    {
    //NSLog(@"MOVE");
        if(editMode == @"move" && selSprite != Nil)
        {
            [self panForTranslation:translation];
        }
    else if(editMode == @"rotate")
        {
            NSLog(@"Rotate");
                //UITouch *touch = [touch event];
                
                
                
                //keep adding the difference of the two angles to the dial rotation
                selSprite.rotation +=currentTouch - previousTouch;
selSpriteBody->SetTransform(b2Vec2(selSprite.position.x/[LevelHelperLoader pointsToMeterRatio] , selSprite.position.y/[LevelHelperLoader pointsToMeterRatio] ), CC_DEGREES_TO_RADIANS(-(selSprite.rotation)));

        }
    }
}

@end
