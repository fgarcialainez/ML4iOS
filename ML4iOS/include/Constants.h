/**
 *
 * Constants.h
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

/**
 * Defines constants for HTTP Status codes and RESOURCE Status Codes
 */

//HTTP Status Codes
#define HTTP_OK 200
#define HTTP_CREATED 201
#define HTTP_ACCEPTED 202
#define HTTP_NO_CONTENT 204
#define HTTP_BAD_REQUEST 400
#define HTTP_UNAUTHORIZED 401
#define HTTP_PAYMENT_REQUIRED 402
#define HTTP_FORBIDDEN 403
#define HTTP_NOT_FOUND 404
#define HTTP_METHOD_NOT_ALLOWED 405
#define HTTP_LENGTH_REQUIRED 411
#define HTTP_INTERNAL_SERVER_ERROR 500

//RESOURCE Status Codes (A resource can be a data source, dataset, model, prediction, etc)
#define WAITING 0
#define QUEUED 1
#define STARTED 2
#define IN_PROGRESS 3
#define SUMMARIZED 4
#define FINISHED 5
#define FAULTY -1
#define UNKNOWN -2
#define RUNNABLE -3