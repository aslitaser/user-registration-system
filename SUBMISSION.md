# User Registration System Submission

## Implementation Details

### 1. User Registration
- Implemented user registration using Ruby on Rails with a PostgreSQL database.
- User model includes email, password (securely hashed), first name, last name, and confirmation details.
- Registration process includes email format validation and password complexity requirements.
- Upon successful registration, a confirmation token is generated and stored.

### 2. Confirmation Email
- Utilized ActionMailer for creating and sending confirmation emails.
- Implemented an asynchronous email sending process using Sidekiq and RabbitMQ.
- Confirmation emails include a unique token for account verification.

### 3. Reminder Email
- Created a ReminderEmailWorker using Sidekiq for sending reminder emails.
- Implemented a scheduled job that runs every hour to check for unconfirmed accounts.
- Reminder emails are sent to users who haven't confirmed their accounts within 24 hours of registration.

### 4. Redis Integration
- Integrated Redis for caching frequently accessed user data.
- Implemented caching for user profiles to reduce database queries.
- Utilized Redis as a backend for Sidekiq job processing.

### 5. RabbitMQ Usage
- Implemented RabbitMQ for reliable message queuing in the email sending process.
- Used RabbitMQ to decouple the user registration process from email sending, improving system responsiveness.

### 6. Sidekiq Integration
- Integrated Sidekiq for background job processing, particularly for email sending tasks.
- Implemented Sidekiq Scheduler for running the reminder email job at regular intervals.

## Design Decisions

1. **Asynchronous Processing**: Chose to process emails asynchronously to improve user experience and system performance.
2. **Token-based Confirmation**: Implemented a token-based email confirmation system for security.
3. **Caching Strategy**: Decided to cache user profiles to reduce database load for frequently accessed data.
4. **Rate Limiting**: Implemented basic rate limiting to prevent abuse of the registration system.

## Testing Strategy

- Implemented unit tests for models, focusing on validations and business logic.
- Created integration tests for controllers to ensure proper handling of requests and responses.
- Developed system tests to verify end-to-end functionality of the registration process.
- Implemented specific tests for background jobs and mailers.
- Utilized FactoryBot for creating test data and RSpec for running tests.

## Performance Considerations

1. **Caching**: Implemented caching of user profiles to reduce database queries.
2. **Background Processing**: Utilized Sidekiq for handling time-consuming tasks asynchronously.
3. **Database Indexing**: Added appropriate indexes to the users table for faster query performance.

## Security Measures

1. **Password Security**: Implemented secure password hashing using bcrypt.
2. **Email Confirmation**: Required email confirmation to activate accounts.
3. **Rate Limiting**: Basic rate limiting to prevent brute force attacks.
4. **Secure Communications**: Configured the application to use HTTPS in production.
5. **Input Validation**: Implemented strong parameters and model-level validations.

## Scalability

1. **Stateless Application**: Designed the application to be stateless, allowing for horizontal scaling.
2. **Background Job Processing**: Use of Sidekiq allows for easy scaling of background processing.
3. **Caching**: Redis caching implementation helps in reducing database load as the user base grows.
4. **Message Queuing**: RabbitMQ usage allows for better handling of increased email sending loads.
