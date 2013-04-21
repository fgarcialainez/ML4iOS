/**
 *
 * Constants.h
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

@interface Constants : NSObject

// OP_TYPE
#define OPTYPE_NUMERIC @"numeric"
#define OPTYPE_CATEGORICAL @"categorical"
#define OPTYPE_TEXT @"text"
#define OPTYPE_DATETIME @"datetime"

// Operators
#define OPERATOR_LT @"<"
#define OPERATOR_LE @"<="
#define OPERATOR_EQ @"="
#define OPERATOR_NE @"!="
#define OPERATOR_NE2 @"/="
#define OPERATOR_GE @">="
#define OPERATOR_GT @">"

@end