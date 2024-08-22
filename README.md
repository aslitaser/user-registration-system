# User Registration System

## Introduction

This User Registration System is a Ruby on Rails application that handles user registration with email confirmation and reminder functionality. It uses background job processing for handling emails asynchronously and implements caching for improved performance.

Key Features:
- User registration with email and password
- Asynchronous email confirmation
- Automated reminder emails for unconfirmed accounts after 24 hours
- Rate limiting for security
- Caching for performance optimization

## System Architecture

The system is built using the following technologies:

- Ruby on Rails 7.2.0
- PostgreSQL (for primary database)
- Redis (for caching and Sidekiq backend)
- RabbitMQ (for message queuing)
- Sidekiq (for background job processing)
- Sidekiq-scheduler (for scheduling reminder emails)

## Prerequisites

Ensure you have the following installed:

- Ruby 3.3.4
- Rails 7.2.0
- PostgreSQL 12 or newer
- Redis 6 or newer
- RabbitMQ 3.8 or newer

## Installation

1. Clone the repository:
   ```
   git clone https://github.com/yourusername/user-registration-system.git
   cd user-registration-system
   ```

2. Install dependencies:
   ```
   bundle install
   ```

3. Set up the database:
   ```
   rails db:create db:migrate
   ```

## Configuration

1. Set up environment variables in a `.env` file:
   ```
   DATABASE_URL=postgresql://username:password@localhost/database_name
   REDIS_URL=redis://localhost:6379/1
   RABBITMQ_URL=amqp://localhost:5672
   MAILER_SENDER=noreply@yourapp.com
   ```

2. Configure Action Mailer in `config/environments/development.rb` and `production.rb`.

## Running the Application

1. Start Redis:
   ```
   redis-server
   ```

2. Start RabbitMQ:
   ```
   rabbitmq-server
   ```

3. Start Sidekiq:
   ```
   bundle exec sidekiq
   ```

4. Start the Rails server:
   ```
   rails server
   ```

The application will be available at `http://localhost:3000`.

## Testing

Run the test suite with:

```
bundle exec rspec
```

## Background Jobs

Sidekiq processes background jobs. The Sidekiq web interface is available at `http://localhost:3000/sidekiq`.

## Key Components

1. User Model (`app/models/user.rb`): Handles user data and validations.
2. Registrations Controller (`app/controllers/registrations_controller.rb`): Manages user registration.
3. User Mailer (`app/mailers/user_mailer.rb`): Defines confirmation and reminder emails.
4. Email Worker (`app/workers/email_worker.rb`): Processes email sending jobs.
5. Reminder Email Worker (`app/workers/reminder_email_worker.rb`): Sends reminder emails to unconfirmed users.
6. Sidekiq Configuration (`config/initializers/sidekiq.rb`): Sets up Sidekiq with Redis and RabbitMQ.

## Caching

User profiles are cached using Redis to improve performance. See the `cached_profile` method in the User model.

## Rate Limiting

Basic rate limiting is implemented in the Application Controller to prevent abuse.