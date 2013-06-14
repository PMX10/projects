//
//  GHUnitCocos2dbase_Highscore.h
//  SmashingWord_me
//
//  Created by Denny Winoto on 5/2/13.
//
//

#import <Foundation/Foundation.h>
#import <GHUnitIOS/GHUnit.h>
#import "cocos2d.h"

#import <OCMock/OCMock.h>


#import "HighestScoreScene.h"
#import "globalVar.h"
#import "AppDelegate.h"

@interface GHUnitCocos2dbase_Highscore : GHTestCase
{
    //AppController *app;
	UIWindow *window_;
	UINavigationController *navController_;
    
    
    
	CCDirectorIOS	*director_;							// weak ref
    
    //SinglePlayerScene *spc;
    HighestScoreScene *hss;
}
@end
