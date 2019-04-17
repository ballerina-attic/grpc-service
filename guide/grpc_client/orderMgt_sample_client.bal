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
    orderInfo updateReq = {id:"100500", name:"XYZ", description:"Updated."};
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
    var findResponse = orderMgtBlockingEp->findOrder("100500");
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
    var cancelResponse = orderMgtBlockingEp->cancelOrder("100500");
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