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

endpoint grpc:Listener listener {
    host:"localhost",
    port:9090
};

// Order management is done using an in memory map.
// Add some sample orders to 'orderMap' at startup.
map<string> ordersMap;

@Description {value:"gRPC service."}
@grpc:serviceConfig
service order_mgt bind listener {

    @Description {value:"gRPC method to find an order"}
    findOrder(endpoint caller, string orderId) {
        string payload;
        // Find the requested order from the map.
        if (ordersMap.hasKey(orderId)) {
            payload = ordersMap[orderId];
        } else {
            payload = "Order : '" + orderId + "' cannot be found.";
        }

        // Send response to the caller.
        _ = caller->send(payload);
        _ = caller->complete();
    }

    @Description {value:"gRPC method to create a new Order."}
    addOrder(endpoint caller, string orderId, string orderReq) {
        // Add the new order to the map.
        ordersMap[orderId] = orderReq;
        // Create response message.
        string payload = "Status : Order created; OrderID : " + orderId;

        // Send 201 Created status code
        string statusCode = "StatusCode : 201";
        _ = caller->send(statusCode);

        // Send response to the caller.
        _ = caller->send(payload);
        _ = caller->complete();
    }

    @Description {value:"gRPC method to update an existing Order."}
    updateOrder(endpoint caller, string orderId, string updatedOrder) {
        string payload;
        // Find the order that needs to be updated.
        if (ordersMap.hasKey(orderId)) {
            // Update the existing order.
            ordersMap[orderId] = updatedOrder;
            payload = "Order : '" + orderId + "' updated.";
        } else {
            payload = "Order : '" + orderId + "' cannot be found.";
        }

        // Send response to the caller.
        _ = caller->send(payload);
        _ = caller->complete();
    }

    @Description {value:"gRPC method to delete an existing Order."}
    cancelOrder(endpoint caller, string orderId) {
        string payload;
        if (ordersMap.hasKey(orderId)) {
            // Remove the requested order from the map.
            _ = ordersMap.remove(orderId);
            payload = "Order : '" + orderId + "' removed.";
        } else {
            payload = "Order : '" + orderId + "' cannot be found.";
        }

        // Send response to the caller.
        _ = caller->send(payload);
        _ = caller->complete();
    }
}
