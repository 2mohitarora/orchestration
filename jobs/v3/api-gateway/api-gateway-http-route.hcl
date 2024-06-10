Kind = "http-route"
Name = "sample-api-http-route"

// Rules define how requests will be routed
Rules = [
  {
    Matches = [
      {
        Path = {
          Match = "prefix"
          Value = "/hello"
        }
      }
    ]
    Services = [
      {
        Name = "sample-api"
      }
    ]
  }
]

Parents = [
  {
    Kind        = "api-gateway"
    Name        = "api-gateway"
    SectionName = "api-gateway-http-listener"
  }
]