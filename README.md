# Mobile App Data Fetching with Caching and Retry Mechanism

## Overview
This repository demonstrates a robust data-fetching solution for a Flutter mobile app. The solution includes caching, handling API timeouts, retries, and error management to ensure a smooth user experience even in adverse network conditions.

## Key Features

- Caching: Utilizes local storage to provide cached data when there is no internet connection.
- Timeout Handling: Configures requests to avoid infinite waiting times by applying a timeout.
- Retry Mechanism: Implements a retry logic to handle transient errors with up to three retries.
- Error Handling: Gracefully handles API errors and informs the user through the UI.

# Implementation Details
## Caching Data
When the app is offline, it retrieves data from a local cache using the Hive package. Cached responses include HTTP data and metadata such as ETag or Last-Modified headers.

## Timeout Handling
To prevent indefinite waits, the requests are configured with a timeout duration. If the API does not respond within this period, the request is terminated.

## Retry Mechanism
The system retries failed requests up to three times before returning an error. This helps in handling temporary issues with the API or network.

## Error Handling
The app is designed to handle various types of API errors, including client errors and timeout exceptions. The UI displays appropriate messages based on the error type.

