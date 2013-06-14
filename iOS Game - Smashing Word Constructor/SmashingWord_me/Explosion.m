//
//  Explosion.m
//  SmashingWord_me
//
//  Created by Edward on 5/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Explosion.h"

@implementation Explosion

- (void) didLoadFromCCB
{
    // Setup a delegate method for the animationManager of the explostion
    CCBAnimationManager* animationManager = self.userObject;
    animationManager.delegate = self;
}

- (void) completedAnimationSequenceNamed:(NSString *)name
{
    // Remove the explosion object after the animation has finished
    self.isScheduledForRemove = YES;
}


@end
