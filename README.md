<div align="center">

  # 🩺 DIAZEN
  ### *Smart Companion for Functional Insulin Therapy (FIT)*

  [![Flutter](https://img.shields.io/badge/Flutter-3.5+-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
  [![Dart](https://img.shields.io/badge/Dart-3.5+-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
  [![Firebase](https://img.shields.io/badge/Firebase-Backend-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com)
  [![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-brightgreen?style=for-the-badge)](https://flutter.dev)
  [![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)](LICENSE)

  <p align="center">
    <b>A mobile e-health application designed to simplify diabetes daily management through Functional Insulin Therapy (FIT / ITF), offering precise prandial dose calculation, nutrition & activity tracking, and practitioner oversight.</b>
  </p>

  <p align="center">
    <i>Developed as a Bachelor's final-year capstone project & architectural blueprint for an e-health startup solution.</i>
  </p>

</div>

---

## 📑 Table of Contents

- [Overview](#-overview)
- [Key Features](#-key-features)
  - [Prandial Insulin Dose Calculator (FIT)](#1-prandial-insulin-dose-calculator-fit)
  - [Meal & Carbohydrate Tracking](#2-meal--carbohydrate-tracking)
  - [Blood Glucose Monitoring & Trends](#3-blood-glucose-monitoring--trends)
  - [Physical Activity Logging](#4-physical-activity-logging)
  - [Doctor & Healthcare Provider Portal](#5-doctor--healthcare-provider-portal)
  - [Authentication & User Profiles](#6-authentication--user-profiles)
- [Screenshots](#-screenshots)
- [System Architecture & Tech Stack](#-system-architecture--tech-stack)
- [Project Directory Structure](#-project-directory-structure)
- [Getting Started](#-getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Firebase Configuration](#firebase-configuration)
- [Medical Disclaimer](#-medical-disclaimer)
- [Roadmap](#-roadmap)
- [Author & Acknowledgments](#-author--acknowledgments)

---

## 🌟 Overview

Living with **Type 1 Diabetes** (or insulin-requiring diabetes) is a continuous balancing act. **Functional Insulin Therapy (FIT / Insulinothérapie Fonctionnelle - ITF)** empowers patients to adapt their rapid-acting insulin doses to their actual meals and lifestyle rather than adhering to rigid dietary constraints.

However, calculating prandial insulin requires handling multiple mathematical variables simultaneously:
- **Insulin-to-Carb Ratio (ICR)** per meal
- **Insulin Sensitivity Factor (ISF)**
- **Target vs. current glycemia (Correction factor)**
- **Physical exertion offsets (Planned and unplanned activities)**

**Diazen** was created to eliminate calculation errors, reduce cognitive load, and give patients confidence and freedom in their daily routine.

---

## 🚀 Key Features

### 1. 💉 Prandial Insulin Dose Calculator (FIT)
- **Clinical FIT Algorithm**: Computes rapid-acting insulin doses based on:
  - Total meal carbohydrates (g)
  - Pre-prandial blood glucose and individual target glucose
  - Personalized **ICR** and **ISF**
- **Activity Correction**: Automatically applies unit/percentage reductions for planned and spontaneous physical exercise based on intensity, duration, and calories burned.
- **Detailed Dose Breakdown**: Distinguishes between **meal dose**, **correction dose**, and **activity adjustment**.

### 2. 🍽️ Meal & Carbohydrate Tracking
- Comprehensive meal database with nutrition lookup.
- Custom plate builder with ingredient breakdown.
- Saved meal templates for quick, one-tap logging.
- Complete meal history with calculated carbohydrate intakes.

### 3. 🩸 Blood Glucose Monitoring & Trends
- Pre- and post-prandial glucose logging.
- Interactive charts (`fl_chart`) showcasing glycemic variability and target range adherence.
- Hypoglycemia and hyperglycemia historical insights.

### 4. 🏃 Physical Activity Logging
- Track diverse workout categories, duration, and intensity levels.
- Estimation of energy expenditure (METs & calories).
- Immediate feedback on how specific activities impact glycemic stability and insulin sensitivity.

### 5. 👨‍⚕️ Doctor & Healthcare Provider Portal
- **Dual-role ecosystem**: Dedicated interfaces for both patients and healthcare professionals.
- **Practitioner View**: Doctors can review their patients' metabolic parameters, dose history, and glycemic trends.
- **Clinical Summaries**: Export and send structured medical reports (PDF/Email) to assist clinical consultations.

### 6. 🔐 Authentication & User Profiles
- Secure user management powered by **Firebase Authentication**.
- Multi-provider support: Email/Password (with verification) and Social Logins (Google, Apple, Facebook).
- Medical onboarding: Personalized configuration of glycemic targets, sensitivity factors, and medical contacts.

---

## 📱 Screenshots

<div align="center">

| **1. Welcome & Onboarding** | **2. Patient Dashboard** | **3. Dose Calculator** | **4. Calculation Results** |
|:---:|:---:|:---:|:---:|
| <img src="https://github.com/user-attachments/assets/2e8175d2-00c4-4aa0-b80a-d3676174caa6" width="220" alt="Welcome & Onboarding" /> | <img src="https://github.com/user-attachments/assets/c5ad0e2f-05d9-4b32-8fe7-85dc75c0e65d" width="220" alt="Dashboard" /> | <img src="https://github.com/user-attachments/assets/de1ff962-86c6-48d4-8200-a373e134081f" width="220" alt="Calculator" /> | <img src="https://github.com/user-attachments/assets/1d79efcb-380f-4226-a55e-2051f996d881" width="220" alt="Dose Results" /> |

| **5. Meal & Plate Tracking** | **6. Blood Glucose Logs** | **7. Activity Tracking** | **8. Reports & Doctor Space** |
|:---:|:---:|:---:|:---:|
| <img src="https://github.com/user-attachments/assets/f9f16c6a-b6be-44f8-8530-9eba049bb956" width="220" alt="Meal & Plate Tracking" /> | <img src="https://github.com/user-attachments/assets/22ac67e8-6da6-421b-aedf-73f29b319ff4" width="220" alt="Glucose Logs" /> | <img src="https://github.com/user-attachments/assets/1b1b19bc-dfe7-4307-b372-8bfe698e2d93" width="220" alt="Physical Activity" /> | <img src="https://github.com/user-attachments/assets/1ca90c5e-b14b-4fe8-a904-f74f1e71b446" width="220" alt="Reports & Doctor Space" /> |

</div>

---

## 🛠️ System Architecture & Tech Stack

| Domain | Technology / Library | Description |
|---|---|---|
| **Framework** | [Flutter](https://flutter.dev) (Dart 3.5+) | Cross-platform mobile development (Android & iOS) |
| **Backend & Cloud** | [Cloud Firestore](https://firebase.google.com/docs/firestore) | NoSQL real-time cloud database |
| **Authentication** | [Firebase Auth](https://firebase.google.com/docs/auth) | Email/Password, Google Sign-In, Apple, Facebook |
| **Cloud Storage** | [Firebase Storage](https://firebase.google.com/docs/storage) | Secure storage for user documents and media |
| **Local Storage** | [Hive](https://pub.dev/packages/hive) & [Shared Preferences](https://pub.dev/packages/shared_preferences) | Fast offline caching and user preferences |
| **Data Visualization** | [FL Chart](https://pub.dev/packages/fl_chart) | Dynamic, responsive glucose trend charts |
| **Icons & Design** | Lucide Icons, Google Nav Bar, Cupertino Icons | Modern, clean UI components following Material 3 |
| **Networking & Email** | HTTP & Mailer | Nutrition APIs, activity sync, and medical reporting |

---

## 📂 Project Directory Structure

```text
lib/
├── authentication/              # Authentication & user onboarding flows
│   ├── auth_state_service.dart  # Session state & routing management
│   ├── doctor_signin_screen.dart# Healthcare provider sign-in
│   ├── loginpage.dart           # Patient login screen
│   ├── signuppage.dart          # Patient registration screen
│   ├── medical_info_form.dart   # Baseline FIT parameters setup (ICR, ISF)
│   ├── social_auth_service.dart # Google / Apple / Facebook OAuth
│   └── ...
├── classes/                     # Data models & Firestore operations
│   ├── activite.dart            # Activity data model
│   ├── firestore_ops.dart       # Centralized Firestore CRUD operations
│   ├── glucose_log.dart         # Blood glucose measurement entity
│   ├── ingredient.dart          # Food ingredient & carb breakdown
│   ├── injection.dart           # Insulin injection entity & calculations
│   ├── medecin.dart             # Practitioner profile model
│   ├── repas.dart               # Meal entity
│   └── utilisateur.dart         # Patient profile model
├── screens/                     # Core application views
│   ├── home_screen.dart         # Main patient dashboard
│   ├── calculate_dose_screen.dart# Interactive FIT dose calculation engine
│   ├── dose_result_screen.dart  # Detailed dose calculation summary
│   ├── log_glucose_screen.dart  # Glucose measurement input screen
│   ├── add_plate_screen.dart    # Custom meal / carb composition
│   ├── saved_meals_screen.dart  # Favorite meals catalog
│   ├── activity_screen.dart     # Physical activity logger
│   ├── history_screen.dart      # Historical diary of logs & injections
│   ├── doctor_home_screen.dart  # Medical practitioner dashboard
│   ├── patient_screen.dart      # Practitioner's detailed patient view
│   ├── rapport_screen.dart      # Clinical report generation & export
│   └── ...
├── firebase_options.dart        # Platform-specific Firebase credentials
└── main.dart                    # Application bootstrap & theme setup
```

---

## ⚡ Getting Started

### Prerequisites

Ensure you have the following installed on your development machine:
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (`^3.5.4` or later)
- [Dart SDK](https://dart.dev/get-dart)
- [Android Studio](https://developer.android.com/studio) or [Xcode](https://developer.apple.com/xcode/) (for iOS simulation)
- [Firebase CLI](https://firebase.google.com/docs/cli) (if configuring your own Firebase project)

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

3. **Verify Flutter setup**:
   ```bash
   flutter doctor
   ```

### Firebase Configuration

This application relies on Firebase services. If you are deploying or testing with your own Firebase project:

1. Install the FlutterFire CLI:
   ```bash
   dart pub global activate flutterfire_cli
   ```
2. Configure your Firebase apps:
   ```bash
   flutterfire configure
   ```
3. Enable **Authentication** (Email/Password, Google, Apple), **Cloud Firestore**, and **Firebase Storage** in the Firebase Console.

### Run the App

Connect an emulator or physical device, then run:

```bash
# Debug mode
flutter run

# Release mode
flutter run --release
```

---

## ⚠️ Medical Disclaimer

> **IMPORTANT**: **Diazen** is intended solely as an educational and assistive tool for individuals practicing Functional Insulin Therapy.  
> It is **not** a certified medical device and does not replace the professional advice, diagnosis, or treatment of a qualified endocrinologist or diabetologist.  
> Users must always verify calculated doses against their personal medical instructions and double-check their blood glucose levels before administering insulin.

---

## 🗺️ Roadmap

- [ ] **CGM (Continuous Glucose Monitor) Integration**: Direct Bluetooth/Cloud synchronization with Dexcom and FreeStyle Libre sensors.
- [ ] **Computer Vision Meal Recognition**: Automatic carbohydrate estimation via smartphone camera and AI food classification.
- [ ] **Smartwatch Companion App**: WearOS and watchOS support for quick bolus logging on the wrist.
- [ ] **Multi-Language Support**: Complete French and English localization.

---

## 👥 Author & Acknowledgments

- **Abderrahmane Benchohra** - Lead Developer & Designer - [GitHub](https://github.com/benchohrabdou)
- Developed as a **Bachelor's Degree Final-Year Project**.
- Special thanks to supervising faculty and consulting healthcare specialists for their clinical insights into Functional Insulin Therapy protocols.

---

<div align="center">
  <sub>Made with ❤️ and Flutter to make diabetes management easier.</sub>
</div>
