"""
Groups URLs
"""
from django.urls import path
from .views import (
    GroupListCreateView, GroupDetailView, JoinGroupView,
    LeaveGroupView, remove_member, promote_to_admin
)

urlpatterns = [
    path('', GroupListCreateView.as_view(), name='group-list-create'),
    path('<int:pk>/', GroupDetailView.as_view(), name='group-detail'),
    path('join/', JoinGroupView.as_view(), name='join-group'),
    path('<int:group_id>/leave/', LeaveGroupView.as_view(), name='leave-group'),
    path('<int:group_id>/remove/<int:user_id>/', remove_member, name='remove-member'),
    path('<int:group_id>/promote/<int:user_id>/', promote_to_admin, name='promote-admin'),
]
