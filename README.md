# Pokémon App

A SwiftUI-based Pokémon application built with a clean MVVM architecture, 
modern concurrency (async/await), SwiftData for local persistence, and a simple authentication flow. 
The app includes a full set of screens, a slide-out side menu, and detailed Pokémon browsing.

---

## 📱 Features

### **Authentication Flow**

* **Signup Screen** – Register user details and store them locally using **SwiftData**.
* **Login Screen** – Authenticate using stored credentials.
* **Forgot Password Screen** – Reset password flow (local logic / placeholder depending on implementation).

### **Pokémon Modules**

* **Home / Pokémon List Screen** – Fetch Pokémon list from API using async/await.
* **Pokémon Detail Screen** – Displays detailed information including images, stats, and more.
* Built with responsive SwiftUI design.

### **Side Menu**

* A sliding side menu that provides quick navigation across the app.

### **Local Persistence**

* Uses **SwiftData** to store user details securely.
* Lightweight and fast local storage.

### **Architecture**

* **MVVM Pattern** used throughout the project.
* ViewModels interact with async API calls.
* Separation of concerns ensured across modules.

### **Modern Concurrency**

* APIs implemented using **async/await**.
* Clean error handling & structured tasks.

---

## 🏗️ Tech Stack

* **SwiftUI** – Declarative UI
* **SwiftData** – Local user storage
* **MVVM Architecture** – Highly maintainable structure
* **Modern Concurrency (async/await)** – Efficient API calls
* **URLSession** – Networking

---

## 📦 Installation

1. Clone the repository.
2. Open the project in **Xcode 15 or higher**.
3. Run on iOS 17+ device or simulator.

---

## 📁 Folder Structure

```
PokemonApp/
│
├── Models/
├── ViewModels/
├── Views/
├── Services/
├── SwiftData/
└── Resources/
```

---

## 🚀 Future Improvements

* Add caching for Pokémon images.
* Implement real password reset via backend.
* Add animations & transitions.
* Add filtering & sorting in Pokémon list.

---

## 🧑‍💻 Author

Created by **Sathish**.

---

## 📝 License

This project is free to use for learning purposes.
