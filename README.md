# Salone Transport Hub (Flutter prototype)

PROG 202 - Software Engineering, Assignment 2. Limkokwing University of Creative Technology, Sierra Leone.

A Flutter front end for the Salone Transport Hub from Assignment 1: fares, fare comparison,
transport requests, fare issue reports, and role screens for passengers, drivers and the administrator.

## Run

```
flutter pub get
flutter run
```

## Demo accounts
- Administrator: `admin` / `admin123`
- Drivers (password `1234`): `rider1` (okada), `kekeh1` (kekeh), `taxi1` and `taxi2` (taxi), `van1` (private vehicle), `poda1` (poda-poda), `bus1` (bus)
- Passengers: create an account on the Register screen.

## Try the full flow (one device, three users)
1. Register as a passenger, log in, and send a request (Home > Request a ride).
2. Log out. Log in as the matching driver (for a kekeh request use `kekeh1`) and accept it.
3. Log out. Log in as the passenger again, open Alerts, then the request, and accept or reject the driver.
4. Log in as `admin` to verify new drivers, edit fares and review fare reports.

## Project structure
```
lib/
  main.dart              app entry, theme and text-size limits
  core/                  colours, theme, route names, router, validators, helpers
  models/                data classes (users, requests, reports, notifications, fares)
  data/                  places, fare records and the fare rules
  state/                 AppState (in-memory data and actions)
  widgets/               reusable widgets (cards, buttons, fields, tiles, nav bar, logo)
  screens/               auth, passenger, driver, admin and common screens
assets/images/logo.png   app logo
```

## Notes
- No database in this stage: everything is in memory and is lost when the app closes.
- Fares tagged "Simulated estimate" are not official. Drivers and vehicles are fictional.
- Not connected to, or endorsed by, any government body or union.
