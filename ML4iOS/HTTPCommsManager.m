/**
 *
 * HTTPCommsManager.m
 * ML4iOS
 *
 * Created by Felix Garcia Lainez on April 22, 2012
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

#import "HTTPCommsManager.h"
#import "Constants.h"

#pragma mark URL Definitions

//BigML API URLs
#define BIGML_IO_DATASOURCE_URL [NSString stringWithFormat:@"%@/source", apiBaseURL]
#define BIGML_IO_DATASET_URL [NSString stringWithFormat:@"%@/dataset", apiBaseURL]
#define BIGML_IO_MODEL_URL [NSString stringWithFormat:@"%@/model", apiBaseURL]
#define BIGML_IO_PREDICTION_URL [NSString stringWithFormat:@"%@/prediction", apiBaseURL]

#pragma mark -

/**
 * Interface that contains private methods
 */
@interface HTTPCommsManager()

#pragma mark -
#pragma mark Generic Methods

/**
 * Makes a HTTP POST request to create a generic item
 * @param url The endpoint url
 * @param body The HTTP body in JSON format
 * @param code The HTTP status code returned
 * @return The created item if success, else nil
 */
-(NSDictionary*)createItemWithURL:(NSString*)url body:(NSString*)body statusCode:(NSInteger*)code;

/**
 * Makes a HTTP PUT request to update a generic item
 * @param url The endpoint url
 * @param body The HTTP body in JSON format
 * @param code The HTTP status code returned
 * @return The updated item if success, else nil
 */
-(NSDictionary*)updateItemWithURL:(NSString*)url body:(NSString*)body statusCode:(NSInteger*)code;

/**
 * Makes a HTTP DELETE request to delete a generic item
 * @param url The endpoint url
 * @return The HTTP status code returned
 */
-(NSInteger)deleteItemWithURL:(NSString*)url;

/**
 * Makes a HTTP GET request to retrieve a generic item
 * @param url The endpoint url
 * @param code The HTTP status code returned
 * @return The item retrieved if success, else nil
 */
-(NSDictionary*)getItemWithURL:(NSString*)url statusCode:(NSInteger*)code;

/**
 * Makes a HTTP GET request to retrieve a list of generic items
 * @param url The endpoint url
 * @param code The HTTP status code returned
 * @return The list of items retrieved if success, else nil
 */
-(NSDictionary*)listItemsWithURL:(NSString*)url statusCode:(NSInteger*)code;

@end

#pragma mark -

@implementation HTTPCommsManager

//*******************************************************************************
//**************************  PRIVATE METHODS  **********************************
//*******************************************************************************

#pragma mark -
#pragma mark Generic Methods

-(NSDictionary*)createItemWithURL:(NSString*)url body:(NSString*)body statusCode:(NSInteger*)code
{
    NSDictionary* item = nil;
    
    NSError *error = nil;
    NSHTTPURLResponse *response = nil;
    
    NSMutableURLRequest* request= [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSData* responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    *code = [response statusCode];
    
    if(*code == HTTP_CREATED && responseData != nil)
        item = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
    
    return item;
}

-(NSDictionary*)updateItemWithURL:(NSString*)url body:(NSString*)body statusCode:(NSInteger*)code
{
    NSDictionary* item = nil;
    
    NSError *error = nil;
    NSHTTPURLResponse *response = nil;
    
    NSMutableURLRequest* request= [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"PUT"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSData* responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    *code = [response statusCode];
    
    if(*code == HTTP_ACCEPTED && responseData != nil)
        item = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
    
    return item;
}

-(NSInteger)deleteItemWithURL:(NSString*)url
{
    NSError *error = nil;
    NSHTTPURLResponse *response = nil;
    
    NSMutableURLRequest* request= [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"DELETE"];
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    return [response statusCode];
}

-(NSDictionary*)getItemWithURL:(NSString*)url statusCode:(NSInteger*)code
{
    NSDictionary* item = nil;
    
    NSError *error = nil;
    NSHTTPURLResponse *response = nil;
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    NSData* responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    *code = [response statusCode];
    
    if(*code == HTTP_OK && responseData != nil)
        item = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
    
    return item;
}

-(NSDictionary*)listItemsWithURL:(NSString*)url statusCode:(NSInteger*)code
{
    NSDictionary* items = nil;
    
    NSError *error = nil;
    NSHTTPURLResponse *response = nil;
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    NSData* responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    *code = [response statusCode];
    
    if(*code == HTTP_OK && responseData != nil)
        items = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
    
    return items;
}

//*******************************************************************************
//**************************  INITIALIZERS  *************************************
//*******************************************************************************

#pragma mark -

-(HTTPCommsManager*)initWithUsername:(NSString*)username key:(NSString*)key developmentMode:(BOOL)devMode
{
    if([username length] > 0 && [key length] > 0)
    {
        self = [super init];
        
        if(self) {
            apiUsername = [[NSString alloc]initWithString:username];
            apiKey = [[NSString alloc]initWithString:key];
            developmentMode = devMode;
            
            if(developmentMode)
                apiBaseURL = [[NSString stringWithString:@"https://bigml.io/dev/andromeda"]retain];
            else
                apiBaseURL = [[NSString stringWithString:@"https://bigml.io/andromeda"]retain];
                
            authToken = [[NSString alloc]initWithFormat:@"?username=%@;api_key=%@;", apiUsername, apiKey];
        }
    }
    
    return self;
}

-(void)dealloc
{
    [apiKey release];
    [apiUsername release];
    [authToken release];
    [apiBaseURL release];
    [super dealloc];
}

//*******************************************************************************
//**************************  DATA SOURCES  *************************************
//*******************************************************************************

#pragma mark -
#pragma mark DataSources

-(NSDictionary*)createDataSourceWithName:(NSString*)name filePath:(NSString*)filePath statusCode:(NSInteger*)code
{
    NSDictionary* createdDataSource = nil;
    
    NSMutableString* urlString = [NSMutableString stringWithCapacity:30];
    [urlString appendFormat:@"%@%@", BIGML_IO_DATASOURCE_URL, authToken];
    
    NSMutableURLRequest* request= [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    NSMutableData *postbody = [NSMutableData data];
    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@\"\r\n", name] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[NSData dataWithContentsOfFile:filePath]];
    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postbody];
    
    NSError *error = nil;
    NSHTTPURLResponse *response = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    *code = [response statusCode];
    
    if((*code == HTTP_CREATED) && responseData != nil)
        createdDataSource = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
    
    return createdDataSource;
}

-(NSDictionary*)updateDataSourceNameWithId:(NSString*)identifier name:(NSString*)name statusCode:(NSInteger*)code
{
    NSString* urlString = [NSString stringWithFormat:@"%@/%@%@", BIGML_IO_DATASOURCE_URL, identifier, authToken];
    
    NSMutableString* bodyString = [NSMutableString stringWithCapacity:30];
    [bodyString appendFormat:@"{\"name\":\"%@\"}", name];
    
    return [self updateItemWithURL:urlString body:bodyString statusCode:code];
}

-(NSInteger)deleteDataSourceWithId:(NSString*)identifier
{
    NSString* urlString = [NSString stringWithFormat:@"%@/%@%@", BIGML_IO_DATASOURCE_URL, identifier, authToken];
    
    return [self deleteItemWithURL:urlString];
}

-(NSDictionary*)getAllDataSourcesWithName:(NSString*)name offset:(NSInteger)offset limit:(NSInteger)limit statusCode:(NSInteger*)code
{
    NSMutableString* urlString = [NSMutableString stringWithCapacity:30];
    [urlString appendFormat:@"%@%@", BIGML_IO_DATASOURCE_URL, authToken];
    
    if([name length] > 0)
        [urlString appendFormat:@"name=%@;", name];
     
    if(offset > 0)
        [urlString appendFormat:@"offset=%d;", offset];
    
    if(limit > 0)
        [urlString appendFormat:@"limit=%d;", limit];
    
    return [self listItemsWithURL:urlString statusCode:code];
}

-(NSDictionary*)getDataSourceWithId:(NSString*)identifier statusCode:(NSInteger*)code
{
    NSString* urlString = [NSString stringWithFormat:@"%@/%@%@", BIGML_IO_DATASOURCE_URL, identifier, authToken];
    
    return [self getItemWithURL:urlString statusCode:code];
}

//*******************************************************************************
//**************************  DATASETS  *****************************************
//*******************************************************************************

#pragma mark -
#pragma mark DataSets

-(NSDictionary*)createDataSetWithDataSourceId:(NSString*)sourceId name:(NSString*)name statusCode:(NSInteger*)code
{
    NSString* urlString = [NSString stringWithFormat:@"%@%@", BIGML_IO_DATASET_URL, authToken];
    
    NSMutableString* bodyString = [NSMutableString stringWithCapacity:30];
    [bodyString appendFormat:@"{\"source\":\"source/%@\"", sourceId];
    
    if([name length] > 0)
        [bodyString appendFormat:@", \"name\":\"%@\"}", name];
    else
        [bodyString appendString:@"}"];
    
    return [self createItemWithURL:urlString body:bodyString statusCode:code];
    
}

-(NSDictionary*)updateDataSetNameWithId:(NSString*)identifier name:(NSString*)name statusCode:(NSInteger*)code
{
    NSString* urlString = [NSString stringWithFormat:@"%@/%@%@", BIGML_IO_DATASET_URL, identifier, authToken];
    
    NSMutableString* bodyString = [NSMutableString stringWithCapacity:30];
    [bodyString appendFormat:@"{\"name\":\"%@\"}", name];
    
    return [self updateItemWithURL:urlString body:bodyString statusCode:code];
}

-(NSInteger)deleteDataSetWithId:(NSString*)identifier
{
    NSString* urlString = [NSString stringWithFormat:@"%@/%@%@", BIGML_IO_DATASET_URL, identifier, authToken];
    
    return [self deleteItemWithURL:urlString];
}

-(NSDictionary*)getAllDataSetsWithName:(NSString*)name offset:(NSInteger)offset limit:(NSInteger)limit statusCode:(NSInteger*)code
{
    NSMutableString* urlString = [NSMutableString stringWithCapacity:30];
    [urlString appendFormat:@"%@%@", BIGML_IO_DATASET_URL, authToken];
    
    if([name length] > 0)
        [urlString appendFormat:@"name=%@;", name];
    
    if(offset > 0)
        [urlString appendFormat:@"offset=%d;", offset];
    
    if(limit > 0)
        [urlString appendFormat:@"limit=%d;", limit];
    
    return [self listItemsWithURL:urlString statusCode:code];
}

-(NSDictionary*)getDataSetWithId:(NSString*)identifier statusCode:(NSInteger*)code
{
    NSString* urlString = [NSString stringWithFormat:@"%@/%@%@", BIGML_IO_DATASET_URL, identifier, authToken];
    
    return [self getItemWithURL:urlString statusCode:code];
}

//*******************************************************************************
//**************************  MODELS  *******************************************
//*******************************************************************************

#pragma mark -
#pragma mark Models

-(NSDictionary*)createModelWithDataSetId:(NSString*)sourceId name:(NSString*)name statusCode:(NSInteger*)code
{
    NSString* urlString = [NSString stringWithFormat:@"%@%@", BIGML_IO_MODEL_URL, authToken];
    
    NSMutableString* bodyString = [NSMutableString stringWithCapacity:30];
    [bodyString appendFormat:@"{\"dataset\":\"dataset/%@\"", sourceId];
    
    if([name length] > 0)
        [bodyString appendFormat:@", \"name\":\"%@\"}", name];
    else
        [bodyString appendString:@"}"];
    
    return [self createItemWithURL:urlString body:bodyString statusCode:code];
    
}

-(NSDictionary*)updateModelNameWithId:(NSString*)identifier name:(NSString*)name statusCode:(NSInteger*)code
{
    NSString* urlString = [NSString stringWithFormat:@"%@/%@%@", BIGML_IO_MODEL_URL, identifier, authToken];
    
    NSMutableString* bodyString = [NSMutableString stringWithCapacity:30];
    [bodyString appendFormat:@"{\"name\":\"%@\"}", name];
    
    return [self updateItemWithURL:urlString body:bodyString statusCode:code];
}

-(NSInteger)deleteModelWithId:(NSString*)identifier
{
    NSString* urlString = [NSString stringWithFormat:@"%@/%@%@", BIGML_IO_MODEL_URL, identifier, authToken];
    
    return [self deleteItemWithURL:urlString];
}

-(NSDictionary*)getAllModelsWithName:(NSString*)name offset:(NSInteger)offset limit:(NSInteger)limit statusCode:(NSInteger*)code
{
    NSMutableString* urlString = [NSMutableString stringWithCapacity:30];
    [urlString appendFormat:@"%@%@", BIGML_IO_MODEL_URL, authToken];
    
    if([name length] > 0)
        [urlString appendFormat:@"name=%@;", name];
    
    if(offset > 0)
        [urlString appendFormat:@"offset=%d;", offset];
    
    if(limit > 0)
        [urlString appendFormat:@"limit=%d;", limit];
    
    return [self listItemsWithURL:urlString statusCode:code];
}

-(NSDictionary*)getModelWithId:(NSString*)identifier statusCode:(NSInteger*)code
{
    NSString* urlString = [NSString stringWithFormat:@"%@/%@%@", BIGML_IO_MODEL_URL, identifier, authToken];
    
    return [self getItemWithURL:urlString statusCode:code];
}

//*******************************************************************************
//**************************  PREDICTIONS  **************************************
//*******************************************************************************

#pragma mark -
#pragma mark Predictions

-(NSDictionary*)createPredictionWithModelId:(NSString*)modelId name:(NSString*)name inputData:(NSString*)inputData statusCode:(NSInteger*)code
{
    NSString* urlString = [NSString stringWithFormat:@"%@%@", BIGML_IO_PREDICTION_URL, authToken];
    
    NSMutableString* bodyString = [NSMutableString stringWithCapacity:30];
    [bodyString appendFormat:@"{\"model\":\"model/%@\"", modelId];
    
    if([name length] > 0)
        [bodyString appendFormat:@", \"name\":\"%@\"", name];
    
    if([inputData length] > 0)
        [bodyString appendFormat:@", \"input_data\":%@", inputData];
    else
        [bodyString appendFormat:@", \"input_data\":{}"];
        
    [bodyString appendString:@"}"];
    
    return [self createItemWithURL:urlString body:bodyString statusCode:code];
}

-(NSDictionary*)updatePredictionWithId:(NSString*)identifier name:(NSString*)name statusCode:(NSInteger*)code
{
    NSString* urlString = [NSString stringWithFormat:@"%@/%@%@", BIGML_IO_PREDICTION_URL, identifier, authToken];
    
    NSMutableString* bodyString = [NSMutableString stringWithCapacity:30];
    
    if([name length] > 0)
        [bodyString appendFormat:@"{\"name\":\"%@\"}", name];
    
    return [self updateItemWithURL:urlString body:bodyString statusCode:code];
}

-(NSInteger)deletePredictionWithId:(NSString*)identifier
{
    NSString* urlString = [NSString stringWithFormat:@"%@/%@%@", BIGML_IO_PREDICTION_URL, identifier, authToken];
    
    return [self deleteItemWithURL:urlString];
}

-(NSDictionary*)getAllPredictionsWithName:(NSString*)name offset:(NSInteger)offset limit:(NSInteger)limit statusCode:(NSInteger*)code
{
    NSMutableString* urlString = [NSMutableString stringWithCapacity:30];
    [urlString appendFormat:@"%@%@", BIGML_IO_PREDICTION_URL, authToken];
    
    if([name length] > 0)
        [urlString appendFormat:@"name=%@;", name];
    
    if(offset > 0)
        [urlString appendFormat:@"offset=%d;", offset];
    
    if(limit > 0)
        [urlString appendFormat:@"limit=%d;", limit];
    
    return [self listItemsWithURL:urlString statusCode:code];
}

-(NSDictionary*)getPredictionWithId:(NSString*)identifier statusCode:(NSInteger*)code
{
    NSString* urlString = [NSString stringWithFormat:@"%@/%@%@", BIGML_IO_PREDICTION_URL, identifier, authToken];
    
    return [self getItemWithURL:urlString statusCode:code];
}

@end