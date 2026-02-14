"""
User URLs
"""
from django.urls import path
from rest_framework_simplejwt.views import TokenRefreshView
from .views import (
    RegisterView, LoginView, ProfileView, ChangePasswordView,
    BadgeListView, DailyMoodCreateView, LeaderboardView, user_stats
)

urlpatterns = [
    # Authentication
    path('register/', RegisterView.as_view(), name='register'),
    path('login/', LoginView.as_view(), name='login'),
    path('token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    
    # Profile
    path('profile/', ProfileView.as_view(), name='profile'),
    path('change-password/', ChangePasswordView.as_view(), name='change-password'),
    path('stats/', user_stats, name='user-stats'),
    
    # Badges
    path('badges/', BadgeListView.as_view(), name='badges'),
    
    # Daily Mood
    path('mood/', DailyMoodCreateView.as_view(), name='daily-mood'),
    
    # Leaderboard
    path('leaderboard/', LeaderboardView.as_view(), name='leaderboard'),
]
