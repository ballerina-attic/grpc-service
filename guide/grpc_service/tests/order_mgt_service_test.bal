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

import ballerina/grpc;
import ballerina/test;

// Unit tests for the gRPC service implemented

@test:BeforeSuite
function beforeFunc() {
    // Start the 'orderMgt' gRPC service before running the test.
    _ = test:startServices("grpc_service");
}

// Client endpoint configuration
endpoint orderMgtBlockingClient orderMgtBlockingEp {
    url:"http://localhost:9090"
};


@test:Config
// Function to test 'addOrder'.
function testAddOrder() {
    // Create an order
    orderInfo orderReq = {id: "100500", name: "XYZ", description: "Sample order."};
    var addResponse = orderMgtBlockingEp->addOrder(orderReq);
    match addResponse {
        (string, grpc:Headers) payload => {
            string result;
            grpc:Headers resHeaders;
            (result, resHeaders) = payload;
            string expected = "Status : Order created; OrderID : 100500";
            test:assertEquals(result, expected, msg = "Response mismatch!");
        }
        error err => {
            test:assertTrue(false, msg = "Error: Cannot get response from 'addOrder' method");
        }
    }
}

@test:Config {
    dependsOn: ["testAddOrder"]
}
// Function to test 'updateOrder'.
function testUpdateOrder() {
    // Update an order
    orderInfo updateReq = {id: "100500", name: "XYZ", description: "Updated order."};
    var updateResponse = orderMgtBlockingEp->updateOrder(updateReq);
    match updateResponse {
        (string, grpc:Headers) payload => {
            string result;
            grpc:Headers resHeaders;
            (result, resHeaders) = payload;
            string expected = "Order : '100500' updated.";
            test:assertEquals(result, expected, msg = "Response mismatch!");
        }
        error err => {
            test:assertTrue(false, msg = "Error: Cannot get response from 'updateOrder' method");

        }
    }
}

@test:Config {
    dependsOn: ["testUpdateOrder"]
}
// Function to test 'findOrder'.
function testFindOrder() {
    // Find an order
    var findResponse = orderMgtBlockingEp->findOrder("100500");
    match findResponse {
        (string, grpc:Headers) payload => {
            string result;
            grpc:Headers resHeaders;
            (result, resHeaders) = payload;
            string expected = "{\"id\":\"100500\",\"name\":\"XYZ\",\"description\":\"Updated order.\"}";
            test:assertEquals(result, expected, msg = "Response mismatch!");
        }
        error err => {
            test:assertTrue(false, msg = "Error: Cannot get response from 'findOrder' method");
        }
    }
}
@test:Config {
    dependsOn: ["testFindOrder"]
}
// Function to test 'cancelOrder'.
function testCancelOrder() {
    // Cancel an order
    var cancelResponse = orderMgtBlockingEp->cancelOrder("100500");
    match cancelResponse {
        (string, grpc:Headers) payload => {
            string result;
            grpc:Headers resHeaders;
            (result, resHeaders) = payload;
            string expected = "Order : '100500' removed.";
            test:assertEquals(result, expected, msg = "Response mismatch!");
        }
        error err => {
            test:assertTrue(false, msg = "Error: Cannot get response from 'cancelOrder' method");
        }
    }
}

//@test:AfterSuite
function afterFunc() {
    // Stop the 'orderMgt' gRPC service after running the test.
    test:stopServices("grpc_service");
}
