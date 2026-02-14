# 🎭 ChaosClub Django Backend - Complete Package

## What You Got

I've created a **complete, production-ready Django REST API backend** for your ChaosClub Flutter app! Here's everything included:

### 📁 Project Structure

```
chaosclub_backend/
├── 📄 README.md                    - Complete documentation
├── 📄 API_DOCUMENTATION.md         - Detailed API guide for Flutter
├── 📄 requirements.txt             - All dependencies
├── 📄 manage.py                    - Django management
├── 📄 setup.sh                     - Quick setup script
├── 📄 .env.example                 - Environment template
├── 📄 .gitignore                   - Git ignore rules
│
├── 📁 chaosclub_backend/           - Main project config
│   ├── settings.py                - Django settings
│   ├── urls.py                    - URL routing
│   ├── wsgi.py                    - WSGI config
│   └── asgi.py                    - ASGI config
│
├── 📁 users/                       - User Management
│   ├── models.py                  - User, Badge, DailyMood
│   ├── serializers.py             - API serializers
│   ├── views.py                   - Auth & profile views
│   ├── urls.py                    - User endpoints
│   ├── admin.py                   - Admin panel config
│   └── apps.py                    - App configuration
│
├── 📁 groups/                      - Groups/Squads
│   ├── models.py                  - Group, Membership
│   ├── serializers.py             - API serializers
│   ├── views.py                   - Group management
│   ├── urls.py                    - Group endpoints
│   ├── admin.py                   - Admin panel config
│   └── apps.py                    - App configuration
│
└── 📁 activities/                  - Prompts, Polls, Capsules
    ├── models.py                  - DailyPrompt, Poll, TimeCapsule
    ├── serializers.py             - API serializers
    ├── views.py                   - Activity views
    ├── urls.py                    - Activity endpoints
    ├── admin.py                   - Admin panel config
    └── apps.py                    - App configuration
```

## 🚀 Quick Start (3 Steps)

### Option 1: Automated Setup (Recommended)

```bash
# Make setup script executable and run it
chmod +x setup.sh
./setup.sh
```

This will:
- ✅ Create virtual environment
- ✅ Install all dependencies
- ✅ Setup database
- ✅ Create initial badges
- ✅ Prompt for admin user creation

### Option 2: Manual Setup

```bash
# 1. Create virtual environment
python3 -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# 2. Install dependencies
pip install -r requirements.txt

# 3. Setup database
python manage.py makemigrations
python manage.py migrate

# 4. Create admin user
python manage.py createsuperuser

# 5. Run server
python manage.py runserver
```

## ✨ Features Implemented

### 🔐 Authentication & Users
- ✅ User registration with email & username
- ✅ JWT authentication (login/logout)
- ✅ Profile management with emoji avatars
- ✅ Password change
- ✅ Daily mood tracking
- ✅ Streak system (tracks consecutive days)
- ✅ Points system for gamification
- ✅ Badge system with achievements
- ✅ Leaderboard with rankings

### 👥 Groups (Squads)
- ✅ Create groups with custom emoji
- ✅ 6-character invite codes
- ✅ Join groups via invite code
- ✅ Admin/member role system
- ✅ Member management (add/remove)
- ✅ Chaos level tracking
- ✅ Leave group functionality

### 🎮 Activities

**Daily Prompts**
- ✅ Daily questions for groups
- ✅ Vote for group members
- ✅ Vote tracking and results
- ✅ Points for participation

**Polls**
- ✅ Create custom polls
- ✅ Multiple choice options
- ✅ Anonymous voting option
- ✅ Real-time vote counts
- ✅ Results display

**Time Capsules**
- ✅ Create scheduled messages
- ✅ Set unlock dates
- ✅ Media support (photos/videos)
- ✅ Auto-unlock on date
- ✅ Preview for creators

### 🎯 Gamification
- ✅ Points for all activities
- ✅ Streak tracking system
- ✅ Badge system
- ✅ Leaderboard rankings
- ✅ Activity statistics

## 📱 Flutter Integration

### Base Configuration

```dart
class ApiConfig {
  static const String baseUrl = 'http://your-server:8000/api';
}
```

### Key Endpoints for Your Flutter Screens

**Login Screen** → `POST /api/auth/login/`
**Signup Screen** → `POST /api/auth/register/`
**Profile Screen** → `GET /api/auth/profile/`
**Home Screen** → `GET /api/groups/` + `GET /api/auth/stats/`
**Create Group** → `POST /api/groups/`
**Join Group** → `POST /api/groups/join/`
**Group Dashboard** → `GET /api/groups/{id}/`
**Daily Mood** → `POST /api/auth/mood/`
**Daily Prompt** → `GET /api/activities/groups/{id}/prompts/`
**Vote Prompt** → `POST /api/activities/prompts/{id}/vote/`
**Create Poll** → `POST /api/activities/groups/{id}/polls/`
**Vote Poll** → `POST /api/activities/polls/{id}/vote/`
**Create Capsule** → `POST /api/activities/groups/{id}/capsules/`
**Leaderboard** → `GET /api/auth/leaderboard/`

## 🔗 Important URLs

Once server is running:
- **API Docs (Swagger)**: http://127.0.0.1:8000/swagger/
- **API Docs (ReDoc)**: http://127.0.0.1:8000/redoc/
- **Admin Panel**: http://127.0.0.1:8000/admin/

## 📊 Database Models

### Users App
- `User` - Custom user with emoji avatar, points, streaks
- `Badge` - Achievement badges
- `UserBadge` - Badges earned by users
- `DailyMood` - Daily mood check-ins

### Groups App
- `Group` - Groups/squads with invite codes
- `GroupMembership` - User-group relationships with roles

### Activities App
- `DailyPrompt` - Daily questions
- `PromptVote` - Votes on prompts
- `Poll` - User-created polls
- `PollOption` - Poll choices
- `PollVote` - Votes on polls
- `TimeCapsule` - Scheduled messages

## 🔧 Configuration

### Environment Variables

Create `.env` file:
```env
SECRET_KEY=your-secret-key
DEBUG=True
ALLOWED_HOSTS=localhost,127.0.0.1
```

### CORS Settings

Already configured to allow all origins in development. For production, update `settings.py`:

```python
CORS_ALLOWED_ORIGINS = [
    "https://your-flutter-app-domain.com",
]
```

## 🚀 Deployment

### For Production

1. **Use PostgreSQL** instead of SQLite
2. **Set environment variables** properly
3. **Disable DEBUG** mode
4. **Set SECRET_KEY** to a secure random string
5. **Configure ALLOWED_HOSTS**
6. **Setup HTTPS** for API
7. **Run collectstatic** for static files

### Popular Hosting Options
- **Railway** - Easy deployment
- **Heroku** - Classic PaaS
- **DigitalOcean App Platform** - Simple scaling
- **AWS EC2** - Full control
- **Google Cloud Run** - Containerized

## 📝 API Response Examples

### Registration
```json
POST /api/auth/register/
{
  "username": "chaos_king",
  "email": "king@example.com",
  "password": "Pass123!",
  "password2": "Pass123!",
  "emoji_avatar": "😎"
}

Response: {
  "user": {...},
  "tokens": {
    "access": "eyJ0eXAi...",
    "refresh": "eyJ0eXAi..."
  }
}
```

### Create Group
```json
POST /api/groups/
Authorization: Bearer <token>
{
  "name": "Squad Goals",
  "emoji": "🔥",
  "chaos_level": "high"
}

Response: {
  "id": 1,
  "invite_code": "ABC123",
  ...
}
```

## 🎯 Points System

Users earn points for:
- Daily mood: 10 points
- Voting on prompt: 5 points
- Voting on poll: 3 points
- Creating capsule: 15 points
- Creating poll: 10 points

## 🏆 Badges

Pre-configured badges:
- 🔥 7 Day Streak
- 🌟 30 Day Streak
- 👑 Roast King (100 points)
- 😂 Meme Master (150 points)
- 📦 Capsule Creator (50 points)
- 📊 Poll Master (75 points)
- 🎭 Chaos Coordinator (200 points)
- 👥 Squad Leader (50 points)

## 💡 Pro Tips

1. **Test with Swagger UI** - The interactive docs at `/swagger/` let you test all endpoints
2. **Use Admin Panel** - View and manage data at `/admin/`
3. **Check API_DOCUMENTATION.md** - Detailed integration guide for Flutter
4. **Secure Your Tokens** - Use flutter_secure_storage in your Flutter app
5. **Handle Token Refresh** - Implement auto-refresh when access token expires

## 🐛 Troubleshooting

**Can't run server?**
- Make sure virtual environment is activated
- Check if port 8000 is available

**Database errors?**
- Delete `db.sqlite3` and run migrations again
- Make sure you ran `makemigrations` and `migrate`

**Import errors?**
- Verify all dependencies are installed
- Check if you're in the correct directory

## 📚 Next Steps

1. ✅ Run the setup script
2. ✅ Create a test user via API or admin panel
3. ✅ Test endpoints using Swagger UI
4. ✅ Integrate with your Flutter app
5. ✅ Deploy to production server

## 🤝 Support

Need help? Check:
- README.md - Full documentation
- API_DOCUMENTATION.md - API integration guide
- Swagger UI at `/swagger/` - Interactive API testing

## 🎉 You're All Set!

Your Django backend is ready to rock with your Flutter app. The API is fully functional and matches all your Flutter screens perfectly!

**Happy coding! 🚀**
