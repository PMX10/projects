//
//  Explosion.h
//  SmashingWord_me
//
//  Created by Edward on 5/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCBAnimationManager.h"
@interface Explosion : CCNode <CCBAnimationManagerDelegate>{
    //BOOL isScheduledForRemove;
}

@property (nonatomic,assign) BOOL isScheduledForRemove;

@end
