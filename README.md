# Atlas Explorer – Flutter Assessment

A Flutter application built using **GetX** for state management and **Dio** for API communication. The application contains two modules: Country Explorer and User Directory.

## Features

### 1. Country Explorer
- Fetch country information using the Countries GraphQL API.
- Display country name, country code, capital, and continent.
- Search countries by name.
- View detailed country information.
- Handle nullable fields such as capital.
- Display loading, error, and empty states where implemented.

### 2. User Directory
- Fetch user information from the JSONPlaceholder REST API.
- Display user name, email, phone number, and company.
- Search users by name.
- View user details.
- Fetch and display posts for a selected user.
- Display loading and error states where implemented.

## Technologies Used

- Flutter
- Dart
- GetX – State management and dependency injection
- Dio – HTTP requests
- GraphQL – Country data
- REST API – User and post data
- Flutter Test – Automated testing

## APIs Used

**Countries GraphQL API**

`https://countries.trevorblades.com/`

**JSONPlaceholder REST API**

- Users: `https://jsonplaceholder.typicode.com/users`
- User posts: `https://jsonplaceholder.typicode.com/posts?userId=1`
- Post details: `https://jsonplaceholder.typicode.com/posts/1`

## Project Architecture

The project follows a feature-based structure with separation between UI, controllers, repositories, models, and network-related code.

```text
lib/
├── core/
│   ├── errors/
│   ├── network/
│   └── widgets/
├── features/
│   ├── countries/
│   │   ├── data/
│   │   ├── logic/
│   │   └── presentation/
│   ├── users/
│   │   ├── data/
│   │   ├── logic/
│   │   └── presentation/
│   └── home/
│       └── presentation/
└── main.dart

test/
```

## Getting Started

### Prerequisites
- Flutter SDK
- Dart SDK
- Android Studio or VS Code
- An emulator, simulator, or connected device

### Installation

1. Clone the repository:

   ```bash
   git clone (https://github.com/Karthika2623/flutter-assessment_tasks.git)
   ```

2. Navigate to the project directory:

   ```bash
   cd flutter_assesment_tasks
   ```

3. Install dependencies:

   ```bash
   flutter pub get
   ```

4. Run the application:

   ```bash
   flutter run
   ```

### Run Tests

```bash
flutter test
```

### Analyze the Project

```bash
flutter analyze
```

## Screenshots

Add screenshots of the following screens to demonstrate the application:


https://github.com/user-attachments/assets/fa8289d6-dfea-4356-8bdc-d996ed442dff





- Country list and search
- Country details
- User list and search
- User details and posts

## Error Handling

The application is designed to handle API loading and error states, empty results, and nullable country fields where implemented.

## Author

Flutter Developer

## License

This project was created for a Flutter developer assessment.
