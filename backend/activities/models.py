"""
Activities Models - Daily Prompts, Polls, Time Capsules
"""
from django.db import models
from django.utils import timezone
from users.models import User
from groups.models import Group


class DailyPrompt(models.Model):
    """Daily prompts/questions for groups"""
    group = models.ForeignKey(Group, on_delete=models.CASCADE, related_name='prompts')
    question = models.TextField()
    emoji = models.CharField(max_length=10, default='🎯')
    date = models.DateField(default=timezone.now)
    
    created_by = models.ForeignKey(User, on_delete=models.CASCADE)
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        db_table = 'daily_prompts'
        unique_together = ['group', 'date']
        ordering = ['-date']
    
    def __str__(self):
        return f"{self.group.name} - {self.question[:50]}"


class PromptVote(models.Model):
    """Votes on daily prompts"""
    prompt = models.ForeignKey(DailyPrompt, on_delete=models.CASCADE, related_name='votes')
    voter = models.ForeignKey(User, on_delete=models.CASCADE, related_name='prompt_votes')
    voted_for = models.ForeignKey(User, on_delete=models.CASCADE, related_name='received_prompt_votes')
    
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        db_table = 'prompt_votes'
        unique_together = ['prompt', 'voter']
        ordering = ['-created_at']
    
    def __str__(self):
        return f"{self.voter.username} voted for {self.voted_for.username}"


class Poll(models.Model):
    """User-created polls"""
    group = models.ForeignKey(Group, on_delete=models.CASCADE, related_name='polls')
    created_by = models.ForeignKey(User, on_delete=models.CASCADE, related_name='polls')
    
    question = models.TextField()
    is_anonymous = models.BooleanField(default=False)
    
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        db_table = 'polls'
        ordering = ['-created_at']
    
    def __str__(self):
        return f"{self.question[:50]} - {self.group.name}"


class PollOption(models.Model):
    """Options for polls"""
    poll = models.ForeignKey(Poll, on_delete=models.CASCADE, related_name='options')
    text = models.CharField(max_length=200)
    order = models.IntegerField(default=0)
    
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        db_table = 'poll_options'
        ordering = ['order']
    
    def __str__(self):
        return self.text
    
    @property
    def vote_count(self):
        return self.votes.count()


class PollVote(models.Model):
    """Votes on poll options"""
    poll = models.ForeignKey(Poll, on_delete=models.CASCADE, related_name='votes')
    option = models.ForeignKey(PollOption, on_delete=models.CASCADE, related_name='votes')
    voter = models.ForeignKey(User, on_delete=models.CASCADE, related_name='poll_votes')
    
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        db_table = 'poll_votes'
        unique_together = ['poll', 'voter']
        ordering = ['-created_at']
    
    def __str__(self):
        return f"{self.voter.username} voted on {self.poll.question[:30]}"


class TimeCapsule(models.Model):
    """Time capsules - scheduled messages"""
    group = models.ForeignKey(Group, on_delete=models.CASCADE, related_name='capsules')
    created_by = models.ForeignKey(User, on_delete=models.CASCADE, related_name='capsules')
    
    message = models.TextField()
    media_url = models.URLField(blank=True, null=True)  # For photos/videos
    
    unlock_date = models.DateTimeField()
    is_unlocked = models.BooleanField(default=False)
    
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        db_table = 'time_capsules'
        ordering = ['unlock_date']
    
    def __str__(self):
        return f"Capsule for {self.group.name} - Unlocks {self.unlock_date}"
    
    def check_unlock(self):
        """Check if capsule should be unlocked"""
        if not self.is_unlocked and timezone.now() >= self.unlock_date:
            self.is_unlocked = True
            self.save()
            return True
        return False


class Memory(models.Model):
    """Memories - any significant event in a group"""
    MEMORY_TYPES = [
        ('capsule', 'Time Capsule Unlock'),
        ('poll', 'Poll Result'),
        ('prompt', 'Daily Prompt'),
        ('milestone', 'Group Milestone'),
        ('custom', 'Custom Memory'),
    ]
    
    group = models.ForeignKey(Group, on_delete=models.CASCADE, related_name='memories')
    memory_type = models.CharField(max_length=20, choices=MEMORY_TYPES)
    title = models.CharField(max_length=200)
    description = models.TextField()
    media_url = models.URLField(blank=True, null=True)
    
    # Link to original content if applicable
    related_capsule = models.ForeignKey(TimeCapsule, on_delete=models.SET_NULL, null=True, blank=True)
    related_poll = models.ForeignKey(Poll, on_delete=models.SET_NULL, null=True, blank=True)
    related_prompt = models.ForeignKey(DailyPrompt, on_delete=models.SET_NULL, null=True, blank=True)
    
    memory_date = models.DateField()  # The date this memory represents
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        db_table = 'memories'
        ordering = ['-memory_date']
        verbose_name_plural = 'Memories'
    
    def __str__(self):
        return f"{self.title} - {self.group.name}"
