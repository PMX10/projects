//
//  HowToPlayScene.m
//  SmashingWord_me
//
//  Created by Edward on 3/19/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "HowToPlayScene.h"
#import "CCBReader.h"

@implementation HowToPlayScene
-(void)BackButtonPress:(id)sender{
    CCScene* scene = [CCBReader sceneWithNodeGraphFromFile:@"GameMenu.ccbi"];
    [[CCDirector sharedDirector]replaceScene:[CCTransitionCrossFade transitionWithDuration:0.3 scene:scene]];
}
@end
