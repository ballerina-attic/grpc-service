import ballerina/grpc;
import ballerina/log;

// gRPC service endpoint definition.
listener grpc:Listener ep = new (9090);

// Order management is done using an in memory map.
// Add some sample orders to 'orderMap' at startup.
map<orderInfo> ordersMap = {};

// gRPC service.
service orderMgt on ep {

    // gRPC method to find an order.
    resource function findOrder(grpc:Caller caller, string orderId) {
        string payload = "";
        error? result = ();
        // Find the requested order from the map.
        if (ordersMap.hasKey(orderId)) {
            var jsonValue = typedesc<json>.constructFrom(ordersMap[orderId]);
            if (jsonValue is error) {
                // Send casting error as internal error.
                result = caller->sendError(grpc:INTERNAL, <string>jsonValue.detail()["message"]);
            } else {
                json orderDetails = jsonValue;
                payload = orderDetails.toString();
                // Send response to the caller.
                result = caller->send(payload);
                result = caller->complete();
            }
        } else {
            // Send entity not found error.
            payload = "Order : '" + orderId + "' cannot be found.";
            result = caller->sendError(grpc:NOT_FOUND, payload);
        }

        if (result is error) {
            log:printError("Error from Connector: " + result.reason() + " - "
                    + <string>result.detail()["message"] + "\n");
        }
    }

    // gRPC method to create a new Order.
    resource function addOrder(grpc:Caller caller, orderInfo orderReq) {
        // Add the new order to the map.
        string orderId = orderReq.id;
        ordersMap[orderReq.id] = <@untained>orderReq;
        // Create response message.
        string payload = "Status : Order created; OrderID : " + orderId;

        // Send response to the caller.
        error? result = caller->send(payload);
        result = caller->complete();
        if (result is error) {
            log:printError("Error from Connector: " + result.reason() + " - "
                    + <string>result.detail()["message"] + "\n");
        }
    }

    // gRPC method to update an existing Order.
    resource function updateOrder(grpc:Caller caller, orderInfo updatedOrder) {
        string payload;
        error? result = ();
        // Find the order that needs to be updated.
        string orderId = updatedOrder.id;
        if (ordersMap.hasKey(orderId)) {
            // Update the existing order.
            ordersMap[orderId] = <@untained>updatedOrder;
            payload = "Order : '" + orderId + "' updated.";
            // Send response to the caller.
            result = caller->send(payload);
            result = caller->complete();
        } else {
            // Send entity not found error.
            payload = "Order : '" + orderId + "' cannot be found.";
            result = caller->sendError(grpc:NOT_FOUND, payload);
        }

        if (result is error) {
            log:printError("Error from Connector: " + result.reason() + " - "
                    + <string>result.detail()["message"] + "\n");
        }
    }

    // gRPC method to delete an existing Order.
    resource function cancelOrder(grpc:Caller caller, string orderId) {
        string payload;
        error? result = ();
        // Find the order that needs to be updated.
        if (ordersMap.hasKey(orderId)) {
            // Remove the requested order from the map.
            _ = ordersMap.remove(orderId);
            payload = "Order : '" + orderId + "' removed.";
            // Send response to the caller.
            result = caller->send(payload);
            result = caller->complete();
        } else {
            // Send entity not found error.
            payload = "Order : '" + orderId + "' cannot be found.";
            result = caller->sendError(grpc:NOT_FOUND, payload);
        }
        if (result is error) {
            log:printError("Error from Connector: " + result.reason() + " - "
                    + <string>result.detail()["message"] + "\n");
        }
    }
}
