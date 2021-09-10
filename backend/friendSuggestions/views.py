from django.http import response
from django.http.request import QueryDict
from django.shortcuts import render
from django.db.models import query
from rest_framework import serializers, status
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated

from userInfo.views import FollowingInfoView

from .createFriendSuggestions import Node, Friends
from .removeDuplicateSuggestions import RemoveDuplicateSuggestions
# Serializers
from .serializers import FriendSuggestionSerializer
from userInfo.serializers import FollowingInfoSerializer
# Models
from .models import FriendSuggestion
from userInfo.models import FollowingInfo

# Create your views here.


class FriendSuggestionView:
    # Gets all friend suggestions for a user.
    @api_view(['GET', ])
    def getFriendSuggestions(request, username):
        try:
            querySet = FriendSuggestion.objects.filter(username=username)
        except FriendSuggestion.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)
        serializer = FriendSuggestionSerializer(querySet, many=True)
        return Response(serializer.data)

    @api_view(['GET', ])
    def getSuggestions(request, username):
        querySet = FollowingInfo.objects.filter(username=username)
        serializer = FollowingInfoSerializer(querySet, many=True)
        suggestionsSet = FollowingInfo.objects.none()
        # Loops through each following user.
        for i in range(0, len(serializer.data)):
            # Filters to find users that the following users are following.
            suggestionsSet |= FollowingInfo.objects.filter(
                username=serializer.data[i]['followingUsername'])
        suggestionsSetB = FollowingInfo.objects.none()
        # Loops through each following user.
        for i in range(0, len(serializer.data)):
            # Excludes users that the user already follows.
            suggestionsSetB |= FollowingInfo.objects.exclude(
                username=serializer.data[i]['followingUsername']).exclude(followingUsername=serializer.data[i]['followingUsername']).exclude(followingUsername=username)
        # Finds the intersection of the two sets.
        suggestionsSet &= suggestionsSetB
        serializer = FollowingInfoSerializer(suggestionsSet, many=True)
        return Response(serializer.data)

    # Creates a new queryDict for a FriendSuggestion object.

    def createQueryDict(username, friendSuggestion):
        newDict = {"username": username, "friendSuggestion": friendSuggestion}
        queryDict = QueryDict('', mutable=True)
        queryDict.update(newDict)
        return queryDict

    # Gets all of the users the user is following and returns an array of all the users or array of a specific number of users.
    # Time Complexity: O(n)
    def findFollowing(username, level, numberOfChildren):
        # Gets all of the users the user follows.
        followingData = FollowingInfoView.usersFollowing(username=username)
        # Sets length of children array to followingData.
        children = [Node(data=None)] * len(followingData)
        # Sets numberOfSuggestions.
        numberOfSuggestions = 8
        # Finds suggestions per child.
        suggestionsPerChild = numberOfSuggestions/numberOfChildren
        # Checks if level is 2 and the length of followingData is greater than suggestionsPerChild.
        if level == 3 and len(followingData) > suggestionsPerChild:
            # Sets length of children array to suggestionsPerChild.
            children = [Node(data=None)] * int(suggestionsPerChild)
        # Fills list with Nodes which contain each user's username.
        for i in range(0, len(children)):
            user: Node = Node(data=followingData[i])
            children[i] = user
        # Returns array of all users following.
        return children

    # Creates friend suggestions for a user by building a tree and then uses BFS to find friends of their friends.
    # These suggestions are then added to the DB.
    @api_view(['GET', ])
    def createFriendSuggestions(request, username):
        # The root user which the suggestions are for.
        root = Node(data=username)
        # Gets an array of all users following.
        children = FriendSuggestionView.findFollowing(
            username=username, level=2, numberOfChildren=1)
        # Sets children of root user to children.
        root.children = children
        # Loops through each child node in list.
        for i in range(0, len(root.children)):
            # Gets an array of all users following for th child.
            children = FriendSuggestionView.findFollowing(
                username=root.children[i].data, level=3, numberOfChildren=len(root.children))
            # Sets children to teh child's children.
            root.children[i].children = children
        # Calls level order to traverse the 3rd level of the tree.
        Friends.levelOrder(root=root, level=3)
        # Gets all friendSuggestions.
        friendSuggestions = Friends.listOfFriendSuggestions
        # Creates new RemoveDuplicateSuggestions object.
        d = RemoveDuplicateSuggestions()
        # Removes all duplicate friend suggestions from the list.
        friendSuggestions = d.removeDuplicates(friendSuggestions)
        # Resets list.
        Friends.listOfFriendSuggestions = []
        # Loops through each friend suggestion.
        for i in range(0, len(friendSuggestions)):
            # Checks if friendSuggestion is itself.
            if friendSuggestions[i] != username:
                # Posts friend suggestion to DB.
                FriendSuggestionView.postSuggestionsToDB(
                    username=username, friendSuggestion=friendSuggestions[i])
        return Response("Success")

    # Posts a friend suggestion to the DB.
    def postSuggestionsToDB(username, friendSuggestion):
        try:
            querySet = FriendSuggestion.objects.get(
                username=username)
        except FriendSuggestion.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)
        queryDict = FriendSuggestionView.createQueryDict(
            username=username, friendSuggestion=friendSuggestion)
        serializer = FriendSuggestionSerializer(data=queryDict)
        if username != "":
            serializer = FriendSuggestionSerializer(querySet, data=queryDict)
        if serializer.is_valid():
            # Saves or updates data
            serializer.save()
            print("New Suggestion!")
        else:
            print("Failed to add suggestion!")
