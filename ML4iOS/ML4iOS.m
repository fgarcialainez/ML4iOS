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
//*************************** ASYNC CALLBACKS  **********************************
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
    NSInvocationOperation *operation = [[[NSInvocationOperation alloc] initWithTarget:self selector:selector object:params]autorelease];
    [operationQueue addOperation:operation];
    return operation;
}

-(void)dealloc
{
    [operationQueue cancelAllOperations];
    [operationQueue release];
    [commsManager release];
    [super dealloc];
}

+(NSString*) getResourceIdentifierFromJSONObject:(NSDictionary*)resouce
{
    NSString* identifier = nil;
    
    NSString* fullSourceIdentifier = [resouce objectForKey:@"resource"];
    NSRange range = [fullSourceIdentifier rangeOfString:@"/"];
    
    if(range.location != NSNotFound)
        identifier = [fullSourceIdentifier substringFromIndex:range.location + 1];
    
    return identifier;
}

//*******************************************************************************
//*************************** SOURCES  ******************************************
//************* https://bigml.com/developers/sources ****************************
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
    [params setObject:name forKey:@"name"];
    [params setObject:filePath forKey:@"filePath"];
    
    return [self launchOperationWithSelector:@selector(createDataSourceAction:) params:params];
}

-(void)createDataSourceAction:(NSDictionary*)params
{
    NSInteger statusCode = 0;
    NSString* name = [params objectForKey:@"name"];
    NSString* filePath = [params objectForKey:@"filePath"];
    
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
    [params setObject:identifier forKey:@"identifier"];
    [params setObject:name forKey:@"name"];
    
    return [self launchOperationWithSelector:@selector(updateDataSourceAction:) params:params];
}

-(void)updateDataSourceAction:(NSDictionary*)params
{
    NSInteger statusCode = 0;
    NSString* identifier = [params objectForKey:@"identifier"];
    NSString* name = [params objectForKey:@"name"];
    
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
    [params setObject:identifier forKey:@"identifier"];
    
    return [self launchOperationWithSelector:@selector(deleteDataSourceAction:) params:params];
}

-(void)deleteDataSourceAction:(NSDictionary*)params
{
    NSInteger statusCode = [commsManager deleteDataSourceWithId:[params objectForKey:@"identifier"]];
    
    [delegate dataSourceDeletedWithStatusCode:statusCode];
}

-(NSDictionary*)getAllDataSourcesWithNameSync:(NSString*)name offset:(NSInteger)offset limit:(NSInteger)limit statusCode:(NSInteger*)code
{
    return [commsManager getAllDataSourcesWithName:name offset:offset limit:limit statusCode:code];
}

-(NSOperation*)getAllDataSourcesWithName:(NSString*)name offset:(NSInteger)offset limit:(NSInteger)limit
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:3];
    [params setObject:name forKey:@"name"];
    [params setObject:[NSNumber numberWithInteger:offset] forKey:@"offset"];
    [params setObject:[NSNumber numberWithInteger:limit] forKey:@"limit"];
    
    return [self launchOperationWithSelector:@selector(getAllDataSourcesAction:) params:params];
}

-(void)getAllDataSourcesAction:(NSDictionary*)params
{
    NSInteger statusCode = 0;
    NSString* name = [params objectForKey:@"name"];
    NSInteger offset = [[params objectForKey:@"offset"]integerValue];
    NSInteger limit = [[params objectForKey:@"limit"]integerValue];
    
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
    [params setObject:identifier forKey:@"identifier"];
    
    return [self launchOperationWithSelector:@selector(getDataSourceAction:) params:params];
}

-(void)getDataSourceAction:(NSDictionary*)params
{
    NSInteger statusCode = 0;
    NSDictionary* dataSource = [commsManager getDataSourceWithId:[params objectForKey:@"identifier"] statusCode:&statusCode];
    
    [delegate dataSourceRetrieved:dataSource statusCode:statusCode];
}

-(BOOL)checkDataSourceIsReadyWithIdSync:(NSString*)identifier
{
    BOOL ready = NO;
    
    NSInteger statusCode = 0;
    NSDictionary* dataSource = [commsManager getDataSourceWithId:identifier statusCode:&statusCode];
    
    if(dataSource != nil && statusCode == HTTP_OK)
        ready = [[[dataSource objectForKey:@"status"]objectForKey:@"code"]intValue] == FINISHED;
    
    return ready;
}

-(NSOperation*)checkDataSourceIsReadyWithId:(NSString*)identifier
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:1];
    [params setObject:identifier forKey:@"identifier"];
    
    return [self launchOperationWithSelector:@selector(checkDataSourceIsReadyAction:) params:params];
}

-(void)checkDataSourceIsReadyAction:(NSDictionary*)params
{
    BOOL ready = NO;
    
    NSInteger statusCode = 0;
    NSDictionary* dataSource = [commsManager getDataSourceWithId:[params objectForKey:@"identifier"] statusCode:&statusCode];
    
    if(dataSource != nil && statusCode == HTTP_OK)
        ready = [[[dataSource objectForKey:@"status"]objectForKey:@"code"]intValue] == FINISHED;
    
    [delegate dataSourceIsReady:ready];
}

//*******************************************************************************
//*************************** DATASETS  *****************************************
//************* https://bigml.com/developers/datasets ***************************
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
    [params setObject:sourceId forKey:@"sourceId"];
    [params setObject:name forKey:@"name"];
    
    return [self launchOperationWithSelector:@selector(createDataSetAction:) params:params];
}

-(void)createDataSetAction:(NSDictionary*)params
{
    NSInteger statusCode = 0;
    NSString* sourceId = [params objectForKey:@"sourceId"];
    NSString* name = [params objectForKey:@"name"];
    
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
    [params setObject:identifier forKey:@"identifier"];
    [params setObject:name forKey:@"name"];
    
    return [self launchOperationWithSelector:@selector(updateDataSetAction:) params:params];
}

-(void)updateDataSetAction:(NSDictionary*)params
{
    NSInteger statusCode = 0;
    NSString* identifier = [params objectForKey:@"identifier"];
    NSString* name = [params objectForKey:@"name"];
    
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
    [params setObject:identifier forKey:@"identifier"];
    
    return [self launchOperationWithSelector:@selector(deleteDataSetAction:) params:params];
}

-(void)deleteDataSetAction:(NSDictionary*)params
{
    NSInteger statusCode = [commsManager deleteDataSetWithId:[params objectForKey:@"identifier"]];
    
    [delegate dataSetDeletedWithStatusCode:statusCode];
}

-(NSDictionary*)getAllDataSetsWithNameSync:(NSString*)name offset:(NSInteger)offset limit:(NSInteger)limit statusCode:(NSInteger*)code
{
    return [commsManager getAllDataSetsWithName:name offset:offset limit:limit statusCode:code];
}

-(NSOperation*)getAllDataSetsWithName:(NSString*)name offset:(NSInteger)offset limit:(NSInteger)limit
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:3];
    [params setObject:name forKey:@"name"];
    [params setObject:[NSNumber numberWithInteger:offset] forKey:@"offset"];
    [params setObject:[NSNumber numberWithInteger:limit] forKey:@"limit"];
    
    return [self launchOperationWithSelector:@selector(getAllDataSetsAction:) params:params];
}

-(void)getAllDataSetsAction:(NSDictionary*)params
{
    NSInteger statusCode = 0;
    NSString* name = [params objectForKey:@"name"];
    NSInteger offset = [[params objectForKey:@"offset"]integerValue];
    NSInteger limit = [[params objectForKey:@"limit"]integerValue];
    
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
    [params setObject:identifier forKey:@"identifier"];
    
    return [self launchOperationWithSelector:@selector(getDataSetAction:) params:params];
}

-(void)getDataSetAction:(NSDictionary*)params
{
    NSInteger statusCode = 0;
    NSDictionary* dataSet = [commsManager getDataSetWithId:[params objectForKey:@"identifier"] statusCode:&statusCode];
    
    [delegate dataSetRetrieved:dataSet statusCode:statusCode];
}

-(BOOL)checkDataSetIsReadyWithIdSync:(NSString*)identifier
{
    BOOL ready = NO;
    
    NSInteger statusCode = 0;
    NSDictionary* dataSet = [commsManager getDataSetWithId:identifier statusCode:&statusCode];
    
    if(dataSet != nil && statusCode == HTTP_OK)
        ready = [[[dataSet objectForKey:@"status"]objectForKey:@"code"]intValue] == FINISHED;
    
    return ready;
}

-(NSOperation*)checkDataSetIsReadyWithId:(NSString*)identifier
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:1];
    [params setObject:identifier forKey:@"identifier"];
    
    return [self launchOperationWithSelector:@selector(checkDataSetIsReadyAction:) params:params];
}

-(void)checkDataSetIsReadyAction:(NSDictionary*)params
{
    BOOL ready = NO;
    
    NSInteger statusCode = 0;
    NSDictionary* dataSet = [commsManager getDataSetWithId:[params objectForKey:@"identifier"] statusCode:&statusCode];
    
    if(dataSet != nil && statusCode == HTTP_OK)
        ready = [[[dataSet objectForKey:@"status"]objectForKey:@"code"]intValue] == FINISHED;
    
    [delegate dataSetIsReady:ready];
}

//*******************************************************************************
//*************************** MODELS  *******************************************
//************* https://bigml.com/developers/models *****************************
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
    [params setObject:dataSetId forKey:@"dataSetId"];
    [params setObject:name forKey:@"name"];
    
    return [self launchOperationWithSelector:@selector(createModelAction:) params:params];
}

-(void)createModelAction:(NSDictionary*)params
{
    NSInteger statusCode = 0;
    NSString* dataSetId = [params objectForKey:@"dataSetId"];
    NSString* name = [params objectForKey:@"name"];
    
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
    [params setObject:identifier forKey:@"identifier"];
    [params setObject:name forKey:@"name"];
    
    return [self launchOperationWithSelector:@selector(updateModelAction:) params:params];
}

-(void)updateModelAction:(NSDictionary*)params
{
    NSInteger statusCode = 0;
    NSString* identifier = [params objectForKey:@"identifier"];
    NSString* name = [params objectForKey:@"name"];
    
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
    [params setObject:identifier forKey:@"identifier"];
    
    return [self launchOperationWithSelector:@selector(deleteModelAction:) params:params];
}

-(void)deleteModelAction:(NSDictionary*)params
{
    NSInteger statusCode = [commsManager deleteModelWithId:[params objectForKey:@"identifier"]];
    
    [delegate modelDeletedWithStatusCode:statusCode];
}

-(NSDictionary*)getAllModelsWithNameSync:(NSString*)name offset:(NSInteger)offset limit:(NSInteger)limit statusCode:(NSInteger*)code
{
    return [commsManager getAllModelsWithName:name offset:offset limit:limit statusCode:code];
}

-(NSOperation*)getAllModelsWithName:(NSString*)name offset:(NSInteger)offset limit:(NSInteger)limit
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:3];
    [params setObject:name forKey:@"name"];
    [params setObject:[NSNumber numberWithInteger:offset] forKey:@"offset"];
    [params setObject:[NSNumber numberWithInteger:limit] forKey:@"limit"];
    
    return [self launchOperationWithSelector:@selector(getAllModelsAction:) params:params];
}

-(void)getAllModelsAction:(NSDictionary*)params
{
    NSInteger statusCode = 0;
    NSString* name = [params objectForKey:@"name"];
    NSInteger offset = [[params objectForKey:@"offset"]integerValue];
    NSInteger limit = [[params objectForKey:@"limit"]integerValue];
    
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
    [params setObject:identifier forKey:@"identifier"];
    
    return [self launchOperationWithSelector:@selector(getModelAction:) params:params];
}

-(void)getModelAction:(NSDictionary*)params
{
    NSInteger statusCode = 0;
    NSDictionary* model = [commsManager getModelWithId:[params objectForKey:@"identifier"] statusCode:&statusCode];
    
    [delegate modelRetrieved:model statusCode:statusCode];
}

-(BOOL)checkModelIsReadyWithIdSync:(NSString*)identifier
{
    BOOL ready = NO;
    
    NSInteger statusCode = 0;
    NSDictionary* model = [commsManager getModelWithId:identifier statusCode:&statusCode];
    
    if(model != nil && statusCode == HTTP_OK)
        ready = [[[model objectForKey:@"status"]objectForKey:@"code"]intValue] == FINISHED;
    
    return ready;
}

-(NSOperation*)checkModelIsReadyWithId:(NSString*)identifier
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:3];
    [params setObject:identifier forKey:@"identifier"];
    
    return [self launchOperationWithSelector:@selector(checkModelIsReadyAction:) params:params];
}

-(void)checkModelIsReadyAction:(NSDictionary*)params
{
    BOOL ready = NO;
    
    NSInteger statusCode = 0;
    NSDictionary* model = [commsManager getModelWithId:[params objectForKey:@"identifier"] statusCode:&statusCode];
    
    if(model != nil && statusCode == HTTP_OK)
        ready = [[[model objectForKey:@"status"]objectForKey:@"code"]intValue] == FINISHED;
    
    [delegate modelIsReady:ready];
}

//*******************************************************************************
//*************************** PREDICTIONS  **************************************
//************* https://bigml.com/developers/predictions ************************
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
    [params setObject:modelId forKey:@"identifier"];
    [params setObject:name forKey:@"name"];
    [params setObject:inputData forKey:@"inputData"];
    
    return [self launchOperationWithSelector:@selector(createPredictionAction:) params:params];
}

-(void)createPredictionAction:(NSDictionary*)params
{
    NSInteger statusCode = 0;
    NSString* identifier = [params objectForKey:@"identifier"];
    NSString* name = [params objectForKey:@"name"];
    NSString* inputData = [params objectForKey:@"inputData"];
    
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
    [params setObject:identifier forKey:@"identifier"];
    [params setObject:name forKey:@"name"];
    
    return [self launchOperationWithSelector:@selector(updatePredictionAction:) params:params];
}

-(void)updatePredictionAction:(NSDictionary*)params
{
    NSInteger statusCode = 0;
    NSString* identifier = [params objectForKey:@"identifier"];
    NSString* name = [params objectForKey:@"name"];
    
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
    [params setObject:identifier forKey:@"identifier"];
    
    return [self launchOperationWithSelector:@selector(deletePredictionAction:) params:params];
}

-(void)deletePredictionAction:(NSDictionary*)params
{
    NSInteger statusCode = [commsManager deletePredictionWithId:[params objectForKey:@"identifier"]];
    
    [delegate predictionDeletedWithStatusCode:statusCode];
}

-(NSDictionary*)getAllPredictionsWithNameSync:(NSString*)name offset:(NSInteger)offset limit:(NSInteger)limit statusCode:(NSInteger*)code
{
    return [commsManager getAllPredictionsWithName:name offset:offset limit:limit statusCode:code];
}

-(NSOperation*)getAllPredictionsWithName:(NSString*)name offset:(NSInteger)offset limit:(NSInteger)limit
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:3];
    [params setObject:name forKey:@"name"];
    [params setObject:[NSNumber numberWithInteger:offset] forKey:@"offset"];
    [params setObject:[NSNumber numberWithInteger:limit] forKey:@"limit"];
    
    return [self launchOperationWithSelector:@selector(getAllPredictionsAction:) params:params];
}

-(void)getAllPredictionsAction:(NSDictionary*)params
{
    NSInteger statusCode = 0;
    NSString* name = [params objectForKey:@"name"];
    NSInteger offset = [[params objectForKey:@"offset"]integerValue];
    NSInteger limit = [[params objectForKey:@"limit"]integerValue];
    
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
    [params setObject:identifier forKey:@"identifier"];
    
    return [self launchOperationWithSelector:@selector(getPredictionAction:) params:params];
}

-(void)getPredictionAction:(NSDictionary*)params
{
    NSInteger statusCode = 0;
    NSDictionary* prediction = [commsManager getPredictionWithId:[params objectForKey:@"identifier"] statusCode:&statusCode];
    
    [delegate predictionRetrieved:prediction statusCode:statusCode];
}

-(BOOL)checkPredictionIsReadyWithIdSync:(NSString*)identifier
{
    BOOL ready = NO;
    
    NSInteger statusCode = 0;
    NSDictionary* prediction = [commsManager getPredictionWithId:identifier statusCode:&statusCode];
    
    if(prediction != nil && statusCode == HTTP_OK)
        ready = [[[prediction objectForKey:@"status"]objectForKey:@"code"]intValue] == FINISHED;
    
    return ready;
}

-(NSOperation*)checkPredictionIsReadyWithId:(NSString*)identifier
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:3];
    [params setObject:identifier forKey:@"identifier"];
    
    return [self launchOperationWithSelector:@selector(checkPredictionIsReadyAction:) params:params];
}

-(void)checkPredictionIsReadyAction:(NSDictionary*)params
{
    BOOL ready = NO;
    
    NSInteger statusCode = 0;
    NSDictionary* prediction = [commsManager getPredictionWithId:[params objectForKey:@"identifier"] statusCode:&statusCode];
    
    if(prediction != nil && statusCode == HTTP_OK)
        ready = [[[prediction objectForKey:@"status"]objectForKey:@"code"]intValue] == FINISHED;
    
    [delegate predictionIsReady:ready];
}

//*******************************************************************************
//*************************** LOCAL PREDICTIONS  ********************************
//*******************************************************************************

#pragma mark -
#pragma mark Local Predictions

-(NSDictionary*)createLocalPredictionWithJSONModelSync:(NSDictionary*)jsonModel arguments:(NSString*)args argsByName:(BOOL)byName
{
    return [LocalPredictiveModel predictWithJSONModel:jsonModel arguments:args argsByName:NO];
}

@end
