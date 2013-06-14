//
//  GameMenuScene.m
//  SmashingWord_me
//
//  Created by Edward on 3/19/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "GameMenuScene.h"
#import "CCBReader.h"

@implementation GameMenuScene
-(void)HowToPlayButtonPress: (id)sender{
    CCScene* scene =  [CCBReader sceneWithNodeGraphFromFile:@"HowToPlay.ccbi"];
    [[CCDirector sharedDirector]replaceScene:[CCTransitionCrossFade transitionWithDuration:0.3 scene:scene]];
}

-(void)SinglePlayerButtonPress: (id)sender{
    CCScene* scene = [CCBReader sceneWithNodeGraphFromFile:@"LevelSelect.ccbi"];
    [[CCDirector sharedDirector]replaceScene:[CCTransitionCrossFade transitionWithDuration:0.3 scene:scene]];
}

-(void)MultiPlayerButtonPress:(id)sender{
    //if (!TEST_MODE) {
        [[GCHelper sharedInstance] authenticateLocalUser];
    //}
    TEST_MUL = NO;
    CCScene* scene = [CCBReader sceneWithNodeGraphFromFile:@"MultiPlayer.ccbi"];
    [[CCDirector sharedDirector]replaceScene:[CCTransitionCrossFade transitionWithDuration:0.3 scene:scene]];
}

-(void)HighestScoreButtonPress: (id)sender{
    CCScene* scene = [CCBReader sceneWithNodeGraphFromFile:@"HighestScore.ccbi"];
    [[CCDirector sharedDirector]replaceScene:[CCTransitionCrossFade transitionWithDuration:0.3 scene:scene]];
}

-(void)ShopButtonPress: (id)sender{
    CCScene* scene = [CCBReader sceneWithNodeGraphFromFile:@"Shop.ccbi"];
    [[CCDirector sharedDirector]replaceScene:[CCTransitionCrossFade transitionWithDuration:0.3 scene:scene]];
}
@end
