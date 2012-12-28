//
//  SceneManager.m
// 

#import "SceneManager.h"
#import "CCDirector.h"
#import "SimpleAudioEngine.h"
#import "CDAudioManager.h"
#import "CocosDenshion.h"
@interface SceneManager ()

+(void) go: (CCLayer *) layer;
+(CCScene *) wrap: (CCLayer *) layer;

@end

@implementation SceneManager

/*  ___Template___________________________________
 
    Step 3 - Add implementation to call scene
    ______________________________________________
 

+(void) goSceneName {
    [SceneManager go:[SceneName node]];
}
 
*/

+(void) goMainMenu {
    [[SimpleAudioEngine sharedEngine]playBackgroundMusic:@"level-2.mp3" loop:TRUE];
    [SceneManager go:[MainMenu node]];
    //[[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInT transitionWithDuration:0.2 scene:[MainMenu node]]];
    
}
+(void) goMainMenuFromChapter {
    
    //[SceneManager go:[MainMenu node]];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInT transitionWithDuration:0.2 scene:[MainMenu node]]];
}
+(void) goOptionsMenu {
    [SceneManager go:[OptionsMenu node]];
}

+(void) goChapterSelect {
    
    //[SceneManager go:[ChapterSelect node]];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInB transitionWithDuration:0.2 scene:[ChapterSelect node]]];
}

+(void) goChapterSelectFromLevel {
    
    //[SceneManager go:[ChapterSelect node]];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInT transitionWithDuration:0.2 scene:[ChapterSelect node]]];
}
+(void) goLevelSelectFromBoard {
    [[SimpleAudioEngine sharedEngine]playBackgroundMusic:@"level-2.mp3" loop:TRUE];
    //[SceneManager go:[ChapterSelect node]];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInT transitionWithDuration:0.2 scene:[LevelSelect node]]];
}

+(void) goLevelSelect {
    
    //[SceneManager go:[LevelSelect node]];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInB transitionWithDuration:0.2 scene:[LevelSelect node]]];
}
+(void) goLevelSelectFromLevel {
    [[SimpleAudioEngine sharedEngine]playBackgroundMusic:@"level-2.mp3" loop:TRUE];
    //[SceneManager go:[LevelSelect node]];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInT transitionWithDuration:0.2 scene:[LevelSelect node]]];
}

+(void) goGameScene {
    //load the level here...
    //[SceneManager go:[GameScene node]];
    
    [SceneManager go:[GameBoardLayer node]];
}

+(void) go: (CCLayer *) layer {
    CCDirector *director = [CCDirector sharedDirector];
    CCScene *newScene = [SceneManager wrap:layer];
    if ([director runningScene]) {
        
        [director replaceScene:newScene];
    }
    else {
        [director runWithScene:newScene];
    }
}

+(CCScene *) wrap: (CCLayer *) layer {
    CCScene *newScene = [CCScene node];
    [newScene addChild: layer];
    return newScene;
    }

@end
