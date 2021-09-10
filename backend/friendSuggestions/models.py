from django.db import models
from django.db.models.fields import CharField

# Create your models here.


class FriendSuggestion(models.Model):
    username = CharField(max_length=100)
    friendSuggestion = CharField(max_length=100)
