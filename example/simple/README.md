# Very basic and simple example of using Hoth

This is a very simple example of using Hoth. It shows you how to define a module (math)
and a service (addition) using a very basic RackProvider. It also demonstrates how Hoth 
choose if it should invoke the service by a remote call or locally (this works by
looking for a local implementation of the service, see `simple_client.rb`).

To run this example you need to start the RackProvider first:

    cd example/simple
    rackup simple_provider.ru
    
Next: Run the client:

    ruby simple_client.rb
    
Have fun!
