# Service Health Registry
Simple, flexible, client-driven service/application health monitoring.

# Purpose
Many third party monitoring solutions rely on "clunky" agents, or require the service/application to be accessible from the monitoring node. 

The latter is OK in an internal environment, but what if the application you want to monitor is in a remote network that doesn't have a static public IP address? Or if it is otherwise not routable? What if the application is running on an operating system that is not supported by your monitoring system? That's where this app comes in.

Simply run your health checks in whatever way you'd like and then send a POST request to the service's sensor's endpoint. The service status can then be queried by querying the sensor's `/get/` endpoint via HTTP. Simple!

# Installation
1) Deploy a container from the latest docker image (`xtrasimplicity/service-health-registry:latest`)
2) Set the `ADMIN_AUTH_TOKEN` environment variable to something secure. You'll need to use this when registering new applications/services.

# Usage
Instructions coming soon. For now, please take a look at the Cucumber features in `features/`.