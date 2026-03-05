# Miki Menabung - Application Blueprint

## Overview

"Miki Menabung" is a mobile application designed to help users track their savings in a simple and intuitive way. It features a login system and a dashboard to visualize savings progress.

## Style, Design, and Features

### Version 1.0 (Initial)

*   **Theme:** A clean and modern design with a blue color scheme, inspired by finance and trust.
*   **Typography:** Uses the "Poppins" font from Google Fonts for a friendly and readable interface.
*   **Core Features:**
    *   **Login Screen:** A simple login page with fields for email and password, and a prominent app logo.
    *   **Dashboard Screen:**
        *   Displays the user's current savings balance.
        *   Shows progress towards a defined savings goal.
        *   Lists recent transactions (deposits and withdrawals).
    *   **Navigation:** Uses `go_router` for navigating between the login and dashboard screens.

### Version 2.0 (Enhanced Dashboard & Targets)

*   **State Management:** Integrated `provider` for robust state management of savings targets and transactions.
*   **Attractive UI:** Redesigned dashboard with a more visually appealing and interactive layout, using cards, icons, and progress indicators.
*   **Dynamic Targets:**
    *   **Add Target:** Users can create new savings goals through a dedicated "Add Target" screen.
    *   **Target Details:** Each target includes a title, total amount, and a minimum daily savings amount.
    *   **Make Deposits:** Users can make deposits ("setoran") towards a specific target, with a dialog to input the nominal amount.
*   **Models:** Introduced `SavingsTarget` and `Transaction` models to structure application data.

## Current Plan

### Implement Enhanced Dashboard

1.  **Add `provider`:** Add the `provider` package for state management.
2.  **Create Models & Provider:** Define `SavingsTarget` model and a `SavingsProvider` to manage state.
3.  **Refactor `main.dart`:** Wrap the app with `ChangeNotifierProvider`.
4.  **Create `add_target_screen.dart`:** Build the UI for adding a new savings target.
5.  **Redesign `dashboard_screen.dart`:**
    *   Display a list of savings targets from the `SavingsProvider`.
    *   Show an empty state with an "Add Target" button if no targets exist.
    *   Implement the "Setor" (Deposit) dialog to add funds to a target.
6.  **Update Routing:** Add a route for the `add_target_screen`.
