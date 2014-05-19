/**
 *
 * LocalPredictiveTree.m
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
#import "LocalPredictionTree.h"
#import "Predicate.h"
#import "Constants.h"

@implementation LocalPredictionTree

@synthesize predicate;

-(LocalPredictionTree*)initWithRoot:(NSDictionary*)aRoot fields:(NSDictionary*)aFields objectiveField:(NSString*)aObjectiveField
{
    self = [super init];
    
    if(self)
    {
        root = aRoot;
        fields = aFields;
        objectiveField = aObjectiveField;
        
        output = root[@"output"];
        confidence = root[@"confidence"];
        
        NSObject* predicateObj = root[@"predicate"];
        
        //Generate predicate
        if([predicateObj respondsToSelector:@selector(boolValue)] && [(NSNumber*)predicateObj boolValue] == YES)
            isPredicate = YES;
        else
        {
            NSDictionary* predicateDict = (NSDictionary*)predicateObj;
            NSString* field = predicateDict[@"field"];
            
            self.predicate = [[Predicate alloc]init];
            [self.predicate setOpType:fields[field][@"optype"]];
            [self.predicate setPredicateOperator:predicateDict[@"operator"]];
            [self.predicate setField:field];
            [self.predicate setValue:predicateDict[@"value"]];
        }
        
        //Generate children array
        children = [[NSMutableArray alloc]init];
        NSArray* childrenObj = root[@"children"];
        
        if(childrenObj != nil)
        {
            for(NSInteger i = 0; i < [childrenObj count]; i++)
            {
                NSDictionary* child = childrenObj[i];
                
                LocalPredictionTree* childTree = [[LocalPredictionTree alloc]initWithRoot:child fields:fields objectiveField:objectiveField];
                [children addObject:childTree];
            }
        }
    }
    
    return self;
}


-(NSDictionary*)predict:(NSDictionary*)inputData
{
    if([children count] > 0)
    {
        for(NSInteger i = 0; i < [children count]; i++)
        {
            LocalPredictionTree* child = children[i];
            
            NSString* field = child.predicate.field;
            NSString* inputValue = inputData[fields[field][@"name"]];
            
            if(inputValue == nil)
                continue;
            
            NSString* opType = child.predicate.opType;
            NSString* operator = child.predicate.predicateOperator;
            NSString* value = child.predicate.value;
            
            
            if([operator isEqualToString:OPERATOR_EQ] && [inputValue isEqualToString:value]) {
                return [child predict:inputData];
            }
            
            if(([operator isEqualToString:OPERATOR_NE] || [operator isEqualToString:OPERATOR_NE2]) && ![inputValue isEqualToString:value]){
                return [child predict:inputData];
            }
            
            if([operator isEqualToString:OPERATOR_LT])
            {
                if([opType isEqualToString:OPTYPE_DATETIME] && [inputValue compare:value] < 0){
                    return [child predict:inputData];
                }
                
                if(![opType isEqualToString:OPTYPE_DATETIME] && [inputValue doubleValue] < [value doubleValue]){
                    return  [child predict:inputData];
                }
            }
            
            if([operator isEqualToString:OPERATOR_LE])
            {
                if([opType isEqualToString:OPTYPE_DATETIME] && [inputValue compare:value] <= 0){
                    return [child predict:inputData];
                }
                
                if(![opType isEqualToString:OPTYPE_DATETIME] && [inputValue doubleValue] <= [value doubleValue]){
                    return  [child predict:inputData];
                }
            }
            
            if([operator isEqualToString:OPERATOR_GE])
            {
                if([opType isEqualToString:OPTYPE_DATETIME] && [inputValue compare:value] >= 0){
                    return [child predict:inputData];
                }
                
                if(![opType isEqualToString:OPTYPE_DATETIME] && [inputValue doubleValue] >= [value doubleValue]){
                    return  [child predict:inputData];
                }
            }
            
            if([operator isEqualToString:OPERATOR_GT])
            {
                if([opType isEqualToString:OPTYPE_DATETIME] && [inputValue compare:value] > 0){
                    return [child predict:inputData];
                }
                
                if(![opType isEqualToString:OPTYPE_DATETIME] && [inputValue doubleValue] > [value doubleValue]){
                    return  [child predict:inputData];
                }
            }            
        }
	}
    
    //The result of a prediction is the output of the node and the confidence
    NSMutableDictionary* prediction = [[NSMutableDictionary alloc]initWithCapacity:2];
    
    if(output != nil)
        [prediction setValue:output forKey:@"value"];
    
    if(confidence != nil)
        [prediction setValue:confidence forKey:@"confidence"];
    
    return prediction;
}

@end
