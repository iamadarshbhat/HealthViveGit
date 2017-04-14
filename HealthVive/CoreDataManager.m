//
//  CoreDataManager.m
//  HealthVive
//
//  Created by Sadhasivan Sriram on 19/01/17.
//  Copyright © 2017 NousInfosystems. All rights reserved.
//

#import "CoreDataManager.h"

@implementation CoreDataManager

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


+ (id)sharedManager {
    static CoreDataManager *coreDataManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        coreDataManager = [[self alloc] init];
    });
    return coreDataManager;
}


- (id)init
{
    self = [super init];
    if (self) {
        [self managedObjectContext];
    }
    return self;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"HealthVive.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
             NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
    
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}





// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"HealthVive" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

//Returns the list of objects saved in entity.
-(NSArray*)fetchDataFromEntity:(NSString*)entityName predicate:(NSPredicate*)predicate
{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityName];
    NSArray *dataArray =[[NSArray alloc]init];
    [fetchRequest setPredicate:predicate];
    dataArray = [[_managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    return dataArray;
}


//Returns the list of objects saved in entity with order.
-(NSArray*)fetchDataFromEntity:(NSString*)entityName predicate:(NSPredicate*)predicate sortBy:(NSString *)param
{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityName];
    NSArray *dataArray =[[NSArray alloc]init];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setSortDescriptors:@[[[NSSortDescriptor alloc] initWithKey:param ascending:YES]]];
    dataArray = [[_managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    return dataArray;
}




-(void)saveDetailsToEntity:(NSString *)entityName andValues:(NSDictionary *)valuesToSave{
    
    //NSManagedObjectContext *context = _managedObjectContext;
    NSManagedObject *managedObject = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:_managedObjectContext];
    
    for (NSString *key in valuesToSave.allKeys) {

        [managedObject setValue:[valuesToSave valueForKey:key] forKey:key];
    }
    [self commitChanges];
}

-(void)updateDeatailsToEntity:(NSString *)entityName andPredicate:(NSPredicate*)predicate andValues:(NSDictionary *)valuesToSave
{
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityName];
    [fetchRequest setPredicate:predicate];
    
    NSManagedObject *managedObject = [[_managedObjectContext executeFetchRequest:fetchRequest error:&error]lastObject];
    

    for (NSString *key in valuesToSave.allKeys) {
        
        [managedObject setValue:[valuesToSave valueForKey:key] forKey:key];
    }
    
    if (![_managedObjectContext save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
   
   
}

-(NSManagedObject*)getById :(NSManagedObjectID*) ids{
    return [_managedObjectContext objectWithID:ids];
}


-(void)update:(NSManagedObject*) object :(NSDictionary *)dict{
   NSManagedObject *updatingObj =  [self getById:object.objectID];
    for (NSString *key in dict.allKeys) {
        [updatingObj setValue:[dict valueForKey:key] forKey:key];
    }
    [self commitChanges];
}

-(void)deleteData:(NSManagedObject*) object{
    NSManagedObject *deletingObj = [self getById:object.objectID];
    [_managedObjectContext deleteObject:deletingObj];
    [self commitChanges];
}

-(void)commitChanges{
    NSError *error;
  
    if (![_managedObjectContext save:&error]) {
        // Handle the error.
        NSLog(@"Error ---- %@",error);
    }
   }

@end
