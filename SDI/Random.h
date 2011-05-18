//
//  Random.h
//  SDI
//
//  Created by Jong Pil Park on 11. 5. 18..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Random : NSObject {
    
}

void initRandomSeed(long firstSeed);
float nextRandomFloat();

@end
