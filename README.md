# 🔐 Secure Password Manager – Backend

> Depends on the frontend part : [https://github.com/Thynkon/password-manager-api](https://github.com/NATSIIRT/HEIGVD_WEB_PROJECT_FRONTEND)

> [!NOTE]  
> In a real-world case, the master key should be stored in a password manager, not as plain text in the README!

## Using docker

In order to be able to use this api, all you need to do is to type the following command:

```sh
RAILS_MASTER_KEY=6af8def2059cb625408b19bdcd19fdbc docker compose up --build
```

And then, you can access it throught: `http://localhost:3000`

## Natively

### Requirements

First, make sure you have ruby installed.

The easiest-way is throught **asdf**
First install it by [reading the official docs](https://asdf-vm.com/guide/getting-started.html).

Then, add the ruby plugin:

```sh
asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git
```

Finally, install ruby.

```sh
 asdf install ruby 3.4.3
 asdf set ruby 3.4.3
```

### Setup

First, create the file `config/master.key` and add to it:
```txt
6af8def2059cb625408b19bdcd19fdbc
```

This is the way ruby on rails handles credentials. It encrypts a yml file with the master key. Those credentials can then be accessed from the ruby on rails app. In there, we stored the hmac used to generate the `JWT` tokens.

Install the project's dependencies:

```sh
bundle install
```


Then, run the db migrations:

```sh
./bin/rails db:migrate
```

Finally, run the server:

```sh
./bin/rails server
```

## Docs

A swagger-like documentation (for the api routes) can be consulted at:

`http://localhost:3000/api-docs`
