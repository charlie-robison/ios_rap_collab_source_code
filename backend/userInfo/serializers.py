from rest_framework import serializers
from .models import UserInfo
from .models import ProfileInfo
from .models import FollowerInfo
from .models import FollowingInfo


class UserInfoSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserInfo
        fields = ['username', 'password', 'userType', 'genre']


class ProfileInfoSerializer(serializers.ModelSerializer):
    class Meta:
        model = ProfileInfo
        fields = ['username', 'userBio', 'userUrl1', 'userUrl2',
                  'userUrl3', 'urlName1', 'urlName2', 'urlName3']


class FollowerInfoSerializer(serializers.ModelSerializer):
    class Meta:
        model = FollowerInfo
        fields = ['username', 'followerUsername']


class FollowingInfoSerializer(serializers.ModelSerializer):
    class Meta:
        model = FollowingInfo
        fields = ['username', 'followingUsername']
