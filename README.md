# Secrets API

> A minimal Ruby on Rails API that provides JWT-based authentication and allows users to store and manage encrypted secrets.

---

## 🚀 Overview

This API enables:

* User registration and login using JWT tokens
* Secure secret storage per user
* Swagger-powered API documentation

---

## 🔐 Security Disclaimer

> \[!WARNING]
> The `RAILS_MASTER_KEY` provided below is **for development purposes only**.
> In a real-world case, **never store secrets in plain text** or in version control. Use a password manager or secret manager (e.g., HashiCorp Vault, 1Password, Doppler).

---

## 🐳 Using Docker

To run the app with Docker:

```sh
RAILS_MASTER_KEY=6af8def2059cb625408b19bdcd19fdbc docker compose up --build
```

Then visit: [http://localhost:3000](http://localhost:3000)

---

## 💻 Running Natively

### ✅ Requirements

You need Ruby installed. The recommended way is via [`asdf`](https://asdf-vm.com/guide/getting-started.html):

```sh
asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git
asdf install ruby 3.4.3
asdf global ruby 3.4.3
```

---

### 🔧 Setup Instructions

1. Create the master key file:

```sh
echo "6af8def2059cb625408b19bdcd19fdbc" > config/master.key
```

This allows Rails to decrypt `config/credentials.yml.enc` (which contains the JWT HMAC secret).

2. Install dependencies:

```sh
bundle install
```

3. Create and migrate the database:

```sh
./bin/rails db:create db:migrate
```

4. (Optional) Seed example data:

```sh
./bin/rails db:seed
```

5. Run the server:

```sh
./bin/rails server
```

Now visit: [http://localhost:3000](http://localhost:3000)

---

## 🔑 Authentication

This API uses **JWT (JSON Web Token)** for authentication.

### How it works:

1. **Register a user**
   `POST /users` with `{ username, password }`

2. **Login**
   `POST /login` with `{ username, password }`
   → returns `{ token, sym_key_salt }`

3. **Access protected routes**
   Add this header:

```
Authorization: Bearer <your-token>
```

---

## 📘 API Documentation

The Swagger-style interactive docs are available at:

👉 [http://localhost:3000/api-docs](http://localhost:3000/api-docs)

### Update the Swagger file:

If you change your API specs, regenerate the OpenAPI JSON with:

```sh
bundle exec rake rswag:specs:swaggerize
```

This will generate `swagger/v1/swagger.json` from your RSpec integration tests.
