from django.urls import path, include
from . import views
from .views import *

urlpatterns  =  [
    path('', views.main),
    path('api/user/emailav', views.email_availability),
    path('checkcode', views.checkCode),
    path('books/<str:book>', views.book),
    path('books', views.books),
    path('search', views.search),
    path('choosestyle', views.choosestyle),
    path('upload', views.upload),
    path('me', views.me),
    path('changepass', views.changepass),
    path('api/book/get', BookSendInfo.as_view()),
    path('login', views.login),
    path('getnickname', views.get_user_info),
    path('changepassword', views.change_password),
    path('changeemail', views.change_email),
    path('verifynewemail', views.verify_new_email),
    path('api/book/search', views.search_book),
]
