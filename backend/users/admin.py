"""
User Admin Configuration
"""
from django.contrib import admin
from django.contrib.auth.admin import UserAdmin as BaseUserAdmin
from .models import User, Badge, UserBadge, DailyMood


@admin.register(User)
class UserAdmin(BaseUserAdmin):
    list_display = ['username', 'email', 'emoji_avatar', 'total_points', 'current_streak', 'created_at']
    list_filter = ['created_at', 'current_streak']
    search_fields = ['username', 'email']
    ordering = ['-created_at']
    
    fieldsets = BaseUserAdmin.fieldsets + (
        ('Profile', {'fields': ('emoji_avatar', 'bio')}),
        ('Stats', {'fields': ('total_points', 'current_streak', 'longest_streak', 'last_activity_date')}),
    )


@admin.register(Badge)
class BadgeAdmin(admin.ModelAdmin):
    list_display = ['name', 'icon', 'points_required', 'created_at']
    search_fields = ['name', 'description']


@admin.register(UserBadge)
class UserBadgeAdmin(admin.ModelAdmin):
    list_display = ['user', 'badge', 'earned_at']
    list_filter = ['badge', 'earned_at']
    search_fields = ['user__username']


@admin.register(DailyMood)
class DailyMoodAdmin(admin.ModelAdmin):
    list_display = ['user', 'mood', 'date', 'created_at']
    list_filter = ['mood', 'date']
    search_fields = ['user__username']
