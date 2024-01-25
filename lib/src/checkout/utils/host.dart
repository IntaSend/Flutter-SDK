// String representing the live host URL
String liveHost = "https://websdk.intasend.com/?";

// String representing the test (sandbox) host URL
String testHost = "https://websdk-sandbox.intasend.com/?";

// Function to determine the host URL based on whether it is a test environment
String host({required bool isTest}) =>
    // Using the ternary operator to conditionally select the host URL
    isTest ? testHost : liveHost;
