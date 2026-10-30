# Salone Transport Hub (Flutter Mobile App)

## Project Description

A Flutter mobile application prototype that helps people in Sierra Leone find transport fares, compare transport options, request a ride and report fare problems. It is the Flutter stage of the **Salone Transport Hub** project and builds on the problem, requirements and system logic from Assignment 1 (a Dart console prototype). The project falls under the **Transportation and Public Services** domain.

The app is a student prototype. It is not owned, approved or endorsed by any government body, union or transport operator, and it does not set or control any transport price.

## Problem Being Solved

Fares for okada, kekeh, taxi, poda-poda and bus in Freetown and the provinces are agreed through official channels and revised often, but passengers have no single, clear place to check the fare that applies to their journey. This can lead to confusion and disagreements between passengers and drivers. Visitors from overseas have an even harder time, because they do not know local prices or currencies. The app gives passengers one place to see fares, compare modes, request a driver and record a fare issue for review.

## Objectives

- Turn the Assignment 1 Dart prototype into a Flutter mobile app with at least 10 connected screens
- Use Flutter widgets, forms with validation, navigation, reusable widgets and a clean project structure
- Show fares clearly, with their fare type and where each fare comes from
- Support three roles: Passenger, Driver and Administrator
- Work on any phone size, in light and dark mode
- Help visitors from overseas by showing prices in their own currency

## Features

**Everyone**

- Animated logo on start-up (tap to skip) and a custom app icon
- Register and log in (Passenger or Driver) with form validation
- Phone number checks: Sierra Leone numbers (`076 123 456` or `+232 76 123 456`) and international numbers with a country code. Made-up numbers such as `0000000000` are rejected
- Country detection from the calling code (128 countries, including all West African countries)
- Place search screen for pickup and destination (63 places)
- Fare list and side-by-side Compare view for okada, kekeh, taxi (shared and private hire), poda-poda and bus
- Prices always set in leones (NLe), with an "about" amount in USD, EUR, GBP or CNY for visitors
- Settings: light or dark mode, accent colour, currency and Restore defaults. Settings are saved **per user**, so one person's theme never changes another person's
- Higher-contrast default light theme for easier reading
- Notifications with pull-to-refresh

**Passenger**

- Home with summary, quick actions and popular routes
- Request a ride: choose the vehicle type, number of people and extra seats to keep free, with a live fare estimate
- Choose how to pay: NLe, USD, EUR, GBP or CNY (see "Paying in Other Currencies")
- Accept or reject the driver who responds, or cancel the request
- Report a fare issue and read the administrator's reply

**Driver**

- Home with verification status and trip summary
- Incoming requests that match the driver's vehicle type (only after the administrator verifies the driver)
- Accept or decline requests, see how the passenger will pay, and mark a trip as completed

**Administrator**

- Dashboard with items needing attention, key numbers, simple charts and expected payments by currency
- Verify drivers
- Add or edit route fares and the flat pole-to-pole fare
- Review fare issue reports and reply to the passenger

## Screens (25)

Splash, Welcome, Login, Register, Place search, Settings, About, Fares and Compare, Request transportation, Request details, Report fare issue, My fare reports, Notifications, Profile, Passenger home, My requests, Driver home, Incoming requests, My trips, Admin dashboard, Drivers, Manage fares, Fare reports, Edit fare, Review report.

## Flutter Concepts Demonstrated

| Area         | What is used                                                                                                   |
| ------------ | -------------------------------------------------------------------------------------------------------------- |
| UI           | Scaffold, AppBar, Text, Image.asset, Icons, Buttons, Container, Row, Column, Card, ListView, GridView          |
| Forms        | TextField, TextFormField, dropdowns, TextEditingController, form validation                                    |
| Navigation   | Navigator, named routes, navigation stack, passing data between screens, Bottom Navigation Bar, Drawer, TabBar |
| Architecture | Reusable widgets, organised folders, separation of concerns, naming conventions, clean code                    |

## Getting Started (Clone and Run on a PC)

### 1. Install the tools

| Tool           | Why                      | Link                                         |
| -------------- | ------------------------ | -------------------------------------------- |
| Git            | to clone the project     | https://git-scm.com/downloads                |
| Flutter SDK    | to build the app         | https://docs.flutter.dev/get-started/install |
| Android Studio | Android SDK and emulator | https://developer.android.com/studio         |

In Android Studio, open **Settings > Plugins** and install the **Flutter** and **Dart** plugins. Then check your setup in a terminal:

```
flutter doctor
```

Fix anything marked with a red cross. If it complains about Android licences, run `flutter doctor --android-licenses` and accept them.

### 2. Clone the project

Choose a simple folder such as `C:\Projects` (avoid OneDrive folders, which can slow or break builds):

```
git clone https://github.com/AKK041705/PROG202-ASSIGNMENT2-GROUP4-BSEM1101.git
cd PROG202-ASSIGNMENT2-GROUP4-BSEM1101
```

If `pubspec.yaml` is not in this folder, `cd` into the subfolder that contains it.

### 3. Open it in Android Studio

1. Choose **File > Open** and select the project folder (the one with `pubspec.yaml`).
2. Click **Get dependencies** when Android Studio shows the banner, or run this in the terminal:

```
flutter pub get
```

### 4. Start a phone

- **Emulator:** open **Device Manager** in Android Studio, click **Create Device**, pick a Pixel phone and a system image with Android 14 or 15, then press the play button.
- **Real phone:** turn on **Developer options** and **USB debugging**, plug it in and accept the prompt on the phone.

### 5. Run the app

In the toolbar, pick your device and press the green **Run** button (the file next to it should say `main.dart`). Or use the terminal:

```
flutter devices
flutter run
```

The first build takes a few minutes. The app opens with the animated logo, then the Welcome screen.

### Other ways to run

- **VS Code:** open the folder, install the Flutter extension, pick a device in the bottom-right corner and press `F5`
- **Chrome (no emulator needed):** `flutter run -d chrome`

### Troubleshooting

| Problem                                    | Fix                                                                                                                                    |
| ------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------- |
| The emulator crashes or images do not show | Edit the emulator in Device Manager and set **Graphics** to **Software**, then cold boot it. Or run `flutter run --no-enable-impeller` |
| A build error after pulling changes        | `flutter clean` then `flutter pub get` then `flutter run`                                                                              |
| `flutter` is not recognised                | Add Flutter's `bin` folder to your PATH, then reopen the terminal                                                                      |
| The old app icon still shows               | Uninstall the app from the emulator and run it again                                                                                   |
| You changed the icon image                 | Run `dart run flutter_launcher_icons`                                                                                                  |

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
assets/icon/             app launcher icon images
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

## Try the Full Flow

1. Log in as `amina`, open **Request a ride**, choose Kekeh from Lumley to Wilberforce, 2 people and 1 extra seat. The estimate is NLe 36.0.
2. Under **How will you pay?**, try GBP or EUR to see the amount in that currency.
3. Log out, log in as `kekeh1` and accept the request.
4. Log out, log in as `amina` again, open the request and accept or reject the driver.
5. Log in as `admin` to verify drivers, edit fares, review fare reports and see expected payments by currency.
6. In **Settings**, switch to dark mode or another accent colour, then log in as a different user to see that their theme is separate.

## Paying in Other Currencies

Prices in the app are always set in leones (NLe). A visitor can choose to pay in **NLe, USD, EUR, GBP or CNY** when requesting a ride:

- The amount in the chosen currency is worked out from indicative exchange rates and shown before the request is sent
- A payment in another currency is recorded in that currency and is **not converted to leones** by the app
- The administrator dashboard adds up the expected payments for each currency separately
- This prototype takes **no real payment**. Accepting foreign currency in Sierra Leone must follow Bank of Sierra Leone rules, which must be checked before any real use

## Phone Numbers and Countries

- Sierra Leone numbers can be typed as `076 123 456` or `+232 76 123 456`
- Numbers from other countries need the country code, for example `+233 24 123 4567` (Ghana) or `+44 7700 900123` (United Kingdom)
- The country is found from the code (128 countries), including all West African countries. Visitors see prices in their currency when it is USD, EUR, GBP or CNY, and USD for other countries
- Numbers that look made up, such as `0000000000` or `77000000`, are rejected

## Fare Data

- **Official price list**: kekeh routes, provincial bus fares (at NLe 45.00 per litre) and the okada and kekeh pole-to-pole fare of NLe 7, as supplied for this project
- **Published sample (news)**: a few poda-poda fares from news reports
- **Simulated estimate**: calculated by the app from an assumed distance and rate per kilometre, shown only so every mode can be demonstrated. These are **not** official fares
- Exchange rates are Bank of Sierra Leone reference rates of 5 June 2026. They are indicative only and change every day. They are set in `lib/services/currency_service.dart`

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
- Simulated fares are not official, and exchange rates are indicative only
- No real payments are taken, and the app is not connected to any government system, union, mobile money provider or GPS service
- Currencies other than NLe, USD, EUR, GBP and CNY are shown as USD
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
