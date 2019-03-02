## grape-sneaker-example
Sample Grape API to illustrate Sneakers + Bunny inside a Grape API for background job processing with RabbitMQ

Sneakers allows you to subscribe to events in RabbitMQ, however it does not allow you to publish events on its own. We must use Bunny for publishing events for our sneaker worker to then digest and process

### Requirements

- Have RabbitMQ Installed on your development machine, I use all the default configurations for the connection

  - [Download Instructions]: https://www.rabbitmq.com/download.html

- Have MongoDB installed on your development machine (I used mongoDB for my DB layer, it is not required for background job processing, it is only for illustration, when background processing in an API you will more than likely need to interract with a DB

  - [Download Instructions]: https://docs.mongodb.com/manual/administration/install-community/

- Tested using Ruby 2.4.1

### Installation

```
bundle install
```

### Getting Started

The API code, and the sneakers worker run as two seperate processes on the machine, to start the API run the following from the root of the project

```
bundle exec rackup
```

to run the worker process run the following in a seperate terminal window

```
bundle exec ruby sneakers.rb
```

