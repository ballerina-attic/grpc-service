// NOTE: This is an auto generated client stub which is used to connect to gRPC server.

import ballerina/grpc;
import ballerina/io;

// Blocking client.
public type order_mgtBlockingStub object {

    public {
        grpc:Client clientEndpoint;
        grpc:Stub stub;
    }

    function initStub (grpc:Client clientEndpoint) {
        grpc:Stub navStub = new;
        navStub.initStub(clientEndpoint, "blocking", DESCRIPTOR_KEY, descriptorMap);
        self.stub = navStub;
    }

    function findOrder (string req, grpc:Headers... headers) returns ((string, grpc:Headers)|error) {

        var unionResp = self.stub.blockingExecute("order_mgt/findOrder", req, ...headers);
        match unionResp {
            error payloadError => {
                return payloadError;
            }
            (any, grpc:Headers) payload => {
                any result;
                grpc:Headers resHeaders;
                (result, resHeaders) = payload;
                return (<string>result, resHeaders);
            }
        }
    }

    function addOrder (newOrder req, grpc:Headers... headers) returns ((string, grpc:Headers)|error) {

        var unionResp = self.stub.blockingExecute("order_mgt/addOrder", req, ...headers);
        match unionResp {
            error payloadError => {
                return payloadError;
            }
            (any, grpc:Headers) payload => {
                any result;
                grpc:Headers resHeaders;
                (result, resHeaders) = payload;
                return (<string>result, resHeaders);
            }
        }
    }

    function updateOrder (newOrder req, grpc:Headers... headers) returns ((string, grpc:Headers)|error) {

        var unionResp = self.stub.blockingExecute("order_mgt/updateOrder", req, ...headers);
        match unionResp {
            error payloadError => {
                return payloadError;
            }
            (any, grpc:Headers) payload => {
                any result;
                grpc:Headers resHeaders;
                (result, resHeaders) = payload;
                return (<string>result, resHeaders);
            }
        }
    }

    function cancelOrder (string req, grpc:Headers... headers) returns ((string, grpc:Headers)|error) {

        var unionResp = self.stub.blockingExecute("order_mgt/cancelOrder", req, ...headers);
        match unionResp {
            error payloadError => {
                return payloadError;
            }
            (any, grpc:Headers) payload => {
                any result;
                grpc:Headers resHeaders;
                (result, resHeaders) = payload;
                return (<string>result, resHeaders);
            }
        }
    }

};

// Non-blocking client.
public type order_mgtStub object {

    public {
        grpc:Client clientEndpoint;
        grpc:Stub stub;
    }

    function initStub (grpc:Client clientEndpoint) {
        grpc:Stub navStub = new;
        navStub.initStub(clientEndpoint, "non-blocking", DESCRIPTOR_KEY, descriptorMap);
        self.stub = navStub;
    }

    function findOrder (string req, typedesc listener, grpc:Headers... headers) returns (error?) {
        return self.stub.nonBlockingExecute("order_mgt/findOrder", req, listener, ...headers);
    }

    function addOrder (newOrder req, typedesc listener, grpc:Headers... headers) returns (error?) {
        return self.stub.nonBlockingExecute("order_mgt/addOrder", req, listener, ...headers);
    }

    function updateOrder (newOrder req, typedesc listener, grpc:Headers... headers) returns (error?) {
        return self.stub.nonBlockingExecute("order_mgt/updateOrder", req, listener, ...headers);
    }

    function cancelOrder (string req, typedesc listener, grpc:Headers... headers) returns (error?) {
        return self.stub.nonBlockingExecute("order_mgt/cancelOrder", req, listener, ...headers);
    }

};

// Blocking endpoint.
public type order_mgtBlockingClient object {

    public {
        grpc:Client client;
        order_mgtBlockingStub stub;
    }

    public function init (grpc:ClientEndpointConfig config) {
        // initialize client endpoint.
        grpc:Client client = new;
        client.init(config);
        self.client = client;
        // initialize service stub.
        order_mgtBlockingStub stub = new;
        stub.initStub(client);
        self.stub = stub;
    }

    public function getCallerActions () returns (order_mgtBlockingStub) {
        return self.stub;
    }
};

//Non-blocking endpoint.
public type order_mgtClient object {

    public {
        grpc:Client client;
        order_mgtStub stub;
    }

    public function init (grpc:ClientEndpointConfig config) {
        // initialize client endpoint.
        grpc:Client client = new;
        client.init(config);
        self.client = client;
        // initialize service stub.
        order_mgtStub stub = new;
        stub.initStub(client);
        self.stub = stub;
    }

    public function getCallerActions () returns (order_mgtStub) {
        return self.stub;
    }
};

// Type definition.
type newOrder {
    string id;
    string name;
    string description;

};

@final string DESCRIPTOR_KEY = "order_mgt.proto";
map descriptorMap =
{
    "order_mgt.proto":"0A0F6F726465725F6D67742E70726F746F1A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F22500A086E65774F72646572120E0A0269641801200128095202696412120A046E616D6518022001280952046E616D6512200A0B6465736372697074696F6E180320012809520B6465736372697074696F6E328C020A096F726465725F6D677412470A0966696E644F72646572121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C756512330A086164644F7264657212092E6E65774F726465721A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C756512360A0B7570646174654F7264657212092E6E65774F726465721A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C756512490A0B63616E63656C4F72646572121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C7565620670726F746F33",

    "google.protobuf.wrappers.proto":"0A0E77726170706572732E70726F746F120F676F6F676C652E70726F746F62756622230A0B446F75626C6556616C756512140A0576616C7565180120012801520576616C756522220A0A466C6F617456616C756512140A0576616C7565180120012802520576616C756522220A0A496E74363456616C756512140A0576616C7565180120012803520576616C756522230A0B55496E74363456616C756512140A0576616C7565180120012804520576616C756522220A0A496E74333256616C756512140A0576616C7565180120012805520576616C756522230A0B55496E74333256616C756512140A0576616C756518012001280D520576616C756522210A09426F6F6C56616C756512140A0576616C7565180120012808520576616C756522230A0B537472696E6756616C756512140A0576616C7565180120012809520576616C756522220A0A427974657356616C756512140A0576616C756518012001280C520576616C756542570A13636F6D2E676F6F676C652E70726F746F627566420D577261707065727350726F746F50015A057479706573F80101A20203475042AA021E476F6F676C652E50726F746F6275662E57656C6C4B6E6F776E5479706573620670726F746F33"

};
