# Experiment: Machine learning in Nix

This introduce how can nix could be used to manage a machine learning application.
This example consists in a convolutional neural network trained on mnist numbers with Keras, that is then used in a flask application that recognize digits.


## Model

The model consists in a simple keras file. The model can be build with the `model.nix` nix expression.

Using nix here bring a few advantages:

- Modularity: It is easy to change the backend or the number of epochs to build.
- Determinism: Builds are reproducible. 
- Dependencies: Nix handle the dependencies automatically for us, there is no need to install TensorFlow or Theano.
- Distributed builds: Nix builds can be distributed on remote machines, this could be used to build the model on a machine with enough power.
- Continuous integration: Hydra, the nix CI tool can be used to build our model.


### Building the model

Building the model with default values (tensorflow backend, 10 epoch):

```sh
$ nix-build -A model
```

`default.nix` also defines a few other model variations.

Else `nix-build -E` can be used to directly override the parameters:

```sh
$ nix-build -E 'with import ./.; model.override { epochs = 5; }'
```


## Frontend

The frontend consists in a simple flask application using Keras to serve a trained model.


## Running the frontend

Running the frontend from command line:

```sh
$ MODEL=$(nix-build -A model)/model.h5 $(nix-build -A frontend)/bin/cnn-mnist
```


## NixOS module

NixOS is a linux distribution based on Nix, it has a declarative approach that allow to abstract complex configurations.
Custom NixOS modules are very easy to create and use, for example `module.nix` defines a NixOS module for the frontend application.

This module can be imported in the main NixOS configuration file, `configuration.nix`, and used.
The following code imports the module and enable the frontend application (`cnn-mnist`).

```nix
  imports = [ /PATH/TO/MODULE/FILE/module.nix ];

  services.cnn-mnist.enable = true;
```

The module defines a few more configuration options that can be used to customize the way the application is run:

- port: The port to listen onto
- host: The application host
- backend: Which backend to use, theano or tensorflow
- model: Which model file to use

NixOS module system is very expressive, the following snippet is all that is needed to run our frontend behind a nginx reverse proxy:


```nix
  services.cnn-mnist = {
    enable  = true;
    port    = 8000;
    backend = "theano";
  };

  # Opening port 80
  networking.firewall.allowedTCPPorts = [ 80 ];
  
  # Nginx frontend 
  services.nginx = {
    enable = true;
    httpConfig = ''
      server {
        listen 80;
        location / {
          proxy_pass          http://127.0.0.1:8000;
          proxy_http_version  1.1;
        }
      }
    '';
  };
```

### Deployment

NixOps, a tool to deploy NixOS configurations can be used to deploy our application to a server.

The `nixops-deployment.nix` file defines a virtualbox deployment file, that can be rnu with the following commands:

```
$ nixops create -d cnn-mnist nixops-deployment.nix
$ nixops deploy -d cnn-mnist
```


# Thanks & Inspiration

- Siraj Raval - [How to Deploy Keras Models to Production](https://www.youtube.com/watch?v=f6Bf3gl4hWY)
- Francois Chollet - [Keras Examples](https://github.com/fchollet/keras/tree/master/examples)
