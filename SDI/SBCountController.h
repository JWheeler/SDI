//
//  SBRegController.h
//  SDI
//
//  Created by Jong Pil Park on 11. 3. 30..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SBCount;

enum 
{
    SBRegCountIncrease = 0,
    SBRegCountDecrease = 1
};


@interface SBCountController : NSObject <NSFetchedResultsControllerDelegate> 
{
    SBCount *sbCount;
    SBCount *updateObject;
}

@property (nonatomic, retain) SBCount *sbCount;
@property (nonatomic, retain) SBCount *updateObject;

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (void)insertNewObject:(SBCount *)obj;
- (void)updateObject:(SBCount *)obj withType:(int)type;
- (void)deleteObject:(SBCount *)obj;
- (SBCount *)searchObjet:(SBCount *)obj;
- (SBCount *)isObjectExistence:(SBCount *)obj;

@end
