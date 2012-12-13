//
//  LevelParser.m
//

#import "LevelParser.h"
#import "Level.h"
#import "GDataXMLNode.h"

@implementation LevelParser

+ (NSString *)dataFilePath:(BOOL)forSave forChapter:(int)chapter {

    NSString *xmlFileName = [NSString stringWithFormat:@"Levels-Chapter%i",chapter];
    
    /***************************************************************************
     This method is used to set up the specified xml for reading/writing.
     Specify the name of the XML file you want to work with above.
     You don't have to worry about the rest of the code in this method.
     ***************************************************************************/
    
    NSString *xmlFileNameWithExtension = [NSString stringWithFormat:@"%@.xml",xmlFileName];    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *documentsPath = [documentsDirectory stringByAppendingPathComponent:xmlFileNameWithExtension];
    if (forSave || [[NSFileManager defaultManager] fileExistsAtPath:documentsPath]) {
        return documentsPath;   
        NSLog(@"%@ opened for read/write",documentsPath);
    } else {
        NSLog(@"Created/copied in default %@",xmlFileNameWithExtension);
        return [[NSBundle mainBundle] pathForResource:xmlFileName ofType:@"xml"];
    }  
}

+ (NSMutableArray *)loadLevelsForChapter:(int)chapter {

    /*************************************************************************** 
     This loadData method is used to load data from the xml file 
     specified in the dataFilePath method above.  

     MODIFY the list of variables below which will be used to create
     and return an instance of TemplateData at the end of this method.
     ***************************************************************************/
    
    NSString *name;
    int number;
    BOOL unlocked;
    int stars;
    int userLastStars;
    NSString *data;
    int belts;
    int fans;
    int springs;
    int userHighScore;
    int userLastScore;
    NSString *background;
    NSString *item;
    
    NSMutableArray *levels = [NSMutableArray arrayWithCapacity:1];

    // Create NSData instance from xml in filePath
    NSString *filePath = [self dataFilePath:FALSE forChapter:chapter];
    NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    NSError *error;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&error];
    if (doc == nil) { return nil; NSLog(@"xml file is empty!");}
    NSLog(@"Loading %@", filePath);
    
    /*************************************************************************** 
     This next line will usually have the most customisation applied because 
     it will be a direct reflection of what you want out of the XML file.
     ***************************************************************************/
    
    NSArray *dataArray = [doc nodesForXPath:@"//Levels/Level" error:nil];
    NSLog(@"Array Contents = %@", dataArray);
    
    /*************************************************************************** 
     We use dataArray to populate variables created at the start of this 
     method. For each variable you will need to:
        1. Create an array based on the elements in the xml
        2. Assign the variable a value based on data in elements in the xml
     ***************************************************************************/
    
    for (GDataXMLElement *element in dataArray) {
        
        NSArray *nameArray = [element elementsForName:@"Name"];
        NSArray *numberArray = [element elementsForName:@"Number"];
        NSArray *unlockedArray = [element elementsForName:@"Unlocked"];
        NSArray *starsArray = [element elementsForName:@"Stars"];
        NSArray *userLastStarsArray = [element elementsForName:@"UserLastStars"];
        NSArray *dataArray= [element elementsForName:@"Data"];
        NSArray *beltsArray= [element elementsForName:@"Belts"];
        NSArray *fansArray= [element elementsForName:@"Fans"];
        NSArray *springsArray= [element elementsForName:@"Springs"];
        NSArray *userLastScoreArray= [element elementsForName:@"UserLastScore"];
        NSArray *userHighScoreArray= [element elementsForName:@"UserHighScore"];
        NSArray *backgroundArray= [element elementsForName:@"Background"];
        NSArray *itemArray= [element elementsForName:@"Item"];
        
        // name
        if (nameArray.count > 0) {
            GDataXMLElement *nameElement = (GDataXMLElement *) [nameArray objectAtIndex:0];
            name = [nameElement stringValue];
        }
        
        // number
        if (numberArray.count > 0) {
            GDataXMLElement *numberElement = (GDataXMLElement *) [numberArray objectAtIndex:0];
            number = [[numberElement stringValue] intValue];
        } 
        
        // unlocked
        if (unlockedArray.count > 0) {
            GDataXMLElement *unlockedElement = (GDataXMLElement *) [unlockedArray objectAtIndex:0];
            unlocked = [[unlockedElement stringValue] boolValue];
        } 
        
        // stars
        if (starsArray.count > 0) {
            GDataXMLElement *starsElement = (GDataXMLElement *) [starsArray objectAtIndex:0];
            stars = [[starsElement stringValue] intValue];
        }
        // User Last stars
        if (starsArray.count > 0) {
            GDataXMLElement *userLastStarsElement = (GDataXMLElement *) [userLastStarsArray objectAtIndex:0];
            userLastStars = [[userLastStarsElement stringValue] intValue];
        }
        
        // data
        if (dataArray.count > 0) {
            GDataXMLElement *dataElement = (GDataXMLElement *) [dataArray objectAtIndex:0];
            data = [dataElement stringValue];
        }
        
        // belts
        if (beltsArray.count > 0) {
            GDataXMLElement *beltsElement = (GDataXMLElement *) [beltsArray objectAtIndex:0];
            belts = [[beltsElement stringValue] intValue];
        }
        
        // fans
        if (fansArray.count > 0) {
            GDataXMLElement *fansElement = (GDataXMLElement *) [fansArray objectAtIndex:0];
            fans = [[fansElement stringValue] intValue];
        }
        // springs
        if (springsArray.count > 0) {
            GDataXMLElement *springsElement = (GDataXMLElement *) [springsArray objectAtIndex:0];
            springs = [[springsElement stringValue] intValue];
        }
        // userHighScore
        if (userHighScoreArray.count > 0) {
            GDataXMLElement *userHighScoreElement = (GDataXMLElement *) [userHighScoreArray objectAtIndex:0];
            userHighScore = [[userHighScoreElement stringValue] intValue];
        }
        // userLastScore
        if (userLastScoreArray.count > 0) {
            GDataXMLElement *userLastScoreElement = (GDataXMLElement *) [userLastScoreArray objectAtIndex:0];
            userLastScore = [[userLastScoreElement stringValue] intValue];
        }
        
        // background
        if (backgroundArray.count > 0) {
            GDataXMLElement *backgroundElement = (GDataXMLElement *) [backgroundArray objectAtIndex:0];
            background = [backgroundElement stringValue];
        }
        // item
        if (itemArray.count > 0) {
            GDataXMLElement *itemElement = (GDataXMLElement *) [itemArray objectAtIndex:0];
            item = [itemElement stringValue];
        }
        Level *level = [[Level alloc] initWithName:name 
                                            number:number 
                                          unlocked:unlocked 
                                             stars:stars
                                     userLastStars:userLastStars
                                              data:data
                                            belts:belts
                                              fans:fans
                                           springs:springs
                                            userHighScore:userHighScore
                                     userLastScore:userLastScore
                        background:background
                        item:item];
        [levels addObject:level];
        [level release];
    }
    
    [doc release];
    [xmlData release];
    return levels;
}

+ (void)saveData:(NSMutableArray *)saveData 
      forChapter:(int)chapter {
    
   
    /*************************************************************************** 
     This method writes data to the xml based on a TemplateData instance
     You will have to be very aware of the intended xml contents and structure
     as you will be wiping and re-writing the whole xml file.
     
     We write an xml by creating elements and adding 'children' to them.
     
     You'll need to write a line for each element to build the hierarchy // <-- MODIFY CODE ACCORDINGLY
     ***************************************************************************/
    
    // create the <Levels> element
    GDataXMLElement *levelsElement = [GDataXMLNode elementWithName:@"Levels"];
    
    // Loop through levels found in the levels array 
    for (Level *level in saveData) {
     
        // create the <Level> element
        GDataXMLElement *levelElement = [GDataXMLNode elementWithName:@"Level"];
        
        // create the <Name> element
        GDataXMLElement *nameElement = [GDataXMLNode elementWithName:@"Name"
                                                         stringValue:level.name];   
        // create the <Number> element
        GDataXMLElement *numberElement = [GDataXMLNode elementWithName:@"Number" 
                                                           stringValue:[[NSNumber numberWithInt:level.number] stringValue]];
        // create the <Unlocked> element
        GDataXMLElement *unlockedElement = [GDataXMLNode elementWithName:@"Unlocked"   
                                                             stringValue:[[NSNumber numberWithBool:level.unlocked] stringValue]];
        // create the <Stars> element
        GDataXMLElement *starsElement = [GDataXMLNode elementWithName:@"Stars" 
                                                           stringValue:[[NSNumber numberWithInt:level.stars] stringValue]];
        // create the <UserLastStars> element
        GDataXMLElement *userLastStarsElement = [GDataXMLNode elementWithName:@"UserLastStars"
                                                          stringValue:[[NSNumber numberWithInt:level.userLastStars] stringValue]];
        // create the <Data> element
        GDataXMLElement *dataElement = [GDataXMLNode elementWithName:@"Data"
                                                         stringValue:level.data];
        // create the <Belts> element
        GDataXMLElement *beltsElement = [GDataXMLNode elementWithName:@"Belts"
                                                          stringValue:[[NSNumber numberWithInt:level.belts] stringValue]];
        // create the <Fans> element
        GDataXMLElement *fansElement = [GDataXMLNode elementWithName:@"Fans"
                                                          stringValue:[[NSNumber numberWithInt:level.fans] stringValue]];
        // create the <Springs> element
        GDataXMLElement *springsElement = [GDataXMLNode elementWithName:@"Springs"
                                                          stringValue:[[NSNumber numberWithInt:level.springs] stringValue]];
        // create the <UserLastScore> element
        GDataXMLElement *userLastScoreElement = [GDataXMLNode elementWithName:@"UserLastScore"
                                                            stringValue:[[NSNumber numberWithInt:level.userLastScore] stringValue]];
        // create the <UserHighScore> element
        GDataXMLElement *userHighScoreElement = [GDataXMLNode elementWithName:@"UserHighScore"
                                                                  stringValue:[[NSNumber numberWithInt:level.userHighScore] stringValue]];
        // create the <Background> element
        GDataXMLElement *backgroundElement = [GDataXMLNode elementWithName:@"Background"
                                                                  stringValue:level.background];
        
        // create the <Item> element
        GDataXMLElement *itemElement = [GDataXMLNode elementWithName:@"Item"
                                                               stringValue:level.item];
        
        // enclose variable elements into a <Level> element
        [levelElement addChild:nameElement];
        [levelElement addChild:numberElement];
        [levelElement addChild:unlockedElement];
        [levelElement addChild:starsElement];
        [levelElement addChild:userLastStarsElement];
        [levelElement addChild:dataElement];
        [levelElement addChild:beltsElement];
        [levelElement addChild:fansElement];
        [levelElement addChild:springsElement];
        [levelElement addChild:userLastScoreElement];
        [levelElement addChild:userHighScoreElement];
        [levelElement addChild:backgroundElement];
        [levelElement addChild:itemElement];
        // enclose each <Level> into the <Levels> element
        [levelsElement addChild:levelElement];
    }
    
    // put the <Levels> element (and everything in it) into the XML doc
    GDataXMLDocument *document = [[[GDataXMLDocument alloc] 
                                   initWithRootElement:levelsElement] autorelease];
   
    NSData *xmlData = document.XMLData;
    
    // overwrite the existing file, being sure to overwrite the proper chapter
    NSString *filePath = [self dataFilePath:TRUE forChapter:chapter];
    NSLog(@"Saving data to %@...", filePath);
    [xmlData writeToFile:filePath atomically:YES];
}

@end