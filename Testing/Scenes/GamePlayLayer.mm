//
//  GamePlayLayer.m
//  Testing
//
//  Created by Tim Roadley on 10/08/11.
//  Copyright 2011 Tim Roadley. All rights reserved.
//

#import "GamePlayLayer.h"

@implementation GamePlayLayer

@synthesize iPad, device;

- (void) setupPhysicsWorld {
    
    b2Vec2 gravity = b2Vec2(kHorizontalGravity, kVerticalGravity); // Set in TRBox2DConstants.h
    bool doSleep = true;
    world = new b2World(gravity, doSleep);
    debugDraw = new GLESDebugDraw(PTM_RATIO);
    world->SetDebugDraw(debugDraw);
    uint32 flags = 0;
    flags += b2DebugDraw::e_shapeBit;
    flags += b2DebugDraw::e_jointBit;
    //      flags += b2DebugDraw::e_aabbBit;
    //      flags += b2DebugDraw::e_pairBit;
    //      flags += b2DebugDraw::e_centerOfMassBit;
    debugDraw->SetFlags(flags);
}
- (void) limitWorldToScreen {

    TRBox2D *limits = [[TRBox2D new] autorelease];
    [limits createEdgesForWorld:world 
                 fromScreenSize:[CCDirector sharedDirector].winSize];
    [self addChild:limits];
}
- (void)tick: (ccTime) dt {
    
    //It is recommended that a fixed time step is used with Box2D for stability
    //of the simulation, however, we are using a variable time step here.
    //You need to make an informed choice, the following URL is useful
    //http://gafferongames.com/game-physics/fix-your-timestep/
    
    int32 velocityIterations = 8;
    int32 positionIterations = 1;
    
    // Instruct the world to perform a single step of simulation. It is
    // generally best to keep the time step and iterations fixed.
    world->Step(dt, velocityIterations, positionIterations);
    
    //Iterate over the bodies in the physics world
    for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
    {
        if (b->GetUserData() != NULL) {
            //Synchronize the AtlasSprites position and rotation with the corresponding body
            CCSprite *myActor = (CCSprite*)b->GetUserData();
            myActor.position = CGPointMake( b->GetPosition().x * PTM_RATIO, b->GetPosition().y * PTM_RATIO);
            myActor.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
        }
    }
}
- (void)draw {
    
    glDisable(GL_TEXTURE_2D);
    glDisableClientState(GL_COLOR_ARRAY);
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
    
    world->DrawDebugData();  // comment this out to get rid of Box2D debug drawing
    
    glEnable(GL_TEXTURE_2D);
    glEnableClientState(GL_COLOR_ARRAY);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
}

- (id)init
{
    self = [super init];
    if (self != nil) {
        
        // Determine Device
        self.iPad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
        if (self.iPad) {
            self.device = @"iPad";
        }
        else {
            self.device = @"iPhone";
        }

        // Determine Screen Size
        CGSize screenSize = [CCDirector sharedDirector].winSize;  

        CCLabelTTF *label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Your %@ is displaying the GamePlayLayer", self.device]
                                               fontName:@"Marker Felt" 
                                               fontSize:14]; 
        
        label.position = ccp( screenSize.width/2, 50);  
        
        // Add label to this scene
        [self addChild:label z:0]; 

        
        // ** put new code below ** //
        
        /* -- Boilerplate code to set up TRBox2D  -- */
        [self setupPhysicsWorld];
        [self limitWorldToScreen];
        
        /* -- Set Up Shape Cache  -- */
        [[GB2ShapeCache sharedShapeCache]  addShapesWithFile:@"Sprites-Physics.plist"];
        
        /* -- Set Up Sprite Cache  -- */
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"Sprites.plist"];
        CCSpriteBatchNode *sprites = [CCSpriteBatchNode batchNodeWithFile:@"Sprites.png"];
        [self addChild:sprites];
        
        /* -- Create Box2D Body with CCSprite userdata  -- */
        TRBox2D *newBody = [TRBox2D spriteWithSpriteFrameName:@"NinjaBaby.png"]; 
        
        [newBody setPosition:ccp((screenSize.width/2), (screenSize.height/2))];
        
        [newBody createBodyInWorld:world 
                        b2bodyType:b2_dynamicBody 
                             angle:0.0 
                        allowSleep:true 
                     fixedRotation:false 
                            bullet:false];
        
        /* -- Add fixtures to Physics Object -- */
        [[GB2ShapeCache sharedShapeCache] addFixturesToBody:newBody.body forShapeName:@"NinjaBaby"];
       
        /*  // to add a circle fixture instead, comment out the line above
        b2CircleShape circle;
        circle.m_radius = 1.0; // radius in meters 
        [newBody addFixtureOfShape:&circle 
                          friction:1.0 
                       restitution:1.0 
                           density:1.0 
                          isSensor:false];
        */
        [self addChild:newBody];
        
        // schedule Box2D updates
        [self schedule: @selector(tick:)];
        
        // ** put new code above ** //                            
    }
    return self;
}

@end
