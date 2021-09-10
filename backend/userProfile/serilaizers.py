from rest_framework import serializers
from .models import UserPost, PostComment, PostLike, TotalNumberOfPosts


class UserPostSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserPost
        fields = ['username', 'postNumber', 'postCaption',
                  'numberOfLikes', 'numberOfComments', 'postUrl', 'urlName']


class PostLikeSerializer(serializers.ModelSerializer):
    class Meta:
        model = PostLike
        fields = ['username', 'likesUsername', 'postNumber']


class PostCommentSerializer(serializers.ModelSerializer):
    class Meta:
        model = PostComment
        fields = ['username', 'commenterUsername',
                  'postNumber', 'comment']


class TotalNumberOfPostsSerializer(serializers.ModelSerializer):
    class Meta:
        model = TotalNumberOfPosts
        fields = ['totalPosts', 'totalComments']
