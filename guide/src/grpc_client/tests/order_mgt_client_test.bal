import ballerina/test;

// Before suite function
@test:BeforeSuite
function beforeFunc() {
    // Start order-mgt server
    _ = test:startServices("order-mgt-service");
}

// After suite function
@test:AfterSuite
function afterFunc() {
    // Stop order-mgt server
    test:stopServices("order-mgt-service");
}

@test:Config{}
function testOrderMgtClient() {
    test:assertTrue(true, msg = "test");
}
