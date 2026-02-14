"""
Groups Models - Groups, Memberships, Invites
"""
from django.db import models
from django.utils import timezone
from users.models import User
import secrets
import string


def generate_invite_code():
    """Generate a random 6-character invite code"""
    return ''.join(secrets.choice(string.ascii_uppercase + string.digits) for _ in range(6))


class Group(models.Model):
    """Group/Squad model"""
    CHAOS_LEVELS = [
        ('low', 'Low'),
        ('medium', 'Medium'),
        ('high', 'High'),
        ('extreme', 'Extreme'),
    ]
    
    name = models.CharField(max_length=100)
    emoji = models.CharField(max_length=10, default='🔥')
    invite_code = models.CharField(max_length=6, unique=True, default=generate_invite_code)
    chaos_level = models.CharField(max_length=20, choices=CHAOS_LEVELS, default='medium')
    
    created_by = models.ForeignKey(User, on_delete=models.CASCADE, related_name='created_groups')
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        db_table = 'groups'
        ordering = ['-created_at']
    
    def __str__(self):
        return f"{self.emoji} {self.name}"
    
    @property
    def member_count(self):
        return self.memberships.count()


class GroupMembership(models.Model):
    """Group membership - tracks who's in what group"""
    ROLES = [
        ('admin', 'Admin'),
        ('member', 'Member'),
    ]
    
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='memberships')
    group = models.ForeignKey(Group, on_delete=models.CASCADE, related_name='memberships')
    role = models.CharField(max_length=20, choices=ROLES, default='member')
    
    joined_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        db_table = 'group_memberships'
        unique_together = ['user', 'group']
        ordering = ['-joined_at']
    
    def __str__(self):
        return f"{self.user.username} in {self.group.name}"
