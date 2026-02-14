# ChaosClub Backend API

Django REST API backend for the ChaosClub Flutter mobile app - Built for chaotic friendships! 🎭

## Features

### 🔐 Authentication
- User registration and login with JWT tokens
- Profile management with emoji avatars
- Password change functionality
- Streak tracking and points system

### 👥 Groups (Squads)
- Create groups with custom names and emojis
- Join groups using 6-character invite codes
- Group member management (admin/member roles)
- Chaos level tracking

### 🎮 Activities
- **Daily Prompts**: Daily questions where members vote for each other
- **Polls**: User-created polls with multiple options
- **Time Capsules**: Scheduled messages that unlock on specific dates
- **Daily Moods**: Track daily mood check-ins

### 🏆 Gamification
- Points system for activity participation
- Streak tracking
- Badges and achievements
- Leaderboard

## Project Structure

```
chaosclub_backend/
├── chaosclub_backend/      # Main project settings
│   ├── settings.py        # Django settings
│   ├── urls.py            # URL routing
│   ├── wsgi.py            # WSGI config
│   └── asgi.py            # ASGI config
├── users/                 # User authentication & profiles
│   ├── models.py          # User, Badge, DailyMood models
│   ├── serializers.py     # API serializers
│   ├── views.py           # API views
│   ├── urls.py            # User endpoints
│   └── admin.py           # Admin configuration
├── groups/                # Groups/Squads management
│   ├── models.py          # Group, GroupMembership models
│   ├── serializers.py     # API serializers
│   ├── views.py           # API views
│   ├── urls.py            # Group endpoints
│   └── admin.py           # Admin configuration
├── activities/            # Prompts, Polls, Capsules
│   ├── models.py          # DailyPrompt, Poll, TimeCapsule models
│   ├── serializers.py     # API serializers
│   ├── views.py           # API views
│   ├── urls.py            # Activity endpoints
│   └── admin.py           # Admin configuration
├── manage.py              # Django management script
└── requirements.txt       # Python dependencies
```

## Installation & Setup

### Prerequisites
- Python 3.8+
- pip
- Virtual environment (recommended)

### Step 1: Install Dependencies

```bash
# Create virtual environment
python -m venv venv

# Activate virtual environment
# On Windows:
venv\Scripts\activate
# On macOS/Linux:
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt
```

### Step 2: Database Setup

```bash
# Create migrations
python manage.py makemigrations

# Apply migrations
python manage.py migrate

# Create superuser for admin panel
python manage.py createsuperuser
```

### Step 3: Create Initial Badges (Optional)

```bash
python manage.py shell
```

Then in the Python shell:

```python
from users.models import Badge

badges = [
    {'name': 'roast_king', 'description': 'Master of roasts', 'icon': '👑', 'points_required': 100},
    {'name': 'meme_master', 'description': 'Meme legend', 'icon': '😂', 'points_required': 150},
    {'name': 'capsule_creator', 'description': 'Time capsule pro', 'icon': '📦', 'points_required': 50},
    {'name': 'streak_7', 'description': '7 day streak', 'icon': '🔥', 'points_required': 0},
    {'name': 'streak_30', 'description': '30 day streak', 'icon': '🌟', 'points_required': 0},
]

for badge_data in badges:
    Badge.objects.get_or_create(**badge_data)

exit()
```

### Step 4: Run Development Server

```bash
python manage.py runserver
```

Server will start at `http://127.0.0.1:8000/`

## API Documentation

Once the server is running, visit:
- Swagger UI: `http://127.0.0.1:8000/swagger/`
- ReDoc: `http://127.0.0.1:8000/redoc/`
- Admin Panel: `http://127.0.0.1:8000/admin/`

## API Endpoints

### Authentication (`/api/auth/`)
```
POST   /api/auth/register/           - Register new user
POST   /api/auth/login/              - Login user
POST   /api/auth/token/refresh/      - Refresh JWT token
GET    /api/auth/profile/            - Get user profile
PUT    /api/auth/profile/            - Update profile
POST   /api/auth/change-password/    - Change password
GET    /api/auth/stats/              - Get user stats
GET    /api/auth/badges/             - List all badges
POST   /api/auth/mood/               - Create daily mood
GET    /api/auth/leaderboard/        - Get leaderboard
```

### Groups (`/api/groups/`)
```
GET    /api/groups/                  - List user's groups
POST   /api/groups/                  - Create new group
GET    /api/groups/{id}/             - Get group details
PUT    /api/groups/{id}/             - Update group
DELETE /api/groups/{id}/             - Delete group
POST   /api/groups/join/             - Join group with invite code
POST   /api/groups/{id}/leave/       - Leave group
POST   /api/groups/{id}/remove/{user_id}/  - Remove member
POST   /api/groups/{id}/promote/{user_id}/ - Promote to admin
```

### Activities (`/api/activities/`)
```
# Daily Prompts
GET    /api/activities/groups/{id}/prompts/     - List prompts
POST   /api/activities/groups/{id}/prompts/     - Create prompt
POST   /api/activities/prompts/{id}/vote/       - Vote on prompt

# Polls
GET    /api/activities/groups/{id}/polls/       - List polls
POST   /api/activities/groups/{id}/polls/       - Create poll
GET    /api/activities/polls/{id}/              - Get poll details
POST   /api/activities/polls/{id}/vote/         - Vote on poll

# Time Capsules
GET    /api/activities/groups/{id}/capsules/    - List capsules
POST   /api/activities/groups/{id}/capsules/    - Create capsule
GET    /api/activities/capsules/{id}/           - Get capsule details

# Summary
GET    /api/activities/groups/{id}/summary/     - Get activity summary
```

## Request/Response Examples

### Register User
```json
POST /api/auth/register/

Request:
{
  "username": "chaos_king",
  "email": "king@chaosclub.app",
  "password": "SecurePass123!",
  "password2": "SecurePass123!",
  "emoji_avatar": "😎",
  "bio": "CEO of bad decisions"
}

Response:
{
  "user": {
    "id": 1,
    "username": "chaos_king",
    "email": "king@chaosclub.app",
    "emoji_avatar": "😎",
    "bio": "CEO of bad decisions",
    "total_points": 0,
    "current_streak": 0,
    "longest_streak": 0,
    "earned_badges": []
  },
  "tokens": {
    "refresh": "eyJ0eXAiOiJKV1QiLCJhbGc...",
    "access": "eyJ0eXAiOiJKV1QiLCJhbGc..."
  }
}
```

### Create Group
```json
POST /api/groups/
Authorization: Bearer <access_token>

Request:
{
  "name": "Squad Goals",
  "emoji": "🔥",
  "chaos_level": "high"
}

Response:
{
  "id": 1,
  "name": "Squad Goals",
  "emoji": "🔥",
  "invite_code": "ABC123",
  "chaos_level": "high",
  "member_count": 1,
  "members": [...],
  "created_by": {...},
  "current_user_role": "admin"
}
```

### Create Poll
```json
POST /api/activities/groups/1/polls/
Authorization: Bearer <access_token>

Request:
{
  "question": "What's the worst pizza topping?",
  "is_anonymous": false,
  "options": [
    {"text": "Pineapple", "order": 0},
    {"text": "Anchovies", "order": 1},
    {"text": "Olives", "order": 2}
  ]
}
```

## Production Deployment

### Environment Variables
Create a `.env` file:

```env
SECRET_KEY=your-secret-key-here
DEBUG=False
ALLOWED_HOSTS=your-domain.com,www.your-domain.com

# Database (PostgreSQL recommended for production)
DB_NAME=chaosclub_db
DB_USER=your_db_user
DB_PASSWORD=your_db_password
DB_HOST=localhost
DB_PORT=5432
```

### Using PostgreSQL

1. Install PostgreSQL:
```bash
pip install psycopg2-binary
```

2. Update `settings.py` database configuration:
```python
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': os.getenv('DB_NAME'),
        'USER': os.getenv('DB_USER'),
        'PASSWORD': os.getenv('DB_PASSWORD'),
        'HOST': os.getenv('DB_HOST'),
        'PORT': os.getenv('DB_PORT'),
    }
}
```

### Security Settings for Production

In `settings.py`, update:
```python
DEBUG = False
ALLOWED_HOSTS = ['your-domain.com']
CORS_ALLOW_ALL_ORIGINS = False
CORS_ALLOWED_ORIGINS = [
    "https://your-flutter-app-domain.com",
]
```

### Collect Static Files
```bash
python manage.py collectstatic
```

## Flutter Integration

### Base URL Configuration
In your Flutter app, set the base URL:

```dart
class ApiConfig {
  static const String baseUrl = 'http://your-server-url:8000/api';
}
```

### Authentication Header
Include JWT token in requests:

```dart
final token = await storage.read(key: 'access_token');
final response = await http.get(
  Uri.parse('$baseUrl/auth/profile/'),
  headers: {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  },
);
```

## Testing

```bash
# Run tests
python manage.py test

# Run with coverage
coverage run --source='.' manage.py test
coverage report
```

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

MIT License - Feel free to use this for your projects!

## Support

For issues or questions:
- Create an issue on GitHub
- Email: support@chaosclub.app

## Acknowledgments

Built for the ChaosClub Flutter app - Making friend groups more fun, one chaos at a time! 🎭🔥
