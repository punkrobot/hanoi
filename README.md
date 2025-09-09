# Tower of Hanoi

A modern implementation of the classic Towers of Hanoi puzzle with both interactive gameplay and automated solving capabilities.

## Overview

This project consists of two main components:
- **Flutter Mobile/Web App**: Cross-platform client with interactive gameplay
- **Flask API**: Python backend that provides puzzle solutions

## Architecture

The project follows Clean Architecture principles with clear separation between layers:

### Flutter App Architecture
```
lib/
├── config/            # Dependency injection setup
├── data/              # Data layer
│   ├── models/        # API response models
│   ├── repositories/  # Data access abstraction
│   └── services/      # Network and device services
├── domain/            # Business logic layer
│   ├── models/        # Business entities
│   └── usecases/      # Business operations
└── ui/                # Presentation layer
    ├── main/          # Main game screen
    ├── shared/        # Reusable components
    └── extensions/    # Utility extensions
```

### Flask API
```
api/
├── app.py             # Flask application entry point
├── hanoi_service.py   # Core Hanoi solving algorithm
└── requirements.txt   # Python dependencies
```

## Quick Start

### Prerequisites
- **Flutter SDK** (3.0+)
- **Python** (3.11+)
- **Docker** (optional, for containerized deployment)

### Option 1: Local Development

#### 1. Setup Flask API
```bash
# Create and activate virtual environment
python3 -m venv .venv
source .venv/bin/activate

# Install dependencies
pip install -r api/requirements.txt

# Run the API server
python3 api/app.py
```
The API will be available at `http://localhost:8080`

#### 2. Setup Flutter App
```bash
cd app

# Get dependencies
flutter pub get

# Generate code for JSON serialization
flutter packages pub run build_runner build --delete-conflicting-outputs

# Run the app
flutter run
```

### Option 2: Docker Deployment

#### Quick Start with Docker Compose
```bash
# Build Flutter web app
cd app
flutter build web --release
cd ..

# Build and run with Docker
docker-compose up --build

# Access the application
open http://localhost:3000
```

## Development

### Flutter Development Commands
```bash
cd app

# Analyze code quality
flutter analyze

# Build for different platforms
flutter build apk              # Android APK
flutter build ios --release   # iOS
flutter build web --release   # Web
```

### API Development Commands
```bash
# Activate virtual environment
source .venv/bin/activate

# Run API server
python3 api/app.py

# Test API endpoints
curl "http://localhost:8080/api/hanoi/3"
curl "http://localhost:8080/health"
```

## Supported Platforms

- **Web**: Web App
- **iOS**: Native iOS application
- **Android**: Native Android application  

## API Documentation

### Endpoints

#### `GET /api/hanoi/<n>`
Solves the Towers of Hanoi puzzle for n disks.

**Parameters:**
- `n` (integer): Number of disks

**Response:**
```json
{
  "disks": 3,
  "moves_count": 7,
  "moves": [
    {
      "description": "Move disk 1 from A to C",
      "disk": 1,
      "from": "A",
      "to": "C"
    },
    ...
  ]
}
```

## License

This project is provided as-is for educational and demonstration purposes.
