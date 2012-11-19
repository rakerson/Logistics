//
//  Chapter.m
//

#import "Chapter.h"

@implementation Chapter 

// Synthesize variables
@synthesize name = _name;
@synthesize icon = _icon;
@synthesize number = _number;

-(id)initWithName:(NSString*)name icon:(NSString*)icon number:(int)number {

    if ((self = [super init])) {

        // Set class instance variables based on values 
        // given to this method
        self.name = name;
        self.icon = icon;
        self.number = number;
        
    }
    return self;
}

- (void) dealloc {
    [_name release]; // FIX MEMORY LEAK
    [_icon release];
    [super dealloc];
}

@end