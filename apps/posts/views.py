# pages/views.py
from django.views.generic import TemplateView
from django.views.generic import ListView
from .models import Post

class HomePageView(TemplateView):
    template_name = "home.html"
    
class AboutPageView(TemplateView):
    template_name = "about.html"
    
class PostsView(ListView):
    model = Post
    template_name = "posts.html"