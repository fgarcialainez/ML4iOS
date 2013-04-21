/**
 *
 * LocalPredictiveModel.h
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

/**
 * Utility class to handle local predictions
 */
@interface LocalPredictiveModel : NSObject
{
    
}

/**
 * Creates a local prediction using the model and args passed as parameters
 * @param jsonModel The model to use to create the prediction
 * @param args The arguments to create the prediction
 * @param byName The arguments passed in args parameter are passed by name
 * @return The result of the prediction
 */
+(NSDictionary*)predictWithJSONModel:(NSDictionary*)jsonModel arguments:(NSString*)args argsByName:(BOOL)byName;

/**
 * Generates a hash of input data by name instead of by fieldId
 * @param inputDataByFieldId Contains the input data keyed by fieldId
 * @param fields The fields of the model
 * @return The input data keyed by field name
 */
+(NSDictionary*)createInputDataByNameFromInputDataByFieldId:(NSDictionary*)inputDataByFieldId fields:(NSDictionary*)fields;

@end
