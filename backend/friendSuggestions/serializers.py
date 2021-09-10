from rest_framework import serializers
from .models import FriendSuggestion


class FriendSuggestionSerializer(serializers.ModelSerializer):
    class Meta:
        model = FriendSuggestion
        fields = ['username', 'friendSuggestion']
