//
//  ShopScene.h
//  SmashingWord_me
//
//  Created by Edward on 5/1/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "globalVar.h"

@interface ShopScene : CCLayer {
    CCLabelTTF* shopItem[5];
    CCLabelTTF* moneyLabel;
}


-(void)freezeTimePress:(id)sender;

-(void)extraTimePress:(id)sender;

-(void)slowdownTimePress:(id)sender;

-(void)cloudPress:(id)sender;

-(void)increasePress:(id)sender;

@end 
