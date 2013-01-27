//
//  ChapterSelect.m
//  

#import "ChapterSelect.h"  
#import "CCScrollLayer.h"
#import "Chapter.h"
//#import "Chapters.h"
#import "ChapterParser.h"
#import "GameData.h"
#import "GameDataParser.h"
#import "GAI.h"

@implementation ChapterSelect
@synthesize iPad, device;
- (void)onBack: (id) sender {
    /* 
     This is where you choose where clicking 'back' sends you.
     */
    [SceneManager goMainMenuFromChapter];
    
}

- (void)onSelectChapter:(CCMenuItemImage *)sender { 
    
    //CCLOG(@"writing the selected stage to GameData.xml as %i", sender.tag);
    GameData *gameData = [GameDataParser loadData];
    if(sender.tag < 3)
    {
    [gameData setSelectedChapter:sender.tag];
    [GameDataParser saveData:gameData];
    
    [SceneManager goLevelSelect];
    }
    }

- (CCLayer*)layerWithChapterName:(NSString*)chapterName
                   chapterIcon:(NSString*)chapterIcon
                   chapterNumber:(int)chapterNumber 
                      screenSize:(CGSize)screenSize {

    CCLayer *layer = [[[CCLayer alloc] init] autorelease]; // FIX MEMORY LEAK
    int largeFont = [CCDirector sharedDirector].winSize.height / kFontScaleLarge;
    CCLabelTTF *layerLabel = [CCLabelTTF labelWithString:chapterName fontName:@"Fontdinerdotcom" fontSize:largeFont];
    if (self.iPad) {
        CCMenuItemImage *image = [CCMenuItemImage itemFromNormalImage:@"chapter.png" 
                                                        selectedImage:@"chapter.png" 
                                                               target:self 
                                                             selector:@selector(onSelectChapter:)];
        image.tag = chapterNumber;
        CCMenu *menu = [CCMenu menuWithItems: image, nil];
        [menu alignItemsVertically];
        
        //add chapter icon.
        CCSprite * chapter_icon = [CCSprite spriteWithFile:[NSString stringWithFormat:@"%@-%@.gif", chapterIcon, self.device]];
        chapter_icon.scale = 0.5;
        [chapter_icon setPosition:ccp(screenSize.width*0.5, screenSize.height*0.45)];
        [layer addChild:chapter_icon z:5];

        
        [layer addChild: menu];
        // Put a label in the new layer based on the passed chapterName
        layerLabel.position =  ccp( screenSize.width*0.5 , screenSize.height*0.65 );
    }
    else {
        CCMenuItemImage *image = [CCMenuItemImage itemFromNormalImage:@"chapter-iphone.png" 
                                                        selectedImage:@"chapter-iphone.png" 
                                                               target:self 
                                                             selector:@selector(onSelectChapter:)];
        image.tag = chapterNumber;
        CCMenu *menu = [CCMenu menuWithItems: image, nil];
        [menu alignItemsVertically];
        
        //add chapter icon.
        CCSprite * chapter_icon = [CCSprite spriteWithFile:[NSString stringWithFormat:@"%@-%@.gif", chapterIcon, self.device]];
        chapter_icon.scale = 0.5;
        [chapter_icon setPosition:ccp(screenSize.width*0.5, screenSize.height*0.45)];
        [layer addChild:chapter_icon z:5];
        
        [layer addChild: menu];
        // Put a label in the new layer based on the passed chapterName
        
        layerLabel.position =  ccp( screenSize.width*0.5 , screenSize.height*0.65 );
    }
    
    
    //layerLabel.rotation = -6.0f;
    layerLabel.color = ccc3(95,58,0);
    [layer addChild:layerLabel];
    
    return layer;
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

- (id)init {
    
    if( (self=[super init])) {
        
        //id tracker = [GAI sharedInstance].defaultTracker;
        //[tracker sendEventWithCategory:@"Scene"
        //                    withAction:@"Go"
        //                     withLabel:@"Chapter"
        //                     withValue:[NSNumber numberWithInt:100]];
        
        self.iPad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
        if (self.iPad) {
            self.device = @"ipad";
        }
        else {
            self.device = @"iphone";
        }
        
        CGSize screenSize = [CCDirector sharedDirector].winSize;  

        CCSprite * bg = [CCSprite spriteWithFile:[NSString stringWithFormat:@"level-back-%@.jpg", self.device]];
        //CCSprite * bg = [CCSprite spriteWithFile:@"test.png"];
        [bg setPosition:ccp(screenSize.width*0.5, screenSize.height*0.5)];
        [self addChild:bg z:0];
        
        NSMutableArray *layers = [NSMutableArray new];

        NSMutableArray *chapters = [ChapterParser loadData];
        
        for (Chapter *chapter in chapters) { //for (Chapter *chapter in chapters.chapters) {
            // Create a layer for each of the stages found in Chapters.xml
            CCLayer *layer = [self layerWithChapterName:chapter.name chapterIcon:chapter.icon chapterNumber:chapter.number screenSize:screenSize];
            [layers addObject:layer];
        }
        
        int tOffset=0;
        if (self.iPad) {
            tOffset = 570;
        }
        else
        {
             tOffset = 240;
        }
        // Set up the swipe-able layers
        CCScrollLayer *scroller = [[CCScrollLayer alloc] initWithLayers:layers 
                                                            widthOffset:tOffset];
            
        
      
        GameData *gameData = [GameDataParser loadData];
        [scroller selectPage:(gameData.selectedChapter -1)];
        
        [self addChild:scroller];
        
        [scroller release];
        [layers release];
        
        [self addBackButton];  

    }
    return self;
}



@end
