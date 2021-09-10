from django.db import models
from django.db.models.fields import CharField, IntegerField
from django.db.models.fields.files import FileField, ImageField

# Create your models here.


class UserPost(models.Model):
    username = CharField(max_length=10)
    postNumber = IntegerField()
    #postImage = ImageField()
    #postSound = FileField()
    postCaption = CharField(max_length=196)
    numberOfLikes = IntegerField()
    numberOfComments = IntegerField()
    postUrl = CharField(max_length=200)
    urlName = CharField(max_length=10)


class PostLike(models.Model):
    username = CharField(max_length=10)
    likesUsername = CharField(max_length=10)
    postNumber = IntegerField()


class PostComment(models.Model):
    username = CharField(max_length=10)
    commenterUsername = CharField(max_length=10)
    postNumber = IntegerField()
    comment = CharField(max_length=200)


class TotalNumberOfPosts(models.Model):
    totalPosts = IntegerField()
