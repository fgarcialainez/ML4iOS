/**
 *
 * ML4iOS.m
 * ML4iOS
 *
 * Created by Felix Garcia Lainez on April 7, 2012
 * Copyright 2012 Felix Garcia Lainez
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "ML4iOS.h"
#import "HTTPCommsManager.h"
#import "Constants.h"
#import "LocalPredictiveModel.h"

/**
 * Interface that contains private methods
 */
@interface ML4iOS()

#pragma mark -

/**
 * Creates an asynchronous operation, adding it to the queue
 * @param selector The method to be called asynchronously from NSOperation
 * @param params The parameters passed to the method referenced in selector
 */
-(NSOperation*)launchOperationWithSelector:(SEL)selector params:(NSObject*)params;

//*******************************************************************************
//*****************************  ASYNC CALLBACKS  *******************************
//*******************************************************************************

/**
 * This collection of methods are called from asynchronous operations created by the method launchOperationWithSelector.
 * There is one method by asynchronous request defined in the public interface.
 */

#pragma mark -
#pragma mark DataSources Async Callbacks

-(void)createDataSourceAction:(NSDictionary*)params;
-(void)updateDataSourceAction:(NSDictionary*)params;
-(void)deleteDataSourceAction:(NSDictionary*)params;
-(void)getAllDataSourcesAction:(NSDictionary*)params;
-(void)getDataSourceAction:(NSDictionary*)params;
-(void)checkDataSourceIsReadyAction:(NSDictionary*)params;

#pragma mark -
#pragma mark Datasets Async Callbacks

-(void)createDataSetAction:(NSDictionary*)params;
-(void)updateDataSetAction:(NSDictionary*)params;
-(void)deleteDataSetAction:(NSDictionary*)params;
-(void)getAllDataSetsAction:(NSDictionary*)params;
-(void)getDataSetAction:(NSDictionary*)params;
-(void)checkDataSetIsReadyAction:(NSDictionary*)params;

#pragma mark -
#pragma mark Models Async Callbacks

-(void)createModelAction:(NSDictionary*)params;
-(void)updateModelAction:(NSDictionary*)params;
-(void)deleteModelAction:(NSDictionary*)params;
-(void)getAllModelsAction:(NSDictionary*)params;
-(void)getModelAction:(NSDictionary*)params;
-(void)checkModelIsReadyAction:(NSDictionary*)params;

#pragma mark -
#pragma mark Clusters Async Callbacks

-(void)createClusterAction:(NSDictionary*)params;
-(void)updateClusterAction:(NSDictionary*)params;
-(void)deleteClusterAction:(NSDictionary*)params;
-(void)getAllClustersAction:(NSDictionary*)params;
-(void)getClusterAction:(NSDictionary*)params;
-(void)checkClusterIsReadyAction:(NSDictionary*)params;

#pragma mark -
#pragma mark Predictions Async Callbacks

-(void)createPredictionAction:(NSDictionary*)params;
-(void)updatePredictionAction:(NSDictionary*)params;
-(void)deletePredictionAction:(NSDictionary*)params;
-(void)getAllPredictionsAction:(NSDictionary*)params;
-(void)getPredictionAction:(NSDictionary*)params;
-(void)checkPredictionIsReadyAction:(NSDictionary*)params;

@end

#pragma mark -

@implementation ML4iOS

#pragma mark -

@synthesize delegate;

#pragma mark -

-(ML4iOS*)initWithUsername:(NSString*)username key:(NSString*)key developmentMode:(BOOL)devMode
{
    self = [super init];
    
    if(self)
    {
        operationQueue = [[NSOperationQueue alloc]init];
        commsManager = [[HTTPCommsManager alloc]initWithUsername:username key:key developmentMode:devMode];
    }
    
    return self;
}

-(void)cancelAllAsynchronousOperations
{
    [operationQueue cancelAllOperations];
}

-(NSOperation*)launchOperationWithSelector:(SEL)selector params:(NSObject*)params
{
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:selector object:params];
    [operationQueue addOperation:operation];
    return operation;
}

-(void)dealloc
{
    [operationQueue cancelAllOperations];
}

+(NSString*) getResourceIdentifierFromJSONObject:(NSDictionary*)resouce
{
    NSString* identifier = nil;
    
    NSString* fullSourceIdentifier = resouce[@"resource"];
    NSRange range = [fullSourceIdentifier rangeOfString:@"/"];
    
    if(range.location != NSNotFound)
        identifier = [fullSourceIdentifier substringFromIndex:range.location + 1];
    
    return identifier;
}

//*******************************************************************************
//********************************  SOURCES  ************************************
//****************** https://bigml.com/developers/sources ***********************
//*******************************************************************************

#pragma mark -
#pragma mark DataSources

-(NSDictionary*)createDataSourceWithNameSync:(NSString*)name filePath:(NSString*)filePath statusCode:(NSInteger*)code
{
    return [commsManager createDataSourceWithName:name filePath:filePath statusCode:code];
}

-(NSOperation*)createDataSourceWithName:(NSString*)name filePath:(NSString*)filePath
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:2];
    params[@"name"] = name;
    params[@"filePath"] = filePath;
    
    return [self launchOperationWithSelector:@selector(createDataSourceAction:) params:params];
}

-(void)createDataSourceAction:(NSDictionary*)params
{
    NSInteger statusCode = 0;
    NSString* name = params[@"name"];
    NSString* filePath = params[@"filePath"];
    
    NSDictionary* dataSource = [commsManager createDataSourceWithName:name filePath:filePath statusCode:&statusCode];
    
    [delegate dataSourceCreated:dataSource statusCode:statusCode];
}

-(NSDictionary*)updateDataSourceNameWithIdSync:(NSString*)identifier name:(NSString*)name statusCode:(NSInteger*)code
{
    return [commsManager updateDataSourceNameWithId:identifier name:name statusCode:code];
}

-(NSOperation*)updateDataSourceNameWithId:(NSString*)identifier name:(NSString*)name
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:2];
    params[@"identifier"] = identifier;
    params[@"name"] = name;
    
    return [self launchOperationWithSelector:@selector(updateDataSourceAction:) params:params];
}

-(void)updateDataSourceAction:(NSDictionary*)params
{
    NSInteger statusCode = 0;
    NSString* identifier = params[@"identifier"];
    NSString* name = params[@"name"];
    
    NSDictionary* dataSource = [commsManager updateDataSourceNameWithId:identifier name:name statusCode:&statusCode];
    
    [delegate dataSourceUpdated:dataSource statusCode:statusCode];
}

-(NSInteger)deleteDataSourceWithIdSync:(NSString*)identifier
{
    return [commsManager deleteDataSourceWithId:identifier];
}

-(NSOperation*)deleteDataSourceWithId:(NSString*)identifier
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:1];
    params[@"identifier"] = identifier;
    
    return [self launchOperationWithSelector:@selector(deleteDataSourceAction:) params:params];
}

-(void)deleteDataSourceAction:(NSDictionary*)params
{
    NSInteger statusCode = [commsManager deleteDataSourceWithId:params[@"identifier"]];
    
    [delegate dataSourceDeletedWithStatusCode:statusCode];
}

-(NSDictionary*)getAllDataSourcesWithNameSync:(NSString*)name offset:(NSInteger)offset limit:(NSInteger)limit statusCode:(NSInteger*)code
{
    return [commsManager getAllDataSourcesWithName:name offset:offset limit:limit statusCode:code];
}

-(NSOperation*)getAllDataSourcesWithName:(NSString*)name offset:(NSInteger)offset limit:(NSInteger)limit
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:3];
    params[@"name"] = name;
    params[@"offset"] = @(offset);
    params[@"limit"] = @(limit);
    
    return [self launchOperationWithSelector:@selector(getAllDataSourcesAction:) params:params];
}

-(void)getAllDataSourcesAction:(NSDictionary*)params
{
    NSInteger statusCode = 0;
    NSString* name = params[@"name"];
    NSInteger offset = [params[@"offset"]integerValue];
    NSInteger limit = [params[@"limit"]integerValue];
    
    NSDictionary* dataSources = [commsManager getAllDataSourcesWithName:name offset:offset limit:limit statusCode:&statusCode];
    
    [delegate dataSourcesRetrieved:dataSources statusCode:statusCode];
}

-(NSDictionary*)getDataSourceWithIdSync:(NSString*)identifier statusCode:(NSInteger*)code
{
    return [commsManager getDataSourceWithId:identifier statusCode:code];
}

-(NSOperation*)getDataSourceWithId:(NSString*)identifier
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:1];
    params[@"identifier"] = identifier;
    
    return [self launchOperationWithSelector:@selector(getDataSourceAction:) params:params];
}

-(void)getDataSourceAction:(NSDictionary*)params
{
    NSInteger statusCode = 0;
    NSDictionary* dataSource = [commsManager getDataSourceWithId:params[@"identifier"] statusCode:&statusCode];
    
    [delegate dataSourceRetrieved:dataSource statusCode:statusCode];
}

-(BOOL)checkDataSourceIsReadyWithIdSync:(NSString*)identifier
{
    BOOL ready = NO;
    
    NSInteger statusCode = 0;
    NSDictionary* dataSource = [commsManager getDataSourceWithId:identifier statusCode:&statusCode];
    
    if(dataSource != nil && statusCode == HTTP_OK)
        ready = [dataSource[@"status"][@"code"]intValue] == FINISHED;
    
    return ready;
}

-(NSOperation*)checkDataSourceIsReadyWithId:(NSString*)identifier
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:1];
    params[@"identifier"] = identifier;
    
    return [self launchOperationWithSelector:@selector(checkDataSourceIsReadyAction:) params:params];
}

-(void)checkDataSourceIsReadyAction:(NSDictionary*)params
{
    BOOL ready = NO;
    
    NSInteger statusCode = 0;
    NSDictionary* dataSource = [commsManager getDataSourceWithId:params[@"identifier"] statusCode:&statusCode];
    
    if(dataSource != nil && statusCode == HTTP_OK)
        ready = [dataSource[@"status"][@"code"]intValue] == FINISHED;
    
    [delegate dataSourceIsReady:ready];
}

//*******************************************************************************
//*********************************  DATASETS  **********************************
//******************* https://bigml.com/developers/datasets *********************
//*******************************************************************************

#pragma mark -
#pragma mark Datasets

-(NSDictionary*)createDataSetWithDataSourceIdSync:(NSString*)sourceId name:(NSString*)name statusCode:(NSInteger*)code
{
    return [commsManager createDataSetWithDataSourceId:sourceId name:name statusCode:code];
}

-(NSOperation*)createDataSetWithDataSourceId:(NSString*)sourceId name:(NSString*)name
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:2];
    params[@"sourceId"] = sourceId;
    params[@"name"] = name;
    
    return [self launchOperationWithSelector:@selector(createDataSetAction:) params:params];
}

-(void)createDataSetAction:(NSDictionary*)params
{
    NSInteger statusCode = 0;
    NSString* sourceId = params[@"sourceId"];
    NSString* name = params[@"name"];
    
    NSDictionary* dataSet = [commsManager createDataSetWithDataSourceId:sourceId name:name statusCode:&statusCode];
    
    [delegate dataSetCreated:dataSet statusCode:statusCode];
}

-(NSDictionary*)updateDataSetNameWithIdSync:(NSString*)identifier name:(NSString*)name statusCode:(NSInteger*)code
{
    return [commsManager updateDataSetNameWithId:identifier name:name statusCode:code];
}

-(NSOperation*)updateDataSetNameWithId:(NSString*)identifier name:(NSString*)name
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:2];
    params[@"identifier"] = identifier;
    params[@"name"] = name;
    
    return [self launchOperationWithSelector:@selector(updateDataSetAction:) params:params];
}

-(void)updateDataSetAction:(NSDictionary*)params
{
    NSInteger statusCode = 0;
    NSString* identifier = params[@"identifier"];
    NSString* name = params[@"name"];
    
    NSDictionary* dataSet = [commsManager updateDataSetNameWithId:identifier name:name statusCode:&statusCode];
    
    [delegate dataSetUpdated:dataSet statusCode:statusCode];
}

-(NSInteger)deleteDataSetWithIdSync:(NSString*)identifier
{
    return [commsManager deleteDataSetWithId:identifier];
}

-(NSOperation*)deleteDataSetWithId:(NSString*)identifier
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:1];
    params[@"identifier"] = identifier;
    
    return [self launchOperationWithSelector:@selector(deleteDataSetAction:) params:params];
}

-(void)deleteDataSetAction:(NSDictionary*)params
{
    NSInteger statusCode = [commsManager deleteDataSetWithId:params[@"identifier"]];
    
    [delegate dataSetDeletedWithStatusCode:statusCode];
}

-(NSDictionary*)getAllDataSetsWithNameSync:(NSString*)name offset:(NSInteger)offset limit:(NSInteger)limit statusCode:(NSInteger*)code
{
    return [commsManager getAllDataSetsWithName:name offset:offset limit:limit statusCode:code];
}

-(NSOperation*)getAllDataSetsWithName:(NSString*)name offset:(NSInteger)offset limit:(NSInteger)limit
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:3];
    params[@"name"] = name;
    params[@"offset"] = @(offset);
    params[@"limit"] = @(limit);
    
    return [self launchOperationWithSelector:@selector(getAllDataSetsAction:) params:params];
}

-(void)getAllDataSetsAction:(NSDictionary*)params
{
    NSInteger statusCode = 0;
    NSString* name = params[@"name"];
    NSInteger offset = [params[@"offset"]integerValue];
    NSInteger limit = [params[@"limit"]integerValue];
    
    NSDictionary* dataSources = [commsManager getAllDataSetsWithName:name offset:offset limit:limit statusCode:&statusCode];
    
    [delegate dataSetsRetrieved:dataSources statusCode:statusCode];
}

-(NSDictionary*)getDataSetWithIdSync:(NSString*)identifier statusCode:(NSInteger*)code
{
    return [commsManager getDataSetWithId:identifier statusCode:code];
}

-(NSOperation*)getDataSetWithId:(NSString*)identifier
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:1];
    params[@"identifier"] = identifier;
    
    return [self launchOperationWithSelector:@selector(getDataSetAction:) params:params];
}

-(void)getDataSetAction:(NSDictionary*)params
{
    NSInteger statusCode = 0;
    NSDictionary* dataSet = [commsManager getDataSetWithId:params[@"identifier"] statusCode:&statusCode];
    
    [delegate dataSetRetrieved:dataSet statusCode:statusCode];
}

-(BOOL)checkDataSetIsReadyWithIdSync:(NSString*)identifier
{
    BOOL ready = NO;
    
    NSInteger statusCode = 0;
    NSDictionary* dataSet = [commsManager getDataSetWithId:identifier statusCode:&statusCode];
    
    if(dataSet != nil && statusCode == HTTP_OK)
        ready = [dataSet[@"status"][@"code"]intValue] == FINISHED;
    
    return ready;
}

-(NSOperation*)checkDataSetIsReadyWithId:(NSString*)identifier
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:1];
    params[@"identifier"] = identifier;
    
    return [self launchOperationWithSelector:@selector(checkDataSetIsReadyAction:) params:params];
}

-(void)checkDataSetIsReadyAction:(NSDictionary*)params
{
    BOOL ready = NO;
    
    NSInteger statusCode = 0;
    NSDictionary* dataSet = [commsManager getDataSetWithId:params[@"identifier"] statusCode:&statusCode];
    
    if(dataSet != nil && statusCode == HTTP_OK)
        ready = [dataSet[@"status"][@"code"]intValue] == FINISHED;
    
    [delegate dataSetIsReady:ready];
}

//*******************************************************************************
//*********************************  MODELS  ************************************
//******************* https://bigml.com/developers/models ***********************
//*******************************************************************************

#pragma mark -
#pragma mark Models

-(NSDictionary*)createModelWithDataSetIdSync:(NSString*)dataSetId name:(NSString*)name statusCode:(NSInteger*)code
{
    return [commsManager createModelWithDataSetId:dataSetId name:name statusCode:code];
}

-(NSOperation*)createModelWithDataSetId:(NSString*)dataSetId name:(NSString*)name
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:2];
    params[@"dataSetId"] = dataSetId;
    params[@"name"] = name;
    
    return [self launchOperationWithSelector:@selector(createModelAction:) params:params];
}

-(void)createModelAction:(NSDictionary*)params
{
    NSInteger statusCode = 0;
    NSString* dataSetId = params[@"dataSetId"];
    NSString* name = params[@"name"];
    
    NSDictionary* model = [commsManager createModelWithDataSetId:dataSetId name:name statusCode:&statusCode];
    
    [delegate modelCreated:model statusCode:statusCode];
}

-(NSDictionary*)updateModelNameWithIdSync:(NSString*)identifier name:(NSString*)name statusCode:(NSInteger*)code
{
    return [commsManager updateModelNameWithId:identifier name:name statusCode:code];
}

-(NSOperation*)updateModelNameWithId:(NSString*)identifier name:(NSString*)name
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:2];
    params[@"identifier"] = identifier;
    params[@"name"] = name;
    
    return [self launchOperationWithSelector:@selector(updateModelAction:) params:params];
}

-(void)updateModelAction:(NSDictionary*)params
{
    NSInteger statusCode = 0;
    NSString* identifier = params[@"identifier"];
    NSString* name = params[@"name"];
    
    NSDictionary* model = [commsManager updateModelNameWithId:identifier name:name statusCode:&statusCode];
    
    [delegate modelUpdated:model statusCode:statusCode];
}

-(NSInteger)deleteModelWithIdSync:(NSString*)identifier
{
    return [commsManager deleteModelWithId:identifier];
}

-(NSOperation*)deleteModelWithId:(NSString*)identifier
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:1];
    params[@"identifier"] = identifier;
    
    return [self launchOperationWithSelector:@selector(deleteModelAction:) params:params];
}

-(void)deleteModelAction:(NSDictionary*)params
{
    NSInteger statusCode = [commsManager deleteModelWithId:params[@"identifier"]];
    
    [delegate modelDeletedWithStatusCode:statusCode];
}

-(NSDictionary*)getAllModelsWithNameSync:(NSString*)name offset:(NSInteger)offset limit:(NSInteger)limit statusCode:(NSInteger*)code
{
    return [commsManager getAllModelsWithName:name offset:offset limit:limit statusCode:code];
}

-(NSOperation*)getAllModelsWithName:(NSString*)name offset:(NSInteger)offset limit:(NSInteger)limit
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:3];
    params[@"name"] = name;
    params[@"offset"] = @(offset);
    params[@"limit"] = @(limit);
    
    return [self launchOperationWithSelector:@selector(getAllModelsAction:) params:params];
}

-(void)getAllModelsAction:(NSDictionary*)params
{
    NSInteger statusCode = 0;
    NSString* name = params[@"name"];
    NSInteger offset = [params[@"offset"]integerValue];
    NSInteger limit = [params[@"limit"]integerValue];
    
    NSDictionary* models = [commsManager getAllModelsWithName:name offset:offset limit:limit statusCode:&statusCode];
    
    [delegate modelsRetrieved:models statusCode:statusCode];
}

-(NSDictionary*)getModelWithIdSync:(NSString*)identifier statusCode:(NSInteger*)code
{
    return [commsManager getModelWithId:identifier statusCode:code];
}

-(NSOperation*)getModelWithId:(NSString*)identifier
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:1];
    params[@"identifier"] = identifier;
    
    return [self launchOperationWithSelector:@selector(getModelAction:) params:params];
}

-(void)getModelAction:(NSDictionary*)params
{
    NSInteger statusCode = 0;
    NSDictionary* model = [commsManager getModelWithId:params[@"identifier"] statusCode:&statusCode];
    
    [delegate modelRetrieved:model statusCode:statusCode];
}

-(BOOL)checkModelIsReadyWithIdSync:(NSString*)identifier
{
    BOOL ready = NO;
    
    NSInteger statusCode = 0;
    NSDictionary* model = [commsManager getModelWithId:identifier statusCode:&statusCode];
    
    if(model != nil && statusCode == HTTP_OK)
        ready = [model[@"status"][@"code"]intValue] == FINISHED;
    
    return ready;
}

-(NSOperation*)checkModelIsReadyWithId:(NSString*)identifier
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:3];
    params[@"identifier"] = identifier;
    
    return [self launchOperationWithSelector:@selector(checkModelIsReadyAction:) params:params];
}

-(void)checkModelIsReadyAction:(NSDictionary*)params
{
    BOOL ready = NO;
    
    NSInteger statusCode = 0;
    NSDictionary* model = [commsManager getModelWithId:params[@"identifier"] statusCode:&statusCode];
    
    if(model != nil && statusCode == HTTP_OK)
        ready = [model[@"status"][@"code"]intValue] == FINISHED;
    
    [delegate modelIsReady:ready];
}

//*******************************************************************************
//*********************************  CLUSTERS  **********************************
//******************* https://bigml.com/developers/clusters *********************
//*******************************************************************************

#pragma mark -
#pragma mark Clusters

-(NSDictionary*)createClusterWithDataSetIdSync:(NSString*)dataSetId name:(NSString*)name numberOfClusters:(NSInteger)k statusCode:(NSInteger*)code
{
    return [commsManager createClusterWithDataSetId:dataSetId name:name numberOfClusters:k statusCode:code];
}

-(NSOperation*)createClusterWithDataSetId:(NSString*)dataSetId name:(NSString*)name numberOfClusters:(NSInteger)k
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:2];
    params[@"dataSetId"] = dataSetId;
    params[@"name"] = name;
    params[@"k"] = [NSNumber numberWithInteger:k];
    
    return [self launchOperationWithSelector:@selector(createClusterAction:) params:params];
}

-(void)createClusterAction:(NSDictionary*)params
{
    NSInteger statusCode = 0;
    NSString* dataSetId = params[@"dataSetId"];
    NSString* name = params[@"name"];
    NSInteger k = [params[@"k"]intValue];
    
    NSDictionary* cluster = [commsManager createClusterWithDataSetId:dataSetId name:name numberOfClusters:k statusCode:&statusCode];
    
    [delegate clusterCreated:cluster statusCode:statusCode];
}

-(NSDictionary*)updateClusterNameWithIdSync:(NSString*)identifier name:(NSString*)name statusCode:(NSInteger*)code
{
    return [commsManager updateClusterNameWithId:identifier name:name statusCode:code];
}

-(NSOperation*)updateClusterNameWithId:(NSString*)identifier name:(NSString*)name
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:2];
    params[@"identifier"] = identifier;
    params[@"name"] = name;
    
    return [self launchOperationWithSelector:@selector(updateClusterAction:) params:params];
}

-(void)updateClusterAction:(NSDictionary*)params
{
    NSInteger statusCode = 0;
    NSString* identifier = params[@"identifier"];
    NSString* name = params[@"name"];
    
    NSDictionary* model = [commsManager updateClusterNameWithId:identifier name:name statusCode:&statusCode];
    
    [delegate clusterUpdated:model statusCode:statusCode];
}

-(NSInteger)deleteClusterWithIdSync:(NSString*)identifier
{
    return [commsManager deleteClusterWithId:identifier];
}

-(NSOperation*)deleteClusterWithId:(NSString*)identifier
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:1];
    params[@"identifier"] = identifier;
    
    return [self launchOperationWithSelector:@selector(deleteClusterAction:) params:params];
}

-(void)deleteClusterAction:(NSDictionary*)params
{
    NSInteger statusCode = [commsManager deleteClusterWithId:params[@"identifier"]];
    
    [delegate clusterDeletedWithStatusCode:statusCode];
}

-(NSDictionary*)getAllClustersWithNameSync:(NSString*)name offset:(NSInteger)offset limit:(NSInteger)limit statusCode:(NSInteger*)code
{
    return [commsManager getAllClustersWithName:name offset:offset limit:limit statusCode:code];
}

-(NSOperation*)getAllClustersWithName:(NSString*)name offset:(NSInteger)offset limit:(NSInteger)limit
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:3];
    params[@"name"] = name;
    params[@"offset"] = @(offset);
    params[@"limit"] = @(limit);
    
    return [self launchOperationWithSelector:@selector(getAllClustersAction:) params:params];
}

-(void)getAllClustersAction:(NSDictionary*)params
{
    NSInteger statusCode = 0;
    NSString* name = params[@"name"];
    NSInteger offset = [params[@"offset"]integerValue];
    NSInteger limit = [params[@"limit"]integerValue];
    
    NSDictionary* clusters = [commsManager getAllClustersWithName:name offset:offset limit:limit statusCode:&statusCode];
    
    [delegate clustersRetrieved:clusters statusCode:statusCode];
}

-(NSDictionary*)getClusterWithIdSync:(NSString*)identifier statusCode:(NSInteger*)code
{
    return [commsManager getClusterWithId:identifier statusCode:code];
}

-(NSOperation*)getClusterWithId:(NSString*)identifier
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:1];
    params[@"identifier"] = identifier;
    
    return [self launchOperationWithSelector:@selector(getClusterAction:) params:params];
}

-(void)getClusterAction:(NSDictionary*)params
{
    NSInteger statusCode = 0;
    NSDictionary* cluster = [commsManager getClusterWithId:params[@"identifier"] statusCode:&statusCode];
    
    [delegate clusterRetrieved:cluster statusCode:statusCode];
}

-(BOOL)checkClusterIsReadyWithIdSync:(NSString*)identifier
{
    BOOL ready = NO;
    
    NSInteger statusCode = 0;
    NSDictionary* cluster = [commsManager getClusterWithId:identifier statusCode:&statusCode];
    
    if(cluster != nil && statusCode == HTTP_OK)
        ready = [cluster[@"status"][@"code"]intValue] == FINISHED;
    
    return ready;
}

-(NSOperation*)checkClusterIsReadyWithId:(NSString*)identifier
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:3];
    params[@"identifier"] = identifier;
    
    return [self launchOperationWithSelector:@selector(checkClusterIsReadyAction:) params:params];
}

-(void)checkClusterIsReadyAction:(NSDictionary*)params
{
    BOOL ready = NO;
    
    NSInteger statusCode = 0;
    NSDictionary* cluster = [commsManager getModelWithId:params[@"identifier"] statusCode:&statusCode];
    
    if(cluster != nil && statusCode == HTTP_OK)
        ready = [cluster[@"status"][@"code"]intValue] == FINISHED;
    
    [delegate clusterIsReady:ready];
}

//*******************************************************************************
//******************************  PREDICTIONS  **********************************
//****************** https://bigml.com/developers/predictions *******************
//*******************************************************************************

#pragma mark -
#pragma mark Predictions

-(NSDictionary*)createPredictionWithModelIdSync:(NSString*)modelId name:(NSString*)name inputData:(NSString*)inputData statusCode:(NSInteger*)code
{
    return [commsManager createPredictionWithModelId:modelId name:name inputData:inputData statusCode:code];
}

-(NSOperation*)createPredictionWithModelId:(NSString*)modelId name:(NSString*)name inputData:(NSString*)inputData
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:3];
    params[@"identifier"] = modelId;
    params[@"name"] = name;
    params[@"inputData"] = inputData;
    
    return [self launchOperationWithSelector:@selector(createPredictionAction:) params:params];
}

-(void)createPredictionAction:(NSDictionary*)params
{
    NSInteger statusCode = 0;
    NSString* identifier = params[@"identifier"];
    NSString* name = params[@"name"];
    NSString* inputData = params[@"inputData"];
    
    NSDictionary* prediction = [commsManager createPredictionWithModelId:identifier name:name inputData:inputData statusCode:&statusCode];
    
    [delegate predictionCreated:prediction statusCode:statusCode];
}

-(NSDictionary*)updatePredictionWithIdSync:(NSString*)identifier name:(NSString*)name statusCode:(NSInteger*)code
{
    return [commsManager updatePredictionWithId:identifier name:name statusCode:code];
}

-(NSOperation*)updatePredictionWithId:(NSString*)identifier name:(NSString*)name
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:3];
    params[@"identifier"] = identifier;
    params[@"name"] = name;
    
    return [self launchOperationWithSelector:@selector(updatePredictionAction:) params:params];
}

-(void)updatePredictionAction:(NSDictionary*)params
{
    NSInteger statusCode = 0;
    NSString* identifier = params[@"identifier"];
    NSString* name = params[@"name"];
    
    NSDictionary* prediction = [commsManager updatePredictionWithId:identifier name:name statusCode:&statusCode];
    
    [delegate predictionUpdated:prediction statusCode:statusCode];
}

-(NSInteger)deletePredictionWithIdSync:(NSString*)identifier
{
    return [commsManager deletePredictionWithId:identifier];
}

-(NSOperation*)deletePredictionWithId:(NSString*)identifier
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:1];
    params[@"identifier"] = identifier;
    
    return [self launchOperationWithSelector:@selector(deletePredictionAction:) params:params];
}

-(void)deletePredictionAction:(NSDictionary*)params
{
    NSInteger statusCode = [commsManager deletePredictionWithId:params[@"identifier"]];
    
    [delegate predictionDeletedWithStatusCode:statusCode];
}

-(NSDictionary*)getAllPredictionsWithNameSync:(NSString*)name offset:(NSInteger)offset limit:(NSInteger)limit statusCode:(NSInteger*)code
{
    return [commsManager getAllPredictionsWithName:name offset:offset limit:limit statusCode:code];
}

-(NSOperation*)getAllPredictionsWithName:(NSString*)name offset:(NSInteger)offset limit:(NSInteger)limit
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:3];
    params[@"name"] = name;
    params[@"offset"] = @(offset);
    params[@"limit"] = @(limit);
    
    return [self launchOperationWithSelector:@selector(getAllPredictionsAction:) params:params];
}

-(void)getAllPredictionsAction:(NSDictionary*)params
{
    NSInteger statusCode = 0;
    NSString* name = params[@"name"];
    NSInteger offset = [params[@"offset"]integerValue];
    NSInteger limit = [params[@"limit"]integerValue];
    
    NSDictionary* predictions = [commsManager getAllPredictionsWithName:name offset:offset limit:limit statusCode:&statusCode];
    
    [delegate predictionsRetrieved:predictions statusCode:statusCode];
}

-(NSDictionary*)getPredictionWithIdSync:(NSString*)identifier statusCode:(NSInteger*)code
{
    return [commsManager getPredictionWithId:identifier statusCode:code];
}

-(NSOperation*)getPredictionWithId:(NSString*)identifier
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:1];
    params[@"identifier"] = identifier;
    
    return [self launchOperationWithSelector:@selector(getPredictionAction:) params:params];
}

-(void)getPredictionAction:(NSDictionary*)params
{
    NSInteger statusCode = 0;
    NSDictionary* prediction = [commsManager getPredictionWithId:params[@"identifier"] statusCode:&statusCode];
    
    [delegate predictionRetrieved:prediction statusCode:statusCode];
}

-(BOOL)checkPredictionIsReadyWithIdSync:(NSString*)identifier
{
    BOOL ready = NO;
    
    NSInteger statusCode = 0;
    NSDictionary* prediction = [commsManager getPredictionWithId:identifier statusCode:&statusCode];
    
    if(prediction != nil && statusCode == HTTP_OK)
        ready = [prediction[@"status"][@"code"]intValue] == FINISHED;
    
    return ready;
}

-(NSOperation*)checkPredictionIsReadyWithId:(NSString*)identifier
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:3];
    params[@"identifier"] = identifier;
    
    return [self launchOperationWithSelector:@selector(checkPredictionIsReadyAction:) params:params];
}

-(void)checkPredictionIsReadyAction:(NSDictionary*)params
{
    BOOL ready = NO;
    
    NSInteger statusCode = 0;
    NSDictionary* prediction = [commsManager getPredictionWithId:params[@"identifier"] statusCode:&statusCode];
    
    if(prediction != nil && statusCode == HTTP_OK)
        ready = [prediction[@"status"][@"code"]intValue] == FINISHED;
    
    [delegate predictionIsReady:ready];
}

//*******************************************************************************
//***************************  LOCAL PREDICTIONS  *******************************
//*******************************************************************************

#pragma mark -
#pragma mark Local Predictions

-(NSDictionary*)createLocalPredictionWithJSONModelSync:(NSDictionary*)jsonModel arguments:(NSString*)args argsByName:(BOOL)byName
{
    return [LocalPredictiveModel predictWithJSONModel:jsonModel arguments:args argsByName:NO];
}

@end
