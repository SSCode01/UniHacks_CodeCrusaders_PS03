"""
User Views - Authentication, Profile, Leaderboard
"""
from rest_framework import generics, status, permissions
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework_simplejwt.tokens import RefreshToken
from django.contrib.auth import authenticate
from django.db.models import Count, Window, F
from django.db.models.functions import DenseRank
from .models import User, Badge, DailyMood
from .serializers import (
    UserSerializer, RegisterSerializer, ChangePasswordSerializer,
    BadgeSerializer, DailyMoodSerializer, LeaderboardSerializer
)


class RegisterView(generics.CreateAPIView):
    """User registration"""
    queryset = User.objects.all()
    permission_classes = (permissions.AllowAny,)
    serializer_class = RegisterSerializer
    
    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        user = serializer.save()
        
        # Generate tokens
        refresh = RefreshToken.for_user(user)
        
        return Response({
            'user': UserSerializer(user).data,
            'tokens': {
                'refresh': str(refresh),
                'access': str(refresh.access_token),
            }
        }, status=status.HTTP_201_CREATED)


class LoginView(APIView):
    """User login"""
    permission_classes = (permissions.AllowAny,)
    
    def post(self, request):
        username = request.data.get('username')
        password = request.data.get('password')
        
        user = authenticate(username=username, password=password)
        
        if user:
            refresh = RefreshToken.for_user(user)
            return Response({
                'user': UserSerializer(user).data,
                'tokens': {
                    'refresh': str(refresh),
                    'access': str(refresh.access_token),
                }
            })
        
        return Response(
            {'error': 'Invalid credentials'},
            status=status.HTTP_401_UNAUTHORIZED
        )


class ProfileView(generics.RetrieveUpdateAPIView):
    """Get and update user profile"""
    serializer_class = UserSerializer
    permission_classes = [permissions.IsAuthenticated]
    
    def get_object(self):
        return self.request.user


class ChangePasswordView(APIView):
    """Change user password"""
    permission_classes = [permissions.IsAuthenticated]
    
    def post(self, request):
        serializer = ChangePasswordSerializer(data=request.data)
        
        if serializer.is_valid():
            user = request.user
            
            if not user.check_password(serializer.data.get('old_password')):
                return Response(
                    {'error': 'Wrong password'},
                    status=status.HTTP_400_BAD_REQUEST
                )
            
            user.set_password(serializer.data.get('new_password'))
            user.save()
            
            return Response({'message': 'Password updated successfully'})
        
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class BadgeListView(generics.ListAPIView):
    """List all available badges"""
    queryset = Badge.objects.all()
    serializer_class = BadgeSerializer
    permission_classes = [permissions.IsAuthenticated]


class DailyMoodCreateView(generics.CreateAPIView):
    """Create daily mood check-in"""
    serializer_class = DailyMoodSerializer
    permission_classes = [permissions.IsAuthenticated]
    
    def create(self, request, *args, **kwargs):
        response = super().create(request, *args, **kwargs)
        
        # Update user streak
        request.user.update_streak()
        
        # Award points for daily check-in
        request.user.add_points(10)
        
        return response


class LeaderboardView(APIView):
    """Get leaderboard with rankings"""
    permission_classes = [permissions.IsAuthenticated]
    
    def get(self, request):
        # Annotate users with rank based on total points
        users = User.objects.annotate(
            rank=Window(
                expression=DenseRank(),
                order_by=F('total_points').desc()
            ),
            badges_count=Count('earned_badges')
        ).order_by('-total_points')[:100]  # Top 100
        
        serializer = LeaderboardSerializer(users, many=True)
        return Response(serializer.data)


@api_view(['GET'])
@permission_classes([permissions.IsAuthenticated])
def user_stats(request):
    """Get user statistics"""
    user = request.user
    
    stats = {
        'total_points': user.total_points,
        'current_streak': user.current_streak,
        'longest_streak': user.longest_streak,
        'badges_count': user.earned_badges.count(),
        'groups_count': user.memberships.count(),
        'capsules_count': user.capsules.count(),
    }
    
    return Response(stats)
