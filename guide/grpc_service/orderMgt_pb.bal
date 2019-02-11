// NOTE: This is an auto generated stub based on service definition in `orderMgt.proto` file.
import ballerina/grpc;

public type orderMgtBlockingClient client object {
    private grpc:Client grpcClient = new;
    private grpc:ClientEndpointConfig config = {};
    private string url;

    function __init(string url, grpc:ClientEndpointConfig? config = ()) {
        self.config = config ?: {};
        self.url = url;
        // initialize client endpoint.
        grpc:Client c = new;
        c.init(self.url, self.config);
        error? result = c.initStub("blocking", ROOT_DESCRIPTOR, getDescriptorMap());
        if (result is error) {
            panic result;
        } else {
            self.grpcClient = c;
        }
    }

    remote function findOrder(string req, grpc:Headers? headers = ()) returns ((string, grpc:Headers)|error) {
        
        var payload = check self.grpcClient->blockingExecute("grpc_service.orderMgt/findOrder", req, headers = headers);
        grpc:Headers resHeaders = new;
        any result = ();
        (result, resHeaders) = payload;
        return (string.convert(result), resHeaders);
    }

    remote function addOrder(orderInfo req, grpc:Headers? headers = ()) returns ((string, grpc:Headers)|error) {
        
        var payload = check self.grpcClient->blockingExecute("grpc_service.orderMgt/addOrder", req, headers = headers);
        grpc:Headers resHeaders = new;
        any result = ();
        (result, resHeaders) = payload;
        return (string.convert(result), resHeaders);
    }

    remote function updateOrder(orderInfo req, grpc:Headers? headers = ()) returns ((string, grpc:Headers)|error) {
        
        var payload = check self.grpcClient->blockingExecute("grpc_service.orderMgt/updateOrder", req, headers = headers);
        grpc:Headers resHeaders = new;
        any result = ();
        (result, resHeaders) = payload;
        return (string.convert(result), resHeaders);
    }

    remote function cancelOrder(string req, grpc:Headers? headers = ()) returns ((string, grpc:Headers)|error) {
        
        var payload = check self.grpcClient->blockingExecute("grpc_service.orderMgt/cancelOrder", req, headers = headers);
        grpc:Headers resHeaders = new;
        any result = ();
        (result, resHeaders) = payload;
        return (string.convert(result), resHeaders);
    }
};

public type orderMgtClient client object {
    private grpc:Client grpcClient = new;
    private grpc:ClientEndpointConfig config = {};
    private string url;

    function __init(string url, grpc:ClientEndpointConfig? config = ()) {
        self.config = config ?: {};
        self.url = url;
        // initialize client endpoint.
        grpc:Client c = new;
        c.init(self.url, self.config);
        error? result = c.initStub("non-blocking", ROOT_DESCRIPTOR, getDescriptorMap());
        if (result is error) {
            panic result;
        } else {
            self.grpcClient = c;
        }
    }

    remote function findOrder(string req, service msgListener, grpc:Headers? headers = ()) returns (error?) {
        
        return self.grpcClient->nonBlockingExecute("grpc_service.orderMgt/findOrder", req, msgListener, headers = headers);
    }

    remote function addOrder(orderInfo req, service msgListener, grpc:Headers? headers = ()) returns (error?) {
        
        return self.grpcClient->nonBlockingExecute("grpc_service.orderMgt/addOrder", req, msgListener, headers = headers);
    }

    remote function updateOrder(orderInfo req, service msgListener, grpc:Headers? headers = ()) returns (error?) {
        
        return self.grpcClient->nonBlockingExecute("grpc_service.orderMgt/updateOrder", req, msgListener, headers = headers);
    }

    remote function cancelOrder(string req, service msgListener, grpc:Headers? headers = ()) returns (error?) {
        
        return self.grpcClient->nonBlockingExecute("grpc_service.orderMgt/cancelOrder", req, msgListener, headers = headers);
    }
};

type orderInfo record {
    string id;
    string name;
    string description;
    !...;
};

const string ROOT_DESCRIPTOR = "0A0E6F726465724D67742E70726F746F120C677270635F736572766963651A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F22510A096F72646572496E666F120E0A0269641801200128095202696412120A046E616D6518022001280952046E616D6512200A0B6465736372697074696F6E180320012809520B6465736372697074696F6E32A7020A086F726465724D677412470A0966696E644F72646572121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C756512410A086164644F7264657212172E677270635F736572766963652E6F72646572496E666F1A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C756512440A0B7570646174654F7264657212172E677270635F736572766963652E6F72646572496E666F1A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C756512490A0B63616E63656C4F72646572121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C7565620670726F746F33";
function getDescriptorMap() returns map<string> {
    return {
        "orderMgt.proto":"0A0E6F726465724D67742E70726F746F120C677270635F736572766963651A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F22510A096F72646572496E666F120E0A0269641801200128095202696412120A046E616D6518022001280952046E616D6512200A0B6465736372697074696F6E180320012809520B6465736372697074696F6E32A7020A086F726465724D677412470A0966696E644F72646572121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C756512410A086164644F7264657212172E677270635F736572766963652E6F72646572496E666F1A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C756512440A0B7570646174654F7264657212172E677270635F736572766963652E6F72646572496E666F1A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C756512490A0B63616E63656C4F72646572121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C7565620670726F746F33",
        "google/protobuf/wrappers.proto":"0A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F120F676F6F676C652E70726F746F62756622230A0B446F75626C6556616C756512140A0576616C7565180120012801520576616C756522220A0A466C6F617456616C756512140A0576616C7565180120012802520576616C756522220A0A496E74363456616C756512140A0576616C7565180120012803520576616C756522230A0B55496E74363456616C756512140A0576616C7565180120012804520576616C756522220A0A496E74333256616C756512140A0576616C7565180120012805520576616C756522230A0B55496E74333256616C756512140A0576616C756518012001280D520576616C756522210A09426F6F6C56616C756512140A0576616C7565180120012808520576616C756522230A0B537472696E6756616C756512140A0576616C7565180120012809520576616C756522220A0A427974657356616C756512140A0576616C756518012001280C520576616C756542570A13636F6D2E676F6F676C652E70726F746F627566420D577261707065727350726F746F50015A057479706573F80101A20203475042AA021E476F6F676C652E50726F746F6275662E57656C6C4B6E6F776E5479706573620670726F746F33"
        
    };
}
