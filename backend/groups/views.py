"""
Groups Views - Create, Join, Manage Groups
"""
from rest_framework import generics, status, permissions
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from rest_framework.views import APIView
from .models import Group, GroupMembership
from .serializers import GroupSerializer, JoinGroupSerializer


class GroupListCreateView(generics.ListCreateAPIView):
    """List user's groups and create new group"""
    serializer_class = GroupSerializer
    permission_classes = [permissions.IsAuthenticated]
    
    def get_queryset(self):
        # Get groups where user is a member
        user = self.request.user
        return Group.objects.filter(memberships__user=user)


class GroupDetailView(generics.RetrieveUpdateDestroyAPIView):
    """Get, update, or delete a group"""
    serializer_class = GroupSerializer
    permission_classes = [permissions.IsAuthenticated]
    
    def get_queryset(self):
        return Group.objects.filter(memberships__user=self.request.user)
    
    def perform_update(self, serializer):
        # Only admins can update
        group = self.get_object()
        membership = GroupMembership.objects.get(user=self.request.user, group=group)
        
        if membership.role != 'admin':
            raise permissions.PermissionDenied("Only admins can update the group")
        
        serializer.save()
    
    def perform_destroy(self, instance):
        # Only creator can delete
        if instance.created_by != self.request.user:
            raise permissions.PermissionDenied("Only the creator can delete the group")
        instance.delete()


class JoinGroupView(APIView):
    """Join a group using invite code"""
    permission_classes = [permissions.IsAuthenticated]
    
    def post(self, request):
        serializer = JoinGroupSerializer(data=request.data, context={'request': request})
        
        if serializer.is_valid():
            try:
                group = serializer.save()
                return Response(
                    GroupSerializer(group, context={'request': request}).data,
                    status=status.HTTP_200_OK
                )
            except Exception as e:
                return Response(
                    {'error': str(e)},
                    status=status.HTTP_400_BAD_REQUEST
                )
        
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class LeaveGroupView(APIView):
    """Leave a group"""
    permission_classes = [permissions.IsAuthenticated]
    
    def post(self, request, group_id):
        try:
            group = Group.objects.get(id=group_id)
            membership = GroupMembership.objects.get(user=request.user, group=group)
            
            # Check if user is the creator
            if group.created_by == request.user:
                return Response(
                    {'error': 'Group creator cannot leave. Transfer ownership or delete the group.'},
                    status=status.HTTP_400_BAD_REQUEST
                )
            
            membership.delete()
            return Response({'message': 'Successfully left the group'})
            
        except Group.DoesNotExist:
            return Response({'error': 'Group not found'}, status=status.HTTP_404_NOT_FOUND)
        except GroupMembership.DoesNotExist:
            return Response({'error': 'Not a member of this group'}, status=status.HTTP_400_BAD_REQUEST)


@api_view(['POST'])
@permission_classes([permissions.IsAuthenticated])
def remove_member(request, group_id, user_id):
    """Remove a member from the group (admin only)"""
    try:
        group = Group.objects.get(id=group_id)
        admin_membership = GroupMembership.objects.get(user=request.user, group=group)
        
        # Check if requester is admin
        if admin_membership.role != 'admin':
            return Response(
                {'error': 'Only admins can remove members'},
                status=status.HTTP_403_FORBIDDEN
            )
        
        # Get member to remove
        member_membership = GroupMembership.objects.get(user_id=user_id, group=group)
        
        # Can't remove the creator
        if member_membership.user == group.created_by:
            return Response(
                {'error': 'Cannot remove the group creator'},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        member_membership.delete()
        return Response({'message': 'Member removed successfully'})
        
    except Group.DoesNotExist:
        return Response({'error': 'Group not found'}, status=status.HTTP_404_NOT_FOUND)
    except GroupMembership.DoesNotExist:
        return Response({'error': 'Member not found'}, status=status.HTTP_404_NOT_FOUND)


@api_view(['POST'])
@permission_classes([permissions.IsAuthenticated])
def promote_to_admin(request, group_id, user_id):
    """Promote a member to admin (creator only)"""
    try:
        group = Group.objects.get(id=group_id)
        
        # Check if requester is the creator
        if group.created_by != request.user:
            return Response(
                {'error': 'Only the creator can promote members to admin'},
                status=status.HTTP_403_FORBIDDEN
            )
        
        # Get member to promote
        membership = GroupMembership.objects.get(user_id=user_id, group=group)
        membership.role = 'admin'
        membership.save()
        
        return Response({'message': 'Member promoted to admin'})
        
    except Group.DoesNotExist:
        return Response({'error': 'Group not found'}, status=status.HTTP_404_NOT_FOUND)
    except GroupMembership.DoesNotExist:
        return Response({'error': 'Member not found'}, status=status.HTTP_404_NOT_FOUND)
