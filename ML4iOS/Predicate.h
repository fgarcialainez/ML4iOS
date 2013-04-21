/**
 *
 * Predicate.h
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
 * A predicate to be evaluated in a tree's node.
 */
@interface Predicate : NSObject
{
    NSString* opType;
    NSString* predicateOperator;
    NSString* field;
    NSString* value;
}

@property (nonatomic, retain) NSString* opType;
@property (nonatomic, retain) NSString* predicateOperator;
@property (nonatomic, retain) NSString* field;
@property (nonatomic, retain) NSString* value;

@end
