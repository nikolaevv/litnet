from django.shortcuts import render
from django.http import HttpResponse, HttpRequest, HttpResponseRedirect
from django.core.files.storage import FileSystemStorage
from .models import User, Book
from django.core.mail import send_mail
import smtplib
import random
import os
from .forms import UserForm, BookForm, changePassForm, changeEmailForm, verifyForm, searchForm
import json
import time
import magic
from django.http import JsonResponse
from rest_framework import generics
from PIL import Image
import codecs
from .serializers import BookSerializer
import io
from django.template import Context, loader
from config import email_adress, email_pass

registrating_users = {}
changing_email = []
# Глобальные массивы для хранения кодов подтверждения и прочей информации

work_dir = os.path.dirname(os.path.abspath(__file__))
# Абсоютный путь

def main(request):
    #Главная страница
    if request.method == 'POST':
        form = UserForm(request.POST)
        if form.is_valid():
            email = form.cleaned_data['email']
            password = form.cleaned_data['password']
            users = User.objects.all().filter(email = email).filter(password = password)
            if users:
                request.session['user'] = email
                #response = HttpResponse('True')
                #return response
                return HttpResponseRedirect('/books')
            else:
                return HttpResponseRedirect('/')
    else:
        form = UserForm()
    isLogin = request.session.get('user', 'none')
    print(isLogin)
    return render(request, 'main.html', {'form': form})

def email_availability(request):
    new_email = request.POST.get('email', '')
    # Запрос email с формы
    newNickname = request.POST.get('nickname', '')
    newPassword = request.POST.get('password', '')
    userEmails = User.objects.all().filter(email = newEmail)
    # Фильтр в БД по email с формы
    if not userEmails:
        response = HttpResponse('True')
        verify_code = str(random.randint(100000, 999999))
        # Генерация кода
        user = {'password': newPassword,
                'nickname': newNickname,
                'verifyCode': verify_code}

        registrating_users[new_email] = user
        request.session['reg'] = new_email

        smtpObj = smtplib.SMTP('smtp.gmail.com', 587)
        smtpObj.starttls()
        smtpObj.login(email_adress, email_pass)
        smtpObj.sendmail(email_adress, new_email, verify_code)
        return response

    else:
        response = HttpResponse('False')
        return response

def check_code(request):
    user_code = request.POST.get('code', None)
    is_registred = request.session.get('reg', None)
    if is_registred:
        user = registrating_users[is_registred]

        if user['verifyCode'] == userCode:
            response = HttpResponse('Right')
            b = User(nickname = user['nickname'], email = user['email'], password = user['password'])
            b.save()
            request.session['user'] = newEmail
            registratingUsers.remove(user)
            return response

        else:
            response = HttpResponse('Not Right')
            return response

def books(request):
    is_login = request.session.get('user', None)
    if is_login:
        return HttpResponseRedirect('/')

    books = Book.objects.all()
    # Полученик всех книг
    return render(request, 'bookList.html', {'books': books})

def search(request):
    search = request.GET.get('request', '')
    books = Book.objects.all()
    notAvailableBooks = []
    for u in books:
        if u.bookname.find(search) == -1:
            if u.author.find(search) == -1:
                notAvailableBooks.append(str(u.id))
    jso = {'key{}'.format(k):v for k, v in enumerate(notAvailableBooks)}
    arrNotBooks = json.dumps(jso)
    print(arrNotBooks)
    response = HttpResponse(arrNotBooks)
    return response

def choosestyle(request):
    style = request.GET.get('style', '')
    books = Book.objects.all()
    notAvailableBooks = []
    for u in books:
        if u.style != style:
            notAvailableBooks.append(str(u.id))
    jso = {'key{}'.format(k):v for k, v in enumerate(notAvailableBooks)}
    arrNotBooks = json.dumps(jso)
    response = HttpResponse(arrNotBooks)
    return response

def upload(request):
    is_login = request.session.get('user', 'none')
    if not is_login:
        return HttpResponseRedirect('/')
    else:
        if request.method == 'POST':
            form = BookForm(request.POST, request.FILES)
            if form.is_valid():
                bookname = form.cleaned_data['bookname']
                author = form.cleaned_data['author']
                desc = form.cleaned_data['desc']
                style = form.cleaned_data['style']
                # Получение данных произведения

                author_photo = request.FILES['authorPhoto']
                photo_format = str(authorPhoto).split('.')[-1]
                book = request.FILES['book']
                realFormatBook = str(book).split('.')[-1]
                if realFormatBook in ('pdf', 'mobi', 'fb2', 'rtf'):
                    file_name = 'book' + str(random.randint(1000000000, 9999999999)) + '.' + realFormatBook

                    fs = FileSystemStorage()
                    filename = fs.save(file_name, book)
                    uploaded_file_url = fs.url(filename)
                    with open(f'{work_dir}\\main\\templates\\books\\{file_name}', 'wb+') as destination:
                        for chunk in request.FILES['book'].chunks():
                            destination.write(chunk)

                    magicFormat = magic.from_file(books\\' + file_name)
                    # Двухфакторная проверка формата книги и её сохранение

                    if magicFormat.find('PDF') == -1 and magicFormat.find('XML') == -1:
                        os.remove(f'{work_dir}\\main\\templates\\books\\{file_name}')
                    if photo_format in ('png', 'jpeg', 'jpg'):
                        photo_file = 'author' + str(random.randint(1000000000, 9999999999)) + '.' + photo_format

                        with open(f'main\\static\\image\\{photo_file}', 'wb+') as destination:
                            for chunk in request.FILES['authorPhoto'].chunks():
                                  destination.write(chunk)

                        im = Image.open('main\\static\\image\\' + photo_file)
                        (width, height) = im.size
                        if width != height:
                            if width > height:
                                side = (width - height)/2
                                area = (side, 0, (side + height), height)
                                im = im.crop(area)
                                im.save('main\\static\\image\\' + photo_file)
                            elif height > width:
                                side = (height - width)/2
                                area = (0, side, width, (side + width))
                                im = im.crop(area)
                                os.remove(r'C:\YandexDisk\Проекты\litnet\main\static\image\%s' % photo_file)
                                im.save(('main\\static\\image\\' + photo_file))
                                # Обработка изображения

                        b = Book(bookname = bookname, author = author, style = style, desc = desc, form = realFormatBook, authorPhoto = newAuthorPhotoFile, book = newBookFileName, uploader = isLogin)
                        b.save()

        else:
            form = BookForm()
    return render(request, 'upload.html', {'form': form})

def me(request):
    # Страница о пользователе
    isLogin = request.session.get('user', 'none')
    user = User.objects.filter(email = isLogin)[0]
    print(user)
    if isLogin in ('none', ''):
        return HttpResponseRedirect('/')

    return render(request, 'profile.html', {'user': user})

def changepass(request):
    # Смена пароля
    old_password = request.POST.get('oldPassword', '')
    password = request.POST.get('password', '')
    email = request.POST.get('email', '')

    isLogin = request.session.get('user', 'none')
    user = User.objects.all().filter(email = isLogin)[0]

    if user.password == old_password:
        user.password = password
        user.save()

        return HttpResponse('Right')
    return HttpResponse('NotRight')

def book(request, book):
    # Получение книги в PDF формате
    with codecs.open(('main/templates/books/' + book), 'rb') as pdf:
        response = HttpResponse(pdf.read())
        response['Content-Type'] = 'application/pdf'
    pdf.closed
    return response

def login(request):
    # Авторизация
    if request.method == 'POST':
        form = UserForm(request.POST)
        if form.is_valid():
            email = form.cleaned_data['email']
            password = form.cleaned_data['password']
            users = User.objects.all().filter(email = email).filter(password = password)
            if len(users) > 0:
                request.session['user'] = email
                return HttpResponse('True')
            else:
                return HttpResponse('False')

        return HttpResponse('Invalid')

def get_user_info(request):
    # Получение информации о пользователе
    if request.method == 'POST':
        form = UserForm(request.POST)
        if form.is_valid():
            email = form.cleaned_data['email']
            password = form.cleaned_data['password']
            users = User.objects.all().filter(email = email).filter(password = password)
            if users:
                nickname = users[0].nickname
                response = HttpResponse(nickname)
                return response
            else:
                response = HttpResponse('False')
                return response
        else:
            response = HttpResponse('Invalid')
            return response

def change_password(request):
    # Смена пароля
    if request.method == 'POST':
        form = changePassForm(request.POST)
        if form.is_valid():
            email = form.cleaned_data['email']
            oldPassword = form.cleaned_data['oldPassword']
            password = form.cleaned_data['password']
            # Сбор данных с формы

            users = User.objects.all().filter(email = email).filter(password = oldPassword)
            if users:
                users[0].password = password
                users[0].save()
                response = HttpResponse('True')
                return response
            else:
                response = HttpResponse('False')
                return response
        else:
            response = HttpResponse('Invalid')
            return response

def change_email(request):
    # Смена электронной почты
    if request.method == 'POST':
        form = changeEmailForm(request.POST)
        if form.is_valid():
            oldEmail = form.cleaned_data['oldEmail']
            password = form.cleaned_data['password']
            email = form.cleaned_data['email']
            # Сбор формы

            users = User.objects.all().filter(email = oldEmail).filter(password = password)

            if users:
                for i in changingEmail:
                    if i['oldEmail'] == oldEmail:
                        changingEmail.remove(i)

                verify_code = str(random.randint(100000, 999999))
                smtpObj = smtplib.SMTP('smtp.gmail.com', 587)
                smtpObj.starttls()
                smtpObj.login(email_adress, email_pass)
                smtpObj.sendmail(email_adress, email, verify_code)
                # Отправка кода подтверждения на почту пользователя

                change_data = {'oldEmail': oldEmail,
                               'email': email,
                               'verifyCode': verify_code
                }

                changingEmail.append(change_data)
                return HttpResponse('True')
            else:
                return HttpResponse('False')
            return HttpResponse('Invalid')

def search_book(request):
    # Поиск по названию или автору книги
    if request.method == 'POST':
        form = searchForm(request.POST)
        if form.is_valid():
            text = form.cleaned_data['text']
            books = Book.objects.all()
            jsonObject = None
            suitableBooks = []

            for book in books:
                if book.bookname.find(text) != -1 or book.author.find(text) != -1:
                    newArray = {'bookname': book.bookname, 'author': book.author, 'book': book.book}
                    suitableBooks.append(newArray)

            if len(suitableBooks) == 0:
                return HttpResponse('None')
            else:
                return JsonResponse(suitableBooks, safe = False)

        else:
            return HttpResponse('Invalid')

def verify_new_email(request):
    # Подтверждение нового адреса электронной почты
    if request.method == 'POST':
        form = verifyForm(request.POST)
        if form.is_valid():
            oldEmail = form.cleaned_data['oldEmail']
            verifyCode = form.cleaned_data['verifyCode']
            users = User.objects.all().filter(email = oldEmail)

            for i in changingEmail:
                if i['oldEmail'] == oldEmail:
                    user = i

            if users:
                if user['verifyCode'] == verifyCode:
                    users[0].email = user['email']
                    users[0].save()
                    response = HttpResponse(user['email'])
                    changingEmail.remove(user)
                    return response
                return HttpResponse('False')
            return HttpResponse('False')
        return HttpResponse('Invalid')

class BookSendInfo(generics.ListAPIView):
    serializer_class = BookSerializer
    queryset = Book.objects.all()
