from django.contrib import admin
from django.urls import path
from userInfo.views import UserInfoView, ProfileView, FollowerInfoView, FollowingInfoView, MatchUsers
from userProfile.views import CommentView, LikeView, PostView, UserFeed
from friendSuggestions.views import FriendSuggestionView

urlpatterns = [
    path('admin/', admin.site.urls),
    # Gets User Info
    path('userInfo/<username>/get', UserInfoView.getUserInfo),
    # Creates User Info
    path('userInfo/create', UserInfoView.createUserInfo),
    # Gets profile info for a user.
    path('profileInfo/<username>/get', ProfileView.getProfileInfo),
    # Creates or updates profile info.
    path('profileInfo/create', ProfileView.createProfileInfo),
    # Returns matches for a user.
    path('matchInfo/<username>/<typeRequested>/getMatches', MatchUsers.matchUsers),
    # Gets all of the user's followers.
    path('followerInfo/<username>/getAll', FollowerInfoView.getAllFollowers),
    # Gets all of the user's following.
    path('followingInfo/<username>/getAll',
         FollowingInfoView.getAllFollowing),
    # Allows the user to follow another user.
    path('followingInfo/followUser', FollowingInfoView.followUser),
    # Allows the user to unfollow another user.
    path('followingInfo/unfollowUser', FollowingInfoView.unfollowUser),
    # Creates friend suggestions for a user.
    path('friendSuggestions/<username>/createSuggestions',
         FriendSuggestionView.createFriendSuggestions),
    # Gets friend suggestions for a user.
    path('friendSuggestions/<username>/getSuggestions',
         FriendSuggestionView.getSuggestions),
    # Gets all posts from a user.
    path('postInfo/<username>/getAllPosts', PostView.getAllPosts),
    # Gets a particular post from a user.
    path('postInfo/<username>/<postNumber>/getPost', PostView.getPost),
    # User creates a post.
    path('postInfo/createPost', PostView.createPost),
    # User likes a post.
    path('postInfo/likePost', LikeView.likePost),
    # User unlikes a post they previously liked.
    path('postInfo/<username>/<likesUsername>/<postNumber>/unlikePost',
         LikeView.unlikePost),
    # Gets a particular like from a post.
    path('postInfo/<username>/<likesUsername>/<postNumber>/getLike',
         LikeView.getLike),
    # Gets all likes for a post.
    path('postInfo/<username>/<postNumber>/getAllLikes',
         LikeView.getAllLikes),
    # Gets all comments on a user's post.
    path('postInfo/<username>/<postNumber>/getAllComments',
         CommentView.getAllComments),
    # User comments on a post.
    path('postInfo/commentPost',
         CommentView.commentPost),
    # User deletes a comments on a post.
    path('postInfo/<username>/<commenterUsername>/<comment>/<postNumber>/commentPost',
         CommentView.deleteComment),
    # Gets a user's feed.
    path('postInfo/<username>/getFeed',
         UserFeed.getFeed)
]
