Given("I have a sensor named {string} which is healthy") do |sensor_name|
  @service.get_sensor(sensor_name).set_health_status!(true)
end

Given("I have a sensor named {string} which is unhealthy") do |sensor_name|
  @service.get_sensor(sensor_name).set_health_status!(false)
end

Given("I have a sensor named {string}") do |sensor_name|
  @sensor = @service.get_sensor(sensor_name)
end

Given("the sensor is healthy") do
  @sensor.set_health_status!(true)
end

Given("the sensor has a heartbeat interval of {int} seconds") do |interval|
  @sensor.set_heartbeat_interval! interval
end

When("I wait {int} seconds") do |duration|
  $stdout.puts "Sleeping for #{duration} seconds..."
  sleep duration
end