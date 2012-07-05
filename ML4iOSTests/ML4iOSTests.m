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
    apiLibrary = [[ML4iOS alloc]initWithUsername:@"YOUR_BIGML_USERNAME" key:@"YOUR_BIGML_API_KEY" developmentMode:NO];
    [apiLibrary setDelegate:self];
}

- (void)tearDown
{
    // Tear-down code here.
    [apiLibrary cancelAllAsynchronousOperations];
    [apiLibrary release];
    
    [super tearDown];
}

- (void)testExample
{
    NSInteger httpStatusCode = 0;
    
    //CREATES A DATA SOURCE FROM A .CSV
    NSString *path = [[NSBundle bundleForClass:[ML4iOSTests class]] pathForResource:@"IBEX" ofType:@"csv"];
    NSDictionary* dataSource = [apiLibrary createDataSourceWithNameSync:@"IBEX_DataSource" filePath:path statusCode:&httpStatusCode];
    
    STAssertEquals(httpStatusCode, HTTP_CREATED, @"Error creating data source from IBEX.csv");
    
    if(dataSource != nil && httpStatusCode == HTTP_CREATED)
    {
        //EXTRACT DATA SOURCE ID AND CREATE DATASET FROM THAT DATA SOURCE
        NSString* sourceId = [ML4iOS getResourceIdentifierFromJSONObject:dataSource];
        
        //WAIT UNTIL DATA SOURCE IS READY
        while (![apiLibrary checkDataSourceIsReadyWithIdSync:sourceId]) {
            sleep(1);
        }
        
        NSLog(@"Data Source IBEX_DataSource Created and Ready");
        
        NSDictionary* dataSet = [apiLibrary createDataSetWithDataSourceIdSync:sourceId name:@"IBEX_DataSet" statusCode:&httpStatusCode];
        
        STAssertEquals(httpStatusCode, HTTP_CREATED, @"Error creating dataset from IBEX_DataSource");
        
        if(dataSet != nil && httpStatusCode == HTTP_CREATED)
        {
            //EXTRACT DATASET ID AND CREATE MODEL FROM THAT DATASET
            NSString* dataSetId = [ML4iOS getResourceIdentifierFromJSONObject:dataSet];
            
            //WAIT UNTIL DATA SOURCE IS READY
            while (![apiLibrary checkDataSetIsReadyWithIdSync:dataSetId]) {
                sleep(1);
            }
            
            NSLog(@"DataSet IBEX_DataSet Created and Ready");
            
            NSDictionary* model = [apiLibrary createModelWithDataSetIdSync:dataSetId name:@"IBEX_Model" statusCode:&httpStatusCode];
            
            STAssertEquals(httpStatusCode, HTTP_CREATED, @"Error creating model from IBEX_DataSet");
            
            if(model != nil && httpStatusCode == HTTP_CREATED)
            {
                //EXTRACT MODEL ID AND CREATE PREDICTION FROM THAT MODEL
                NSString* modelId = [ML4iOS getResourceIdentifierFromJSONObject:model];
                
                //WAIT UNTIL MODEL IS READY
                while (![apiLibrary checkModelIsReadyWithIdSync:modelId]) {
                    sleep(1);
                }
                
                NSLog(@"Model IBEX_Model Created and Ready");
                
                //WE PASS Minimo=9000 and Maximo=10000
                NSString* inputDataForPrediction = @"{\"000004\": 10000, \"000005\": 9000}";
                
                NSDictionary* prediction = [apiLibrary createPredictionWithModelIdSync:modelId name:@"IBEX_Prediction" inputData:inputDataForPrediction statusCode:&httpStatusCode];
                
                STAssertEquals(httpStatusCode, HTTP_CREATED, @"Error creating prediction from IBEX_Model");
                
                if(prediction != nil)
                {
                    //EXTRACT MODEL ID AND CREATE PREDICTION FROM THAT MODEL
                    NSString* predictionId = [ML4iOS getResourceIdentifierFromJSONObject:prediction];
                    
                    //WAIT UNTIL PREDICTION IS READY
                    while (![apiLibrary checkPredictionIsReadyWithIdSync:predictionId]) {
                        sleep(1);
                    }
                    
                    NSLog(@"Prediction IBEX_Prediction Created and Ready");
                }
            }
        }
    }
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