# ChaosClub API Documentation

## Quick Start Guide for Flutter Integration

### 1. Authentication Flow

#### Register New User
```
POST /api/auth/register/
Content-Type: application/json

{
  "username": "chaos_king",
  "email": "king@example.com",
  "password": "SecurePass123!",
  "password2": "SecurePass123!",
  "emoji_avatar": "😎",
  "bio": "CEO of bad decisions"
}

Response: {
  "user": {...},
  "tokens": {
    "refresh": "...",
    "access": "..."
  }
}
```

#### Login
```
POST /api/auth/login/
Content-Type: application/json

{
  "username": "chaos_king",
  "password": "SecurePass123!"
}

Response: {
  "user": {...},
  "tokens": {
    "refresh": "...",
    "access": "..."
  }
}
```

#### Refresh Token
```
POST /api/auth/token/refresh/
Content-Type: application/json

{
  "refresh": "your-refresh-token"
}

Response: {
  "access": "new-access-token"
}
```

### 2. Profile Management

#### Get Profile
```
GET /api/auth/profile/
Authorization: Bearer <access_token>

Response: {
  "id": 1,
  "username": "chaos_king",
  "email": "king@example.com",
  "emoji_avatar": "😎",
  "bio": "CEO of bad decisions",
  "total_points": 820,
  "current_streak": 5,
  "longest_streak": 10,
  "earned_badges": [...]
}
```

#### Update Profile
```
PUT /api/auth/profile/
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "username": "new_username",
  "emoji_avatar": "🤪",
  "bio": "Updated bio"
}
```

#### Change Password
```
POST /api/auth/change-password/
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "old_password": "OldPass123!",
  "new_password": "NewPass123!"
}
```

### 3. Groups/Squads

#### Get User's Groups
```
GET /api/groups/
Authorization: Bearer <access_token>

Response: [
  {
    "id": 1,
    "name": "Squad Goals",
    "emoji": "🔥",
    "invite_code": "ABC123",
    "chaos_level": "high",
    "member_count": 4,
    "members": [...],
    "created_by": {...},
    "current_user_role": "admin"
  }
]
```

#### Create Group
```
POST /api/groups/
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "name": "Squad Goals",
  "emoji": "🔥",
  "chaos_level": "high"
}

Response: {
  "id": 1,
  "name": "Squad Goals",
  "emoji": "🔥",
  "invite_code": "ABC123",
  ...
}
```

#### Join Group
```
POST /api/groups/join/
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "invite_code": "ABC123"
}

Response: {
  "id": 1,
  "name": "Squad Goals",
  ...
}
```

#### Leave Group
```
POST /api/groups/<group_id>/leave/
Authorization: Bearer <access_token>

Response: {
  "message": "Successfully left the group"
}
```

### 4. Daily Prompts

#### Get Prompts for Group
```
GET /api/activities/groups/<group_id>/prompts/
Authorization: Bearer <access_token>

Response: [
  {
    "id": 1,
    "group": 1,
    "question": "Who would survive a zombie apocalypse?",
    "emoji": "🧟",
    "date": "2024-02-14",
    "created_by": {...},
    "votes": [...],
    "vote_results": {
      "1": 3,
      "2": 1
    },
    "user_has_voted": false
  }
]
```

#### Create Prompt
```
POST /api/activities/groups/<group_id>/prompts/
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "question": "Who would survive a zombie apocalypse?",
  "emoji": "🧟",
  "date": "2024-02-14"
}
```

#### Vote on Prompt
```
POST /api/activities/prompts/<prompt_id>/vote/
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "voted_for_id": 3
}

Response: {
  "message": "Vote recorded successfully"
}
```

### 5. Polls

#### Get Polls for Group
```
GET /api/activities/groups/<group_id>/polls/
Authorization: Bearer <access_token>

Response: [
  {
    "id": 1,
    "group": 1,
    "question": "What's the worst pizza topping?",
    "is_anonymous": false,
    "created_by": {...},
    "options": [
      {
        "id": 1,
        "text": "Pineapple",
        "order": 0,
        "vote_count": 5
      },
      {
        "id": 2,
        "text": "Anchovies",
        "order": 1,
        "vote_count": 2
      }
    ],
    "total_votes": 7,
    "user_voted_option": 1
  }
]
```

#### Create Poll
```
POST /api/activities/groups/<group_id>/polls/
Authorization: Bearer <access_token>
Content-Type: application/json

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

#### Vote on Poll
```
POST /api/activities/polls/<poll_id>/vote/
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "option_id": 1
}

Response: {
  "message": "Vote recorded successfully"
}
```

### 6. Time Capsules

#### Get Capsules for Group
```
GET /api/activities/groups/<group_id>/capsules/
Authorization: Bearer <access_token>

Response: [
  {
    "id": 1,
    "group": 1,
    "message": "Dear future us...",
    "media_url": null,
    "unlock_date": "2024-03-14T00:00:00Z",
    "is_unlocked": false,
    "days_until_unlock": 28,
    "created_by": {...}
  }
]
```

#### Create Capsule
```
POST /api/activities/groups/<group_id>/capsules/
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "message": "Dear future us, remember this moment...",
  "media_url": "https://example.com/photo.jpg",
  "unlock_date": "2024-12-25T00:00:00Z"
}
```

### 7. Daily Mood

#### Submit Daily Mood
```
POST /api/auth/mood/
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "mood": "on_fire"
}

Mood choices:
- "on_fire": On fire 🔥
- "vibing": Vibing 😎
- "chaotic": Chaotic 🤪
- "exhausted": Exhausted 😴
```

### 8. Leaderboard

#### Get Leaderboard
```
GET /api/auth/leaderboard/
Authorization: Bearer <access_token>

Response: [
  {
    "id": 1,
    "username": "chaos_king",
    "emoji_avatar": "😎",
    "total_points": 1250,
    "current_streak": 15,
    "rank": 1,
    "badges_count": 5
  },
  ...
]
```

### 9. Stats

#### Get User Stats
```
GET /api/auth/stats/
Authorization: Bearer <access_token>

Response: {
  "total_points": 820,
  "current_streak": 5,
  "longest_streak": 10,
  "badges_count": 3,
  "groups_count": 2,
  "capsules_count": 4
}
```

### 10. Activity Summary

#### Get Group Activity Summary
```
GET /api/activities/groups/<group_id>/summary/
Authorization: Bearer <access_token>

Response: {
  "prompts_count": 15,
  "polls_count": 8,
  "capsules_count": 4,
  "unlocked_capsules": 1,
  "pending_capsules": 3
}
```

## Error Responses

All endpoints may return these error responses:

### 400 Bad Request
```json
{
  "error": "Description of what went wrong",
  "field_name": ["Field-specific error messages"]
}
```

### 401 Unauthorized
```json
{
  "detail": "Authentication credentials were not provided."
}
```

### 403 Forbidden
```json
{
  "error": "You don't have permission to perform this action"
}
```

### 404 Not Found
```json
{
  "error": "Resource not found"
}
```

## Points System

Users earn points for various activities:
- Daily mood check-in: 10 points
- Voting on prompt: 5 points
- Voting on poll: 3 points
- Creating time capsule: 15 points
- Creating poll: 10 points

## Flutter Implementation Tips

### 1. Store JWT Tokens Securely
```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

// Save tokens
await storage.write(key: 'access_token', value: accessToken);
await storage.write(key: 'refresh_token', value: refreshToken);

// Read tokens
final accessToken = await storage.read(key: 'access_token');
```

### 2. HTTP Client with Token
```dart
class ApiClient {
  static const baseUrl = 'http://your-server:8000/api';
  final storage = FlutterSecureStorage();

  Future<http.Response> get(String endpoint) async {
    final token = await storage.read(key: 'access_token');
    return http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
  }
}
```

### 3. Handle Token Expiration
```dart
Future<http.Response> authenticatedRequest(String endpoint) async {
  var response = await get(endpoint);
  
  if (response.statusCode == 401) {
    // Token expired, refresh it
    await refreshToken();
    response = await get(endpoint);
  }
  
  return response;
}
```
