//
//  IRStrockController.h
//  SDI
//
//  Created by Jong Pil Park on 11. 4. 14..
//  Copyright 2011 Lilac Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class IRStock;

@interface IRStockController : NSObject <NSFetchedResultsControllerDelegate> 
{
    IRStock *irStock;
}

@property (nonatomic, retain) IRStock *irStock;

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (NSFetchedResultsController *)fetchedResultsController;

@end
