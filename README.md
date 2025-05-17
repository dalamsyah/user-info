# User Information System

[![Download APK](https://img.shields.io/badge/Download-APK-brightgreen)](user-info.apk)

There are two projects in this repository:
1. **user-info-api** - Backend API built with Laravel 12
2. **user_info_mobile** - Mobile application built with Flutter 3.29.3

## Quick Start

### Backend Setup (user-info-api)

1. Navigate to the backend directory:
```bash
cd user-info-api
```

2. Install PHP dependencies:
```bash
composer install
```

3. Set up your environment variables by copying the example file:
```bash
cp .env.example .env
```

4. Configure your `.env` file with the following settings:

```
# Database Configuration
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=user_info_api
DB_USERNAME=root
DB_PASSWORD=xx

# Email Configuration
MAIL_MAILER=smtp
MAIL_HOST=live.smtp.mailtrap.io
MAIL_PORT=587
MAIL_USERNAME=api
MAIL_PASSWORD=46xxx

# Sanctum Configuration
SANCTUM_STATEFUL_DOMAINS=123xx.com
```

5. Generate application key:
```bash
php artisan key:generate
```

6. Run database migrations:
```bash
php artisan migrate
```

7. Start the development server:
```bash
php artisan serve
```

The API will be available at `http://localhost:8000`.

### Mobile App Setup (user_info_mobile)

1. Navigate to the mobile app directory:
```bash
cd user_info_mobile
```

2. Install Flutter dependencies:
```bash
flutter pub get
```

3. Update the API base URL in the constants file:
   - Open `lib/core/util/constants.dart`
   - Find the `baseUrl` variable and update it to match your backend server
   - Example: `static const String baseUrl = 'http://10.0.2.2:8000/api';` (for Android emulator)
 

4. Run the app:
```bash
flutter run
```


## Requirements

### Backend
- PHP 8.2+
- Composer
- MySQL 5.7+ or MariaDB 10.2+
- Laravel 12

### Mobile
- Flutter 3.29.3
- Dart SDK
- Android Studio / Xcode

## Troubleshooting

### Backend

- If you encounter database connection issues, make sure your MySQL/MariaDB server is running and the credentials in `.env` are correct.
- For email configuration problems, verify your SMTP settings in the `.env` file.

### Mobile App

- If the app cannot connect to the API, check that the `baseUrl` in `constants.dart` points to your running backend server.
- For Android emulators, use `10.0.2.2` instead of `localhost` to access your local machine.
- For iOS simulators, use `localhost` or `127.0.0.1`.

