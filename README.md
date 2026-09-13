# SimpleEnergy – Vehicle Dashboard App

A small iOS app that displays a list of vehicles and their details, built with Swift and SwiftUI as part of the SimpleEnergy L1 technical assignment.

## Requirements

- Xcode 15+ (iOS 16.6+ deployment target)
- iOS Simulator or physical device

## How to Run

1. Clone the repository
2. Go to inside directory 'SimpleEnergy_Aman'
3. Open `SimpleEnergy_Aman.xcodeproj` in Xcode
4. Select an iPhone simulator
5. Press **Cmd + R** to build and run

## Features

- **Vehicle List** – Shows vehicle name, model, battery %, range, and online/offline status
- **Vehicle Details** – Shows full vehicle info including speed, odometer, connectivity status, and last updated time
- **Pull to Refresh** – Reload latest data on the detail screen

## Architecture

The app follows **MVVM** (Model–View–ViewModel):

- **Model** – `Vehicle` data type
- **View** – SwiftUI screens (`VehicleListView`, `VehicleDetailView`, `VehicleRowView`)
- **ViewModel** – `VehicleListViewModel`, `VehicleDetailViewModel` (state, loading, errors, refresh)
- **Service** – `VehicleService` fetches data via `VehicleServiceProtocol`

Views bind to ViewModels with `@StateObject`. ViewModels call the service layer; views do not fetch data directly.

## Data Source

The app fetches vehicle data from a REST API:
https://raw.githubusercontent.com/amanK1n/SimpleEnergy/main/SimpleEnergy_Aman/SimpleEnergy_Aman/Resource/vehicles.json

If the network request fails, it falls back to a local `vehicles.json` bundled in the app.

## Project Structure

```
SimpleEnergy_Aman/
├── SimpleEnergy_Aman.xcodeproj/
│   ├── project.pbxproj
│   └── project.xcworkspace/
│       └── contents.xcworkspacedata
│
└── SimpleEnergy_Aman/
    ├── App/
    │   └── SimpleEnergy_AmanApp.swift
    │
    ├── Model/
    │   └── Vehicle.swift
    │
    ├── Services/
    │   └── VehicleService.swift
    │
    ├── ViewModel/
    │   ├── VehicleListViewModel.swift
    │   └── VehicleDetailViewModel.swift
    │
    ├── Views/
    │   ├── VehicleListView.swift
    │   ├── VehicleRowView.swift
    │   └── VehicleDetailView.swift
    │
    ├── Resource/
    │   └── vehicles.json          # Local fallback (bundled in app)
    │
    └── Assets.xcassets/
        ├── AccentColor.colorset/
        ├── AppIcon.appiconset/
        └── Contents.json
```

## Assumptions

- Vehicle status values are `"ONLINE"` or `"OFFLINE"`
- `lastUpdated` uses ISO 8601 format: `yyyy-MM-dd'T'HH:mm:ss`
- Remote API returns an array of vehicle objects
- Selecting a vehicle from the list navigates to its detail screen

## Known Limitations

- No unit tests included
