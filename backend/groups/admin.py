"""
Groups Admin Configuration
"""
from django.contrib import admin
from .models import Group, GroupMembership


@admin.register(Group)
class GroupAdmin(admin.ModelAdmin):
    list_display = ['name', 'emoji', 'invite_code', 'chaos_level', 'created_by', 'member_count', 'created_at']
    list_filter = ['chaos_level', 'created_at']
    search_fields = ['name', 'invite_code', 'created_by__username']
    readonly_fields = ['invite_code', 'created_at', 'updated_at']
    
    def member_count(self, obj):
        return obj.member_count
    member_count.short_description = 'Members'


@admin.register(GroupMembership)
class GroupMembershipAdmin(admin.ModelAdmin):
    list_display = ['user', 'group', 'role', 'joined_at']
    list_filter = ['role', 'joined_at']
    search_fields = ['user__username', 'group__name']
