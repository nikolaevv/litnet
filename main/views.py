from django.shortcuts import render
from django.http import HttpResponse, HttpRequest
from .models import User
from django.core.mail import send_mail
import smtplib
import random

def main(request):
    #Главная страница
    return render(request, 'main.html')

def registr(request):
    return render(request, 'registr.html')

def reqAvilableEmail(request):
    global newEmail
    newEmail = request.POST.get('email', '')
    #Запрос email с формы
    global newNickname
    newNickname = request.POST.get('nickname', '')
    global newPassword
    newPassword = request.POST.get('password', '')
    userEmails = User.objects.all().filter(email = newEmail)
    #Фильтр в БД по email с формы
    if not userEmails:
        response = HttpResponse("True")
        global verifyCode
        verifyCode = str(random.randint(100000, 999999))
        #b = User(nickname email password)
        #b.save()
        smtpObj = smtplib.SMTP('smtp.gmail.com', 587)
        smtpObj.starttls()
        smtpObj.login('litnetpost@gmail.com', 'django13579')
        smtpObj.sendmail("litnetpost@gmail.com", newEmail, verifyCode)
        return response
        
    else:
        response = HttpResponse("False")
        return response

def checkCode(request):
    userCode = request.POST.get('code', '')
    if verifyCode == userCode:
        response = HttpResponse("Right")
        b = User(nickname = newNickname, email = newEmail, password = newPassword)
        b.save()
        return response
    
    else:
        response = HttpResponse("NotRight")
        return response
    
def login(request):
    pass