//
//  LevelSelect.m
//  

#import "LevelSelect.h"
#import "Level.h"
#import "LevelParser.h"
#import "GameData.h"
#import "GameDataParser.h"
#import "Chapter.h"
#import "ChapterParser.h"
#import "GAI.h"
#import "Cinematic.h"

@implementation LevelSelect  
@synthesize iPad, device;
@synthesize currentChapter;

- (void) onPlay: (CCMenuItemImage*) sender {

 // the selected level is determined by the tag in the menu item 
    int selectedLevel = sender.tag;
    
 // store the selected level in GameData
    GameData *gameData = [GameDataParser loadData];
    gameData.selectedLevel = selectedLevel;
    [GameDataParser saveData:gameData];
    
 // load the game scene
    //[SceneManager goGameScene];
    [SceneManager goGameScene];
}

- (void)onBack: (id) sender {
    /* 
     This is where you choose where clicking 'back' sends you.
     */
    [SceneManager goChapterSelectFromLevel];
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
- (void)addBackButton {
       
    CCMenuItemImage *goBack = [CCMenuItemImage
                               itemFromNormalImage:[NSString stringWithFormat:@"back-off-%@.png", self.device]
                               selectedImage:[NSString stringWithFormat:@"back-on-%@.png", self.device]
                               target:self
                               selector:@selector(onBack:)];

    CCMenu *back = [CCMenu menuWithItems: goBack, nil];
     
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    [back setPosition:ccp(screenSize.width*0.15, screenSize.height*0.9)];
    [self addChild:back];
    

}
- (void)addCinematicButton {
    GameData *gameData = [GameDataParser loadData];
    NSArray *tempLevelArray = [LevelParser loadLevelsForChapter:gameData.selectedChapter];
    BOOL showA = NO;
    BOOL showB = NO;
       for (Level *level in tempLevelArray) {
        if ([[NSNumber numberWithInt:level.number] intValue] == 1 && level.userLastScore > 1) {
            showA = YES;
        }
        if ([[NSNumber numberWithInt:level.number] intValue] == 12 && level.userLastScore > 1) {
            showB = YES;
        }
    }

    
    
    //if level 1 has been completed
    CCMenuItemImage *goCinematicA = [CCMenuItemImage
                               itemFromNormalImage:[NSString stringWithFormat:@"cinematic-button-%@.png", self.device]
                               selectedImage:[NSString stringWithFormat:@"cinematic-button-%@.png", self.device]
                               target:self
                               selector:@selector(onCinematicA:)];
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    CCMenu *cinMenuA = [CCMenu menuWithItems: goCinematicA, nil];
    [cinMenuA setPosition:ccp(screenSize.width*0.1, screenSize.height*0.72)];
    if(showA)
    {
    [self addChild:cinMenuA];
    }
    //if level 12 has be completed.
    
    
    CCMenuItemImage *goCinematicB = [CCMenuItemImage
                                     itemFromNormalImage:[NSString stringWithFormat:@"cinematic-button-%@.png", self.device]
                                     selectedImage:[NSString stringWithFormat:@"cinematic-button-%@.png", self.device]
                                     target:self
                                     selector:@selector(onCinematicB:)];
    
    
    
    
    CCMenu *cinMenuB = [CCMenu menuWithItems: goCinematicB, nil];
    [cinMenuB setPosition:ccp(screenSize.width*0.9, screenSize.height*0.08)];
    if(showB)
    {
    [self addChild:cinMenuB];
    }
}
- (id)init {
    
    if( (self=[super init])) {
        
        
        id tracker = [GAI sharedInstance].defaultTracker;
        [tracker sendEventWithCategory:@"Scene"
                            withAction:@"Go"
                             withLabel:@"Level"
                             withValue:[NSNumber numberWithInt:100]];
        
        self.iPad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
        if (self.iPad) {
            self.device = @"ipad";
        }
        else {
            self.device = @"iphone";
        }

        int smallFont = [CCDirector sharedDirector].winSize.height / kFontScaleHuge;
        
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        CCSprite * bg = [CCSprite spriteWithFile:[NSString stringWithFormat:@"board-back-%@.jpg", self.device]];
        //CCSprite * bg = [CCSprite spriteWithFile:@"board-back.jpg"];
        [bg setPosition:ccp(screenSize.width*0.5, screenSize.height*0.5)];
        [self addChild:bg z:-50];
        
     // read in selected chapter number:
        GameData *gameData = [GameDataParser loadData];
        int selectedChapter = gameData.selectedChapter;
        currentChapter = gameData.selectedChapter;
        
        
        
     // Read in selected chapter name (use to load custom background later):
        NSString *selectedChapterName = nil;        
        NSMutableArray *selectedChapters = [ChapterParser loadData]; //Chapters *selectedChapters = [ChapterParser loadData];

        for (Chapter *chapter in selectedChapters) {            //for (Chapter *chapter in selectedChapters.chapters) {            
            if ([[NSNumber numberWithInt:chapter.number] intValue] == selectedChapter) {
                CCLOG(@"Selected Chapter is %@ (ie: number %i)", chapter.name, chapter.number);
                selectedChapterName = chapter.name;
            }
        }
        //Title Label
        int largeFont = [CCDirector sharedDirector].winSize.height / kFontScaleLarge;
        CCLabelTTF *layerLabel = [CCLabelTTF labelWithString:selectedChapterName fontName:@"Fontdinerdotcom" fontSize:largeFont];
        layerLabel.position =  ccp( screenSize.width*0.5 , screenSize.height*0.92 );
        [self addChild:layerLabel];
        
        
     // Read in selected chapter levels
        CCMenu *levelMenu = [CCMenu menuWithItems: nil]; 
        NSMutableArray *overlay = [NSMutableArray new];
        
        NSMutableArray *selectedLevels = [LevelParser loadLevelsForChapter:gameData.selectedChapter];
    
        
     // Create a button for every level
        for (Level *level in selectedLevels) {
            
           // NSString *normal =   [NSString stringWithFormat:@"%@-Normal-%@.png", selectedChapterName, self.device];
           // NSString *selected = [NSString stringWithFormat:@"%@-Selected-%@.png", selectedChapterName, self.device];

            CCMenuItemImage *item = [CCMenuItemImage itemFromNormalImage:[NSString stringWithFormat:@"Level-Normal-%@.png", self.device]
                                                           selectedImage:[NSString stringWithFormat:@"Level-Normal-%@.png", self.device]
                                                                  target:self 
                                                                selector:@selector(onPlay:)];
            [item setTag:level.number]; // note the number in a tag for later usage
            [item setIsEnabled:level.unlocked];  // ensure locked levels are inaccessible
            [levelMenu addChild:item];
            
            if (!level.unlocked) {
                
                NSString *overlayImage = [NSString stringWithFormat:@"Locked-%@.png", self.device];
                //NSString *overlayImage = @"test.png";
                CCSprite *overlaySprite = [CCSprite spriteWithFile:overlayImage];
                [overlaySprite setTag:level.number];
                [overlay addObject:overlaySprite];
            }
            else {

                if(level.stars > 3)
                {
                    level.stars = 3;
                }
                NSString *stars = [[NSNumber numberWithInt:level.stars] stringValue];
                
                NSString *overlayImage = [NSString stringWithFormat:@"%@Star-Normal-%@.png",stars, self.device];
                CCSprite *overlaySprite = [CCSprite spriteWithFile:overlayImage];
                [overlaySprite setTag:level.number];
                
                [overlay addObject:overlaySprite];
            }

        }

        [levelMenu alignItemsInColumns:
          [NSNumber numberWithInt:4],
          [NSNumber numberWithInt:4],
          [NSNumber numberWithInt:4],
          nil];

     // Move the whole menu up by a small percentage so it doesn't overlap the back button
        
        [levelMenu setPosition:ccp(screenSize.width*0.5, screenSize.height*0.45)];
        
        
       
        [self addChild:levelMenu z:-3];


     // Create layers for star/padlock overlays & level number labels
        CCLayer *overlays = [[CCLayer alloc] init];
        CCLayer *labels = [[CCLayer alloc] init];

        
        for (CCMenuItem *item in levelMenu.children) {

         // create a label for every level
            
            CCLabelTTF *label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i",item.tag] 
                                                        fontName:@"Fontdinerdotcom" 
                                                        fontSize:smallFont];
            
            [label setColor:ccc3(20, 20, 20)];
            [label setAnchorPoint:item.anchorPoint];
            [label setPosition:ccp(item.position.x, item.position.y+(screenSize.height*0.04))];
            [labels addChild:label];
            
            
         // set position of overlay sprites
         
            for (CCSprite *overlaySprite in overlay) {
                if (overlaySprite.tag == item.tag) {
                    [overlaySprite setAnchorPoint:item.anchorPoint];
                    
                    [overlaySprite setPosition:ccp(item.position.x, item.position.y-(screenSize.height*0.075))];
                    [overlays addChild:overlaySprite];
                }
            }
        }
        
     // Put the overlays and labels layers on the screen at the same position as the levelMenu
        
        [overlays setAnchorPoint:levelMenu.anchorPoint];
        [labels setAnchorPoint:levelMenu.anchorPoint];
        [overlays setPosition:levelMenu.position];
        [labels setPosition:levelMenu.position];
        [self addChild:overlays];
        
        [self addChild:labels];
        [overlays release];
        [labels release];
        [overlay release]; // FIX MEMORY LEAK
        
     // Add back button
        
        [self addBackButton];
    //add bonus level button
        [self addCinematicButton];
    }
    return self;
}

@end
