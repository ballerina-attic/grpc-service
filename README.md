

# gRPC Service

gRPC is a modern, open source remote procedure call (RPC) framework that is widely used in distributed computing. It enables client and server applications to communicate transparently. In gRPC, a client application can directly call methods of a server application that is on a different machine as if it was a local object. On the server side, the server implements and runs a gRPC server to handle client calls. On the client side, the client has a stub that provides the same methods as the server.

> In this guide, you learn to build a comprehensive gRPC service using Ballerina. 

This guide contains the following sections.

- [What you'll build](#what-youll-build)
- [Prerequisites](#prerequisites)
- [Implementation](#implementation)
- [Testing](#testing)
- [Deployment](#deployment)
- [Observability](#observability)

## What you’ll build 
You will build a real-world use case of an order management scenario in an online retail application.  The order management scenario is modeled as a gRPC service; `order_mgt_service`, which accepts different proto requests as order management tasks, such as creating, retrieving, updating, and deleting orders.
The following figure illustrates all the functionalities of the order_mgt gRPC service that we need to build. 

![gRPC Service](images/grpc_service.svg)

- **Create Order** : A gRPC client sends a proto request to the `addOrder` procedure with the order details.  
- **Retrieve Order** : A gRPC client calls the `findOrder` procedure with the `orderID` to retrieve the order.
- **Update Order** : A client makes a procedure call to the `updateOrder` method with the update details.  
- **Cancel Order** : Send a proto request to the `cancelOrder` procedure with `orderID`. 

## Prerequisites
 
- [Ballerina Distribution](https://ballerina.io/learn/getting-started/)
- A Text Editor or an IDE 

### Optional requirements
- Ballerina IDE plugins ([IntelliJ IDEA](https://plugins.jetbrains.com/plugin/9520-ballerina), [VSCode](https://marketplace.visualstudio.com/items?itemName=WSO2.Ballerina), [Atom](https://atom.io/packages/language-ballerina))
- [Docker](https://docs.docker.com/engine/installation/)
- [Kubernetes](https://kubernetes.io/docs/setup/)

## Implementation

> If you want to skip the basics, download the git repository and move directly to the [Testing](#testing) section.

### Create the project structure

Ballerina is a complete programming language that supports custom project structures. Use the following package structure for this guide.

```
grpc-service
  └── guide
       ├── grpc_service
       │    └── order_mgt_service.bal
       └── tests
            ├── order_mgt_service_test.bal          
            └── orderMgt_pb.bal
```

- Create the above directories in your local machine and also create empty `.bal` files.

- Then open the terminal and navigate to `grpc-service/guide` and run Ballerina project initializing toolkit.
```bash
   $ ballerina init
```

### Developing the gRPC service

Let's get started with the implementation of the `order_mgt_service`, which is a gRPC service that handles order management. This service can have dedicated procedures for each order management functionality.

The implementation of this gRPC service is shown below.


##### order_mgt_service.bal
```ballerina
import ballerina/grpc;

// gRPC service endpoint definition.
endpoint grpc:Listener listener {
    host:"localhost",
    port:9090
};

// Order management is done using an in memory map.
// Add sample orders to the 'orderMap' at startup.
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
        // Create a response message.
        string payload = "Status : Order created; OrderID : " + orderId;

        // Send a response to the caller.
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

        // Send a response to the caller.
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

        // Send a response to the caller.
        _ = caller->send(payload);
        _ = caller->complete();
    }
}
```

You can implement the business logic of each resource as per your requirements. For simplicity, we use an in-memory 
map to record all the order details. As shown in the above code, to create a gRPC service you need to import the 
`ballerina/grpc` and define a `grpc:Listener` endpoint.  

### Implement a gRPC client

You can also write a gRPC client in Ballerina to consume the methods implemented in the gRPC service. You can use 
the protobuf tool to automatically generate a client template and the client stub.

- First, you need to build the gRPC service implemented above, to generate a `.proto` definition of the 
`orderMgt` gRPC service. Navigate to `grpc-service/guide` and run the following command. This will generate a proto
 definition named `orderMgt.proto` inside `./target/grpc`.

```bash
   $ ballerina build grpc_service/
```

- Create a new directory using the following command to store the client and client stub files.
```bash
   $ mkdir grpc_client 
```

- Run the following command to auto-generate the client stub and a Ballerina gRPC client template. 
```bash
   $ ballerina grpc --input target/grpc/orderMgt.proto --output grpc_client
```

- Now, you should see two new files inside the `guide/grpc_client` directory namely `orderMgt_sample_client.bal`, 
which is a sample gRPC client and `orderMgt_pb.bal`, which is the gRPC client stub.

- Replace the content of the `orderMgt_sample_client.bal` file with the business logic you need. For example, refer to 
the below implementation.

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

- With that we have completed the development of our 'orderMgt' service and the gRPC client. 


## Testing 

### Invoking the gRPC service 

You can run the gRPC service in your local environment. Open your terminal, navigate to `grpc-service/guide` and execute the following command.
```bash
$ ballerina run grpc_service
```

Test the functionality of the 'orderMgt' gRPC service by running the gRPC client application that was implemented above. Use the command given below. 

```bash
$ ballerina run grpc_client
```

You will see log statements similar to what is printed below on your terminal as the response.
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
- Test functions should be annotated with `@test:Config`. See the below example.
```ballerina
   @test:Config
   function testAddOrder() {
```
  
This guide contains unit test cases for each method available in the 'order_mgt_service'. The 'tests' folder also 
contains a copy of the client stub file, which was generated using the protobuf tool. Note that without this file you cannot run the tests in this guide. 

To run the unit tests, navigate to `grpc-service/guide` and run the following command.
```bash
  $ ballerina test grpc_service
```

To check the implementation of the test file, see [order_mgt_service_test.bal](https://github.com/ballerina-guides/grpc-service/blob/master/guide/grpc_service/tests/order_mgt_service_test.bal).

## Deployment

Once you are done with the development, you can deploy the gRPC service using any of the methods that we listed below. 

### Deploying locally

- As the first step, build a Ballerina executable archive (.balx) of the gRPC service that we developed above. Navigate to `grpc-service/guide` and run the following command. 

```bash
   $ ballerina build grpc_service
```

- Once the `grpc_service.balx` is created inside the `target` folder, you can run it using the following command. 

```bash
   $ ballerina run target/grpc_service.balx
```

- The successful execution of the service prints the following output. 
```bash
   $ ballerina run target/grpc_service.balx 

   ballerina: initiating service(s) in 'target/grpc_service.balx'
   ballerina: started gRPC server connector on port 9090
```

### Deploying on Docker

You can run the service that we developed above as a docker container. As Ballerina platform includes [Ballerina_Docker_Extension](https://github.com/ballerinax/docker), which offers native support for running ballerina programs on containers, you just need to put the corresponding docker annotations on your service code. 

- In our order_mgt_service, we need to import  `ballerinax/docker` and use the annotation `@docker:Config` as shown below to enable docker image generation during the build time. 

##### order_mgt_service.bal
```ballerina
import ballerina/grpc;
import ballerinax/docker;

@docker:Config {
    registry:"ballerina.guides.io",
    name:"grpc_service",
    tag:"v1.0"
}

@docker:Expose{}
endpoint grpc:Listener listener {
    host:"localhost",
    port:9090
};

map<orderInfo> ordersMap;

type orderInfo {
    string id;
    string name;
    string description;
};

// gRPC service.
@grpc:ServiceConfig
service orderMgt bind listener {
``` 

- `@docker:Config` annotation is used to provide the basic docker image configurations for the sample. `@docker:Expose {}` is used to expose the port. 

- Now you can build a Ballerina executable archive (.balx) of the service that we developed above, using the following command. This will also create the corresponding docker image using the docker annotations that you have configured above. Navigate to `grpc-service/guide` and run the following command.  
```
   $ ballerina build grpc_service

   Run following command to start docker container: 
   docker run -d -p 9090:9090 ballerina.guides.io/grpc_service:v1.0
```

- Once you successfully build the docker image, you can run it with the `docker run` command that is shown in the previous step.  
```bash   
   $ docker run -d -p 9090:9090 ballerina.guides.io/grpc_service:v1.0
```

  Here we run the docker image with flag `-p <host_port>:<container_port>` so that we  use  the host port 9090 and the container port 9090. Therefore you can access the service through the host port. 

- Verify docker container is running with the use of `$ docker ps`. The status of the docker container should be shown as 'Up'. 

- You can access the service using the same gRPC client that we have implemented above.
```bash
   $ ballerina run grpc_client
```

### Deploying on Kubernetes

- You can run the service that we developed above, on Kubernetes. The Ballerina language offers native support for running a ballerina programs on Kubernetes, with the use of Kubernetes annotations that you can include as part of your service code. Also, it will take care of the creation of the docker images. So you don't need to explicitly create docker images prior to deploying it on Kubernetes. Refer to [Ballerina_Kubernetes_Extension](https://github.com/ballerinax/kubernetes) for more details and samples on Kubernetes deployment with Ballerina. You can also find details on using Minikube to deploy Ballerina programs. 

- Let's now see how we can deploy our `order_mgt_service` on Kubernetes.

- First we need to import `ballerinax/kubernetes` and use `@kubernetes` annotations as shown below to enable kubernetes deployment for the service we developed above. 

##### order_mgt_service.bal

```ballerina
import ballerina/grpc;
import ballerinax/kubernetes;

@kubernetes:Ingress {
    hostname:"ballerina.guides.io",
    name:"ballerina-guides-grpc-service",
    path:"/"
}

@kubernetes:Service {
    serviceType:"NodePort",
    name:"ballerina-guides-grpc-service"
}

@kubernetes:Deployment {
    image:"ballerina.guides.io/grpc_service:v1.0",
    name:"ballerina-guides-grpc-service"
}

endpoint grpc:Listener listener {
    host:"localhost",
    port:9090
};

map<orderInfo> ordersMap;

type orderInfo {
    string id;
    string name;
    string description;
};

// gRPC service.
@grpc:ServiceConfig
service orderMgt bind listener {
``` 

- Here we have used `@kubernetes:Deployment` to specify the docker image name which will be created as part of building this service. 
- We have also specified `@kubernetes:Service` so that it will create a Kubernetes service which will expose the Ballerina service that is running on a Pod.  
- In addition we have used `@kubernetes:Ingress` which is the external interface to access your service (with path `/` and host name `ballerina.guides.io`)

- Now you can build a Ballerina executable archive (.balx) of the service that we developed above, using the following command. This will also create the corresponding docker image and the Kubernetes artifacts using the Kubernetes annotations that you have configured above.
  
```
   $ ballerina build grpc_service
  
   Run following command to deploy kubernetes artifacts:  
   kubectl apply -f ./target/grpc_service/kubernetes
```

- You can verify that the docker image that we specified in `@kubernetes:Deployment` is created, by using `$ docker images`. 
- Also the Kubernetes artifacts related our service, will be generated in `./target/grpc_service/kubernetes`. 
- Now you can create the Kubernetes deployment using:

```bash
   $ kubectl apply -f ./target/grpc_service/kubernetes 
 
   deployment.extensions "ballerina-guides-grpc-service" created
   ingress.extensions "ballerina-guides-grpc-service" created
   service "ballerina-guides-grpc-service" created
```

- You can verify Kubernetes deployment, service and ingress are running properly, by using following Kubernetes commands.

```bash
   $ kubectl get service
   $ kubectl get deploy
   $ kubectl get pods
   $ kubectl get ingress
```

- If everything is successfully deployed, you can invoke the service either via Node port or ingress. 

Node Port:

First, change the value of the `url` field of gRPC client endpoint to `http://localhost:<Node_Port>` in the `orderMgt_sample_client.bal` file, and then run it using the following command.        
```bash
   $ ballerina run grpc_client     
```

Ingress:

Add `/etc/hosts` entry to match hostname. 
``` 
   127.0.0.1 ballerina.guides.io
```

First, change the value of the `url` field of gRPC client endpoint to `http://ballerina.guides.io` in the `orderMgt_sample_client.bal` file, and then run it using the following command.        
```bash 
   $ ballerina run grpc_client
```

## Observability 
Ballerina is by default observable. Meaning you can easily observe your services, resources, etc.
However, observability is disabled by default via configuration. Observability can be enabled by adding following configurations to `ballerina.conf` file in `grpc-service/guide/`.

```ballerina
[b7a.observability]

[b7a.observability.metrics]
# Flag to enable Metrics
enabled=true

[b7a.observability.tracing]
# Flag to enable Tracing
enabled=true
```

NOTE: The above configuration is the minimum configuration needed to enable tracing and metrics. With these configurations default values are load as the other configuration parameters of metrics and tracing.

### Tracing 

You can monitor ballerina services using in built tracing capabilities of Ballerina. We'll use [Jaeger](https://github.com/jaegertracing/jaeger) as the distributed tracing system.
Follow the following steps to use tracing with Ballerina.

- You can add the following configurations for tracing. Note that these configurations are optional if you already have the basic configuration in `ballerina.conf` as described above.
```
   [b7a.observability]

   [b7a.observability.tracing]
   enabled=true
   name="jaeger"

   [b7a.observability.tracing.jaeger]
   reporter.hostname="localhost"
   reporter.port=5775
   sampler.param=1.0
   sampler.type="const"
   reporter.flush.interval.ms=2000
   reporter.log.spans=true
   reporter.max.buffer.spans=1000
```

- Run Jaeger docker image using the following command
```bash
   $ docker run -d -p5775:5775/udp -p6831:6831/udp -p6832:6832/udp -p5778:5778 -p16686:16686 \
   -p14268:14268 jaegertracing/all-in-one:latest
```

- Navigate to `grpc-service/guide` and run the `order_mgt_service` using the following command 
```
   $ ballerina run grpc_service/
```

- Observe the tracing using Jaeger UI using following URL
```
   http://localhost:16686
```

### Metrics
Metrics and alerts are built-in with ballerina. We will use Prometheus as the monitoring tool.
Follow the below steps to set up Prometheus and view metrics for order_mgt_service.

- You can add the following configurations for metrics. Note that these configurations are optional if you already have the basic configuration in `ballerina.conf` as described under `Observability` section.

```ballerina
   [b7a.observability.metrics]
   enabled=true
   provider="micrometer"

   [b7a.observability.metrics.micrometer]
   registry.name="prometheus"

   [b7a.observability.metrics.prometheus]
   port=9700
   hostname="0.0.0.0"
   descriptions=false
   step="PT1M"
```

- Create a file `prometheus.yml` inside `/tmp/` location. Add the below configurations to the `prometheus.yml` file.
```
   global:
     scrape_interval:     15s
     evaluation_interval: 15s

   scrape_configs:
     - job_name: prometheus
       static_configs:
         - targets: ['172.17.0.1:9797']
```

   NOTE : Replace `172.17.0.1` if your local docker IP differs from `172.17.0.1`
   
- Run the Prometheus docker image using the following command
```
   $ docker run -p 19090:9090 -v /tmp/prometheus.yml:/etc/prometheus/prometheus.yml \
   prom/prometheus
```
   
- You can access Prometheus at the following URL
```
   http://localhost:19090/
```

NOTE: Ballerina will by default have following metrics for HTTP server connector. You can enter following expression in Prometheus UI
-  http_requests_total
-  http_response_time


### Logging

Ballerina has a log package for logging to the console. You can import ballerina/log package and start logging. The following section will describe how to search, analyze, and visualize logs in real time using Elastic Stack.

- Start the Ballerina Service with the following command from `grpc-service/guide`
```
   $ nohup ballerina run grpc_service/ &>> ballerina.log&
```
   NOTE: This will write the console log to the `ballerina.log` file in the `grpc-service/guide` directory

- Start Elasticsearch using the following command

- Start Elasticsearch using the following command
```
   $ docker run -p 9200:9200 -p 9300:9300 -it -h elasticsearch --name \
   elasticsearch docker.elastic.co/elasticsearch/elasticsearch:6.2.2 
```

   NOTE: Linux users might need to run `sudo sysctl -w vm.max_map_count=262144` to increase `vm.max_map_count` 
   
- Start Kibana plugin for data visualization with Elasticsearch
```
   $ docker run -p 5601:5601 -h kibana --name kibana --link \
   elasticsearch:elasticsearch docker.elastic.co/kibana/kibana:6.2.2     
```

- Configure logstash to format the ballerina logs

i) Create a file named `logstash.conf` with the following content
```
input {  
 beats{ 
     port => 5044 
 }  
}

filter {  
 grok{  
     match => { 
	 "message" => "%{TIMESTAMP_ISO8601:date}%{SPACE}%{WORD:logLevel}%{SPACE}
	 \[%{GREEDYDATA:package}\]%{SPACE}\-%{SPACE}%{GREEDYDATA:logMessage}"
     }  
 }  
}   

output {  
 elasticsearch {  
     hosts => "elasticsearch:9200"  
     index => "store"  
     document_type => "store_logs"  
 }  
}  
```

ii) Save the above `logstash.conf` inside a directory named as `{SAMPLE_ROOT}\pipeline`
     
iii) Start the logstash container, replace the {SAMPLE_ROOT} with your directory name
     
```
$ docker run -h logstash --name logstash --link elasticsearch:elasticsearch \
-it --rm -v ~/{SAMPLE_ROOT}/pipeline:/usr/share/logstash/pipeline/ \
-p 5044:5044 docker.elastic.co/logstash/logstash:6.2.2
```
  
 - Configure filebeat to ship the ballerina logs
    
i) Create a file named `filebeat.yml` with the following content
```
filebeat.prospectors:
- type: log
  paths:
    - /usr/share/filebeat/ballerina.log
output.logstash:
  hosts: ["logstash:5044"]  
```
NOTE : Modify the ownership of filebeat.yml file using `$chmod go-w filebeat.yml` 

ii) Save the above `filebeat.yml` inside a directory named as `{SAMPLE_ROOT}\filebeat`   
        
iii) Start the logstash container, replace the {SAMPLE_ROOT} with your directory name
     
```
$ docker run -v {SAMPLE_ROOT}/filbeat/filebeat.yml:/usr/share/filebeat/filebeat.yml \
-v {SAMPLE_ROOT}/guide/grpc_service/ballerina.log:/usr/share\
/filebeat/ballerina.log --link logstash:logstash docker.elastic.co/beats/filebeat:6.2.2
```
 
 - Access Kibana to visualize the logs using following URL
```
   http://localhost:5601 
```
  
