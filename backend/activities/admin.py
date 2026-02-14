"""
Activities Admin Configuration
"""
from django.contrib import admin
from .models import DailyPrompt, PromptVote, Poll, PollOption, PollVote, TimeCapsule, Memory


@admin.register(DailyPrompt)
class DailyPromptAdmin(admin.ModelAdmin):
    list_display = ['question', 'group', 'emoji', 'date', 'created_by', 'created_at']
    list_filter = ['date', 'created_at']
    search_fields = ['question', 'group__name', 'created_by__username']


@admin.register(PromptVote)
class PromptVoteAdmin(admin.ModelAdmin):
    list_display = ['prompt', 'voter', 'voted_for', 'created_at']
    list_filter = ['created_at']
    search_fields = ['voter__username', 'voted_for__username']


class PollOptionInline(admin.TabularInline):
    model = PollOption
    extra = 2


@admin.register(Poll)
class PollAdmin(admin.ModelAdmin):
    list_display = ['question', 'group', 'is_anonymous', 'created_by', 'created_at']
    list_filter = ['is_anonymous', 'created_at']
    search_fields = ['question', 'group__name', 'created_by__username']
    inlines = [PollOptionInline]


@admin.register(PollVote)
class PollVoteAdmin(admin.ModelAdmin):
    list_display = ['poll', 'option', 'voter', 'created_at']
    list_filter = ['created_at']
    search_fields = ['voter__username', 'poll__question']


@admin.register(TimeCapsule)
class TimeCapsuleAdmin(admin.ModelAdmin):
    list_display = ['group', 'created_by', 'unlock_date', 'is_unlocked', 'created_at']
    list_filter = ['is_unlocked', 'unlock_date', 'created_at']
    search_fields = ['group__name', 'created_by__username', 'message']
    readonly_fields = ['created_at']


@admin.register(Memory)
class MemoryAdmin(admin.ModelAdmin):
    list_display = ['title', 'group', 'memory_type', 'memory_date', 'created_at']
    list_filter = ['memory_type', 'memory_date', 'created_at']
    search_fields = ['title', 'description', 'group__name']
    readonly_fields = ['created_at']
