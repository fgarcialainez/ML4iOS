/**
 *
 * LocalPredictiveTree.h
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
#import <Foundation/Foundation.h>

@class Predicate;

/**
 * A tree that represents a node in the predictive model
 */
@interface LocalPredictionTree : NSObject
{
    NSDictionary* root;
    NSDictionary* fields;
    NSString* objectiveField;
    
    NSObject* output;
    NSObject* confidence;
    BOOL isPredicate;
    Predicate* predicate;
    NSMutableArray* children; //LocalPredictionTree Array
}

@property (nonatomic, strong) Predicate* predicate;

/**
 * Initializes a LocalPredictionTree object
 * @param aRoot A json object that acts as root of this tree
 * @param aFields The fields of the predictive model
 * @param aObjectiveField The objective field id (ej: 0000001, 0000002, etc)
 */
-(LocalPredictionTree*)initWithRoot:(NSDictionary*)aRoot fields:(NSDictionary*)aFields objectiveField:(NSString*)aObjectiveField;

/**
 * Create the prediction with current model and input data passed as parameter
 * @param inputData The input data to create the prediction
 * @return A NSDictionary with the result of the prediction keyed with "value" string and the confidence of the prediction keyed with "confidence" string.
 */
-(NSDictionary*)predict:(NSDictionary*)inputData;

@end
