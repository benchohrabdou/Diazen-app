<div align="center">

  # DIAZEN
  ### Smart Companion for Functional Insulin Therapy (FIT)

  [![Flutter](https://img.shields.io/badge/Flutter-3.5+-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
  [![Dart](https://img.shields.io/badge/Dart-3.5+-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
  [![Firebase](https://img.shields.io/badge/Firebase-Backend-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com)
  [![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-brightgreen?style=for-the-badge)](https://flutter.dev)
  [![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)](LICENSE)

  <p align="center">
    A mobile application designed for diabetes self-management through Functional Insulin Therapy (FIT / ITF), offering prandial dose calculation, carbohydrate and activity tracking, and practitioner oversight.
  </p>

</div>

---

## Table of Contents

- [Overview](#overview)
- [Key Features](#key-features)
  - [Prandial Insulin Dose Calculator (FIT)](#1-prandial-insulin-dose-calculator-fit)
  - [Meal & Carbohydrate Tracking](#2-meal--carbohydrate-tracking)
  - [Blood Glucose Monitoring & Trends](#3-blood-glucose-monitoring--trends)
  - [Physical Activity Logging](#4-physical-activity-logging)
  - [Doctor & Healthcare Provider Portal](#5-doctor--healthcare-provider-portal)
  - [Authentication & User Profiles](#6-authentication--user-profiles)
- [Screenshots](#screenshots)
- [System Architecture & Tech Stack](#system-architecture--tech-stack)
- [Project Directory Structure](#project-directory-structure)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Configuration](#configuration)
  - [Firebase Configuration](#firebase-configuration)
  - [Running the Application](#running-the-application)
- [Medical Disclaimer](#medical-disclaimer)
- [Roadmap](#roadmap)

---

## Overview

Managing Type 1 Diabetes (or insulin-requiring diabetes) requires continuous monitoring and multi-variable arithmetic. **Functional Insulin Therapy (FIT / Insulinothérapie Fonctionnelle - ITF)** allows patients to adapt their rapid-acting insulin doses to their actual nutritional intake and activity level.

Calculating a prandial insulin dose requires factoring in:
- **Insulin-to-Carb Ratio (ICR)** per meal
- **Insulin Sensitivity Factor (ISF)**
- **Target vs. current glycemia (Correction factor)**
- **Physical exertion offsets (Planned and unplanned activities)**

**Diazen** automates these calculations to minimize dosing errors and reduce cognitive load for patients in their daily management.

---

## Key Features

### 1. Prandial Insulin Dose Calculator (FIT)
- Computes rapid-acting insulin doses based on:
  - Total meal carbohydrates (g)
  - Pre-prandial blood glucose and individual target glucose
  - Configured **ICR** and **ISF** values
- Dynamic activity compensation: applies dose reductions for planned and spontaneous physical exercise based on intensity, duration, and calories burned.
- Breakdown of calculated doses: **meal dose**, **correction dose**, and **activity adjustment**.
- Safety protections: blocks computation if blood glucose is below 70 mg/dL with a warning, and validates glucose (20–600 mg/dL) and carbohydrate ranges (0–300 g).

### 2. Meal & Carbohydrate Tracking
- Food and meal database with nutritional estimation.
- Custom plate composer with ingredient details.
- Saved meal templates for fast logging.
- Comprehensive history of meals and carbohydrate intake.

### 3. Blood Glucose Monitoring & Trends
- Pre- and post-prandial glucose logging.
- Trend visualization using `fl_chart`.
- Log history for monitoring glycemic variability and target range adherence.

### 4. Physical Activity Logging
- Logging of workout type, duration, and intensity level.
- Energy expenditure calculation (METs and calories).
- Tracks exercise impact on blood glucose and insulin sensitivity.

### 5. Doctor & Healthcare Provider Portal
- Dedicated interfaces for patients and healthcare professionals.
- Practitioner view to review patient glycemic history, dose logs, and metabolic parameters.
- Clinical report dashboard with summary statistics and glycemic charts (*PDF and email report export is planned*).

### 6. Authentication & User Profiles
- User account management powered by **Firebase Authentication**.
- Authentication via Email/Password (with verification) and Google Sign-In (*Apple Sign-In is planned*).
- Profile setup for medical baseline values (target glucose, ICR, ISF, and physician contacts).

---

## Screenshots

<div align="center">

| **1. Welcome & Onboarding** | **2. Patient Dashboard** | **3. Dose Calculator** | **4. Calculation Results** |
|:---:|:---:|:---:|:---:|
| <img src="https://github.com/user-attachments/assets/2e8175d2-00c4-4aa0-b80a-d3676174caa6" width="220" alt="Welcome & Onboarding" /> | <img src="https://github.com/user-attachments/assets/c5ad0e2f-05d9-4b32-8fe7-85dc75c0e65d" width="220" alt="Dashboard" /> | <img src="https://github.com/user-attachments/assets/de1ff962-86c6-48d4-8200-a373e134081f" width="220" alt="Calculator" /> | <img src="https://github.com/user-attachments/assets/1d79efcb-380f-4226-a55e-2051f996d881" width="220" alt="Dose Results" /> |

| **5. Meal & Plate Tracking** | **6. Blood Glucose Logs** | **7. Activity Tracking** | **8. Reports & Doctor Space** |
|:---:|:---:|:---:|:---:|
| <img src="https://github.com/user-attachments/assets/f9f16c6a-b6be-44f8-8530-9eba049bb956" width="220" alt="Meal & Plate Tracking" /> | <img src="https://github.com/user-attachments/assets/22ac67e8-6da6-421b-aedf-73f29b319ff4" width="220" alt="Glucose Logs" /> | <img src="https://github.com/user-attachments/assets/1b1b19bc-dfe7-4307-b372-8bfe698e2d93" width="220" alt="Physical Activity" /> | <img src="https://github.com/user-attachments/assets/1ca90c5e-b14b-4fe8-a904-f74f1e71b446" width="220" alt="Reports & Doctor Space" /> |

</div>

---

## System Architecture & Tech Stack

| Domain | Technology / Library | Description |
|---|---|---|
| **Framework** | [Flutter](https://flutter.dev) (Dart 3.5+) | Cross-platform mobile development (Android & iOS) |
| **Backend & Database** | [Cloud Firestore](https://firebase.google.com/docs/firestore) | Real-time NoSQL cloud database |
| **Authentication** | [Firebase Auth](https://firebase.google.com/docs/auth) | Email/Password, Google Sign-In (*Apple Sign-In planned*) |
| **Cloud Storage** | Firebase Storage | *(Planned)* Media and document storage |
| **Local Storage** | [Shared Preferences](https://pub.dev/packages/shared_preferences) | Local caching and user preferences (*Hive caching planned*) |
| **Data Visualization** | [FL Chart](https://pub.dev/packages/fl_chart) | Dynamic glycemic trend charts |
| **UI Components** | Lucide Icons, Google Nav Bar, Cupertino Icons | Interface styling and navigation |
| **Networking & Services** | HTTP | Nutrition and activity API integration (*PDF/email export planned*) |

---

## Project Directory Structure

```text
lib/
├── authentication/              # Authentication & onboarding flows
│   ├── auth_state_service.dart  # Session state & routing management
│   ├── doctor_signin_screen.dart# Healthcare provider sign-in
│   ├── loginpage.dart           # Patient login screen
│   ├── signuppage.dart          # Patient registration screen
│   ├── medical_info_form.dart   # Baseline parameters setup (ICR, ISF)
│   ├── social_auth_service.dart # OAuth services
│   └── ...
├── classes/                     # Data models & Firestore operations
│   ├── activite.dart            # Activity data model
│   ├── firestore_ops.dart       # Centralized Firestore CRUD operations
│   ├── glucose_log.dart         # Blood glucose measurement entity
│   ├── ingredient.dart          # Ingredient & carb breakdown
│   ├── injection.dart           # Insulin injection entity
│   ├── medecin.dart             # Practitioner profile model
│   ├── repas.dart               # Meal entity
│   └── utilisateur.dart         # Patient profile model
├── screens/                     # Core application views
│   ├── home_screen.dart         # Main patient dashboard
│   ├── calculate_dose_screen.dart# Interactive dose calculation screen
│   ├── dose_result_screen.dart  # Detailed dose calculation summary
│   ├── log_glucose_screen.dart  # Glucose measurement input screen
│   ├── add_plate_screen.dart    # Meal & carb composition
│   ├── saved_meals_screen.dart  # Saved meals catalog
│   ├── activity_screen.dart     # Physical activity logger
│   ├── history_screen.dart      # Logbook of meals, doses, and glucose
│   ├── doctor_home_screen.dart  # Medical practitioner dashboard
│   ├── patient_screen.dart      # Detailed patient view for doctors
│   ├── rapport_screen.dart      # Clinical report and statistics screen
│   └── ...
├── services/                    # Business logic & computation services
│   └── dose_calculator.dart     # Pure Functional Insulin Therapy (FIT) dose engine
├── firebase_options.dart        # Platform-specific Firebase credentials
└── main.dart                    # Application bootstrap & theme setup
```

---

## Getting Started

### Prerequisites

Ensure the following tools are installed:
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (`^3.5.4` or later)
- [Dart SDK](https://dart.dev/get-dart)
- [Android Studio](https://developer.android.com/studio) or [Xcode](https://developer.apple.com/xcode/)
- [Firebase CLI](https://firebase.google.com/docs/cli)

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/benchohrabdou/Diazen-app.git
   cd Diazen-app
   ```

2. **Install Flutter dependencies**:
   ```bash
   flutter pub get
   ```

3. **Verify environment**:
   ```bash
   flutter doctor
   ```

### Configuration

API keys for external nutrition and physical activity services are loaded at build time via `--dart-define` using `String.fromEnvironment`. Never commit real API keys to any repository file.

Pass the keys as build arguments:

```bash
# Debug mode
flutter run \
  --dart-define=USDA_API_KEY=your_usda_key \
  --dart-define=API_NINJAS_KEY=your_api_ninjas_key

# Release build
flutter build apk \
  --dart-define=USDA_API_KEY=your_usda_key \
  --dart-define=API_NINJAS_KEY=your_api_ninjas_key
```

Supported build variables:
- `USDA_API_KEY`: API key for USDA FoodData Central nutritional food search.
- `API_NINJAS_KEY`: API key for API Ninjas calories burned service.

### Firebase Configuration

To configure with your own Firebase project:

1. Install the FlutterFire CLI:
   ```bash
   dart pub global activate flutterfire_cli
   ```
2. Configure Firebase credentials:
   ```bash
   flutterfire configure
   ```
3. Enable **Authentication** (Email/Password, Google) and **Cloud Firestore** in the Firebase Console.

### Running the Application

Connect a physical device or launch an emulator:

```bash
# Debug mode with API keys
flutter run \
  --dart-define=USDA_API_KEY=your_usda_key \
  --dart-define=API_NINJAS_KEY=your_api_ninjas_key

# Release mode
flutter run --release \
  --dart-define=USDA_API_KEY=your_usda_key \
  --dart-define=API_NINJAS_KEY=your_api_ninjas_key
```

---

## Medical Disclaimer

> **IMPORTANT**: **Diazen** is intended as an assistive tool for individuals practicing Functional Insulin Therapy.  
> It is not a certified medical device and does not replace professional medical advice, diagnosis, or treatment.  
> Users must always verify calculated doses against their individual medical prescriptions and check blood glucose levels prior to insulin administration.

---

## Roadmap

- [ ] **Continuous Glucose Monitor (CGM) Integration**: Bluetooth synchronization with Dexcom and FreeStyle Libre sensors.
- [ ] **Computer Vision Meal Recognition**: Automated carbohydrate estimation via camera.
- [ ] **Smartwatch Companion App**: WearOS and watchOS companion for quick bolus logging.
- [ ] **Apple Sign-In**: Native OAuth sign-in flow for iOS users.
- [ ] **PDF & Email Report Export**: Export clinical summaries to PDF and dispatch via email.
- [ ] **Offline Caching**: Offline-first storage and synchronization with Hive.
- [ ] **Firebase Storage Integration**: Cloud storage for medical documentation and profile assets.
- [ ] **Multi-Language Support**: Complete French and English localization.


