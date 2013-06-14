//
//  HighestScoreScene.m
//  SmashingWord_me
//
//  Created by Edward on 4/18/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "HighestScoreScene.h"
#import "CCBReader.h"

@implementation HighestScoreScene

-(id)init{
    if((self=[super init])){
        bg = [CCSprite spriteWithFile:@"background.png"];
        [bg setPosition:ccp(160, 240)];
        [self addChild:bg z:0];
        
        single = [CCLabelTTF labelWithString: @"Single Top 10" fontName:@"Arial" fontSize:15];
        single.position = ccp(70,430);
        single.color = ccBLACK;
        [self addChild:single z:1];
        
        multi = [CCLabelTTF labelWithString: @"Multi Top 10" fontName:@"Arial" fontSize:15];
        multi.position = ccp(210,430);
        multi.color = ccBLACK;
        [self addChild:multi z:1];
        
        self.gv = [[globalVar alloc] init];
        
        
        [self requestScore];

        
    }
    return self;
}

-(void)BackButtonPress:(id)sender{
    CCScene* scene = [CCBReader sceneWithNodeGraphFromFile:@"GameMenu.ccbi"];
    [[CCDirector sharedDirector]replaceScene:[CCTransitionCrossFade transitionWithDuration:0.3 scene:scene]];
}


-(void)requestScore
{
    
    //single_highest = [self.gv requestData:@"/users/Top10Scores/single" SecondParameter:tempDict];
    single_highest = [self.gv requestData:@"/users/Top10Scores/single"];
    //multi_highest = [self.gv requestData:@"/users/Top10Scores/multiple" SecondParameter:tempDict];
    multi_highest = [self.gv requestData:@"/users/Top10Scores/multiple"];
    
    
    int length = [single_highest count];
    NSLog(@"Single Highest Count:");
    NSLog(@"%i",[single_highest count]);
    NSLog(@"Multiple Highest Count:");
    NSLog(@"%i",[multi_highest count]);
    
    /**** TESTING ******/
    self.single = single_highest;
    self.multi = multi_highest;
    
    for(int i=0; i<length; i++){
        //singleTopTen[i] = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i. %@", i+1, single_highest[i]] fontName:@"Arial" fontSize:15];
        singleTopTen[i]= [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i. %@", i+1, single_highest[i]] dimensions:CGSizeMake(100, 20) hAlignment:kCCTextAlignmentLeft fontName:@"Arial" fontSize:15];
        //singleTopTen[i].position = ccp(40,400-i*30);
        singleTopTen[i].position = ccp(70,400-i*30);
        singleTopTen[i].color = ccBLACK;
        [self addChild:singleTopTen[i] z:1];
        /*
         multiTopTen[i] = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i. %@ %@", i+1, [multi_highest[i] objectForKey:@"user"], [multi_highest[i] objectForKey:@"score"]] fontName:@"Arial" fontSize:15
         hAlignment:kCCTextAlignmentCenter
         lineBreakMode:kCCLineBreakModeWordWrap];
         */
        
        multiTopTen[i]= [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i. %@ %@", i+1, [multi_highest[i] objectForKey:@"user"], [multi_highest[i] objectForKey:@"score"]] dimensions:CGSizeMake(200, 20) hAlignment:kCCTextAlignmentLeft fontName:@"Arial" fontSize:15];
        
        multiTopTen[i].position = ccp(222,400-i*30);
        multiTopTen[i].color = ccBLACK;
        [self addChild:multiTopTen[i] z:1];
    }
}

/*
- (NSArray*) request:(NSString*) path SecondParameter:(NSDictionary*) parameter{
    NSDictionary *jsonDict;
    if ([path isEqualToString:@"users/Top10Scores/single"]){
        jsonDict = [NSDictionary dictionaryWithObjectsAndKeys:nil];
    }
    else if ([path isEqualToString:@"users/Top10Scores/multiple"]){
        jsonDict = [NSDictionary dictionaryWithObjectsAndKeys:nil];
    }
    else{
        jsonDict = [NSDictionary dictionaryWithObjectsAndKeys:
                    nil];
    }
    NSLog(@"1");
    //[jsonDictionaryResponse objectForKey:@"data"];
    NSError *tempError;
    NSLog(@"2");
    NSData *jsonRequest = [NSJSONSerialization dataWithJSONObject:jsonDict options:NSJSONWritingPrettyPrinted error:&tempError];
    NSLog(@"3");
    NSString *fullPath = [NSString stringWithFormat:@"%@%@", @"http://enigmatic-everglades-8004.herokuapp.com/", path];
    NSLog(@"4");
    NSURL *url = [NSURL URLWithString:fullPath];
    NSLog(@"5");
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    NSLog(@"6");
    
    [request setHTTPMethod:@"POST"];
    NSLog(@"7");
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:[NSString stringWithFormat:@"%d", [jsonRequest length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:jsonRequest];
    NSLog(@"8");
    
    NSURLResponse *tempResponse =[[NSURLResponse alloc]init];
    NSLog(@"9");
    NSData *jsonResponse = [NSURLConnection sendSynchronousRequest:request returningResponse:&tempResponse error:&tempError];
    NSLog(@"%@",jsonResponse);
    NSLog(@"10");
    NSDictionary *jsonDictionaryResponse = [NSJSONSerialization JSONObjectWithData:jsonResponse options:kNilOptions error:&tempError];
    NSLog(@"11");
    
    return [jsonDictionaryResponse objectForKey:@"data"];
    
}

*/
@end
