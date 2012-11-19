//
//  Level.m
//

#import "Level.h"

@implementation Level

// Synthesize variables
@synthesize name = _name;
@synthesize number = _number;
@synthesize unlocked = _unlocked;
@synthesize stars = _stars;
@synthesize data = _data;
@synthesize belts = _belts;
@synthesize fans = _fans;
@synthesize springs = _springs;
@synthesize userHighScore = _userHighScore;
@synthesize userLastScore = _userLastScore;
@synthesize background = _background;
// Custom init method takes a variable 
// for each class instance variable
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
background:(NSString *)background{

    if ((self = [super init])) {

        // Set class instance variables based
        
        // on values given to this method
        self.name = name;  
        self.number = number;
        self.unlocked = unlocked;
        self.stars = stars;
        self.belts = belts;
        self.fans = fans;
        self.springs = springs;
        self.userLastScore = userLastScore;
        self.userHighScore = userHighScore;
        self.background = background;
        
    }
    return self;
}

- (void) dealloc {
    [_name release]; // FIX MEMORY LEAK
    [_data release]; // FIX MEMORY LEAK
    [_background release]; // FIX MEMORY LEAK

    [super dealloc];
}

@end