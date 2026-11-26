# Pet Care Diary – iOS Application

A modern, standalone iOS application built with **SwiftUI**, **SwiftData**, and **LocalAuthentication**, following clean **MVVM architecture**.

Designed for iOS 17.0+ for iPhone (portrait orientation).

---

## 🐾 Overview & Features

### 1. Biometric Authentication (Face ID / Touch ID) & Fallback Login
- Automatically initiates Face ID authentication on app launch.
- Gracefully detects biometry type (Face ID, Touch ID, or Optic ID) and displays contextual status.
- Fallback local authentication form with validation:
  - Username cannot be empty.
  - Password minimum length requirement of 6 characters.
  - Demo account credentials: `petowner` / `123456`.
  - Convenient **"Auto-fill Demo Credentials"** button for fast testing.
- Lock/Sign Out button directly available on the Dashboard to re-authenticate at any time.

### 2. Dashboard with Pet Statistics & Upcoming Visits
- **Total Pets** count.
- **Due Soon** vaccination count (upcoming within 30 days).
- **Overdue** vaccination warning count.
- **Vet Visits** upcoming count.
- **Urgent Attention Banner**: Automatically alerts the user if any pet has overdue vaccinations with one-tap navigation.
- **Upcoming Vet Visits Preview**: Shows the next scheduled veterinary appointments with calendar badges and quick-completion actions.
- **Recently Added Pets**: Direct access to newly added pet profiles.
- **Quick Action Buttons**: "Add Pet" and "Book Visit".

### 3. Pet List & Card View
- Beautiful list of pet cards with custom species avatars.
- Shows pet name, breed, species, age description (e.g. `2 yr 3 mo`), weight, and color-coded vaccination status pill.
- Swipe-to-delete with confirmation modal.

### 4. Search & Species Filtering
- Real-time search bar filtering across pet name, breed, and species.
- Horizontal species filter chips: **All, Dog, Cat, Bird, Fish, Rabbit, Other**.
- Status filter pills: **All, Up to Date, Due Soon, Overdue, Not Set**.

### 5. Add Pet Profile
- Name (required with inline validation).
- Species picker with SF Symbols.
- Breed, date of birth, weight in kg.
- Primary veterinarian name and phone number.
- Vaccination schedule toggle: record last vaccination date and next due date.
- Notes (multi-line text field).

### 6. Pet Details View
- Hero profile header with species avatar, name, breed, age, and vaccination badge.
- Full pet information breakdown.
- Vaccination status section with countdown in days or overdue alerts.
- Veterinarian contact card with **direct tap-to-call** phone link (`tel://`).
- **Pet Appointments Section**: Shows all appointments specific to this pet, with a button to add appointments directly for this pet.
- Notes section.
- Action to Edit Pet or permanently Delete Pet.

### 7. Edit Pet Profile
- Update weight, vaccination schedule (toggle on/off or change dates), veterinarian details, and notes.
- Instant SwiftData persistence and reactive UI refresh.

### 8. Delete Pet Profile
- Confirmation alerts to prevent accidental deletion.
- Cascade deletion of associated veterinary appointments.

### 9. Vaccination Status Tracking
- **Up to Date**: Next booster is more than 30 days away (Green shield badge).
- **Due Soon**: Next booster is within the next 30 days (Amber alarm badge).
- **Overdue**: Next booster was due before today (Red warning badge).
- **Not Set**: No next vaccination date specified (Gray badge).

### 10. Veterinary Appointment Management
- Dedicated **Vet Visits** tab.
- Filter by **Upcoming**, **Completed**, or **All**, plus filter by specific Pet.
- Schedule new visits with appointment reason (e.g., Annual Checkup, Vaccine Booster, Dental Cleaning), date/time, clinic name, vet name, and notes.
- Mark appointments completed with interactive checkbox or swipe actions.
- Full integration with the Dashboard upcoming visits preview.

---

## 🛠️ Architecture & Project Structure

The project follows strict **MVVM (Model-View-ViewModel)** separation:

```text
PetCareDiary_Complete/
├── PetCareDiary.xcodeproj/
│   └── project.pbxproj
├── PetCareDiary/
│   ├── PetCareDiaryApp.swift
│   ├── Info.plist
│   ├── Assets.xcassets/
│   │   ├── Contents.json
│   │   ├── AccentColor.colorset/
│   │   └── AppIcon.appiconset/
│   │       ├── Contents.json
│   │       └── AppIcon-1024.png
│   ├── Models/
│   │   ├── Pet.swift
│   │   ├── VetAppointment.swift
│   │   ├── VaccinationStatus.swift
│   │   └── Species.swift
│   ├── ViewModels/
│   │   ├── AuthViewModel.swift
│   │   ├── DashboardViewModel.swift
│   │   ├── PetViewModel.swift
│   │   └── AppointmentViewModel.swift
│   ├── Services/
│   │   ├── BiometricAuthService.swift
│   │   └── SampleDataService.swift
│   └── Views/
│       ├── Main/
│       │   ├── RootView.swift
│       │   └── ContentView.swift
│       ├── Authentication/
│       │   └── LoginView.swift
│       ├── Dashboard/
│       │   ├── DashboardView.swift
│       │   ├── StatCardView.swift
│       │   └── UpcomingVisitCard.swift
│       ├── Pets/
│       │   ├── PetListView.swift
│       │   ├── PetRowCard.swift
│       │   ├── PetDetailView.swift
│       │   ├── AddPetView.swift
│       │   ├── EditPetView.swift
│       │   ├── VaccinationBadge.swift
│       │   └── SpeciesFilterChip.swift
│       └── Appointments/
│           ├── AppointmentListView.swift
│           ├── AddAppointmentView.swift
│           └── AppointmentRowCard.swift
└── README.md
```

---

## 🚀 How to Open and Run in Xcode

1. Extract `PetCareDiary_Complete_Xcode_Project.zip`.
2. Double-click `PetCareDiary.xcodeproj` to open it in **Xcode 15** or later.
3. Select any iPhone simulator (e.g., **iPhone 15 Pro**, **iPhone 16**) from the target destination dropdown in the Xcode toolbar.
4. Press **Cmd + R** (or click the **Play** button) to build and run the application.

### Testing Face ID in the Simulator
1. In the Simulator menu bar, navigate to **Features > Face ID > Enrolled**.
2. When the app launches, choose **Features > Face ID > Matching Face** to authenticate instantly.
3. To test the fallback login, cancel Face ID or enter:
   - **Username**: `petowner`
   - **Password**: `123456`
   (Or tap the **"Auto-fill Demo Credentials"** button).

### Preloaded Sample Data
If running on a clean device or simulator with an empty database:
- Tapping **"Load Sample Demo Data"** from the Dashboard or My Pets screen will instantly populate sample pets (Bella, Milo, Charlie, Luna, Pip) and realistic vet appointments demonstrating all vaccination statuses and upcoming visit cards.
