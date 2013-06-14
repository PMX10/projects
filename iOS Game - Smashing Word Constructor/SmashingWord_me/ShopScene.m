//
//  ShopScene.m
//  SmashingWord_me
//
//  Created by Edward on 5/1/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "ShopScene.h"
#import "CCBReader.h"

@implementation ShopScene

-(id)init{
    if((self=[super init])){
        
        NSString *errorDesc = nil;
        NSPropertyListFormat format;
        NSString *plistPath;
        NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                  NSUserDomainMask, YES) objectAtIndex:0];
        plistPath = [rootPath stringByAppendingPathComponent:@"SavedState.plist"];
        NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
        NSDictionary *unarchivedData = (NSDictionary *)[NSPropertyListSerialization
                                                        propertyListFromData:plistXML
                                                        mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                                        format:&format
                                                        errorDescription:&errorDesc];
        
        // If NSDictionary exists, look to see if it holds a saved game state
        if (!unarchivedData)
        {
            NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
        }
        else
        {
            NSNumber *integerValue = [unarchivedData objectForKey:@"money"];
            money = [integerValue integerValue];
            
            integerValue = [unarchivedData objectForKey:@"extraTimeCounter"];
            extraTimeCounter = [integerValue integerValue];
            
            integerValue = [unarchivedData objectForKey:@"freezeTimeCounter"];
            freezeTimeCounter =[integerValue integerValue];
            
            integerValue = [unarchivedData objectForKey:@"slowdownTimeCounter"];
            slowdownTimeCounter =[integerValue integerValue];
            
            integerValue = [unarchivedData objectForKey:@"cloudCounter"];
            cloudCounter =[integerValue integerValue];
            
            integerValue = [unarchivedData objectForKey:@"increaseCounter"];
            increaseCounter =[integerValue integerValue];
        }
        
        
        moneyLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Gold: %i", money] fontName:@"ArialRoundedMTBold" fontSize:15];
        moneyLabel.position = ccp(50,450);
        moneyLabel.color = ccBLACK;
        [self addChild:moneyLabel z:1];
        
        shopItem[0] = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i left", freezeTimeCounter] fontName:@"ArialRoundedMTBold" fontSize:15];
        shopItem[0].position = ccp(70,300);
        shopItem[0].color = ccBLACK;
        [self addChild:shopItem[0] z:1];
        
        shopItem[1] = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i left", extraTimeCounter] fontName:@"ArialRoundedMTBold" fontSize:15];
        shopItem[1].position = ccp(170,300);
        shopItem[1].color = ccBLACK;
        [self addChild:shopItem[1] z:1];
        
        shopItem[2] = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i left", slowdownTimeCounter] fontName:@"ArialRoundedMTBold" fontSize:15];
        shopItem[2].position = ccp(260,300);
        shopItem[2].color = ccBLACK;
        [self addChild:shopItem[2] z:1];
        
        shopItem[3] = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i left", cloudCounter] fontName:@"ArialRoundedMTBold" fontSize:15];
        shopItem[3].position = ccp(70,130);
        shopItem[3].color = ccBLACK;
        [self addChild:shopItem[3] z:1];
        
        shopItem[4] = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i left", increaseCounter] fontName:@"ArialRoundedMTBold" fontSize:15];
        shopItem[4].position = ccp(170,130);
        shopItem[4].color = ccBLACK;
        [self addChild:shopItem[4] z:1];

        
    }
    return self;
}

-(void)BackButtonPress:(id)sender{

    CCScene* scene = [CCBReader sceneWithNodeGraphFromFile:@"GameMenu.ccbi"];
    [[CCDirector sharedDirector]replaceScene:[CCTransitionCrossFade transitionWithDuration:0.3 scene:scene]];
}

-(void)freezeTimePress:(id)sender{
    if(money >=100){
        money -= 100;
        freezeTimeCounter ++;
        [self saveData];
        [shopItem[0] setString:[NSString stringWithFormat:@"%i left", freezeTimeCounter]];
        [moneyLabel setString:[NSString stringWithFormat:@"Gold: %i",money]];
    }
}

-(void)extraTimePress:(id)sender{
    if(money >=100){
        money -= 100;
        extraTimeCounter ++;
        [self saveData];
        [shopItem[1] setString:[NSString stringWithFormat:@"%i left", extraTimeCounter]];
        [moneyLabel setString:[NSString stringWithFormat:@"Gold: %i",money]];
    }
}

-(void)slowdownTimePress:(id)sender{
    if(money >=100){
        money -= 100;
        slowdownTimeCounter ++;
        [self saveData];
        [shopItem[2] setString:[NSString stringWithFormat:@"%i left", slowdownTimeCounter]];
        [moneyLabel setString:[NSString stringWithFormat:@"Gold: %i",money]];
    }
}

-(void)cloudPress:(id)sender{
    if(money >=100){
        money -= 100;
        cloudCounter ++;
        [self saveData];
        [shopItem[3] setString:[NSString stringWithFormat:@"%i left", cloudCounter]];
        [moneyLabel setString:[NSString stringWithFormat:@"Gold: %i",money]];
    }
}

-(void)increasePress:(id)sender{
    if(money >=250){
        money -= 250;
        increaseCounter ++;
        [self saveData];
        [shopItem[4] setString:[NSString stringWithFormat:@"%i left", increaseCounter]];
        [moneyLabel setString:[NSString stringWithFormat:@"Gold: %i",money]];
    }
}

-(void)saveData{
    // We're going to save the data to SavedState.plist in our app's documents directory
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"SavedState.plist"];
    
    // Create a dictionary to store all your data
    NSMutableDictionary *prefs = [NSMutableDictionary dictionary];
    
    
    //NSUserDefaults *prefs = [[NSUserDefaults standardUserDefaults] synchronize];
    [prefs setObject:[NSNumber numberWithInteger:money] forKey:@"money"];
    [prefs setObject:[NSNumber numberWithInteger:extraTimeCounter] forKey:@"extraTimeCounter"];
    [prefs setObject:[NSNumber numberWithInteger:freezeTimeCounter] forKey:@"freezeTimeCounter"];
    [prefs setObject:[NSNumber numberWithInteger:slowdownTimeCounter] forKey:@"slowdownTimeCounter"];
    [prefs setObject:[NSNumber numberWithInteger:cloudCounter] forKey:@"cloudCounter"];
    [prefs setObject:[NSNumber numberWithInteger:increaseCounter]forKey:@"increaseCounter"];
    
    
    NSString *errorDescription;
    NSData *serializedData = [NSPropertyListSerialization dataFromPropertyList:prefs
                                                                        format:NSPropertyListXMLFormat_v1_0
                                                              errorDescription:&errorDescription];
    
    if(serializedData)
    {
        // Write file
        NSError *error;
        BOOL didWrite = [serializedData writeToFile:plistPath options:NSDataWritingFileProtectionComplete error:&error];
        //NSLog(@"Error while writing: %@", [error description]);
        
        if (didWrite)
            NSLog(@"File did write");
        else
            NSLog(@"File write failed");
    }
    else
    {
        NSLog(@"Error in creating state data dictionary: %@", errorDescription);
    }
}

@end
