# pages/urls.py
from django.urls import path
from apps.posts.views import PostsView

urlpatterns = [
   path("posts/", PostsView.as_view(), name="posts"),
    
]