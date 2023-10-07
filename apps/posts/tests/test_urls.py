from django.test import TestCase
from django.urls import reverse

class UrlTests(TestCase):
    
    def test_posts_url_exists_at_correct_location(self):
        response = self.client.get("/")
        self.assertEqual(response.status_code, 200)

    def test_posts_page(self):  
        response = self.client.get(reverse("posts"))
        self.assertEqual(response.status_code, 200)
        self.assertTemplateUsed(response, "posts.html")
        self.assertContains(response, "Message board posts")
