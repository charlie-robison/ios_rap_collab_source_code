from django.http import response
from django.http.request import QueryDict
from django.shortcuts import render
from django.db.models import query
from rest_framework import serializers, status
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
# All Serializers
from .serializers import UserInfoSerializer, ProfileInfoSerializer, FollowerInfoSerializer, FollowingInfoSerializer
# All Models
from .models import UserInfo, ProfileInfo, FollowerInfo, FollowingInfo


# Create your views here.
class UserInfoView:

    # Gets all user information based on username given.
    @api_view(['GET', ])
    def getUserInfo(request, username):
        try:
            querySet = UserInfo.objects.filter(username=username)
        except UserInfo.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)
        serializer = UserInfoSerializer(querySet, many=True)
        return Response(serializer.data)

    # Creates a new User.
    @api_view(['POST', ])
    def createUserInfo(request):
        serializer = UserInfoSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        else:
            return Response(serializer.errors)


class ProfileView:
    # Gets profile information.
    @api_view(['GET', ])
    def getProfileInfo(request, username):
        try:
            querySet = ProfileInfo.objects.filter(username=username)
        except ProfileInfo.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)
        serializer = ProfileInfoSerializer(querySet, many=True)
        return Response(serializer.data)

    # Creates profile information or updates profile info.
    @api_view(['POST', ])
    def createProfileInfo(request):
        serializer = ProfileInfoSerializer(data=request.data)
        if serializer.is_valid():
            username = serializer.data['username']
            querySet = ProfileInfo.objects.get(username=username)
            serializerSearch = ProfileInfoSerializer(querySet, many=True)
            # Checks if data exists.
            if len(serializerSearch) > 0:
                # Updates profile info.
                serializer = ProfileInfoSerializer(querySet, data=request.data)
                if serializer.is_valid():
                    serializer.save()
                    return Response(serializer.data)
                else:
                    return Response(serializer.errors)
            else:
                # Creates new profile info.
                serializer.save()
                return Response(serializer.data)
        else:
            return Response(serializer.errors)


class MatchUsers:
    # Gets all user matches for a user based on their genre and type of user requested.
    @api_view(['GET', ])
    def matchUsers(request, username, typeRequested):
        try:
            # Gets the user.
            querySet = UserInfo.objects.filter(username=username)
        except UserInfo.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)
        serializer = UserInfoSerializer(querySet, many=True)
        # Stores the genre of the user.
        genre = serializer.data[0]['genre']
        # Creates a querySet of all users which are the typeRequested and genre. Excludes user.
        querySet = UserInfo.objects.filter(
            userType=int(typeRequested), genre=genre).exclude(username=username)
        serializer = UserInfoSerializer(querySet, many=True)
        return Response(serializer.data)


class FollowerInfoView:
    # Gets all followers for a particular user based on their username.
    @api_view(['GET', ])
    def getAllFollowers(request, username):
        try:
            querySet = FollowerInfo.objects.filter(username=username)
        except FollowerInfo.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)
        serializer = FollowerInfoSerializer(querySet, many=True)
        return Response(serializer.data)

    # Creates a new queryDict given the username of the user and their new follower's username.
    def createQueryDict(username, followerUsername):
        newDict = {"username": username, "followerUsername": followerUsername}
        queryDict = QueryDict('', mutable=True)
        queryDict.update(newDict)
        return queryDict

    # Adds a new follower to a user given the username and their new follower's username.
    def addNewFollower(username, followerUsername):
        queryDict = FollowerInfoView.createQueryDict(
            username=username, followerUsername=followerUsername)
        serializer = FollowerInfoSerializer(data=queryDict)
        if serializer.is_valid():
            serializer.save()
            # Adds 1 to user's follower count
            # InteractionsView.updateInteractions(
            # username=username, operation="Follower")
            print("NEW FOLLOWER!!")
            return
        print("FAILED!!")
        return

    # Checks if the user inputted currently follows the user.
    def checkExistingFollowers(username, followerUsername):
        try:
            querySet = FollowerInfo.objects.filter(
                username=username, followerUsername=followerUsername)
        except FollowerInfo.DoesNotExist:
            return False
        serializer = FollowerInfoSerializer(querySet, many=True)
        if len(serializer.data) > 0:
            return True
        return False

    # Deletes a follower from the user's followers.
    def deleteFollower(username, followerUsername):
        checkExisting = FollowerInfoView.checkExistingFollowers(
            username=username, followerUsername=followerUsername)
        if checkExisting:
            FollowerInfo.objects.filter(
                username=username, followerUsername=followerUsername).delete()
            return Response("Someone Unfollowed You!!")
        return Response("Someone tried to unfollow you!")


class FollowingInfoView:
    # Gets all users the user is currently following given their username.
    @api_view(['GET', ])
    def getAllFollowing(request, username):
        try:
            querySet = FollowingInfo.objects.filter(
                username=username)
        except FollowingInfo.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)
        serializer = FollowingInfoSerializer(querySet, many=True)
        return Response(serializer.data)

    # Checks if the current user being followed by the user is already being followed by the user.
    def checkExistingFollowing(username, followingUsername):
        try:
            querySet = FollowingInfo.objects.filter(
                username=username, followingUsername=followingUsername)
        except FollowingInfo.DoesNotExist:
            return False
        serializer = FollowingInfoSerializer(querySet, many=True)
        if len(serializer.data) > 0:
            return True
        return False

    # User follows another user, adding to their following and the followed user's followers.
    @api_view(['POST', ])
    def followUser(request):
        # Gets the request data.
        serializer = FollowingInfoSerializer(data=request.data)
        if serializer.is_valid():
            # The username of the user.
            followerUsername = serializer.validated_data['username']
            # The username of the user being followed.
            followingUsername = serializer.validated_data['followingUsername']
            # Checks if this current user is already being followed by the user.
            checkExisting = FollowingInfoView.checkExistingFollowing(
                username=followerUsername, followingUsername=followingUsername)
            # Checks if followerUser is different than followingUsername and that this is a new use being followed.
            if followerUsername != followingUsername and not checkExisting:
                # Calls addNewFollower from FollowerInfoView to add a new follower to the followed User's followers.
                FollowerInfoView.addNewFollower(
                    username=followingUsername, followerUsername=followerUsername)
                # Saves following information to DB.
                serializer.save()
                # Adds 1 to following count for user.
                # InteractionsView.updateInteractions(
                # username = followerUsername, operation = "Following")
                print("New Following!!")
                return Response(serializer.data)
        return Response(serializer.errors)

    # Allows the user to unfollow another user they are following.
    @api_view(['DELETE', ])
    def unfollowUser(request):
        serializer = FollowingInfoSerializer(data=request.data)
        if serializer.is_valid():
            username = serializer.validated_data['username']
            followingUsername = serializer.validated_data['followingUsername']
            # Checks for existing following.
            checkExisting = FollowingInfoView.checkExistingFollowing(
                username=username, followingUsername=followingUsername)
            # Checks if followingUser is already being followed by the user.
            if checkExisting:
                FollowingInfo.objects.filter(
                    username=username, followingUsername=followingUsername).delete()
                # For user being unfollowed, the user unfollowing is removed as a follower.
                FollowerInfoView.deleteFollower(
                    username=followingUsername, followerUsername=username)
                return Response("User Unfollowed!")
            else:
                return Response("Does Not Follow User!")
        return Response(serializer.errors)

    def usersFollowing(username):
        try:
            querySet = FollowingInfo.objects.filter(username=username)
        except FollowingInfo.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)
        serializer = FollowingInfoSerializer(querySet, many=True)
        followingData = []
        if len(serializer.data) != 0:
            for data in serializer.data:
                followingData.append(data['followingUsername'])
        return followingData
