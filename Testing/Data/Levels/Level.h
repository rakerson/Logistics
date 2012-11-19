//
//  Level.h
//

#import <Foundation/Foundation.h>

@interface Level : NSObject {

    // Declare variables with an underscore
    NSString *_name;
    int _number;
    BOOL _unlocked;
    int _stars;
    NSString *_data;
    int _belts;
    int _fans;
    int _springs;
    int _userLastScore;
    int _userHighScore;
    NSString *_background;
}

// Declare variable properties without an underscore
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) int number;
@property (nonatomic, assign) BOOL unlocked;
@property (nonatomic, assign) int stars;
@property (nonatomic, copy) NSString *data;
@property (nonatomic, assign) int belts;
@property (nonatomic, assign) int fans;
@property (nonatomic, assign) int springs;
@property (nonatomic, assign) int userLastScore;
@property (nonatomic, assign) int userHighScore;
@property (nonatomic, copy) NSString *background;

// Custom init method interface
- (id)initWithName:(NSString *)name 
            number:(int)number 
          unlocked:(BOOL)unlocked 
             stars:(int)stars 
              data:(NSString *)data
             belts:(int)belts
             fans:(int)fans
             springs:(int)springs
userHighScore:(int)userHighScore
userLastScore:(int)userLastScore
background:(NSString *)background;



@end
