//
//  GHUnitCocos2dBase.h
//  SmashingWord_me
//
//  Created by Denny Winoto on 4/18/13.
//
//


#import <Foundation/Foundation.h>
#import <GHUnitIOS/GHUnit.h>
#import "cocos2d.h"

#import "SinglePlayerScene.h"
//#import "MultiPlayerScene.h"
#import "AppDelegate.h"

@interface GHUnitCocos2dBase : GHTestCase
{
    //AppController *app;
	UIWindow *window_;
	UINavigationController *navController_;

    
    
	CCDirectorIOS	*director_;							// weak ref
    
    SinglePlayerScene *spc;
    //MultiPlayerScene *mpc;
}
@end
