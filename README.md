---

# 💸 Expense Tracker App (Flutter)

A **professional Flutter Expense Tracker application** built using **MVVM architecture**, **Provider state management**, and **SQLite (sqflite)** for local data persistence.

This project is designed as a **scalable foundation** for finance, HRMS expense modules, or personal budgeting apps.

---

## 🚀 Features

* ✅ Add, edit, and delete expenses
* ✅ Category-wise expense tracking
* ✅ Category-wise total calculation
* ✅ Overall total expense summary
* ✅ Persistent local storage using SQLite
* ✅ Clean MVVM architecture
* ✅ Provider-based state management
* ✅ Delete confirmation dialog (UX safe)

---

## 🏗 Architecture

The app follows the **MVVM (Model–View–ViewModel)** pattern:

```text
UI (View)
   ↓
ViewModel (Business Logic + State)
   ↓
Model (Data)
   ↓
SQLite Database
```

### Why MVVM?

* Separation of concerns
* Easy maintenance & scalability
* Test-friendly
* Industry-standard architecture

---

## 📁 Project Structure

```text
lib/
 ├─ model/
 │   └─ expense_model.dart
 │
 ├─ db/
 │   └─ expense_db.dart
 │
 ├─ viewmodel/
 │   └─ expense_view_model.dart
 │
 ├─ view/
 │   ├─ expense_home_page.dart
 │   ├─ add_expense_page.dart
 │   └─ edit_expense_page.dart
 │
 └─ main.dart
```

---

## 🧱 Tech Stack

| Layer            | Technology            |
| ---------------- | --------------------- |
| UI               | Flutter (Material UI) |
| State Management | Provider              |
| Architecture     | MVVM                  |
| Local Database   | SQLite (sqflite)      |
| Language         | Dart                  |

---

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.2
  sqflite: ^2.3.0
  path: ^1.9.0
```

---

## 💾 Database Schema

```sql
CREATE TABLE expenses (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT,
  amount REAL,
  category TEXT,
  date TEXT
);
```

---

## 🧠 Core Concepts Used

* ChangeNotifier & notifyListeners
* Provider (`watch` / `read`)
* SQLite CRUD operations
* MVVM best practices
* Clean UI–Logic separation
* Confirmation dialogs for destructive actions

---

## ▶️ Getting Started

### 1️⃣ Clone the repository

```bash
git clone https://github.com/Robiul13/expense-tracker-flutter.git
```

### 2️⃣ Install dependencies

```bash
flutter pub get
```

### 3️⃣ Run the app

```bash
flutter run
```

> ⚠️ If database structure changes, **uninstall the app** and run again to recreate the DB.

---

## 📸 Screens (Optional – you can add later)

* Expense List
* Add Expense
* Edit Expense
* Category Summary

---

## 🔮 Future Enhancements

* 📊 Pie / Bar chart (category distribution)
* 📅 Monthly & yearly filters
* 🏷 Custom categories
* 📤 Export to PDF / Excel
* ☁️ Cloud sync (Firebase)
* ⚡ Riverpod version
* 🧪 Unit & widget tests

---

## 👨‍💻 Author

**Md. Robiul Islam**
Flutter & Backend Developer
📍 Bangladesh

---

## 📄 License

This project is open-source and available under the **MIT License**.

---

## ⭐ Support

If you like this project:

* ⭐ Star the repository
* 🍴 Fork it
* 🐛 Report issues
* 💡 Suggest features

---
