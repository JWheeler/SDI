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


@interface SBCountController : NSObject <NSFetchedResultsControllerDelegate> 
{
    SBCount *sbCount;
}

@property (nonatomic, retain) SBCount *sbCount;

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (void)insertNewObject:(SBCount *)obj;
- (BOOL)searchObject:(SBCount *)obj;
- (void)updateObject:(SBCount *)obj;
- (void)deleteObject:(SBCount *)obj;

@end
