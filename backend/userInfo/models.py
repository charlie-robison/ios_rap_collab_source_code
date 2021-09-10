from django.db import models
from django.db.models.fields import CharField, IntegerField

# Create your models here.


class UserInfo(models.Model):
    username = CharField(max_length=10)
    password = CharField(max_length=10)
    userType = IntegerField()
    genre = IntegerField()


class ProfileInfo(models.Model):
    username = CharField(max_length=10)
    userBio = CharField(max_length=60)
    userUrl1 = CharField(max_length=200)
    userUrl2 = CharField(max_length=200)
    userUrl3 = CharField(max_length=200)
    urlName1 = CharField(max_length=10)
    urlName2 = CharField(max_length=10)
    urlName3 = CharField(max_length=10)


class FollowerInfo(models.Model):
    username = CharField(max_length=10)
    followerUsername = CharField(max_length=10)


class FollowingInfo(models.Model):
    username = CharField(max_length=10)
    followingUsername = CharField(max_length=10)
