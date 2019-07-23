# Service Health Registry
Simple, flexible, client-driven service/application health monitoring.

# Purpose
Many third party monitoring solutions rely on "clunky" agents, or require the service/application to be accessible from the monitoring node. 

The latter is OK in an internal environment, but what if the application you want to monitor is in a remote network that doesn't have a static public IP address? Or if it is otherwise not routable? What if the application is running on an operating system that is not supported by your monitoring system? That's where this app comes in.

Simply run your health checks in whatever way you'd like and then send a POST request to the service's sensor's endpoint. The service status can then be queried by querying the sensor's `/get/` endpoint via HTTP. Simple!

# Installation
1) Deploy a container from the latest docker image (`xtrasimplicity/service-health-registry:latest`)

2) Set the `ADMIN_AUTH_TOKEN` environment variable to something secure. You'll need to use this when registering new applications/services.

3) Take a look at the `docker-compose.yml` file in this repository as an example of how to start the server.

4) Start the server. **Note**: Remember to put it behind a reverse proxy with SSL, if deploying to production!

# Usage
More detailed instructions coming soon. For now, please take a look at the following snippets, and the Cucumber features in `features/` for more info.

### Register a service
```bash
curl -X POST \
  'http://localhost:4567/register_service?name=MyService' \
  -H 'X-AuthToken: MySecretAuthToken'
```

If the service doesn't exist, it'll return a JSON object with a service-specific Authentication token that you'll need to use to update sensors for this service:
```bash
{"status":"ok","AuthToken":"8a80beea740b0a12253fed2c"}
```

### Update a sensor
```bash
curl -X POST \
  'http://localhost:4567/set/MyService/uptime?status=unhealthy' \
  -H 'X-AuthToken: 8a80beea740b0a12253fed2c'
```

### Query a sensor
```bash
curl -X GET \
  http://localhost:4567/get/MyService/uptime

# Response
{"status":"error","message":"sensor is unhealthy"}
```
In addition to the JSON response, the server will also return different HTTP status codes to denote different scenarios. A HTTP response code of `422` denotes that the sensor is **unhealthy**, whereas a HTTP status code of `200` denotes that the sensor is **healthy**.

