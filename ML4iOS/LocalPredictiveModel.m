/**
 *
 * LocalPredictiveModel.m
 * ML4iOS
 *
 * Created by Felix Garcia Lainez on April 21, 2013
 * Copyright 2013 Felix Garcia Lainez
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
#import "LocalPredictiveModel.h"
#import "LocalPredictionTree.h"

@implementation LocalPredictiveModel
    
+(NSDictionary*)predictWithJSONModel:(NSDictionary*)jsonModel arguments:(NSString*)args argsByName:(BOOL)byName
{
    NSDictionary* prediction = nil;
    
    if(jsonModel != nil && args != nil)
    {
        NSString* objectiveField = jsonModel[@"objective_field"];
    
        NSDictionary* fields = jsonModel[@"model"][@"fields"];
        NSDictionary* root = jsonModel[@"model"][@"root"];
    
        NSError *error = nil;
        NSDictionary* inputData = [NSJSONSerialization JSONObjectWithData:[args dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
        
        if(!byName)
            inputData = [LocalPredictiveModel createInputDataByNameFromInputDataByFieldId:inputData fields:fields];
        
        //Explore the predictive model tree recursively
        LocalPredictionTree* tree = [[LocalPredictionTree alloc]initWithRoot:root fields:fields objectiveField:objectiveField];
        prediction = [tree predict:inputData];
    }
    
    return prediction;
}

+(NSDictionary*)createInputDataByNameFromInputDataByFieldId:(NSDictionary*)inputDataByFieldId fields:(NSDictionary*)fields
{
    NSMutableDictionary* inputDataByName = [NSMutableDictionary dictionaryWithCapacity:5];
    
    for(NSString* key in [inputDataByFieldId keyEnumerator])
    {
        NSDictionary* fieldName = fields[key][@"name"];
        inputDataByName[fieldName] = inputDataByFieldId[key];
    }
    
    return inputDataByName;
}

@end
