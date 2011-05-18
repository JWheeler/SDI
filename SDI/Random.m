//
//  Random.m
//  SDI
//
//  Created by Jong Pil Park on 11. 5. 18..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import "Random.h"


@implementation Random

static unsigned long seed;

void initRandomSeed(long firstSeed)
{ 
    seed = firstSeed;
}

float nextRandomFloat()
{
    return (((seed = 1664525*seed + 1013904223)>>16) / (float)0x10000);
}

@end
