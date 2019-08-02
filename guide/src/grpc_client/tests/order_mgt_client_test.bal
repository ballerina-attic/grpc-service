import ballerina/io;
import ballerina/test;

// Before suite function
@test:BeforeSuite
function beforeFunc() {
    // Start chat server
    _ = test:startServices("order-mgt-service");
}

// After suite function
@test:AfterSuite
function afterFunc() {
    // Stop chat server
    test:stopServices("order-mgt-service");
}

@test:Config{}
function testChatServer() {
    test:assertTrue(true, msg = "test");
}
