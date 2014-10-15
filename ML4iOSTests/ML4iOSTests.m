/**
 *
 * ML4iOSTests.m
 * ML4iOSTests
 *
 * Created by Felix Garcia Lainez on May 26, 2012
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

#import "ML4iOSTests.h"
#import "ML4iOS.h"
#import "Constants.h"

@implementation ML4iOSTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
    apiLibrary = [[ML4iOS alloc]initWithUsername:@"BIGML_API_USERNAME" key:@"BIGML_API_KEY" developmentMode:NO];
    [apiLibrary setDelegate:self];
}

- (void)tearDown
{
    // Tear-down code here.
    [apiLibrary cancelAllAsynchronousOperations];
    
    [super tearDown];
}

- (void)testExample
{
    NSInteger httpStatusCode = 0;
    
    NSString* modelId = @"";
    NSString* inputDataForPrediction = @"{\"000000\": 3, \"000001\": 2, \"000002\": 1, \"000003\": 1}";
    
    //CREATES A DATA SOURCE FROM A .CSV
    NSString *path = [[NSBundle bundleForClass:[ML4iOSTests class]] pathForResource:@"iris" ofType:@"csv"];
    NSDictionary* dataSource = [apiLibrary createDataSourceWithNameSync:@"iris_datasource" filePath:path statusCode:&httpStatusCode];
    
    XCTAssertEqual(httpStatusCode, HTTP_CREATED, @"Error creating datasource iris_datasource");
    
    if(dataSource != nil && httpStatusCode == HTTP_CREATED)
    {
        //EXTRACT DATA SOURCE ID AND CREATE DATASET FROM THAT DATA SOURCE
        NSString* sourceId = [ML4iOS getResourceIdentifierFromJSONObject:dataSource];
        
        //WAIT UNTIL DATA SOURCE IS READY
        while (![apiLibrary checkDataSourceIsReadyWithIdSync:sourceId]) {
            sleep(1);
        }
        
        NSLog(@"Datasource iris_source created and ready");
        
        NSDictionary* dataSet = [apiLibrary createDataSetWithDataSourceIdSync:sourceId name:@"iris_dataset" statusCode:&httpStatusCode];
        
        XCTAssertEqual(httpStatusCode, HTTP_CREATED, @"Error creating dataset from iris_dataset");
        
        if(dataSet != nil && httpStatusCode == HTTP_CREATED)
        {
            //EXTRACT DATASET ID AND CREATE MODEL FROM THAT DATASET
            NSString* dataSetId = [ML4iOS getResourceIdentifierFromJSONObject:dataSet];
            
            //WAIT UNTIL DATA SET IS READY
            while (![apiLibrary checkDataSetIsReadyWithIdSync:dataSetId]) {
                sleep(3);
            }
            
            NSLog(@"Dataset iris_dataset created and ready");
            
            NSDictionary* model = [apiLibrary createModelWithDataSetIdSync:dataSetId name:@"iris_model" statusCode:&httpStatusCode];
            
            XCTAssertEqual(httpStatusCode, HTTP_CREATED, @"Error creating model iris_model");
            
            if(model != nil && httpStatusCode == HTTP_CREATED)
            {
                //EXTRACT MODEL ID AND CREATE PREDICTION FROM THAT MODEL
                modelId = [ML4iOS getResourceIdentifierFromJSONObject:model];
                
                //WAIT UNTIL MODEL IS READY
                while (![apiLibrary checkModelIsReadyWithIdSync:modelId]) {
                    sleep(3);
                }
                
                NSLog(@"Model iris_model created and ready");
                
                NSDictionary* prediction = [apiLibrary createPredictionWithModelIdSync:modelId name:@"iris_prediction" inputData:inputDataForPrediction statusCode:&httpStatusCode];
                
                XCTAssertEqual(httpStatusCode, HTTP_CREATED, @"Error creating prediction iris_prediction");
                
                if(prediction != nil)
                {
                    NSString* predictionId = [ML4iOS getResourceIdentifierFromJSONObject:prediction];
                    
                    //WAIT UNTIL PREDICTION IS READY
                    while (![apiLibrary checkPredictionIsReadyWithIdSync:predictionId]) {
                        sleep(1);
                    }
                    
                    NSLog(@"Prediction iris_prediction created and ready");
                    
                    //DELETE PREDICTION
                    XCTAssertEqual([apiLibrary deletePredictionWithIdSync:predictionId], HTTP_NO_CONTENT, @"Error deleting prediction iris_prediciton");
                    
                    NSLog(@"Prediction iris_prediciton deleted");
                }
            }
            
            //CREATE CLUSTER FROM DATASET ID
            NSDictionary* cluster = [apiLibrary createClusterWithDataSetIdSync:dataSetId name:@"iris_cluster" numberOfClusters:5 statusCode:&httpStatusCode];
            
            XCTAssertEqual(httpStatusCode, HTTP_CREATED, @"Error creating cluster iris_cluster");
            
            if(cluster != nil && httpStatusCode == HTTP_CREATED)
            {
                NSString* clusterId = [ML4iOS getResourceIdentifierFromJSONObject:cluster];
                
                //WAIT UNTIL CLUSTER IS READY
                while (![apiLibrary checkClusterIsReadyWithIdSync:clusterId]) {
                    sleep(3);
                }
                
                NSLog(@"Cluster iris_cluster created and ready");
                
                //DELETE CLUSTER
                XCTAssertEqual([apiLibrary deleteClusterWithIdSync:clusterId], HTTP_NO_CONTENT, @"Error deleting cluster iris_cluster");
                
                NSLog(@"Cluster iris_cluster deleted");
            }
            
            //DELETE DATASET
            XCTAssertEqual([apiLibrary deleteDataSetWithIdSync:dataSetId], HTTP_NO_CONTENT, @"Error deleting dataset iris_dataset");
        
            NSLog(@"Dataset iris_dataset deleted");
        }
        
        //DELETE DATASOURCE
        XCTAssertEqual([apiLibrary deleteDataSourceWithIdSync:sourceId], HTTP_NO_CONTENT, @"Error deleting datasource iris_datasource");
        
        NSLog(@"Datasource iris_datasource deleted");
    }
    
    if([modelId length] > 0)
    {
        //GET IRIS MODEL AND CREATE LOCAL PREDICTIONS
        NSDictionary* irisModel = [apiLibrary getModelWithIdSync:modelId statusCode:&httpStatusCode];
    
        NSLog(@"Iris Model for Local Prediction Retrieved with id = %@", [ML4iOS getResourceIdentifierFromJSONObject:irisModel]);
        
        NSDictionary* prediction = [apiLibrary createLocalPredictionWithJSONModelSync:irisModel arguments:inputDataForPrediction argsByName:NO];
        
        XCTAssertNotNil([prediction objectForKey:@"value"], @"Local Prediction value can't be nil");
        XCTAssertNotNil([prediction objectForKey:@"confidence"], @"Local Prediction confidence can't be nil");
        
        NSLog(@"Local Prediction Value = %@", [prediction objectForKey:@"value"]);
        NSLog(@"Local Prediction Confidence = %@", [prediction objectForKey:@"confidence"]);
    }
    
    //DELETE MODEL
    XCTAssertEqual([apiLibrary deleteModelWithIdSync:modelId], HTTP_NO_CONTENT, @"Error deleting model from iris_model");
    
    NSLog(@"Model iris_model deleted");
}

#pragma mark -
#pragma mark ML4iOSDelegate

-(void)dataSourceCreated:(NSDictionary*)dataSource statusCode:(NSInteger)code
{
}

-(void)dataSourceUpdated:(NSDictionary*)dataSource statusCode:(NSInteger)code
{
}

-(void)dataSourceDeletedWithStatusCode:(NSInteger)code
{
}

-(void)dataSourcesRetrieved:(NSDictionary*)dataSources statusCode:(NSInteger)code
{
}

-(void)dataSourceRetrieved:(NSDictionary*)dataSource statusCode:(NSInteger)code
{
}

-(void)dataSourceIsReady:(BOOL)ready
{
}

-(void)dataSetCreated:(NSDictionary*)dataSet statusCode:(NSInteger)code
{
}

-(void)dataSetUpdated:(NSDictionary*)dataSet statusCode:(NSInteger)code
{
}

-(void)dataSetDeletedWithStatusCode:(NSInteger)code
{
}

-(void)dataSetsRetrieved:(NSDictionary*)dataSets statusCode:(NSInteger)code
{
}

-(void)dataSetRetrieved:(NSDictionary*)dataSet statusCode:(NSInteger)code
{
}

-(void)dataSetIsReady:(BOOL)ready
{
}

-(void)modelCreated:(NSDictionary*)model statusCode:(NSInteger)code
{
}

-(void)modelUpdated:(NSDictionary*)model statusCode:(NSInteger)code
{
}

-(void)modelDeletedWithStatusCode:(NSInteger)code
{
}

-(void)modelsRetrieved:(NSDictionary*)models statusCode:(NSInteger)code
{
}

-(void)modelRetrieved:(NSDictionary*)model statusCode:(NSInteger)code
{
}

-(void)modelIsReady:(BOOL)ready
{
}

-(void)clusterCreated:(NSDictionary*)cluster statusCode:(NSInteger)code
{
}

-(void)clusterUpdated:(NSDictionary*)cluster statusCode:(NSInteger)code
{
}

-(void)clusterDeletedWithStatusCode:(NSInteger)code
{
}

-(void)clustersRetrieved:(NSDictionary*)clusters statusCode:(NSInteger)code
{
}

-(void)clusterRetrieved:(NSDictionary*)cluster statusCode:(NSInteger)code
{
}

-(void)clusterIsReady:(BOOL)ready
{
}

-(void)predictionCreated:(NSDictionary*)prediction statusCode:(NSInteger)code
{
}

-(void)predictionUpdated:(NSDictionary*)prediction statusCode:(NSInteger)code
{
}

-(void)predictionDeletedWithStatusCode:(NSInteger)code
{
}

-(void)predictionsRetrieved:(NSDictionary*)predictions statusCode:(NSInteger)code
{
}

-(void)predictionRetrieved:(NSDictionary*)prediction statusCode:(NSInteger)code
{
}

-(void)predictionIsReady:(BOOL)ready
{
}

@end