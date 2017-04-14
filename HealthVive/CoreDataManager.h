//
//  CoreDataManager.h
//  HealthVive
//
//  Created by Sadhasivan Sriram on 19/01/17.
//  Copyright © 2017 NousInfosystems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
+ (id)sharedManager ;
-(NSArray*)fetchDataFromEntity:(NSString*)entityName predicate:(NSPredicate*)predicate;
-(NSArray*)fetchDataFromEntity:(NSString*)entityName predicate:(NSPredicate*)predicate sortBy:(NSString *)param;
-(void)saveDetailsToEntity:(NSString *)entityName andValues:(NSDictionary *)valuesToSave;
-(void)updateDeatailsToEntity:(NSString *)entityName andPredicate:(NSPredicate*)predicate andValues:(NSDictionary *)valuesToSave;
-(void)update:(NSManagedObject*) object :(NSDictionary *)dict;
-(void)deleteData:(NSManagedObject*) object;
-(void)commitChanges;




@end
