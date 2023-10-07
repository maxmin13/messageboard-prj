from django.test import TestCase

from apps.posts.models import Post

class ModelTests(TestCase):

  @classmethod
  def setUpTestData(cls):
    cls.post = Post.objects.create(text="This is a test!")

  def test_post_content(self):
    self.assertEqual(self.post.text, "This is a test!")

