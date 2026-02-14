"""
Activities URLs
"""
from django.urls import path
from .views import (
    DailyPromptListView, VotePromptView,
    PollListCreateView, PollDetailView, VotePollView,
    TimeCapsuleListCreateView, TimeCapsuleDetailView,
    group_activity_summary, on_this_day
)

urlpatterns = [
    # Daily Prompts
    path('groups/<int:group_id>/prompts/', DailyPromptListView.as_view(), name='prompt-list'),
    path('prompts/<int:prompt_id>/vote/', VotePromptView.as_view(), name='vote-prompt'),
    
    # Polls
    path('groups/<int:group_id>/polls/', PollListCreateView.as_view(), name='poll-list'),
    path('polls/<int:pk>/', PollDetailView.as_view(), name='poll-detail'),
    path('polls/<int:poll_id>/vote/', VotePollView.as_view(), name='vote-poll'),
    
    # Time Capsules
    path('groups/<int:group_id>/capsules/', TimeCapsuleListCreateView.as_view(), name='capsule-list'),
    path('capsules/<int:pk>/', TimeCapsuleDetailView.as_view(), name='capsule-detail'),
    
    # Memories & Summary
    path('groups/<int:group_id>/summary/', group_activity_summary, name='activity-summary'),
    path('groups/<int:group_id>/on-this-day/', on_this_day, name='on-this-day'),
]
