//
//  MainMenu.h  
//  

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Constants.h"
#import "SceneManager.h"

@interface MainMenu : CCLayer {
 
    CCMenuItemImage * muteButton;
    CCMenuItemImage * unmuteButton;
}

@property (nonatomic, assign) BOOL iPad;
@property (nonatomic, assign) NSString *device;



@end
