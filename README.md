# Food Order - Full Project

This is the **Food Order** application, designed to support a food ordering system for hotel services. It allows customers to browse food items, place orders, and track their order statuses. Hotel staff can manage orders, food items, and customers through a dedicated management interface. The project consists of a **frontend** for both customer and hotel management views and a **backend** that handles API requests, business logic, and database operations.

## Features

### Frontend

The frontend provides the following features:

- **Authentication**: Customer and admin login.
- **Customer Interface**:
  - Browse and search food items.
  - Add items to a cart and place orders.
  - View order history and track order statuses.
  - Mark favorite items for easy access.
- **Admin Interface (Back Office)**:
  - Manage food items (add, update, delete).
  - Manage customer orders (view, update statuses).
  - View customer profiles and activity.

### Backend

The backend supports the following features:

- **Authentication**: Role-based JWT authentication (customer, manager, admin).
- **Order Management**: Handle customer orders, track statuses, and maintain order history.
- **Product Management**: Add, update, delete, and filter food items.
- **Customer Management**: Manage customer profiles and retrieve their order history.
- **Reporting**: Generate statistics on orders, customer activity, and popular items.

## Technologies

### Frontend

- **Flutter**: Used for building cross-platform user interfaces (iOS, Android, Web).
- **Dart**: The programming language used with Flutter.

### Backend

- **Java 17**: Used for backend development.
- **Spring Boot**: Framework for rapid API creation and server-side logic.
- **MongoDB**: NoSQL database for storing food items, orders, and customer data.
- **Spring Security**: Used for authentication and role-based access control.
- **Maven**: For project build and dependency management.

## Setup Instructions

### Prerequisites

Ensure you have the following installed:

- **Java 17** (for backend)
- **Maven** (for backend)
- **MongoDB** (local or cloud instance for backend)
- **Flutter SDK** (for frontend)
- **Postman** (optional, for API testing)

### Backend Setup

1. Clone the backend repository:

   ```bash
   git clone https://github.com/your-username/food-order-backend.git
   cd food-order-backend

2. Install dependencies and build the project:
   ```bash
   mvn clean install

3. Configure MongoDB in the application.properties file if using a remote MongoDB server.

4. Run the backend:
   ```bash
   mvn spring-boot:run

The backend will run on http://localhost:8080.


## Frontend Setup

1. Clone the frontend repository:
   ```bash
   git clone https://github.com/your-username/food-order-frontend.git
   cd food-order-frontend


2. Install dependencies:
   ```bash
   flutter pub get

3. Run the frontend:
   ```bash
   flutter run -d chrome --web-port=50948
   
The frontend will run on the specified web port.


## Testing APIs
You can use Postman to test backend APIs:

1. Import the Postman collection (food-order.postman_collection.json).

2. Set the base URL to http://localhost:8080.

3. For protected routes, add the following header:
   ```bash
   Authorization: Bearer <your-jwt-token>

## Future Enhancements

Online Payments: Add payment gateways (Stripe, PayPal) for processing orders.
User Feedback: Enable customers to provide feedback and ratings for food items.
Reservation System: Extend the system to handle room reservations for hotels.


## License
This project is licensed under the MIT License.

### Notes:
- This README is structured for both **frontend** and **backend** components, explaining the project as a whole.
- Replace the placeholder URLs with the actual repository links you have on GitHub.
- You can also add screenshots or additional images for each feature (e.g., customer interface, admin interface) under the "Features" section if needed.

This combined README is ready to be used for your project on GitHub!
