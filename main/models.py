from django.db import models

class Book(models.Model):
    bookname = models.CharField(max_length=120)
    #Название книги ("Мистер Мерседес")
    author = models.CharField(max_length=120)
    #Имя автора книги ("Стивен Кинг")
    style = models.CharField(max_length=120)
    #Жанр произведения ("Ужасы, утопия")
    desc = models.TextField()
    #Описание книги
    form = models.CharField(max_length=120)
    #Формат книги ("PDF", "Mobi")
    authorPhoto = models.CharField(max_length=120)
    #Фото автора
    book = models.CharField(max_length=120)
    #Книга
    uploader = models.CharField(max_length=120)
    #E-Mail загрузчика книги
    
    def __str__(self):
        return self.bookname
    
class User(models.Model):
    nickname = models.CharField(max_length=120)
    #Имя
    email = models.CharField(max_length=120, primary_key=True)
    #Электронная почта, уникальна
    password = models.CharField(max_length=120)
    #Пароль
    role = models.CharField(max_length=120, default="ROLE_USER")
    #Роль юзера
    
    def __str__(self):
        return self.email
    
class CheckMail(models.Model):
    email = models.CharField(max_length=120, primary_key=True)
    #Электронная почта, уникальна
    code = models.CharField(max_length=6)
    #Код
    
    def __str__(self):
        return self.email