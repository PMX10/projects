//
//  LevelSelectScene.m
//  SmashingWord_me
//
//  Created by Edward on 4/8/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "LevelSelectScene.h"
#import "CCBReader.h"

@implementation LevelSelectScene
-(void)Level1Chosen: (id)sender{
    CCScene* scene = [CCBReader sceneWithNodeGraphFromFile:@"SinglePlayer.ccbi"];
    [[CCDirector sharedDirector]replaceScene:[CCTransitionCrossFade transitionWithDuration:0.3 scene:scene]];
    BUTTON_APPEAR_DURATION = 1.6;
}

-(void)Level2Chosen: (id)sender{
    CCScene* scene = [CCBReader sceneWithNodeGraphFromFile:@"SinglePlayer.ccbi"];
    [[CCDirector sharedDirector]replaceScene:[CCTransitionCrossFade transitionWithDuration:0.3 scene:scene]];
    BUTTON_APPEAR_DURATION = 1.4;
}

-(void)Level3Chosen: (id)sender{
    CCScene* scene = [CCBReader sceneWithNodeGraphFromFile:@"SinglePlayer.ccbi"];
    [[CCDirector sharedDirector]replaceScene:[CCTransitionCrossFade transitionWithDuration:0.3 scene:scene]];
    BUTTON_APPEAR_DURATION = 1.2;
}

-(void)Level4Chosen: (id)sender{
    CCScene* scene = [CCBReader sceneWithNodeGraphFromFile:@"SinglePlayer.ccbi"];
    [[CCDirector sharedDirector]replaceScene:[CCTransitionCrossFade transitionWithDuration:0.3 scene:scene]];
    BUTTON_APPEAR_DURATION = 1;
}

-(void)Level5Chosen: (id)sender{
    CCScene* scene = [CCBReader sceneWithNodeGraphFromFile:@"SinglePlayer.ccbi"];
    [[CCDirector sharedDirector]replaceScene:[CCTransitionCrossFade transitionWithDuration:0.3 scene:scene]];
    BUTTON_APPEAR_DURATION = 0.8;
}
-(void)BackButtonPress:(id)sender{
    CCScene* scene = [CCBReader sceneWithNodeGraphFromFile:@"GameMenu.ccbi"];
    [[CCDirector sharedDirector]replaceScene:[CCTransitionCrossFade transitionWithDuration:0.3 scene:scene]];
}


@end
