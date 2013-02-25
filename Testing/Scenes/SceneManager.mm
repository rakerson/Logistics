//
//  SceneManager.m
// 

#import "SceneManager.h"
#import "CCDirector.h"
#import "SimpleAudioEngine.h"
#import "CDAudioManager.h"
#import "CocosDenshion.h"
#import "AppDelegate.h"



@interface SceneManager ()

+(void) go: (CCLayer *) layer;
+(CCScene *) wrap: (CCLayer *) layer;

@end

@implementation SceneManager
@synthesize currentSceneName;
/*  ___Template___________________________________
 
    Step 3 - Add implementation to call scene
    ______________________________________________
 

+(void) goSceneName {
    [SceneManager go:[SceneName node]];
}
 
*/

+(void) goMainMenu {
    
    [[SimpleAudioEngine sharedEngine]playBackgroundMusic:@"lobby.mp3" loop:TRUE];
    
    [SceneManager go:[MainMenu node]];
    
    //[[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInT transitionWithDuration:0.2 scene:[MainMenu node]]];
}

+(void) goMainMenuFromChapter {
    //currentSceneName = @"MainMenu";
    //[AppDelegate currentSceneName:@"MainMenu"];
    //[self setCurrentSceneName:@"MainMenu"];
    //[SceneManager go:[MainMenu node]];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInT transitionWithDuration:0.2 scene:[MainMenu node]]];
}
+(void) goOptionsMenu {
    //currentSceneName = @"OptionsMenu";
    [SceneManager go:[OptionsMenu node]];
}

+(void) goChapterSelect {
    //currentSceneName = @"ChapterSelect";
    //[SceneManager go:[ChapterSelect node]];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInB transitionWithDuration:0.2 scene:[ChapterSelect node]]];
}

+(void) goChapterSelectFromLevel {
    //currentSceneName = @"ChapterSelect";
    //[SceneManager go:[ChapterSelect node]];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInT transitionWithDuration:0.2 scene:[ChapterSelect node]]];
}
+(void) goLevelSelectFromBoard {
    //currentSceneName = @"LevelSelect";
    [[SimpleAudioEngine sharedEngine]playBackgroundMusic:@"lobby.mp3" loop:TRUE];
    //[SceneManager go:[ChapterSelect node]];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInT transitionWithDuration:0.2 scene:[LevelSelect node]]];
}

+(void) goLevelSelect {
    //currentSceneName = @"LevelSelect";
    //[SceneManager go:[LevelSelect node]];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInB transitionWithDuration:0.2 scene:[LevelSelect node]]];
}
+(void) goLevelSelectFromLevel {
    //currentSceneName = @"LevelSelect";
    [[SimpleAudioEngine sharedEngine]playBackgroundMusic:@"lobby.mp3" loop:TRUE];
    //[SceneManager go:[LevelSelect node]];
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInT transitionWithDuration:0.2 scene:[LevelSelect node]]];
}
+(void) goLevelSelectFromLevelNoTransition {
    //currentSceneName = @"LevelSelect";
    [[SimpleAudioEngine sharedEngine]playBackgroundMusic:@"lobby.mp3" loop:TRUE];
    //[SceneManager go:[LevelSelect node]];
    
    [[CCDirector sharedDirector] replaceScene:[LevelSelect node]];
}
+(void) goGameScene {
   // currentSceneName = @"GameBoardLayer";
    //load the level here...
    //[SceneManager go:[GameScene node]];
    
    [SceneManager go:[GameBoardLayer node]];
}

+(void) go: (CCLayer *) layer {
    CCDirector *director = [CCDirector sharedDirector];
    CCScene *newScene = [SceneManager wrap:layer];
    if([director runningScene] != newScene)
    {
    
    if ([director runningScene]) {
        
        [director replaceScene:newScene];
    }
    else {
        [director runWithScene:newScene];
    }
    }
}

+(CCScene *) wrap: (CCLayer *) layer {
    CCScene *newScene = [CCScene node];
    [newScene addChild: layer];
    return newScene;
    }

@end
