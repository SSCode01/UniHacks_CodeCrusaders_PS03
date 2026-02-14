"""
User Models - Custom User, Profile, Streaks, Points, Badges
"""
from django.contrib.auth.models import AbstractUser
from django.db import models
from django.utils import timezone


class User(AbstractUser):
    """Custom User model"""
    email = models.EmailField(unique=True)
    username = models.CharField(max_length=150, unique=True)
    emoji_avatar = models.CharField(max_length=10, default='😎')
    bio = models.TextField(max_length=200, blank=True)
    
    # Stats
    total_points = models.IntegerField(default=0)
    current_streak = models.IntegerField(default=0)
    longest_streak = models.IntegerField(default=0)
    last_activity_date = models.DateField(null=True, blank=True)
    
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    USERNAME_FIELD = 'username'
    REQUIRED_FIELDS = ['email']
    
    class Meta:
        db_table = 'users'
        ordering = ['-created_at']
    
    def __str__(self):
        return self.username
    
    def update_streak(self):
        """Update user streak based on last activity"""
        today = timezone.now().date()
        
        if self.last_activity_date:
            days_diff = (today - self.last_activity_date).days
            
            if days_diff == 0:
                # Already logged activity today
                return
            elif days_diff == 1:
                # Consecutive day - increment streak
                self.current_streak += 1
            else:
                # Streak broken
                self.current_streak = 1
        else:
            # First activity
            self.current_streak = 1
        
        # Update longest streak if current is higher
        if self.current_streak > self.longest_streak:
            self.longest_streak = self.current_streak
        
        self.last_activity_date = today
        self.save()
    
    def add_points(self, points):
        """Add points to user"""
        self.total_points += points
        self.save()


class Badge(models.Model):
    """Badges that users can earn"""
    BADGE_TYPES = [
        ('roast_king', 'Roast King 👑'),
        ('meme_master', 'Meme Master 😂'),
        ('capsule_creator', 'Capsule Creator 📦'),
        ('streak_7', '7 Day Streak 🔥'),
        ('streak_30', '30 Day Streak 🌟'),
        ('poll_master', 'Poll Master 📊'),
        ('chaos_coordinator', 'Chaos Coordinator 🎭'),
        ('squad_leader', 'Squad Leader 👥'),
    ]
    
    name = models.CharField(max_length=50, choices=BADGE_TYPES, unique=True)
    description = models.TextField()
    icon = models.CharField(max_length=10)  # Emoji icon
    points_required = models.IntegerField(default=0)
    
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        db_table = 'badges'
        ordering = ['points_required']
    
    def __str__(self):
        return self.get_name_display()


class UserBadge(models.Model):
    """Badges earned by users"""
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='earned_badges')
    badge = models.ForeignKey(Badge, on_delete=models.CASCADE)
    earned_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        db_table = 'user_badges'
        unique_together = ['user', 'badge']
        ordering = ['-earned_at']
    
    def __str__(self):
        return f"{self.user.username} - {self.badge.name}"


class DailyMood(models.Model):
    """Daily mood check-ins"""
    MOOD_CHOICES = [
        ('on_fire', 'On fire 🔥'),
        ('vibing', 'Vibing 😎'),
        ('chaotic', 'Chaotic 🤪'),
        ('exhausted', 'Exhausted 😴'),
    ]
    
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='moods')
    mood = models.CharField(max_length=20, choices=MOOD_CHOICES)
    date = models.DateField(default=timezone.now)
    
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        db_table = 'daily_moods'
        unique_together = ['user', 'date']
        ordering = ['-date']
    
    def __str__(self):
        return f"{self.user.username} - {self.mood} on {self.date}"
