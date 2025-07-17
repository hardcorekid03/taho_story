# 🧋 Taho Story - Mobile Ordering App (Flutter)

**Taho Story** is a mobile application developed using **Flutter**, designed to streamline the order-taking process for a local taho business. The app supports features such as flavor selection, buy-one-take-one offers, multiple sizes, payment options (Cash/GCash), and user-based access control (owner vs. employee).

---

## 📱 Features

- 📝 Place Taho Orders with customer details
- 🍮 Choose from a menu of 15+ custom flavors
- 📦 Select product sizes (MC-B1T1, MM, M)
- 🆓 Buy-One-Take-One flavor selection
- 💰 Payment support: Cash or GCash
  - If GCash is selected, a modal prompts for reference number
- 📜 Order history saved locally (offline-friendly)
- ✏️ Edit and delete existing orders
- 🧾 Auto-calculated SC/PWD discount (20%)
- 🔢 Auto-incrementing order number
- 📋 View menu with pricing and flavor list


---

## 📂 Project Structure

```
lib/
├── main.dart
├── screens/
│   ├── home_screen.dart
│   ├── order_form_screen.dart
│   ├── view_orders_screen.dart
│   └── menu_screen.dart
├── widgets/
│   └── order_form.dart
├── helpers/
│   └── order_builder.dart
assets/
└── fonts/ (HarmonyOS Sans)
```

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK: [Install Guide](https://docs.flutter.dev/get-started/install)
- Dart
- Android Studio or VS Code
- Git

### Installation

1. **Clone the repository**

```bash
git clone https://github.com/hardcorekid03/taho_story.git
cd taho_story
```

2. **Get dependencies**

```bash
flutter pub get
```

3. **Run the app**

```bash
flutter run
```

---

## 🧑‍🎓 Technologies Used

- **Flutter** (Dart)
- **shared_preferences** – for local storage
- **intl** – for date formatting
- **Google Fonts** *(replaced with HarmonyOS Sans)*
- **Material Design 3**

---

## 📖 Usage

- Tap **"Place Taho Order"** to fill out the form.
- Select flavors, sizes, B1T1 options, and payment method.
- Orders are saved locally and can be viewed under **"View Orders"**.
- Edit or delete existing orders easily.
- Visit **"Menu"** to view all available flavors with prices.

---

## 🧪 Testing & Evaluation

| Criteria                            | Max Points |
|-------------------------------------|------------|
| UI/UX Design (ILO 1)                | 20 pts     |
| Coding Standards & Documentation (ILO 2) | 10 pts     |
| Unit Testing (ILO 3) *(optional)*   | 10 pts     |
| **Total**                           | **40 pts** |

This project accounts for **30%** of the final grade in **IT 331 – Application Development & Emerging Technologies**.

---

## 📄 License

This project is for academic use under the guidelines of IT 331 – Application Development.

---

## ✍️ Author

**Name:** Anthony F. Tolentino  
**Course:** BSIT – ETEEAP 
**Subject:** IT 331 – Application Development  
**Instructor:** Maurice Oliver Dela Cruz
**Date Submitted:** July 26, 2025

---