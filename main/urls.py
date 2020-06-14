from django.urls import path, include
from . import views
from .views import *

urlpatterns = [
    path('', views.main, name = 'Главная страница'),
    path('api/user/emailav', views.email_availability, name = 'Проверка на существование электронной почты'),
    path('checkcode', views.checkCode, name = 'Проверка кода'),
    path('books/<str:book>', views.book, name='book'),
    path('books', views.books, name='books'),
    path('search', views.search, name='search'),
    path('choosestyle', views.choosestyle, name='choosestyle'),
    path('upload', views.upload, name='upload'),
    path('me', views.me, name='me'),
    path('changepass', views.changepass, name='changepass'),
    path('api/book/get', BookSendInfo.as_view()),
    path('login', views.login, name='login'),
    path('getnickname', views.getUserInfo, name='getUserInfo'),
    path('changepassword', views.changePassword, name='changePassword'),
    path('changeemail', views.changeEmail, name='changeEmail'),
    path('verifynewemail', views.verifyNewEmail, name='verifyNewEmail'),
    path('api/book/search', views.searchBook, name='searchBook'),
]
