// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "LevelHelperLoader.h"
//#import "PlayerSprite.h"
#import "Level.h"
//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.
//#define PTM_RATIO 72

// HelloWorldLayer
@interface GameBoardLayer : CCLayer
{
	CCLayer *menuLayer;
    CCTexture2D *spriteTexture_;	// weak ref
	b2World* world;					// strong ref
	//GLESDebugDraw *m_debugDraw;		// strong ref
    
    LevelHelperLoader* lh;
    int bells;
    int gifts;
    int giftsRemaining;
    int belts;
    int strikes;
    int fans;
    int springs;
    int gameScore;
    BOOL shooterPull;
    LHSprite *shooterSprite;

    CGPoint shooterStartPoint;
    NSString *background;
    float gameTime;
    CCLabelTTF *bellCounter;
    CCLabelTTF *giftCounter;
    CCLabelTTF *giftRemainingCounter;
    CCLabelTTF *beltCounter;
    CCLabelTTF *fanCounter;
    CCLabelTTF *springCounter;
    
    NSMutableArray *rewardArray;
    double fanAngle;
    CCSprite *rotateTool;
    NSString *editMode;
    //CCSprite *selSprite;
    LHSprite *selSprite;
    b2Body * selSpriteBody;
    CCSprite * _selSprite;
    CCSprite * pauseButton;
    CCSprite * bottomMatte;
    CCSprite * topMatte;
    CCSprite * beltButton;
    CCSprite * fanButton;
    CCSprite * springButton;
    CCSprite * strikeSprite;
    b2Body * _selSpriteBody;
    

    CCLayer * gameLayer;
    CCLayer * buttonLayer;
    //for placing items.
    //current name gift-off
    NSString *currentItemName;
    //current spritesheet UntitledSheet
    NSString *currentSpriteSheet;
    //current file SWS-platforms-gears
    NSString *currentFile;
    //current tag PRESENT
    LevelHelper_TAG currentTAG;
    
    float red;
    float green;
    float blue;
    float hue;
    float shade;
    float value;

    
    
    
}

-(void) removeAllPresents;
-(void) replaceAwardsFromArray;
-(void) updateHUD;
-(void) setupCollisionHandling;
-(void) initHUDLayer;
-(void) initRewards;
-(void) deselectActors;
-(void) resumeGame;
-(void) retryGame;
-(void) restartGame;
-(void) resetGame;
-(void) calculateScore;
- (void)selectSpriteForTouch:(CGPoint)touchLocation;




@property (nonatomic, retain) NSMutableArray *rewardArray;
@property (nonatomic,retain) Level *currentLevel;
@property (nonatomic, assign) BOOL iPad;
@property (nonatomic, assign) NSString *device;
//setters
-(void) setSelSprite:(LHSprite*)newSprite;

@property (nonatomic,readwrite) BOOL isPaused;
@property (nonatomic,readonly) int gameScore;
@property (nonatomic,readwrite) BOOL isPlaying;
///@property (nonatomic,readwrite) BOOL boundarySet;
@property (retain) NSMutableArray *currentLevelArray;

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
