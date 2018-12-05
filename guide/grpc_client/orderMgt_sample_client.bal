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
    orderMgtBlockingClient orderMgtBlockingEp = new("http://localhost:9090");

    // Create an order
    log:printInfo("-----------------------Create a new order-----------------------");
    orderInfo orderReq = {id:"100500", name:"XYZ", description:"Sample order."};
    var addResponse = orderMgtBlockingEp->addOrder(orderReq);
    if (addResponse is error) {
        log:printError("Error from Connector: " + addResponse.reason() + " - "
                                                + <string>addResponse.detail().message + "\n");
    } else {
        string result;
        grpc:Headers resHeaders;
        (result, resHeaders) = addResponse;
        log:printInfo("Response - " + result + "\n");
    }

    // Update an order
    log:printInfo("--------------------Update an existing order--------------------");
    orderInfo updateReq = {id:"100501", name:"XYZ", description:"Updated."};
    var updateResponse = orderMgtBlockingEp->updateOrder(updateReq);
    if (updateResponse is error) {
        log:printError("Error from Connector: " + updateResponse.reason() + " - "
                                                + <string>updateResponse.detail().message + "\n");
    } else {
        string result;
        grpc:Headers resHeaders;
        (result, resHeaders) = updateResponse;
        log:printInfo("Response - " + result + "\n");
    }

    // Find an order
    log:printInfo("---------------------Find an existing order---------------------");
    var findResponse = orderMgtBlockingEp->findOrder("100501");
    if (findResponse is error) {
        log:printError("Error from Connector: " + findResponse.reason() + " - "
                                                + <string>findResponse.detail().message + "\n");
    } else {
        string result;
        grpc:Headers resHeaders;
        (result, resHeaders) = findResponse;
        log:printInfo("Response - " + result + "\n");
    }

    // Cancel an order
    log:printInfo("-------------------------Cancel an order------------------------");
    var cancelResponse = orderMgtBlockingEp->cancelOrder("100501");
    if (cancelResponse is error) {
        log:printError("Error from Connector: " + cancelResponse.reason() + " - "
                + <string>cancelResponse.detail().message + "\n");
    } else {
        string result;
        grpc:Headers resHeaders;
        (result, resHeaders) = cancelResponse;
        log:printInfo("Response - " + result + "\n");
    }
}
