//
//  Chapter.h  
//

#import <Foundation/Foundation.h>

@interface Chapter : NSObject {

    // Declare variables with an underscore in front
    NSString *_name;
    NSString *_icon;
    int _number;
}

// Declare variable properties without an underscore
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, assign) int number;

// Put your custom init method interface here:
-(id)initWithName:(NSString*)name icon:(NSString*)icon number:(int)number;

@end
