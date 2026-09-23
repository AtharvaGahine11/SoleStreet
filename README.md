# SoleStreet — Step Into Your Style 👟

**SoleStreet** is a modern, commercial-grade cross-platform e-commerce application for premium sneakers and streetwear shopping, built entirely with **Flutter** and **Dart**.

This application is created as a college mini-project for **Cross Platform Application Development**, demonstrating production-level Flutter concepts, clean architecture, responsive layouts, and state management without relying on external backends or APIs.

---

## 🌟 Key Features

### 1. Animated Splash & Onboarding
- **Animated Splash Screen**: Smooth fade and scale micro-animations featuring the SoleStreet logo and tagline.
- **3-Step Onboarding Flow**: Interactive slides introducing trending sneakers, style discovery, and secure shopping with page indicators and skip options.

### 2. Main Shell & Bottom Navigation
- **Material 3 Bottom Navigation**: Smooth navigation between Home 🏠, Shop 🛍️, Wishlist ❤️, Cart 🛒, and Profile 👤 screens.
- **Dynamic Badge Counter**: Live cart badge displaying real-time item count.

### 3. Home & Product Catalog
- **Personalized Header**: User avatar, greeting, and notification shortcuts.
- **Search Bar**: Real-time product search by name, brand (Nike, Adidas, Jordan, Puma, New Balance, Vans, Converse, etc.), or category.
- **Promotional Hero Banner**: Custom gradient banner featuring limited-time deals ("STEP INTO THE NEW SEASON").
- **Horizontal Category Selector**: Interactive filter chips (All, Sneakers, Running, Basketball, Lifestyle, Streetwear, Accessories).
- **Trending Sneakers Carousel & Responsive Grids**: Adapts column count across Mobile (2 columns), Tablet (3 columns), and Desktop (4-5 columns).

### 4. Product Details & Selection Engine
- **Image Gallery Carousel**: Multi-angle product views with thumbnail selectors.
- **Pricing & Discounts**: Indian Rupee (`₹`) pricing, original price strike-through, and discount percentage tags.
- **Color & Size Chips**: Interactive size and color selection.
- **Mandatory Size Validation**: Ensures size selection before adding items to cart or proceeding to buy now.

### 5. Filter & Sorting Engine
- Modal bottom sheet filter dialog for:
  - **Category**: Sneakers, Running, Basketball, Lifestyle, Streetwear, Accessories
  - **Price Range**: Under ₹2,000, ₹2,000–₹5,000, ₹5,000–₹10,000, Above ₹10,000
  - **Rating**: 3+ Stars, 4+ Stars
  - **Sorting**: Popularity, Price Low to High, Price High to Low, Rating, Newest

### 6. Wishlist & Shopping Cart
- **Wishlist**: Quick toggle heart buttons and one-tap "Move to Cart" action.
- **Cart Steppers**: Real-time quantity adjustments, item removal, and auto-updated subtotal.
- **Sample Coupon Engine**: Integrated promo code validation:
  - `SOLE10` → 10% Discount
  - `NEWUSER` → 15% Discount
  - `KICK20` → 20% Discount
- **Order Summary Card**: Detailed breakdown of Subtotal, Coupon Discount, Delivery Fee (FREE over ₹5,000), and Total.

### 7. Checkout & Order History
- **Form Validation**: Validates recipient name, mobile number, house/flat, street, city, state, and PIN code.
- **Delivery Options**: Standard Delivery (2-4 Days) vs Express Delivery (24-48 Hours).
- **Payment Gateway Simulation**: Options for UPI (GPay/PhonePe), Credit/Debit Card, NetBanking/Wallet, and Cash on Delivery (COD).
- **Order Success Screen**: Animated checkmark, unique order ID (`#SS-XXXXXX`), order summary, and estimated delivery dates.
- **Order Timeline Tracking**: Track order status (`Confirmed`, `Packed`, `Shipped`, `Delivered`).

### 8. Theme System (Dark & Light Mode)
- Full **Dark Mode** and **Light Mode** support with dynamic state updates using Provider.

---

## 🛠️ Technology Stack

- **Framework**: Flutter 3.44+
- **Language**: Dart 3.12+
- **Design System**: Material 3 & Custom Typography (Google Fonts Inter / Outfit)
- **State Management**: `provider: ^6.1.2` (`ChangeNotifier` + `Consumer`)
- **Formatting**: `intl: ^0.19.0`

---

## 📁 Project Structure

```text
SoleStreet/
├── pubspec.yaml
├── README.md
└── lib/
    ├── main.dart                      # App entrypoint with ChangeNotifierProvider
    │
    ├── models/                        # Core Data Models
    │   ├── product.dart               # Product entity
    │   ├── cart_item.dart             # Cart item entity
    │   ├── address.dart               # Delivery address entity
    │   └── order.dart                 # Order & tracking entity
    │
    ├── data/
    │   └── product_data.dart          # 20 realistic sample sneaker & streetwear items
    │
    ├── providers/
    │   └── app_state.dart             # Master application state (Cart, Wishlist, Coupons, Orders, Theme)
    │
    ├── theme/
    │   └── app_theme.dart             # Material 3 light/dark themes & responsive grid helpers
    │
    ├── widgets/                       # Reusable Custom UI Components
    │   ├── product_card.dart          # Responsive sneaker card
    │   ├── category_chip.dart         # Category pill selector
    │   ├── search_bar_widget.dart     # Interactive search input
    │   ├── cart_item_card.dart        # Cart row with stepper
    │   ├── price_summary.dart         # Checkout price breakdown card
    │   ├── promotional_banner.dart    # Hero discount banner
    │   ├── filter_bottom_sheet.dart   # Filter & sort modal sheet
    │   └── empty_state_widget.dart    # Empty cart/wishlist/search state
    │
    └── screens/                       # Application Views
        ├── splash_screen.dart         # Animated logo splash
        ├── onboarding_screen.dart     # 3-step feature onboarding
        ├── main_navigation_screen.dart# Material 3 Bottom Navigation bar
        ├── home_screen.dart           # E-commerce homepage
        ├── shop_screen.dart           # Filterable product catalog
        ├── product_details_screen.dart# Detailed product view with size validation
        ├── wishlist_screen.dart       # Wishlist grid
        ├── cart_screen.dart           # Cart & coupon system
        ├── checkout_screen.dart       # Shipping address & payment selection
        ├── order_success_screen.dart  # Animated order confirmation
        ├── orders_screen.dart         # Order history list
        ├── order_details_screen.dart  # Order timeline & tracking breakdown
        ├── profile_screen.dart        # User profile & quick shortcuts
        └── settings_screen.dart       # Dark mode & app settings
```

---

## 🚀 How to Run the Project

### Prerequisites
Ensure you have Flutter installed on your system:
```bash
flutter doctor
```

### Installation Steps

1. Navigate to the project directory:
   ```bash
   cd SoleStreet
   ```

2. Fetch all dependencies:
   ```bash
   flutter pub get
   ```

3. Run the application on your target device (Chrome Web, macOS Desktop, Android, or iOS):
   ```bash
   flutter run
   ```

4. *(Optional)* Build production release executable:
   - For Web:
     ```bash
     flutter build web
     ```
   - For APK (Android):
     ```bash
     flutter build apk --release
     ```

---

## 📸 Sample Coupons for Testing Checkout

| Coupon Code | Discount | Description |
|---|---|---|
| `SOLE10` | 10% OFF | 10% discount on cart subtotal |
| `NEWUSER` | 15% OFF | 15% welcome discount |
| `KICK20` | 20% OFF | 20% premium sneakerhead deal |

---

## 🔮 Future Enhancements

- Integration with Firebase Authentication & Cloud Firestore
- Real Payment Gateway integration (Razorpay / Stripe)
- AR Sneaker Try-On simulation
- Push notifications using Firebase Cloud Messaging (FCM)
