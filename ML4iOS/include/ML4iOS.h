/**
 *
 * ML4iOS.h
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

#import <Foundation/Foundation.h>
#import "ML4iOSDelegate.h"

@class HTTPCommsManager;

/**
 * Main class of the library that implements methods that access BigML.io API.
 * This class implements two kind of public methods: Synchronous and Asynchronous.
 * Synchronous methods names ends with the string 'Sync', blocking the caller thread until the request is completed.
 * Asynchronous methods launch the request without blocking the caller thread, returning the response via the ML4iOSDelegate.
 * Note that all NSDictionary objects returned in sync methods contain the data of sources, datasets, models or predictions in JSON format.
 */
@interface ML4iOS : NSObject
{
    /**
     * Async operations queue
     */
    NSOperationQueue* operationQueue;
    
    /**
     * Handles HTTP requests and JSON parsing
     */
    HTTPCommsManager* commsManager;
    
    /**
     * Delegate used for asynchronous responses
     */
    id<ML4iOSDelegate> delegate;
}

#pragma mark -

/**
 * Property used to set the delegate for asynchronous responses
 */
@property(nonatomic, assign) id<ML4iOSDelegate> delegate;

#pragma mark -

/**
 * Initializes the library with the BigML username and API key 
 * @param username The BigML username
 * @param key The BigML.io API key
 * @param devMode true if we want to use the library on development mode, else false
 * @return The created BigMLAPILibrary object
 */
-(ML4iOS*)initWithUsername:(NSString*)username key:(NSString*)key developmentMode:(BOOL)devMode;

/**
 * Cancel all asynchronous operations in the queue
 */
-(void)cancelAllAsynchronousOperations;

/**
 * Extract the identifier from resource strings like source/IDENTIFIER, model/IDENTIFIER, etc
 */
+(NSString*) getResourceIdentifierFromJSONObject:(NSDictionary*)resouce;

//*******************************************************************************
//*************************** SOURCES  ******************************************
//************* https://bigml.com/developers/sources ****************************
//*******************************************************************************

#pragma mark -
#pragma mark DataSources

/**
 * Creates a data source from a given .csv file.
 * @param name This optional parameter provides the name of the data source to be created
 * @param filePath The full path of the csv in the filesystem
 * @param code The HTTP status code returned
 * @return The data source created if success, else nil
 */
-(NSDictionary*)createDataSourceWithNameSync:(NSString*)name filePath:(NSString*)filePath statusCode:(NSInteger*)code;

/**
 * Creates a data source from a given .csv file. The response is provided in the method dataSourceCreated of the delegate.
 * @param name This optional parameter provides the name of the data source to be created. If it is nil then the data source
 * will be named using the .csv file name.
 * @param filePath The full path of the csv in the filesystem
 * @return The async NSOperation created
 */
-(NSOperation*)createDataSourceWithName:(NSString*)name filePath:(NSString*)filePath;

/**
 * Updates the name of a given data source. 
 * @param identifier The identifier of the data source to update 
 * @param name The new name of the data source
 * @param code The HTTP status code returned
 * @return The data source updated if success, else nil
 */
-(NSDictionary*)updateDataSourceNameWithIdSync:(NSString*)identifier name:(NSString*)name statusCode:(NSInteger*)code;

/**
 * Updates the name of a given data source. The response is provided in the method dataSourceUpdated of the delegate.
 * @param identifier The identifier of the data source to update 
 * @param name The new name of the data source
 * @return The async NSOperation created
 */
-(NSOperation*)updateDataSourceNameWithId:(NSString*)identifier name:(NSString*)name;

/**
 * Deletes a given data source. 
 * @param identifier The identifier of the data source to delete 
 * @return The HTTP status code returned
 */
-(NSInteger)deleteDataSourceWithIdSync:(NSString*)identifier;

/**
 * Deletes a given data source. The response is provided in the method dataSourceDeletedWithStatusCode of the delegate.
 * @param identifier The identifier of the data source to delete 
 * @return The async NSOperation created
 */
-(NSOperation*)deleteDataSourceWithId:(NSString*)identifier;

/**
 * Get a list of data sources filtered by name.
 * @param name This optional parameter provides the name of the data sources to be returned. If it is nil then will be 
 * retrieved all data sources without any filtering
 * @param offset The offset to paginate the results
 * @param limit The maximum number of results
 * @param code The HTTP status code returned
 * @return The list of data sources found if success, else nil
 */
-(NSDictionary*)getAllDataSourcesWithNameSync:(NSString*)name offset:(NSInteger)offset limit:(NSInteger)limit statusCode:(NSInteger*)code;

/**
 * Get a list of data sources filtered by name. The response is provided in the method dataSourcesRetrieved of the delegate.
 * @param name This optional parameter provides the name of the data sources to be retrieved. If it is nil then will be 
 * retrieved all data sources without any filtering
 * @param offset The offset to paginate the results
 * @param limit The maximum number of results
 * @return The async NSOperation created
 */
-(NSOperation*)getAllDataSourcesWithName:(NSString*)name offset:(NSInteger)offset limit:(NSInteger)limit;

/**
 * Get a data source.
 * @param identifier The identifier of the data source to get 
 * @param code The HTTP status code returned
 * @return The data source if success, else nil
 */
-(NSDictionary*)getDataSourceWithIdSync:(NSString*)identifier statusCode:(NSInteger*)code;

/**
 * Get a data source. The response is provided in the method dataSourceRetrieved of the delegate.
 * @param identifier The identifier of the data source to get 
 * @return The async NSOperation created
 */
-(NSOperation*)getDataSourceWithId:(NSString*)identifier;

/**
 * Check if the status of the data source is FINISHED.
 * @param identifier The identifier of the data source to check the status 
 * @return true if the status of the data source is FINISHED, else false
 */
-(BOOL)checkDataSourceIsReadyWithIdSync:(NSString*)identifier;

/**
 * Check if the status of the data source is FINISHED. The response is provided in the method dataSourceIsReady of the delegate.
 * @param identifier The identifier of the data source to check the status
 * @return The async NSOperation created
 */
-(NSOperation*)checkDataSourceIsReadyWithId:(NSString*)identifier;

//*******************************************************************************
//*************************** DATASETS  *****************************************
//************* https://bigml.com/developers/datasets ***************************
//*******************************************************************************

#pragma mark -
#pragma mark Datasets

/**
 * Creates a dataset from a given data source.
 * @param sourceId The identifier of the data source
 * @param name This optional parameter provides the name of the dataset to be created
 * @param code The HTTP status code returned
 * @return The dataset created if success, else nil
 */
-(NSDictionary*)createDataSetWithDataSourceIdSync:(NSString*)sourceId name:(NSString*)name statusCode:(NSInteger*)code;

/**
 * Creates a dataset from a given data source. The response is provided in the method dataSetCreated of the delegate.
 * @param sourceId The identifier of the data source
 * @param name This optional parameter provides the name of the dataset to be created
 * @return The async NSOperation created
 */
-(NSOperation*)createDataSetWithDataSourceId:(NSString*)sourceId name:(NSString*)name;

/**
 * Updates the name of a given dataset. 
 * @param identifier The identifier of the dataset to update 
 * @param name The new name of the dataset
 * @param code The HTTP status code returned
 * @return The dataset updated if success, else nil
 */
-(NSDictionary*)updateDataSetNameWithIdSync:(NSString*)identifier name:(NSString*)name statusCode:(NSInteger*)code;

/**
 * Updates the name of a given dataset. The response is provided in the method dataSetUpdated of the delegate.
 * @param identifier The identifier of the dataset to update 
 * @param name The new name of the dataset
 * @return The async NSOperation created
 */
-(NSOperation*)updateDataSetNameWithId:(NSString*)identifier name:(NSString*)name;

/**
 * Deletes a given dataset. 
 * @param identifier The identifier of the dataset to delete 
 * @return The HTTP status code returned
 */
-(NSInteger)deleteDataSetWithIdSync:(NSString*)identifier;

/**
 * Deletes a given dataset. The response is provided in the method dataSetDeletedWithStatusCode of the delegate.
 * @param identifier The identifier of the dataset to delete
 * @return The async NSOperation created
 */
-(NSOperation*)deleteDataSetWithId:(NSString*)identifier;

/**
 * Get a list of datasets filtered by name.
 * @param name This optional parameter provides the name of the datasets to be retrieved. If it is nil then will be 
 * retrieved all datasets without any filtering
 * @param offset The offset to paginate the results
 * @param limit The maximum number of results
 * @param code The HTTP status code returned
 * @return The list of datasets found if success, else nil
 */
-(NSDictionary*)getAllDataSetsWithNameSync:(NSString*)name offset:(NSInteger)offset limit:(NSInteger)limit statusCode:(NSInteger*)code;

/**
 * Get a list of datasets filtered by name. The response is provided in the method dataSetsRetrieved of the delegate.
 * @param name This optional parameter provides the name of the datasets to be retrieved. If it is nil then will be 
 * retrieved all datasets without any filtering
 * @param offset The offset to paginate the results
 * @param limit The maximum number of results
 * @return The async NSOperation created
 */
-(NSOperation*)getAllDataSetsWithName:(NSString*)name offset:(NSInteger)offset limit:(NSInteger)limit;

/**
 * Get a dataset.
 * @param identifier The identifier of the dataset to get 
 * @param code The HTTP status code returned
 * @return The dataset if success, else nil
 */
-(NSDictionary*)getDataSetWithIdSync:(NSString*)identifier statusCode:(NSInteger*)code;

/**
 * Get a dataset. The response is provided in the method dataSetRetrieved of the delegate.
 * @param identifier The identifier of the dataset to get 
 * @return The async NSOperation created
 */
-(NSOperation*)getDataSetWithId:(NSString*)identifier;

/**
 * Check if the status of the dataset is FINISHED.
 * @param identifier The identifier of the dataset to check the status 
 * @return true if the status of the dataset is FINISHED, else false
 */
-(BOOL)checkDataSetIsReadyWithIdSync:(NSString*)identifier;

/**
 * Check if the status of the dataset is FINISHED. The response is provided in the method dataSetIsReady of the delegate.
 * @param identifier The identifier of the dataset to check the status
 * @return The async NSOperation created
 */
-(NSOperation*)checkDataSetIsReadyWithId:(NSString*)identifier;

//*******************************************************************************
//*************************** MODELS  *******************************************
//************* https://bigml.com/developers/models *****************************
//*******************************************************************************

#pragma mark -
#pragma mark Models

/**
 * Creates a model from a given dataset.
 * @param dataSetId The identifier of the dataset
 * @param name This optional parameter provides the name of the model to be created
 * @param code The HTTP status code returned
 * @return The model created if success, else nil
 */
-(NSDictionary*)createModelWithDataSetIdSync:(NSString*)dataSetId name:(NSString*)name statusCode:(NSInteger*)code;

/**
 * Creates a model from a given dataset. The response is provided in the method modelCreated of the delegate.
 * @param dataSetId The identifier of the dataset
 * @param name This optional parameter provides the name of the model to be created
 * @return The async NSOperation created
 */
-(NSOperation*)createModelWithDataSetId:(NSString*)dataSetId name:(NSString*)name;

/**
 * Updates the name of a given model. 
 * @param identifier The identifier of the model to update 
 * @param name The new name of the model
 * @param code The HTTP status code returned
 * @return The model updated if success, else nil
 */
-(NSDictionary*)updateModelNameWithIdSync:(NSString*)identifier name:(NSString*)name statusCode:(NSInteger*)code;

/**
 * Updates the name of a given model. The response is provided in the method modelUpdated of the delegate.
 * @param identifier The identifier of the model to update 
 * @param name The new name of the model
 * @return The async NSOperation created
 */
-(NSOperation*)updateModelNameWithId:(NSString*)identifier name:(NSString*)name;

/**
 * Deletes a given model. 
 * @param identifier The identifier of the model to delete 
 * @return The HTTP status code returned
 */
-(NSInteger)deleteModelWithIdSync:(NSString*)identifier;

/**
 * Deletes a given model. The response is provided in the method modelDeletedWithStatusCode of the delegate.
 * @param identifier The identifier of the dataset to delete
 * @return The async NSOperation created
 */
-(NSOperation*)deleteModelWithId:(NSString*)identifier;

/**
 * Get a list of models filtered by name.
 * @param name This optional parameter provides the name of the models to be retrieved. If it is nil then will be 
 * retrieved all models without any filtering
 * @param offset The offset to paginate the results
 * @param limit The maximum number of results
 * @param code The HTTP status code returned
 * @return The list of models found if success, else nil
 */
-(NSDictionary*)getAllModelsWithNameSync:(NSString*)name offset:(NSInteger)offset limit:(NSInteger)limit statusCode:(NSInteger*)code;

/**
 * Get a list of models filtered by name. The response is provided in the method modelsRetrieved of the delegate.
 * @param name This optional parameter provides the name of the models to be retrieved. If it is nil then will be 
 * retrieved all models without any filtering
 * @param offset The offset to paginate the results
 * @param limit The maximum number of results
 * @return The async NSOperation created
 */
-(NSOperation*)getAllModelsWithName:(NSString*)name offset:(NSInteger)offset limit:(NSInteger)limit;

/**
 * Get a model.
 * @param identifier The identifier of the model to get 
 * @param code The HTTP status code returned
 * @return The model if success, else nil
 */
-(NSDictionary*)getModelWithIdSync:(NSString*)identifier statusCode:(NSInteger*)code;

/**
 * Get a model. The response is provided in the method modelRetrieved of the delegate.
 * @param identifier The identifier of the model to get 
 * @return The async NSOperation created
 */
-(NSOperation*)getModelWithId:(NSString*)identifier;

/**
 * Check if the status of the model is FINISHED.
 * @param identifier The identifier of the model to check the status 
 * @return true if the status of the model is FINISHED, else false
 */
-(BOOL)checkModelIsReadyWithIdSync:(NSString*)identifier;

/**
 * Check if the status of the model is FINISHED. The response is provided in the method modelIsReady of the delegate.
 * @param identifier The identifier of the model to check the status
 * @return The async NSOperation created
 */
-(NSOperation*)checkModelIsReadyWithId:(NSString*)identifier;

//*******************************************************************************
//*************************** PREDICTIONS  **************************************
//************* https://bigml.com/developers/predictions ************************
//*******************************************************************************

#pragma mark -
#pragma mark Predictions

/**
 * Creates a prediction from a given model.
 * @param modelId The identifier of the model
 * @param name This optional parameter provides the name of the prediction to be created
 * @param inputData This optional parameter must be a JSON object that contents the pairs field_id : field_value (For instance @"{\"000001\": 1, \"000002\": 3}").
 * It initializes the values of the given fields before creating the prediction.
 * @param code The HTTP status code returned
 * @return The model created if success, else nil
 */
-(NSDictionary*)createPredictionWithModelIdSync:(NSString*)modelId name:(NSString*)name inputData:(NSString*)inputData statusCode:(NSInteger*)code;

/**
 * Creates a prediction from a given model. The response is provided in the method predictionCreated of the delegate.
 * @param dataSetId The identifier of the dataset
 * @param name This optional parameter provides the name of the prediction to be created
 * @param inputData This optional parameter must be a JSON object that contents the pairs field_id : field_value (For instance @"{\"000001\": 1, \"000002\": 3}").
 * It initializes the values of the given fields before creating the prediction.
 * @return The async NSOperation created
 */
-(NSOperation*)createPredictionWithModelId:(NSString*)modelId name:(NSString*)name inputData:(NSString*)inputData;

/**
 * Updates the name of a given prediction. 
 * @param identifier The identifier of the prediction to update 
 * @param name The new name of the prediction
 * @param code The HTTP status code returned
 * @return The model updated if success, else nil
 */
-(NSDictionary*)updatePredictionWithIdSync:(NSString*)identifier name:(NSString*)name statusCode:(NSInteger*)code;

/**
 * Updates the name of a given prediction. The response is provided in the method predictionUpdated of the delegate.
 * @param identifier The identifier of the prediction to update 
 * @param name The new name of the prediction
 * @return The async NSOperation created
 */
-(NSOperation*)updatePredictionWithId:(NSString*)identifier name:(NSString*)name;

/**
 * Deletes a given prediction. 
 * @param identifier The identifier of the prediction to delete 
 * @return The HTTP status code returned
 */
-(NSInteger)deletePredictionWithIdSync:(NSString*)identifier;

/**
 * Deletes a given prediction. The response is provided in the method predictionDeletedWithStatusCode of the delegate.
 * @param identifier The identifier of the prediction to delete
 * @return The async NSOperation created
 */
-(NSOperation*)deletePredictionWithId:(NSString*)identifier;

/**
 * Get a list of predictions filtered by name.
 * @param name This optional parameter provides the name of the predictions to be retrieved. If it is nil then will be 
 * retrieved all predictions without any filtering
 * @param offset The offset to paginate the results
 * @param limit The maximum number of results
 * @param code The HTTP status code returned
 * @return The list of predictions found if success, else nil
 */
-(NSDictionary*)getAllPredictionsWithNameSync:(NSString*)name offset:(NSInteger)offset limit:(NSInteger)limit statusCode:(NSInteger*)code;

/**
 * Get a list of predictions filtered by name. The response is provided in the method predictionsRetrieved of the delegate.
 * @param name This optional parameter provides the name of the models to be retrieved. If it is nil then will be 
 * retrieved all predictions without any filtering
 * @param offset The offset to paginate the results
 * @param limit The maximum number of results
 * @return The async NSOperation created
 */
-(NSOperation*)getAllPredictionsWithName:(NSString*)name offset:(NSInteger)offset limit:(NSInteger)limit;

/**
 * Get a prediction.
 * @param identifier The identifier of the prediction to get 
 * @param code The HTTP status code returned
 * @return The prediction if success, else nil
 */
-(NSDictionary*)getPredictionWithIdSync:(NSString*)identifier statusCode:(NSInteger*)code;

/**
 * Get a model. The response is provided in the method predictionRetrieved of the delegate.
 * @param identifier The identifier of the prediction to get 
 * @return The async NSOperation created
 */
-(NSOperation*)getPredictionWithId:(NSString*)identifier;

/**
 * Check if the status of a given prediction is FINISHED.
 * @param identifier The identifier of the prediction to check the status 
 * @return true if the status of the prediction is FINISHED, else false
 */
-(BOOL)checkPredictionIsReadyWithIdSync:(NSString*)identifier;

/**
 * Check if the status of a given prediction is FINISHED. The response is provided in the method predictionIsReady of the delegate.
 * @param identifier The identifier of the prediction to check the status
 * @return The async NSOperation created
 */
-(NSOperation*)checkPredictionIsReadyWithId:(NSString*)identifier;

@end