from django.urls import path
from . import views

urlpatterns = [
    path('', views.main, name='mainPage'),
    path('check', views.reqAvilableEmail, name='reqAvilableEmail'),
    path('checkcode', views.checkCode, name='checkCode'),
    path('registr', views.registr, name='registr'),
    path('login', views.login, name='login'),
]