# Salone Transport Hub (Flutter Mobile App)

## Project Description

A Flutter mobile application prototype that helps people in Sierra Leone find transport fares, compare transport options, request a ride and report fare problems. It is the Flutter stage of the **Salone Transport Hub** project and builds on the problem, requirements and system logic from Assignment 1 (a Dart console prototype). The project falls under the **Transportation and Public Services** domain.

The app is a student prototype. It is not owned, approved or endorsed by any government body, union or transport operator, and it does not set or control any transport price.

## Problem Being Solved

Fares for okada, kekeh, taxi, poda-poda and bus in Freetown and the provinces are agreed through official channels and revised often, but passengers have no single, clear place to check the fare that applies to their journey. This can lead to confusion and disagreements between passengers and drivers. The app gives passengers one place to see fares, compare modes, request a driver and record a fare issue for review.

## Objectives

- Turn the Assignment 1 Dart prototype into a Flutter mobile app with at least 10 connected screens
- Use Flutter widgets, forms with validation, navigation, reusable widgets and a clean project structure
- Show fares clearly, with their fare type and where each fare comes from
- Support three roles: Passenger, Driver and Administrator
- Work on any phone size, in light and dark mode

## Features

**Everyone**

- Animated logo on start-up (tap to skip)
- Register and log in (Passenger or Driver) with form validation
- Phone number checks: Sierra Leone numbers (`076 123 456` or `+232 76 123 456`) and international numbers with a country code. Made-up numbers such as `0000000000` are rejected, and the country is found from the calling code
- Place search screen for pickup and destination (63 places)
- Fare list and side-by-side Compare view for okada, kekeh, taxi (shared and private hire), poda-poda and bus
- Prices also shown in USD, EUR, GBP or CNY for visitors from overseas
- Settings: light or dark mode, accent colour, currency and Restore defaults. Settings are saved **per user**, so one person's theme never changes another person's
- Notifications with pull-to-refresh

**Passenger**

- Home with summary, quick actions and popular routes
- Request a ride: choose the vehicle type, number of people and extra seats to keep free, with a live fare estimate
- Accept or reject the driver who responds, or cancel the request
- Report a fare issue and read the administrator's reply

**Driver**

- Home with verification status and trip summary
- Incoming requests that match the driver's vehicle type (only after the administrator verifies the driver)
- Accept or decline requests, and mark a trip as completed

**Administrator**

- Dashboard with items needing attention, key numbers and simple charts
- Verify drivers
- Add or edit route fares and the flat pole-to-pole fare
- Review fare issue reports and reply to the passenger

## Screens (23)

Splash, Welcome, Login, Register, Place search, Settings, About, Fares and Compare, Request transportation, Request details, Report fare issue, My fare reports, Notifications, Profile, Passenger home / My requests, Driver home / Incoming requests / My trips, Admin dashboard / Drivers / Manage fares / Fare reports, Edit fare, Review report.

## Flutter Concepts Demonstrated

| Area         | What is used                                                                                                   |
| ------------ | -------------------------------------------------------------------------------------------------------------- |
| UI           | Scaffold, AppBar, Text, Image.asset, Icons, Buttons, Container, Row, Column, Card, ListView, GridView          |
| Forms        | TextField, TextFormField, dropdowns, TextEditingController, form validation                                    |
| Navigation   | Navigator, named routes, navigation stack, passing data between screens, Bottom Navigation Bar, Drawer, TabBar |
| Architecture | Reusable widgets, organised folders, separation of concerns, naming conventions, clean code                    |

## Project Structure

```
lib/
  main.dart              app entry point
  core/                  colours, themes, routes, router, validators, preferences
  models/                data classes (users, requests, reports, fares, notifications)
  data/                  places, fare records and the fare rules
  services/              phone checks, country detection, currency conversion
  state/                 AppState (in-memory data and actions)
  widgets/               reusable widgets (cards, buttons, fields, tiles, navigation bar, logo)
  screens/               auth, passenger, driver, admin and common screens
assets/images/logo.png   app logo
```

## Demo Accounts

All accounts are fictional.

| Role                                                | Username                | Password   |
| --------------------------------------------------- | ----------------------- | ---------- |
| Administrator                                       | `admin`                 | `admin123` |
| Passenger                                           | `amina`, `mohamed`      | `1234`     |
| Passenger (visitor from the UK, prices also in GBP) | `sarah`                 | `1234`     |
| Driver: okada, kekeh                                | `rider1`, `kekeh1`      | `1234`     |
| Driver: taxi                                        | `taxi1`, `taxi2`        | `1234`     |
| Driver: private vehicle, poda-poda, bus             | `van1`, `poda1`, `bus1` | `1234`     |

You can also create your own passenger or driver account on the Register screen. New drivers must be verified by the administrator before they receive requests.

## How to Run

Install the [Flutter SDK](https://docs.flutter.dev/get-started/install) and Android Studio (or VS Code with the Flutter extension). Start an Android emulator or connect a phone, then run this in the project folder:

```
flutter pub get
flutter run
```

## Try the Full Flow

1. Log in as `amina`, open **Request a ride**, choose Kekeh from Lumley to Wilberforce, 2 people and 1 extra seat. The estimate is NLe 36.0.
2. Log out, log in as `kekeh1` and accept the request.
3. Log out, log in as `amina` again, open the request and accept or reject the driver.
4. Log in as `admin` to verify drivers, edit fares and review fare reports.

## Fare Data

- **Official price list**: kekeh routes, provincial bus fares (at NLe 45.00 per litre) and the okada and kekeh pole-to-pole fare of NLe 7, as supplied for this project
- **Published sample (news)**: a few poda-poda fares from news reports
- **Simulated estimate**: calculated by the app from an assumed distance and rate per kilometre, shown only so every mode can be demonstrated. These are **not** official fares
- Exchange rates are Bank of Sierra Leone reference rates of 5 June 2026. They are indicative only and change every day

Always confirm fares with the latest official notice from the Ministry of Transport and Aviation.

## Screenshots

Add the screenshots to `docs/screenshots/` and list them here.

| Splash                                 | Welcome                                  | Login                                |
| -------------------------------------- | ---------------------------------------- | ------------------------------------ |
| ![Splash](docs/screenshots/splash.png) | ![Welcome](docs/screenshots/welcome.png) | ![Login](docs/screenshots/login.png) |

| Passenger home                               | Compare fares                            | Request a ride                           |
| -------------------------------------------- | ---------------------------------------- | ---------------------------------------- |
| ![Home](docs/screenshots/passenger-home.png) | ![Compare](docs/screenshots/compare.png) | ![Request](docs/screenshots/request.png) |

| Driver home                                 | Admin dashboard                                | Settings (dark mode)                            |
| ------------------------------------------- | ---------------------------------------------- | ----------------------------------------------- |
| ![Driver](docs/screenshots/driver-home.png) | ![Admin](docs/screenshots/admin-dashboard.png) | ![Settings](docs/screenshots/settings-dark.png) |

## Privacy Considerations

- All accounts, drivers, vehicles, requests and reports in the demo are fictional sample data
- Records stay in memory while the app runs and are not saved or sent anywhere
- Passwords are kept as plain text in memory because this is a prototype. The final project will use proper authentication

## Limitations and Next Steps

- No database yet: all data is lost when the app closes
- Simulated fares are not official
- Not connected to any government system, union, mobile money provider or GPS service
- Next stage: Supabase database and authentication, saved records, and later maps, payments and push notifications

## GitHub Information

- Repository: https://github.com/AKK041705/PROG202-ASSIGNMENT2-GROUP4-BSEM1101
- Earlier stage: Assignment 1 – Dart console prototype
  🔗 https://github.com/AKK041705/salone-transport-hub.git

## Author and Group

Group 4 Members:

1. Sabrina Kandeh (Student ID: 905005613)
2. Ibrahim E. Sesay (Student ID: 905005354)
3. Michael H. Coker (Student ID: 905005247)
4. Desmond Hinga Kutubu-Koroma (Student ID: 905005702)
5. Abdul Karim Koroma (Student ID: 905005267)

PROG 202 - Software Engineering, Assignment 2
Examiner: Santigie Foday Kamara
Limkokwing University of Creative Technology, Sierra Leone
GitHub: AKK041705
