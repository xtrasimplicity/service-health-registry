Given("I have a sensor named {string} which is healthy") do |sensor_name|
  @service.get_sensor(sensor_name).set_health_status!(true)
end

Given("I have a sensor named {string} which is unhealthy") do |sensor_name|
  @service.get_sensor(sensor_name).set_health_status!(false)
end