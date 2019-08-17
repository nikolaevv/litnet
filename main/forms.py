from django import forms
from .models import User, Book

class UserForm(forms.Form):
    email = forms.CharField(max_length=255)
    password = forms.CharField(max_length=255)

class BookForm(forms.Form):
    bookname = forms.CharField(max_length=255)
    author = forms.CharField(max_length=255)
    desc = forms.CharField(max_length=1000)
    style = forms.CharField(max_length=255)
    authorPhoto = forms.FileField()
    book = forms.FileField()

class changePassForm(forms.Form):
    email = forms.CharField(max_length=255)
    oldPassword = forms.CharField(max_length=255)
    password = forms.CharField(max_length=255)

class changeEmailForm(forms.Form):
    oldEmail = forms.CharField(max_length=255)
    password = forms.CharField(max_length=255)
    email = forms.CharField(max_length=255)

class verifyForm(forms.Form):
    oldEmail = forms.CharField(max_length=255)
    verifyCode = forms.CharField(max_length=255)

class searchForm(forms.Form):
    text = forms.CharField(max_length=255)
