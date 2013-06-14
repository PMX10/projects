//
//  GHUnitCocos2dBase_Multiplayer.h
//  SmashingWord_me
//
//  Created by Denny Winoto on 5/1/13.
//
//

#import <Foundation/Foundation.h>
#import <GHUnitIOS/GHUnit.h>
#import "cocos2d.h"

#import <OCMock/OCMock.h>

//#import "SinglePlayerScene.h"
#import "MultiPlayerScene.h"
#import "ShopScene.h"
#import "LevelSelectScene.h"
#import "AppDelegate.h"
#import "GCHelper.h"

@interface GHUnitCocos2dBase_Multiplayer : GHTestCase
{
    //AppController *app;
	UIWindow *window_;
	UINavigationController *navController_;
    
    
    
	CCDirectorIOS	*director_;							// weak ref
    
    //SinglePlayerScene *spc;
    MultiPlayerScene *mpc;
    ShopScene *ss;
    LevelSelectScene *lss;
    
}
@end
