//
//  SceneManager.h
//  

#import <Foundation/Foundation.h>
#import "cocos2d.h"

/*  ___Template___________________________________

    Step 1 - Import header of your SceneName
    ______________________________________________
 
#import "SceneName.h"
 
*/
#import "MainMenu.h"
#import "OptionsMenu.h"
#import "ChapterSelect.h"
#import "LevelSelect.h"
#import "GameScene.h"
#import "GameBoardLayer.h"


@interface SceneManager : NSObject {
    
    
    
}

/*  ___Template___________________________________
    
    Step 2 - Add interface scene calling method
    ______________________________________________
 
+(void) goSceneName; 
 
*/

+(void) goMainMenu;
+(void) goMainMenuFromChapter;
+(void) goOptionsMenu;
+(void) goChapterSelect;
+(void) goChapterSelectFromLevel;
+(void) goLevelSelect;
+(void) goLevelSelectFromLevel;
+(void) goLevelSelectFromLevelNoTransition;
+(void) goGameScene;

@property (readwrite, assign) NSString *currentSceneName;
@end
