// Copyright (c) 2018 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied. See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/log;
import ballerina/grpc;

// This is client implementation for unary blocking scenario
public function main(string... args) {
    // Client endpoint configuration
    endpoint orderMgtBlockingClient orderMgtBlockingEp {
        url:"http://localhost:9090"
    };

    // Create an order
    log:printInfo("-----------------------Create a new order-----------------------");
    orderInfo orderReq = {id:"100500", name:"XYZ", description:"Sample order."};
    var addResponse = orderMgtBlockingEp->addOrder(orderReq);
    match addResponse {
        (string, grpc:Headers) payload => {
            string result;
            grpc:Headers resHeaders;
            (result, resHeaders) = payload;
            log:printInfo("Response - " + result + "\n");
        }
        error err => {
            log:printError("Error from Connector: " + err.message + "\n");
        }
    }

    // Update an order
    log:printInfo("--------------------Update an existing order--------------------");
    orderInfo updateReq = {id:"100500", name:"XYZ", description:"Updated."};
    var updateResponse = orderMgtBlockingEp->updateOrder(updateReq);
    match updateResponse {
        (string, grpc:Headers) payload => {
            string result;
            grpc:Headers resHeaders;
            (result, resHeaders) = payload;
            log:printInfo("Response - " + result + "\n");
        }
        error err => {
            log:printError("Error from Connector: " + err.message + "\n");
        }
    }

    // Find an order
    log:printInfo("---------------------Find an existing order---------------------");
    var findResponse = orderMgtBlockingEp->findOrder("100500");
    match findResponse {
        (string, grpc:Headers) payload => {
            string result;
            grpc:Headers resHeaders;
            (result, resHeaders) = payload;
            log:printInfo("Response - " + result + "\n");
        }
        error err => {
            log:printError("Error from Connector: " + err.message + "\n");
        }
    }

    // Cancel an order
    log:printInfo("-------------------------Cancel an order------------------------");
    var cancelResponse = orderMgtBlockingEp->cancelOrder("100500");
    match cancelResponse {
        (string, grpc:Headers) payload => {
            string result;
            grpc:Headers resHeaders;
            (result, resHeaders) = payload;
            log:printInfo("Response - " + result + "\n");
        }
        error err => {
            log:printError("Error from Connector: " + err.message + "\n");
        }
    }
}
