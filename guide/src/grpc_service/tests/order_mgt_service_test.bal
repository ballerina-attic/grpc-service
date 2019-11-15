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

// Client endpoint configuration
orderMgtBlockingClient orderMgtBlockingEp = new("http://localhost:9090");

@test:Config {}
// Function to test 'addOrder'.
function testAddOrder() {
    // Create an order
    orderInfo orderReq = {id: "100500", name: "XYZ", description: "Sample order."};
    var addResponse = orderMgtBlockingEp->addOrder(orderReq);
    if (addResponse is error) {
        test:assertTrue(false, msg = "Error: Cannot get response from 'addOrder' method");
    } else {
        string result;
        grpc:Headers resHeaders;
        [result, resHeaders] = addResponse;
        string expected = "Status : Order created; OrderID : 100500";
        test:assertEquals(result, expected, msg = "Response mismatch!");
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
    if (updateResponse is error) {
        test:assertTrue(false, msg = "Error: Cannot get response from 'updateOrder' method");
    } else {
        string result;
        grpc:Headers resHeaders;
        [result, resHeaders] = updateResponse;
        string expected = "Order : '100500' updated.";
        test:assertEquals(result, expected, msg = "Response mismatch!");
    }
}

@test:Config {
    dependsOn: ["testUpdateOrder"]
}
// Function to test 'findOrder'.
function testFindOrder() {
    // Find an order
    var findResponse = orderMgtBlockingEp->findOrder("100500");
    if (findResponse is error) {
        test:assertTrue(false, msg = "Error: Cannot get response from 'findOrder' method");
    } else {
        string result;
        grpc:Headers resHeaders;
        [result, resHeaders] = findResponse;
        string expected = "{\"id\":\"100500\", \"name\":\"XYZ\", \"description\":\"Updated order.\"}";
        test:assertEquals(result, expected, msg = "Response mismatch!");
    }
}
@test:Config {
    dependsOn: ["testFindOrder"]
}
// Function to test 'cancelOrder'.
function testCancelOrder() {
    // Cancel an order
    var cancelResponse = orderMgtBlockingEp->cancelOrder("100500");
    if (cancelResponse is error) {
        test:assertTrue(false, msg = "Error: Cannot get response from 'cancelOrder' method");
    } else {
        string result;
        grpc:Headers resHeaders;
        [result, resHeaders] = cancelResponse;
        string expected = "Order : '100500' removed.";
        test:assertEquals(result, expected, msg = "Response mismatch!");
    }
}
