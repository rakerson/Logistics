//
//  GameData.h
//

#import <Foundation/Foundation.h>

@interface GameData : NSObject {
    
    int _selectedChapter;
    int _selectedLevel;
    int _levelScore;
    BOOL _sound;
    BOOL _music;
}

@property (nonatomic, assign) int selectedChapter;
@property (nonatomic, assign) int selectedLevel;
@property (nonatomic, readwrite) int levelScore;
@property (nonatomic, assign) BOOL sound;
@property (nonatomic, assign) BOOL music;

-(id)initWithSelectedChapter:(int)chapter
             selectedLevel:(int)level
                     sound:(BOOL)sound
                     music:(BOOL)music;

@end