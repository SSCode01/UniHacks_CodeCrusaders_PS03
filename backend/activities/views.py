"""
Activities Views - Prompts, Polls, Capsules
"""
from rest_framework import generics, status, permissions
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from rest_framework.views import APIView
from django.shortcuts import get_object_or_404
from django.utils import timezone
from .models import (
    DailyPrompt, PromptVote, Poll, PollOption,
    PollVote, TimeCapsule, Memory
)
from .serializers import (
    DailyPromptSerializer, VotePromptSerializer,
    PollSerializer, VotePollSerializer,
    TimeCapsuleSerializer
)
from groups.models import Group, GroupMembership


class DailyPromptListView(generics.ListCreateAPIView):
    """List and create daily prompts for a group"""
    serializer_class = DailyPromptSerializer
    permission_classes = [permissions.IsAuthenticated]
    
    def get_queryset(self):
        group_id = self.kwargs.get('group_id')
        return DailyPrompt.objects.filter(group_id=group_id)
    
    def perform_create(self, serializer):
        group_id = self.kwargs.get('group_id')
        group = get_object_or_404(Group, id=group_id)
        
        # Check if user is a member
        if not GroupMembership.objects.filter(user=self.request.user, group=group).exists():
            raise permissions.PermissionDenied("Not a member of this group")
        
        serializer.save(created_by=self.request.user, group=group)


class VotePromptView(APIView):
    """Vote on a daily prompt"""
    permission_classes = [permissions.IsAuthenticated]
    
    def post(self, request, prompt_id):
        prompt = get_object_or_404(DailyPrompt, id=prompt_id)
        
        # Check if user is a group member
        if not GroupMembership.objects.filter(user=request.user, group=prompt.group).exists():
            return Response(
                {'error': 'Not a member of this group'},
                status=status.HTTP_403_FORBIDDEN
            )
        
        serializer = VotePromptSerializer(data=request.data)
        
        if serializer.is_valid():
            voted_for_id = serializer.validated_data['voted_for_id']
            
            # Delete existing vote if any
            PromptVote.objects.filter(prompt=prompt, voter=request.user).delete()
            
            # Create new vote
            from users.models import User
            voted_for = User.objects.get(id=voted_for_id)
            
            PromptVote.objects.create(
                prompt=prompt,
                voter=request.user,
                voted_for=voted_for
            )
            
            # Award points
            request.user.add_points(5)
            
            return Response({'message': 'Vote recorded successfully'})
        
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class PollListCreateView(generics.ListCreateAPIView):
    """List and create polls for a group"""
    serializer_class = PollSerializer
    permission_classes = [permissions.IsAuthenticated]
    
    def get_queryset(self):
        group_id = self.kwargs.get('group_id')
        return Poll.objects.filter(group_id=group_id).prefetch_related('options')
    
    def perform_create(self, serializer):
        group_id = self.kwargs.get('group_id')
        group = get_object_or_404(Group, id=group_id)
        
        # Check if user is a member
        if not GroupMembership.objects.filter(user=self.request.user, group=group).exists():
            raise permissions.PermissionDenied("Not a member of this group")
        
        serializer.save(group=group)


class PollDetailView(generics.RetrieveAPIView):
    """Get poll details"""
    serializer_class = PollSerializer
    permission_classes = [permissions.IsAuthenticated]
    queryset = Poll.objects.all()


class VotePollView(APIView):
    """Vote on a poll"""
    permission_classes = [permissions.IsAuthenticated]
    
    def post(self, request, poll_id):
        poll = get_object_or_404(Poll, id=poll_id)
        
        # Check if user is a group member
        if not GroupMembership.objects.filter(user=request.user, group=poll.group).exists():
            return Response(
                {'error': 'Not a member of this group'},
                status=status.HTTP_403_FORBIDDEN
            )
        
        serializer = VotePollSerializer(data=request.data)
        
        if serializer.is_valid():
            option_id = serializer.validated_data['option_id']
            option = get_object_or_404(PollOption, id=option_id, poll=poll)
            
            # Delete existing vote if any
            PollVote.objects.filter(poll=poll, voter=request.user).delete()
            
            # Create new vote
            PollVote.objects.create(
                poll=poll,
                option=option,
                voter=request.user
            )
            
            # Award points
            request.user.add_points(3)
            
            return Response({'message': 'Vote recorded successfully'})
        
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class TimeCapsuleListCreateView(generics.ListCreateAPIView):
    """List and create time capsules for a group"""
    serializer_class = TimeCapsuleSerializer
    permission_classes = [permissions.IsAuthenticated]
    
    def get_queryset(self):
        group_id = self.kwargs.get('group_id')
        
        # Only show unlocked capsules or user's own capsules
        queryset = TimeCapsule.objects.filter(group_id=group_id)
        
        # Check each capsule if it should be unlocked
        for capsule in queryset:
            capsule.check_unlock()
        
        # Filter based on unlock status
        return queryset.filter(
            models.Q(is_unlocked=True) | models.Q(created_by=self.request.user)
        )
    
    def perform_create(self, serializer):
        group_id = self.kwargs.get('group_id')
        group = get_object_or_404(Group, id=group_id)
        
        # Check if user is a member
        if not GroupMembership.objects.filter(user=self.request.user, group=group).exists():
            raise permissions.PermissionDenied("Not a member of this group")
        
        serializer.save(group=group)


class TimeCapsuleDetailView(generics.RetrieveAPIView):
    """Get time capsule details"""
    serializer_class = TimeCapsuleSerializer
    permission_classes = [permissions.IsAuthenticated]
    
    def get_queryset(self):
        return TimeCapsule.objects.all()
    
    def retrieve(self, request, *args, **kwargs):
        instance = self.get_object()
        
        # Check if it should be unlocked
        instance.check_unlock()
        
        # Only show if unlocked or created by user
        if not instance.is_unlocked and instance.created_by != request.user:
            return Response(
                {'error': 'Capsule is still locked'},
                status=status.HTTP_403_FORBIDDEN
            )
        
        serializer = self.get_serializer(instance)
        return Response(serializer.data)


@api_view(['GET'])
@permission_classes([permissions.IsAuthenticated])
def group_activity_summary(request, group_id):
    """Get activity summary for a group"""
    from django.db import models
    
    group = get_object_or_404(Group, id=group_id)
    
    # Check if user is a member
    if not GroupMembership.objects.filter(user=request.user, group=group).exists():
        return Response(
            {'error': 'Not a member of this group'},
            status=status.HTTP_403_FORBIDDEN
        )
    
    summary = {
        'prompts_count': DailyPrompt.objects.filter(group=group).count(),
        'polls_count': Poll.objects.filter(group=group).count(),
        'capsules_count': TimeCapsule.objects.filter(group=group).count(),
        'unlocked_capsules': TimeCapsule.objects.filter(group=group, is_unlocked=True).count(),
        'pending_capsules': TimeCapsule.objects.filter(group=group, is_unlocked=False).count(),
    }
    
    return Response(summary)


@api_view(['GET'])
@permission_classes([permissions.IsAuthenticated])
def on_this_day(request, group_id):
    """Get memories from this day in previous years"""
    from datetime import datetime
    from .models import Memory
    
    group = get_object_or_404(Group, id=group_id)
    
    # Check if user is a member
    if not GroupMembership.objects.filter(user=request.user, group=group).exists():
        return Response(
            {'error': 'Not a member of this group'},
            status=status.HTTP_403_FORBIDDEN
        )
    
    today = timezone.now().date()
    
    # Get memories from this day/month in previous years
    memories = Memory.objects.filter(
        group=group,
        memory_date__month=today.month,
        memory_date__day=today.day,
    ).exclude(
        memory_date__year=today.year  # Exclude current year
    )
    
    from .serializers import MemorySerializer
    serializer = MemorySerializer(memories, many=True)
    return Response(serializer.data)
