# Bongkob (បង្កប់)
> "Bongkob" means "to hide" in Khmer.

A mobile steganography app that protects sensitive information by hiding secret messages inside ordinary files — making the existence of the communication completely undetectable.

---

## Features

- **Text Steganography** — hides secret messages inside a paragraph using invisible zero-width characters (U+200B, U+200C)
- **AES-256 Encryption** — encrypts the message before hiding it so even if detected, it cannot be read without the correct password
- **Biometric Lock** — fingerprint authentication to access the app
- **Session History** — logs every encode and decode operation

---

## How It Works

### Encode
1. User enters a secret message, cover paragraph, and password
2. App encrypts the message using AES-256
3. App prepends a header `BONGKOB_V1<<<PAYLOAD>>>` to the encrypted output
4. App converts the full payload to binary bits
5. App inserts invisible characters between words of the cover paragraph — U+200B for bit 0, U+200C for bit 1
6. User copies the encoded paragraph and sends it

### Decode
1. User pastes the encoded paragraph and enters the password
2. App scans for invisible characters and extracts the bits
3. App checks for the header to confirm the text was encoded by Bongkob
4. App decrypts the payload using the password
5. App checks for the end marker `<<<END>>>` to confirm the password is correct
6. Original message is revealed

---

## Security Design

| Layer | What It Does |
|---|---|
| AES-256 | Encrypts the message so it cannot be read without the password |
| Steganography | Hides the encrypted message so nobody knows it exists |
| Header | Detects if a file was encoded by Bongkob without needing a password |
| End marker | Confirms the password is correct after decryption |

---

## Architecture
```bash
lib/
├── main.dart
├── theme/
│ └── app_theme.dart
├── data/
│ └── services/
│ ├── biometric_service.dart
│ ├── crypto_service.dart
│ ├── session_service.dart
│ └── text_stegano_service.dart
├── models/
│ ├── stegano_result.dart
│ └── stegano_session.dart
└── ui/
├── screens/
│ ├── biometric/
│ │ └── biometric_screen.dart
│ ├── decode/
│ │ └── decode_screen.dart
│ ├── encode/
│ │ ├── encode_home_screen.dart
│ │ └── text_encode_screen.dart
│ ├── profile/
│ │ └── profile_screen.dart
│ ├── vault/
│ │ └── vault_screen.dart
│ └── main_screen.dart
└── widgets/
├── error_box.dart
└── success_box.dart
```

---

## Tech Stack

| Technology | Purpose |
|---|---|
| Flutter | Mobile framework |
| Dart | Programming language |
| encrypt ^5.0.3 | AES-256 encryption |
| local_auth ^3.0.2 | Biometric authentication |

---

## Getting Started

### Prerequisites
- Flutter SDK 3.x
- Android device or emulator (API 23+)
- Android Studio or VS Code

### Run

```bash
git clone https://github.com/ThoeunYanit/Bongkob_Mobile_Development_Project.git
cd bongkob
flutter pub get
flutter run
```

### Biometric Setup
To test biometric on emulator:
1. Open Extended Controls → Fingerprint
2. Set up a fingerprint in emulator Settings → Security
3. Use Touch Sensor to simulate fingerprint tap

---

## Test Cases

### Case 1 — Encode success
**Input:** valid message, cover text, and password  
**Expected:** encoding complete, copy button appears

![Encode success](screenshots/encode_success.png)

---

### Case 2 — Encode fail — empty message
**Input:** no message entered  
**Expected:** "Message cannot be empty"

![Encode empty message](screenshots/encode_empty_message.png)

---

### Case 3 — Encode fail — empty cover text
**Input:** no cover text entered  
**Expected:** "Cover text cannot be empty"

![Encode empty cover](screenshots/encode_empty_cover.png)

---

### Case 4 — Encode fail — empty password
**Input:** no password entered  
**Expected:** "Password cannot be empty"

![Encode empty password](screenshots/encode_empty_password.png)

---

### Case 5 — Decode success
**Input:** encoded text + correct password  
**Expected:** original message revealed

![Decode success](screenshots/decode_success.png)

---

### Case 6 — Decode fail — wrong password
**Input:** encoded text + wrong password  
**Expected:** "Incorrect password"

![Decode wrong password](screenshots/decode_wrong_password.png)

---

### Case 7 — Decode fail — plain text
**Input:** plain text with no hidden data  
**Expected:** "No hidden data found in this text"

![Decode plain text](screenshots/decode_plain_text.png)

