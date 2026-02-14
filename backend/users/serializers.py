"""
User Serializers
"""
from rest_framework import serializers
from django.contrib.auth.password_validation import validate_password
from .models import User, Badge, UserBadge, DailyMood


class UserSerializer(serializers.ModelSerializer):
    """Serializer for User model"""
    earned_badges = serializers.SerializerMethodField()
    
    class Meta:
        model = User
        fields = [
            'id', 'username', 'email', 'emoji_avatar', 'bio',
            'total_points', 'current_streak', 'longest_streak',
            'earned_badges', 'created_at'
        ]
        read_only_fields = ['id', 'total_points', 'current_streak', 'longest_streak', 'created_at']
    
    def get_earned_badges(self, obj):
        badges = UserBadge.objects.filter(user=obj).select_related('badge')
        return BadgeSerializer([ub.badge for ub in badges], many=True).data


class RegisterSerializer(serializers.ModelSerializer):
    """Serializer for user registration"""
    password = serializers.CharField(write_only=True, required=True, validators=[validate_password])
    password2 = serializers.CharField(write_only=True, required=True)
    
    class Meta:
        model = User
        fields = ['username', 'email', 'password', 'password2', 'emoji_avatar', 'bio']
    
    def validate(self, attrs):
        if attrs['password'] != attrs['password2']:
            raise serializers.ValidationError({"password": "Password fields didn't match."})
        return attrs
    
    def create(self, validated_data):
        validated_data.pop('password2')
        user = User.objects.create_user(**validated_data)
        return user


class ChangePasswordSerializer(serializers.Serializer):
    """Serializer for password change"""
    old_password = serializers.CharField(required=True)
    new_password = serializers.CharField(required=True, validators=[validate_password])


class BadgeSerializer(serializers.ModelSerializer):
    """Serializer for Badge model"""
    class Meta:
        model = Badge
        fields = ['id', 'name', 'description', 'icon', 'points_required']


class DailyMoodSerializer(serializers.ModelSerializer):
    """Serializer for Daily Mood"""
    class Meta:
        model = DailyMood
        fields = ['id', 'mood', 'date', 'created_at']
        read_only_fields = ['id', 'created_at']
    
    def create(self, validated_data):
        # Ensure user from context
        validated_data['user'] = self.context['request'].user
        return super().create(validated_data)


class LeaderboardSerializer(serializers.ModelSerializer):
    """Serializer for leaderboard"""
    rank = serializers.IntegerField(read_only=True)
    badges_count = serializers.IntegerField(read_only=True)
    
    class Meta:
        model = User
        fields = ['id', 'username', 'emoji_avatar', 'total_points', 'current_streak', 'rank', 'badges_count']
