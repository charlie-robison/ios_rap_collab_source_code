from django.http import response
from django.http.request import QueryDict
from django.shortcuts import render
from django.db.models import query
from rest_framework import serializers, status
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from .updatePostInfo import UpdatePost
from .updateTotalNumber import UpdateTotalPosts
# Serializers
from .serilaizers import UserPostSerializer, PostLikeSerializer, PostCommentSerializer, TotalNumberOfPostsSerializer
from userInfo.serializers import FollowingInfoSerializer
# Models
from .models import UserPost, PostLike, PostComment, TotalNumberOfPosts
from userInfo.models import FollowingInfo

# Create your views here.


class PostView:
    # Gets all posts from a user.
    @api_view(['GET', ])
    def getAllPosts(request, username):
        try:
            # Gets a query set of all posts made by the user ordered from most recent to least recent.
            querySet = UserPost.objects.filter(
                username=username).order_by('-postNumber')
        except UserPost.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)
        serializer = UserPostSerializer(querySet, many=True)
        return Response(serializer.data)

    # Gets a particular post from a user.
    @api_view(['GET', ])
    def getPost(request, username, postNumber):
        try:
            querySet = UserPost.objects.filter(
                username=username, postNumber=postNumber)
        except UserPost.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)
        serializer = UserPostSerializer(querySet, many=True)
        return Response(serializer.data)

    # Creates a new post for a user.
    @api_view(['POST', ])
    def createPost(request):
        # Gets new post data.
        serializer = UserPostSerializer(data=request.data)
        if serializer.is_valid():
            username = serializer.data['username']
            # Gets the total number of posts in DB to find the post number.
            querySet = TotalNumberOfPosts.objects.all()
            serializerGet = TotalNumberOfPostsSerializer(querySet, many=True)
            # Finds the number of previous posts.
            numberOfPosts = serializerGet.data[0]['totalPosts']
            # Creates a new UpdatePost object with new post information.
            post = UpdatePost(username=username, postNumber=0,
                              postCaption=serializer.data['postCaption'], numberOfLikes=serializer.data['numberOfLikes'], numberOfComments=serializer.data['numberOfComments'])
            # Updates postNumber for post to correct number.
            post.updatePostNumber(numberOfPosts=numberOfPosts)
            # Creates a queryDict with updated postNumber of new post.
            queryDict = post.createNewInfo()
            serializer = UserPostSerializer(data=queryDict)
            if serializer.is_valid():
                # Saves update post info.
                serializer.save()
                # Creates UpdateTotalPost object.
                updatePostTotal = UpdateTotalPosts(totalNumber=numberOfPosts)
                # Adds one to total.
                updatePostTotal.addToTotal()
                # Creates a new queryDict with updated info.
                queryDict2 = updatePostTotal.createNewInfo()
                querySet = TotalNumberOfPosts.objects.get(
                    totalPosts=numberOfPosts)
                serializer2 = TotalNumberOfPostsSerializer(
                    querySet, data=queryDict2)
                if serializer2.is_valid():
                    # Saves new totalNumber to DB.
                    serializer2.save()
                    return Response(serializer.data)
                else:
                    return Response(serializer.errors)
            else:
                return Response(serializer.errors)
        else:
            return Response(serializer.errors)


class LikeView:
    # Gets all likes for a certain post.
    @api_view(['GET', ])
    def getAllLikes(request, username, postNumber):
        try:
            querySet = PostLike.objects.filter(
                username=username, postNumber=postNumber)
        except PostLike.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)
        serializer = PostLikeSerializer(querySet, many=True)
        return Response(serializer.data)

    @api_view(['GET', ])
    def getLike(request, username, likesUsername, postNumber):
        try:
            querySet = PostLike.objects.filter(
                username=username, likesUsername=likesUsername, postNumber=postNumber)
        except PostLike.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)
        serializer = PostLikeSerializer(querySet, many=True)
        return Response(serializer.data)

    # Checks for existing likes for a post.
    def checkExistingLikes(dataIndex):
        # Gets post information.
        username = dataIndex['username']
        postNumber = dataIndex['postNumber']
        likesUsername = dataIndex['likesUsername']
        try:
            querySet = PostLike.objects.filter(
                username=username, postNumber=postNumber, likesUsername=likesUsername)
        except PostLike.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)
        serializer = PostLikeSerializer(querySet, many=True)
        # Checks if the user liking the post already liked the post.
        if len(serializer.data) > 0:
            return False
        return True

    # User likes another user's post.
    @api_view(['POST', ])
    def likePost(request):
        # Takes in request data.
        serializer = PostLikeSerializer(data=request.data)
        if serializer.is_valid():
            # Checks for existing likes.
            likesCheck = LikeView.checkExistingLikes(
                dataIndex=serializer.validated_data)
            # Checks if did not already like the post.
            if likesCheck:
                # Saves to DB.
                serializer.save()
                # Gets username and postNumber of the user being liked.
                username = serializer.data['username']
                postNumber = serializer.data['postNumber']
                # Filters to find post.
                querySet = UserPost.objects.filter(
                    username=username, postNumber=postNumber)
                serializerGet = UserPostSerializer(querySet, many=True)
                dataIndex = serializerGet.data[0]
                # Creates new UpdatePost object with given information on post.
                post = UpdatePost(username=username, postNumber=postNumber,
                                  postCaption=dataIndex['postCaption'], numberOfLikes=dataIndex['numberOfLikes'], numberOfComments=dataIndex['numberOfComments'])
                # Increases number of likes by one on the post.
                post.updateLikes(operation="add")
                # Creates a queryDict with the updated information.
                queryDict = post.createNewInfo()
                post.clearAllInfo()
                querySet = UserPost.objects.get(
                    username=username, postNumber=postNumber)
                # Creates a new serializer for the post.
                serializerForPost = UserPostSerializer(
                    querySet, data=queryDict)
                if serializerForPost.is_valid():
                    # Updates post in DB.
                    serializerForPost.save()
                    return Response(serializerForPost.data)
                else:
                    return Response(serializerForPost.errors)
            else:
                return Response("Already Liked This Post!!")
        else:
            return Response(serializer.errors)

    # User unlikes a post they previously liked.
    @api_view(['DELETE', ])
    def unlikePost(request, username, likesUsername, postNumber):
        try:
            # Gets post like information.
            querySet = PostLike.objects.filter(
                username=username, likesUsername=likesUsername, postNumber=postNumber)
        except PostLike.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)
        serializer = PostLikeSerializer(querySet, many=True)
        # Checks if there is one and only one element in serilaizer.data. (User has liked the post before and only once.)
        if len(serializer.data) == 1:
            # Deletes the like from the DB.
            querySet.delete()
            # Gets the post.
            querySetGet = UserPost.objects.filter(
                username=username, postNumber=postNumber)
            serializerGet = UserPostSerializer(querySetGet, many=True)
            # Creates a new UpdatePost object to change post details.
            post = UpdatePost(username=serializerGet.data[0]['username'], postNumber=serializerGet.data[0]['postNumber'], postCaption=serializerGet.data[0]
                              ['postCaption'], numberOfLikes=serializerGet.data[0]['numberOfLikes'], numberOfComments=serializerGet.data[0]['numberOfComments'])
            # Subtract 1 from numberOfLikes on the post.
            post.updateLikes(operation="delete")
            # Creates a queryDict from the new info.
            queryDict = post.createNewInfo()
            # Gets the post.
            querySetGet = UserPost.objects.get(
                username=username, postNumber=postNumber)
            # Serializes the new post data.
            serializer = UserPostSerializer(querySetGet, data=queryDict)
            if serializer.is_valid():
                # Saves the updated post.
                serializer.save()
                return Response(serializer.data)
            else:
                return Response(serializer.errors)
        else:
            return Response("You have not liked the post!")


class CommentView:
    # Gets all comments for a certain post.
    @api_view(['GET', ])
    def getAllComments(request, username, postNumber):
        try:
            querySet = PostComment.objects.filter(
                username=username, postNumber=postNumber)
        except PostLike.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)
        serializer = PostCommentSerializer(querySet, many=True)
        return Response(serializer.data)

    # User comments another user's post.
    @api_view(['POST', ])
    def commentPost(request):
        # Takes in request data.
        serializer = PostCommentSerializer(data=request.data)
        if serializer.is_valid():
            # Saves to DB.
            serializer.save()
            # Gets username and postNumber of the user being commented.
            username = serializer.data['username']
            postNumber = serializer.data['postNumber']
            # Filters to find post.
            querySet = UserPost.objects.filter(
                username=username, postNumber=postNumber)
            serializerGet = UserPostSerializer(querySet, many=True)
            dataIndex = serializerGet.data[0]
            # Creates new UpdatePost object with given information on post.
            post = UpdatePost(username=username, postNumber=postNumber,
                              postCaption=dataIndex['postCaption'], numberOfLikes=dataIndex['numberOfLikes'], numberOfComments=dataIndex['numberOfComments'])
            # Increases number of comments by one.
            post.updateComments(operation="add")
            # Creates a queryDict with the updated information.
            queryDict = post.createNewInfo()
            post.clearAllInfo()
            querySet = UserPost.objects.get(
                username=username, postNumber=postNumber)
            # Creates a new serializer for the post.
            serializerForPost = UserPostSerializer(
                querySet, data=queryDict)
            if serializerForPost.is_valid():
                # Updates post in DB.
                serializerForPost.save()
                return Response(serializerForPost.data)
            else:
                return Response(serializerForPost.errors)
        else:
            return Response(serializer.errors)

    # User deletes a comment on a post they commented.
    @api_view(['DELETE', ])
    def deleteComment(request, username, commenterUsername, comment, postNumber):
        try:
            # Gets post like information.
            querySet = PostComment.objects.filter(
                username=username, commenterUsername=commenterUsername, comment=comment, postNumber=postNumber)
        except PostComment.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)
        serializer = PostCommentSerializer(querySet, many=True)
        # Checks if there is one and only one element in serilaizer.data. (User has commented on the post before)
        if len(serializer.data) >= 1:
            # Deletes the comment from the DB.
            querySet.delete()
            # Gets the post.
            querySetGet = UserPost.objects.filter(
                username=username, postNumber=postNumber)
            serializerGet = UserPostSerializer(querySetGet, many=True)
            # Creates a new UpdatePost object to change post details.
            post = UpdatePost(username=serializerGet.data[0]['username'], postNumber=serializerGet.data[0]['postNumber'], postCaption=serializerGet.data[0]
                              ['postCaption'], numberOfLikes=serializerGet.data[0]['numberOfLikes'], numberOfComments=serializerGet.data[0]['numberOfComments'])
            # Subtract 1 from numberOfComments on the post.
            post.updateComments(operation="delete")
            # Creates a queryDict from the new info.
            queryDict = post.createNewInfo()
            # Gets the post.
            querySetGet = UserPost.objects.get(
                username=username, postNumber=postNumber)
            # Serializes the new post data.
            serializer = UserPostSerializer(querySetGet, data=queryDict)
            if serializer.is_valid():
                # Saves the updated post.
                serializer.save()
                return Response(serializer.data)
            else:
                return Response(serializer.errors)
        else:
            return Response("You have not commented on the post!")


class UserFeed:
    @api_view(['GET', ])
    def getFeed(request, username):
        try:
            # Gets all users the user follows.
            querySet = FollowingInfo.objects.filter(username=username)
        except FollowingInfo.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)
        serializer = FollowingInfoSerializer(querySet, many=True)
        newQuerySet = UserPost.objects.none()
        # Loops through each person the user follows.
        for i in range(0, len(serializer.data)):
            # Adds to set the user's posts.
            newQuerySet |= UserPost.objects.filter(
                username=serializer.data[i]['followingUsername'])
        # Sorts the 50 most recent posts.
        sortedQuerySet = newQuerySet.order_by('-postNumber')[:50]
        serializer = UserPostSerializer(sortedQuerySet, many=True)
        return Response(serializer.data)
