"""
Groups Serializers
"""
from rest_framework import serializers
from .models import Group, GroupMembership
from users.serializers import UserSerializer


class GroupMemberSerializer(serializers.ModelSerializer):
    """Serializer for group members"""
    user = UserSerializer(read_only=True)
    
    class Meta:
        model = GroupMembership
        fields = ['id', 'user', 'role', 'joined_at']


class GroupSerializer(serializers.ModelSerializer):
    """Serializer for Group model"""
    member_count = serializers.IntegerField(read_only=True)
    created_by = UserSerializer(read_only=True)
    members = serializers.SerializerMethodField()
    current_user_role = serializers.SerializerMethodField()
    
    class Meta:
        model = Group
        fields = [
            'id', 'name', 'emoji', 'invite_code', 'chaos_level',
            'member_count', 'members', 'created_by', 'current_user_role',
            'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'invite_code', 'created_by', 'created_at', 'updated_at']
    
    def get_members(self, obj):
        memberships = GroupMembership.objects.filter(group=obj).select_related('user')
        return GroupMemberSerializer(memberships, many=True).data
    
    def get_current_user_role(self, obj):
        request = self.context.get('request')
        if request and request.user.is_authenticated:
            membership = GroupMembership.objects.filter(
                group=obj,
                user=request.user
            ).first()
            return membership.role if membership else None
        return None
    
    def create(self, validated_data):
        request = self.context.get('request')
        validated_data['created_by'] = request.user
        group = super().create(validated_data)
        
        # Add creator as admin
        GroupMembership.objects.create(
            user=request.user,
            group=group,
            role='admin'
        )
        
        return group


class JoinGroupSerializer(serializers.Serializer):
    """Serializer for joining a group with invite code"""
    invite_code = serializers.CharField(max_length=6)
    
    def validate_invite_code(self, value):
        try:
            group = Group.objects.get(invite_code=value.upper())
            return value.upper()
        except Group.DoesNotExist:
            raise serializers.ValidationError("Invalid invite code")
    
    def save(self):
        user = self.context['request'].user
        invite_code = self.validated_data['invite_code']
        group = Group.objects.get(invite_code=invite_code)
        
        # Check if already a member
        if GroupMembership.objects.filter(user=user, group=group).exists():
            raise serializers.ValidationError("Already a member of this group")
        
        # Add user to group
        membership = GroupMembership.objects.create(
            user=user,
            group=group,
            role='member'
        )
        
        return group
