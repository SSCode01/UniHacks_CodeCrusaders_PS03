# 📦 ChaosClub Backend - Quick Extraction Guide

## What's in the ZIP file?

```
chaosclub_backend_complete.zip
│
├── 📄 README.md                    # Complete documentation
├── 📄 API_DOCUMENTATION.md         # API integration guide
├── 📄 SETUP_GUIDE.md               # Quick start guide
├── 📄 FEATURE_CHECKLIST.md         # All features listed
├── 📄 requirements.txt             # Python packages
├── 📄 manage.py                    # Django management
├── 📄 setup.sh                     # Auto setup script
├── 📄 .env.example                 # Config template
├── 📄 .gitignore                   # Git ignore rules
│
├── 📁 chaosclub_backend/           # Main Django project
│   ├── settings.py                # All settings
│   ├── urls.py                    # URL routing
│   ├── wsgi.py                    # WSGI config
│   └── asgi.py                    # ASGI config
│
├── 📁 users/                       # User app
│   ├── models.py                  # User, Badge, DailyMood
│   ├── serializers.py             # API serializers
│   ├── views.py                   # Auth & profile views
│   ├── urls.py                    # User endpoints
│   ├── admin.py                   # Admin config
│   └── apps.py
│
├── 📁 groups/                      # Groups app
│   ├── models.py                  # Group, Membership
│   ├── serializers.py             # API serializers
│   ├── views.py                   # Group management
│   ├── urls.py                    # Group endpoints
│   ├── admin.py                   # Admin config
│   └── apps.py
│
└── 📁 activities/                  # Activities app
    ├── models.py                  # Prompts, Polls, Capsules
    ├── serializers.py             # API serializers
    ├── views.py                   # Activity views
    ├── urls.py                    # Activity endpoints
    ├── admin.py                   # Admin config
    └── apps.py
```

---

## 🚀 SUPER QUICK START (5 Minutes)

### Step 1: Extract ZIP
```bash
# Extract the zip file
unzip chaosclub_backend_complete.zip -d chaosclub_backend

# Navigate to folder
cd chaosclub_backend
```

### Step 2: Run Setup
```bash
# Make script executable
chmod +x setup.sh

# Run setup (installs everything)
./setup.sh
```

**The setup script will:**
- ✅ Create virtual environment
- ✅ Install all Python packages
- ✅ Setup database
- ✅ Create badges
- ✅ Ask if you want to create admin user (say YES)

### Step 3: Start Server
```bash
# Activate virtual environment
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Start Django server
python manage.py runserver
```

### Step 4: Test It! 🎉
Open in browser:
- **API Docs:** http://127.0.0.1:8000/swagger/
- **Admin Panel:** http://127.0.0.1:8000/admin/

---

## 📱 Connect Your Flutter App

### 1. Find Your Computer's IP Address

**Windows:**
```bash
ipconfig
# Look for IPv4 Address (e.g., 192.168.1.100)
```

**Mac/Linux:**
```bash
ifconfig
# or
ip addr show
# Look for inet (e.g., 192.168.1.100)
```

### 2. Update Flutter Code

In your Flutter project, create:

**File: `lib/config/api_config.dart`**
```dart
class ApiConfig {
  // For emulator/simulator
  static const String baseUrl = 'http://127.0.0.1:8000/api';
  
  // For physical device (use your computer's IP)
  // static const String baseUrl = 'http://192.168.1.100:8000/api';
}
```

### 3. Make API Call Example

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';

// Login example
Future<void> login() async {
  final response = await http.post(
    Uri.parse('${ApiConfig.baseUrl}/auth/login/'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'username': 'chaos_king',
      'password': 'password123',
    }),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    print('Login successful!');
    print('Access Token: ${data['tokens']['access']}');
  }
}
```

---

## 📚 Important Files to Read

1. **SETUP_GUIDE.md** - Complete overview
2. **API_DOCUMENTATION.md** - Every API endpoint with examples
3. **README.md** - Full documentation

---

## 🆘 Troubleshooting

### "Python not found"
Install Python 3.8+ from python.org

### "Permission denied"
```bash
chmod +x setup.sh
```

### "Port 8000 already in use"
```bash
# Use different port
python manage.py runserver 8001
```

### Can't connect from Flutter
- Make sure backend server is running
- Use your computer's IP (not 127.0.0.1) for physical devices
- Check firewall settings

---

## ✅ You're Ready!

Everything you need is in this ZIP file. Just extract, setup, and start coding! 🚀

**Questions?** Check the documentation files included in the ZIP.
