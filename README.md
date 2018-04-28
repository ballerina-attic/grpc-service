# gRPC Service

gRPC is a modern, open source remote procedure call (RPC) framework widely used in distributed computing, which enables client and server applications to communicate transparently. In gRPC, a client application can directly call methods on a server application on a different machine as if it was a local object. On the server side, the server implements and runs a gRPC server to handle client calls; whereas, on the client side, the client has a stub that provides the same methods as the server.

> In this guide you will learn about building a comprehensive gRPC service using Ballerina. 

The following are the sections available in this guide.

- [What you'll build](#what-youll-build)
- [Prerequisites](#prerequisites)
- [Implementation](#implementation)
- [Testing](#testing)
- [Deployment](#deployment)
- [Observability](#observability)

## What you’ll build 
To understanding how you can build a gRPC service using Ballerina, let’s consider a real world use case of an order management scenario of an online retail application. 
We can model the order management scenario as a gRPC service; 'order_mgt_service',  which accepts different proto requests for order management tasks such as order creation, retrieval, updating and deletion.
The following figure illustrates all the required functionalities of the orderMgt gRPC service that we need to build. 

![gRPC Service](images/grpc_service.svg)

- **Create Order** : To place a new order, a gRPC client can send a proto request to the `addOrder` procedure with order details.  
- **Retrieve Order** : A gRPC client can call the `findOrder` procedure with orderID to retrive an order.
- **Update Order** : To update an existing order, a client needs make a procedure call to the `updateOrder` method with the update details.  
- **Cancel Order** : An existing order can be deleted by sending a proto request to the `cancelOrder` procedure with orderID. 

## Prerequisites
 
- JDK 1.8 or later
- [Ballerina Distribution](https://github.com/ballerina-lang/ballerina/blob/master/docs/quick-tour.md)
- A Text Editor or an IDE 

### Optional requirements
- Ballerina IDE plugins ([IntelliJ IDEA](https://plugins.jetbrains.com/plugin/9520-ballerina), [VSCode](https://marketplace.visualstudio.com/items?itemName=WSO2.Ballerina), [Atom](https://atom.io/packages/language-ballerina))
- [Docker](https://docs.docker.com/engine/installation/)

## Developing the service 

> If you want to skip the basics, you can download the git repo and directly move to the [Testing](#testing) section by skipping this section.

### Create the project structure

Ballerina is a complete programming language that can have any custom project structure that you wish. Although the language allows you to have any package structure, use the following package structure for this project to follow this guide.

```
grpc-service
  ├── grpc_service
  │   └── order_mgt_service.bal
  └── tests
      ├── order_mgt_service_test.bal          
      └── orderMgt_pb.bal
```
You can create the above Ballerina project using Ballerina project initializing toolkit.

- First, create a new directory in your local machine as `grpc-service` and navigate to that directory using terminal. 
- Then enter the following inputs to the Ballerina project initializing toolkit.
```bash
$ballerina init -i

Create Ballerina.toml [yes/y, no/n]: (y) y
Organization name: (username) grpc-service
Version: (0.0.1) 
Ballerina source [service/s, main/m]: (s) s
Package for the service : (no package) grpc_service
Ballerina source [service/s, main/m, finish/f]: (f) f

Ballerina project initialized
```

- Once you initialize your Ballerina project, you can change the names of the generated files to match with our guide project filenames.
  
### Implement the gRPC service

Let's get started with the implementation of 'order_mgt_service', which is a gRPC service that handles order management. This service can have dedicated procedures for each specific order management functionality.

Implementation of this gRPC service is attached below. Inline comments added for better understanding.


##### order_mgt_service.bal
```ballerina
import ballerina/grpc;

// gRPC service endpoint definition.
endpoint grpc:Listener listener {
    host:"localhost",
    port:9090
};

// Order management is done using an in memory map.
// Add some sample orders to 'orderMap' at startup.
map<orderInfo> ordersMap;

// Type definition for an order.
type orderInfo {
    string id;
    string name;
    string description;
};

// gRPC service.
@grpc:ServiceConfig
service orderMgt bind listener {

    // gRPC method to find an order.
    findOrder(endpoint caller, string orderId) {
        string payload;
        // Find the requested order from the map.
        if (ordersMap.hasKey(orderId)) {
            json orderDetails = check <json>ordersMap[orderId];
            payload = orderDetails.toString();
        } else {
            payload = "Order : '" + orderId + "' cannot be found.";
        }

        // Send response to the caller.
        _ = caller->send(payload);
        _ = caller->complete();
    }

    // gRPC method to create a new Order.
    addOrder(endpoint caller, orderInfo orderReq) {
        // Add the new order to the map.
        string orderId = orderReq.id;
        ordersMap[orderReq.id] = orderReq;
        // Create response message.
        string payload = "Status : Order created; OrderID : " + orderId;

        // Send response to the caller.
        _ = caller->send(payload);
        _ = caller->complete();
    }

    // gRPC method to update an existing Order.
    updateOrder(endpoint caller, orderInfo updatedOrder) {
        string payload;
        // Find the order that needs to be updated.
        string orderId = updatedOrder.id;
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

    // gRPC method to delete an existing Order.
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
```

You can implement the business logic of each resources as per your requirements. For simplicity we have used an in-memory map to keep all the order details. As shown in the above code, first you need to import the `ballerina/grpc` and then define a `grpc:Listener` endpoint to create a gRPC service. 


### Implement a gRPC client

Using ballerina we can also write a gRPC client to consume the methods we implemented in the gRPC service. We can use the protobuf tool to automatically generate a client template and the client stub needed.

- First we need to run the gRPC service we implemented above to generate a .proto definition for the 'orderMgt' gRPC service. Navigate to the project root directory and run the following command to start the 'order_mgt_service'.

```bash
   $ ballerina run grpc_service/
```

- Create a new directory using the following command to store the client and client stub files.
```bash
   $ mkdir grpc_client 
```

- Run the following command to autogenerate the client stub and a Ballerina gRPC client template. Here, `--output`is an optional parameter and the default value is the current working directory.
```bash
   $ ballerina grpc --input target/grpc/orderMgt.proto --output grpc_client
```

- Now you should see two new files inside `guide/grpc_client` directory namely `orderMgt_sample_client.bal`, which is
 a sample gRPC client and `orderMgt_pb.bal`, which is the gRPC client stub.

- Replace the content of the `orderMgt_sample_client.bal` with the business logic you need. For example, refer to the below implementation of a Ballerina gRPC client.

##### orderMgt_sample_client.bal
```ballerina
import ballerina/log;
import ballerina/grpc;

// This is client implementation for unary blocking scenario
function main(string... args) {
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
```

- With that we've completed the development of our 'orderMgt' service and gRPC client. 


## Testing 

### Invoking the gRPC service 

You can run the gRPC service that you developed above, in your local environment. Open your terminal, navigate to sample root directory and execute the following command.
```
   $ballerina run grpc_service
```

You can test the functionality of the 'orderMgt' gRPC service by running the gRPC client application implemented above. Use the below command to run the gRPC client. 

```
   $ballerina run grpc_client
```

You will see log statements similar to below printed in your terminal as the response.
```
INFO  [grpc_client] - -----------------------Create a new order----------------------- 
INFO  [grpc_client] - Response - Status : Order created; OrderID : 100500
 
INFO  [grpc_client] - --------------------Update an existing order-------------------- 
INFO  [grpc_client] - Response - Order : '100500' updated.
 
INFO  [grpc_client] - ---------------------Find an existing order--------------------- 
INFO  [grpc_client] - Response - {"id":"100500","name":"XYZ","description":"Updated."}
 
INFO  [grpc_client] - -------------------------Cancel an order------------------------ 
INFO  [grpc_client] - Response - Order : '100500' removed.
```

### Writing unit tests 

In Ballerina, the unit test cases should be in the same package inside a folder named as 'tests'.  When writing the test functions the below convention should be followed.
* Test functions should be annotated with `@test:Config`. See the below example.
```ballerina
   @test:Config
   function testAddOrder() {
```
  
This guide contains unit test cases for each method available in the 'order_mgt_service' implemented above. 'tests' folder also contains a copy of the client stub file that we generated using protobuf tool. Note that without this file you cannot run the test file in this guide. 

To run the unit tests, navigate to the sample root directory and run the following command.
```
   $ballerina test grpc_service
```

To check the implementation of the test file, refer to the [order_mgt_service_test.bal](https://github.com/ballerina-guides/grpc-service/blob/master/grpc_service/tests/order_mgt_service_test.bal).

## Deployment

Once you are done with the development, you can deploy the gRPC service implemented above. 

### Deploying locally

- As the first step you can build a Ballerina executable archive (.balx) of the service that we developed above, using the following command. It points to the directory in which the service we developed above located and it will create an executable binary out of that. Navigate to the sample root directory and run the following command. 

```
   $ballerina build grpc_service
```

- Once the grpc_service.balx is created inside the target folder, you can run that with the following command. 

```
   $ballerina run target/grpc_service.balx
```

- The successful execution of the service should show us the following output. 
```
   $ballerina run target/grpc_service.balx 

   ballerina: deploying service(s) in 'target/grpc_service.balx'
   ballerina: started gRPC server connector on port 9090
```
