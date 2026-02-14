"""
Activities Serializers
"""
from rest_framework import serializers
from .models import DailyPrompt, PromptVote, Poll, PollOption, PollVote, TimeCapsule, Memory
from users.serializers import UserSerializer


class PromptVoteSerializer(serializers.ModelSerializer):
    """Serializer for prompt votes"""
    voter = UserSerializer(read_only=True)
    voted_for = UserSerializer(read_only=True)
    
    class Meta:
        model = PromptVote
        fields = ['id', 'voter', 'voted_for', 'created_at']


class DailyPromptSerializer(serializers.ModelSerializer):
    """Serializer for daily prompts"""
    created_by = UserSerializer(read_only=True)
    votes = PromptVoteSerializer(many=True, read_only=True)
    vote_results = serializers.SerializerMethodField()
    user_has_voted = serializers.SerializerMethodField()
    
    class Meta:
        model = DailyPrompt
        fields = [
            'id', 'group', 'question', 'emoji', 'date',
            'created_by', 'votes', 'vote_results', 'user_has_voted',
            'created_at'
        ]
        read_only_fields = ['id', 'created_by', 'created_at']
    
    def get_vote_results(self, obj):
        """Get vote counts for each user"""
        from django.db.models import Count
        votes = PromptVote.objects.filter(prompt=obj).values('voted_for').annotate(count=Count('id'))
        return {vote['voted_for']: vote['count'] for vote in votes}
    
    def get_user_has_voted(self, obj):
        request = self.context.get('request')
        if request and request.user.is_authenticated:
            return PromptVote.objects.filter(prompt=obj, voter=request.user).exists()
        return False


class VotePromptSerializer(serializers.Serializer):
    """Serializer for voting on prompts"""
    voted_for_id = serializers.IntegerField()
    
    def validate_voted_for_id(self, value):
        from users.models import User
        if not User.objects.filter(id=value).exists():
            raise serializers.ValidationError("User not found")
        return value


class PollOptionSerializer(serializers.ModelSerializer):
    """Serializer for poll options"""
    vote_count = serializers.IntegerField(read_only=True)
    
    class Meta:
        model = PollOption
        fields = ['id', 'text', 'order', 'vote_count']


class PollSerializer(serializers.ModelSerializer):
    """Serializer for polls"""
    created_by = UserSerializer(read_only=True)
    options = PollOptionSerializer(many=True)
    total_votes = serializers.SerializerMethodField()
    user_voted_option = serializers.SerializerMethodField()
    
    class Meta:
        model = Poll
        fields = [
            'id', 'group', 'question', 'is_anonymous',
            'created_by', 'options', 'total_votes', 'user_voted_option',
            'created_at', 'updated_at'
        ]
        read_only_fields = ['id', 'created_by', 'created_at', 'updated_at']
    
    def get_total_votes(self, obj):
        return PollVote.objects.filter(poll=obj).count()
    
    def get_user_voted_option(self, obj):
        request = self.context.get('request')
        if request and request.user.is_authenticated:
            vote = PollVote.objects.filter(poll=obj, voter=request.user).first()
            return vote.option.id if vote else None
        return None
    
    def create(self, validated_data):
        options_data = validated_data.pop('options')
        poll = Poll.objects.create(**validated_data, created_by=self.context['request'].user)
        
        for i, option_data in enumerate(options_data):
            PollOption.objects.create(poll=poll, order=i, **option_data)
        
        return poll


class VotePollSerializer(serializers.Serializer):
    """Serializer for voting on polls"""
    option_id = serializers.IntegerField()
    
    def validate_option_id(self, value):
        if not PollOption.objects.filter(id=value).exists():
            raise serializers.ValidationError("Option not found")
        return value


class TimeCapsuleSerializer(serializers.ModelSerializer):
    """Serializer for time capsules"""
    created_by = UserSerializer(read_only=True)
    days_until_unlock = serializers.SerializerMethodField()
    
    class Meta:
        model = TimeCapsule
        fields = [
            'id', 'group', 'message', 'media_url', 'unlock_date',
            'is_unlocked', 'days_until_unlock', 'created_by', 'created_at'
        ]
        read_only_fields = ['id', 'is_unlocked', 'created_by', 'created_at']
    
    def get_days_until_unlock(self, obj):
        if obj.is_unlocked:
            return 0
        from django.utils import timezone
        delta = obj.unlock_date - timezone.now()
        return max(0, delta.days)
    
    def create(self, validated_data):
        validated_data['created_by'] = self.context['request'].user
        return super().create(validated_data)


class MemorySerializer(serializers.ModelSerializer):
    """Serializer for memories (On This Day)"""
    class Meta:
        model = Memory
        fields = [
            'id', 'group', 'memory_type', 'title', 'description',
            'media_url', 'memory_date', 'created_at'
        ]
        read_only_fields = ['id', 'created_at']
