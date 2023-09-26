# pages/urls.py
from django.urls import path
from .views import HomePageView
from .views import AboutPageView

urlpatterns = [
    path("admin/", admin.site.urls),
    path("", include("posts.urls")),  # new
]