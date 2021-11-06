#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import requests
import datetime
import os

from urllib import parse
import psycopg2

class BotHandler:

    def __init__(self, token):
        self.token = token
        self.api_url = "https://api.telegram.org/bot{}/".format(token)

    def get_updates(self, offset=None, timeout=5):
        method = 'getUpdates'
        params = {'timeout': timeout, 'offset': offset}
        resp = requests.get(self.api_url + method, params)
        result_json = resp.json()['result']
        return result_json

    def send_message(self, chat_id, text):
        params = {'chat_id': chat_id, 'text': text}
        method = 'sendMessage'
        resp = requests.post(self.api_url + method, params)
        return resp

    def send_audio(self, chat_id, filename):
        af = open(filename, 'rb')

#        aud = open('statimg/firsta.mp3')
#        output = StringIO.StringIO()
#        aud.save(output, 'MP3')
#        reply(aud=output.getvalue())



        params = {'chat_id': chat_id, 'audio' : ('Аудиозапись к уроку', af)}
        method = 'sendAudio'
        resp = requests.post(self.api_url + method, params)
        af.close()
        return resp


    def get_last_update(self):
        get_result = self.get_updates()

        if len(get_result) > 0:
            last_update = get_result[-1]
        else:
            last_update = None

        return last_update

token = "519115229:AAGIQaNoA3klOsfmnWIIF_AAHvT9Atr2uWo"

admin_chat_id = 448045688


greet_bot = BotHandler(token)
greetings = ('здравствуй', 'привет', 'здорово', 'добрый', 'доброе', 'доброго', 'hi', '/start')
goodbye = ('пока', 'чао')

answ = False

now = datetime.datetime.now()


def answered(user, id):
    greet_bot.send_message(admin_chat_id, "--- " + user + " : === Answered" + '\n')


def start(user, id):
#    greet_bot.send_message(admin_chat_id, "--- " + user + " : === Answered" + '\n')

    sql1 = """INSERT INTO chatuser(uid, name) VALUES(%s, %s);"""
    sql2 = """INSERT INTO userstate(uid, lesson) VALUES(%s, %s);"""
    parse.uses_netloc.append("postgres")
    url = parse.urlparse(os.environ["DATABASE_URL"])

    conn = psycopg2.connect(
        database=url.path[1:],
        user=url.username,
        password=url.password,
        host=url.hostname,
        port=url.port
    )

    cur = conn.cursor()
    try:
        cur.execute(sql1, (id, user))
        conn.commit()
    except:
        pass

    cur.close()
    conn.close()


    conn = psycopg2.connect(
        database=url.path[1:],
        user=url.username,
        password=url.password,
        host=url.hostname,
        port=url.port
    )

    cur = conn.cursor()
    try:
        cur.execute(sql2, (id, 0))
        conn.commit()
    except:
        pass
    cur.close()
    conn.close()


def inctement(user, id):
    sql = "SELECT lesson FROM userstate WHERE uid = " + str(id) + ";"
    parse.uses_netloc.append("postgres")
    url = parse.urlparse(os.environ["DATABASE_URL"])

    conn = psycopg2.connect(
        database=url.path[1:],
        user=url.username,
        password=url.password,
        host=url.hostname,
        port=url.port
    )
    cur = conn.cursor()

    try:
        cur.execute(sql)
        result = cur.fetchall()
        lesson = int(result[0][0])
    except:
        pass
    cur.close()
    conn.close()

    sql = "UPDATE userstate SET lesson = lesson + 1 WHERE uid = " + str(id) + ";"
    parse.uses_netloc.append("postgres")
    url = parse.urlparse(os.environ["DATABASE_URL"])

    conn = psycopg2.connect(
        database=url.path[1:],
        user=url.username,
        password=url.password,
        host=url.hostname,
        port=url.port
    )
    cur = conn.cursor()
    try:
        cur.execute(sql)
        conn.commit()
    except:
        pass
    cur.close()
    conn.close()

    lesson = lesson + 1

    sql = "SELECT lessontext FROM lessonmsg WHERE lesson = " + str(lesson) + ";"
    parse.uses_netloc.append("postgres")
    url = parse.urlparse(os.environ["DATABASE_URL"])

    conn = psycopg2.connect(
        database=url.path[1:],
        user=url.username,
        password=url.password,
        host=url.hostname,
        port=url.port
    )
    cur = conn.cursor()

    try:
        cur.execute(sql)
        result = cur.fetchall()
        lessontext = format(result[0][0])
        lessontext = lessontext.replace("Username", user)
        lessontext = lessontext.replace('\n', '\n\n')
        greet_bot.send_message(id, lessontext)
        greet_bot.send_message(admin_chat_id, user + " lesson " + str(lesson))
    except:
        pass
    cur.close()
    conn.close()


    sql = "SELECT filename FROM lessonmsg WHERE lesson = " + str(lesson) + ";"
    parse.uses_netloc.append("postgres")
    url = parse.urlparse(os.environ["DATABASE_URL"])

    conn = psycopg2.connect(
        database=url.path[1:],
        user=url.username,
        password=url.password,
        host=url.hostname,
        port=url.port
    )
    cur = conn.cursor()

    try:
        cur.execute(sql)
        result = cur.fetchall()
        filename = format(result[0][0])
        if filename != "":
#            greet_bot.send_message(id, filename)
            greet_bot.send_message(admin_chat_id, user + " filename " + filename)
            greet_bot.send_audio(admin_chat_id, filename)
    except:
        pass
    cur.close()
    conn.close()


def main():
    new_offset = None
    today = now.day
    hour = now.hour

    while True:
        answ = False

        greet_bot.get_updates(new_offset)

        last_update = greet_bot.get_last_update()
        if not last_update:
#            new_offset = last_update_id + 1
            continue

        last_update_id = last_update['update_id']

        try:
            last_chat_text = last_update['message']['text']
        except:
            last_chat_text = " "

        try:
            last_chat_id = last_update['message']['chat']['id']
        except:
            new_offset = last_update_id + 1
            continue

        try:
            last_chat_name = last_update['message']['chat']['first_name']
        except:
            last_chat_name = "Всем"
# ----------------------------------------------
            new_offset = last_update_id + 1
            continue
# ----------------------------------------------


        if last_chat_name == "Всем" and last_chat_text.lower().find("анести") == -1 and last_chat_text.lower().find("anesti") == -1:
            new_offset = last_update_id + 1
            continue

#        greet_bot.send_message(admin_chat_id, "New update!" + '\n')

        Iam = "! Меня зовут Анести. Я помогу улучшить возможности Вашего голоса. " + \
             "\n\n" + \
             "Я буду использовать материалы Интернет-Курса ""ВОЗРОЖДЕНИЕ ПРИРОДНОГО ГОЛОСА"" от школы " + \
             "www.goloslogos.ru | www.golosobraz.ru | www.kirilltv.ru " + \
             "\n\n" + \
             "автор: Кирилл Плешаков-Качалин" + \
             "\n\n" + \
             "Кроме того, будут материалы из других источников, которые я укажу по мере необходимости."

        if last_chat_id != admin_chat_id:
            greet_bot.send_message(admin_chat_id, "--- " + last_chat_name + " : " + last_chat_text + '\n')

        t = -1
        for s in greetings:
            t = last_chat_text.lower().find(s)
            if t != -1:
                if today == now.day and 6 <= hour < 12:
                    greet_bot.send_message(last_chat_id, 'Доброе утро, {}'.format(last_chat_name) + Iam)
        ##            today += 1

                elif today == now.day and 12 <= hour < 17:
                    greet_bot.send_message(last_chat_id, 'Добрый день, {}'.format(last_chat_name) + Iam)
        ##            today += 1

                elif today == now.day and 17 <= hour < 23:
                    greet_bot.send_message(last_chat_id, 'Добрый вечер, {}'.format(last_chat_name) + Iam)
        ##            today += 1
                start(last_chat_name, last_chat_id)
                answered(last_chat_name, last_chat_id)
                answ = True
                break

        if last_chat_text.lower().find("палочки") != -1 or last_chat_text.lower().find("палки") != -1:
            greet_bot.send_message(last_chat_id, "Не волшебник выбирает палочки, а палочки выбирают волшебника. " + \
            "Возьмите для начала в руки палочки 5B. Они Вам понравятся. А Вы им. Есть еще конечно 5A, толстые 2A и B, тонкие 7A и B. " +\
             "Но их Вы попробуете в следующий раз, когда захотите экспериментов. " + \
             "Обратите внимание на наконечник. Нейлоновый наконечник дает более звонкий звук, но профи такими не играют.")
            answered(last_chat_name, last_chat_id)
            answ = True

        if last_chat_text.lower().find("репет") != -1 or last_chat_text.lower().find("баз") != -1:
            greet_bot.send_message(last_chat_id, "Не важно, где Вы репетируете, если Вы делаете это регулярно. " + \
            "Иногда удаётся поупражняться в школе на электронных барабанах за 100р в час или бить в акустические по 300, " + \
             "радуя своими успехами учеников в соседних классах. Если всё занято можно пойти в LikeStudio " + \
             "недалеко от школы или не побояться спуститься в подземелье UnderTheGround. Хотя и Hendrix Studio неплох. ")
            greet_bot.send_message(last_chat_id, \
             "Недавно ребята своими силами создали собственную реп.базу DRUM POINT GROOVE - Текстильщики - Волгоградский проспект 42,  корп. 7" + \
             "\n\n" + \
             "DRUM POINT GROOVE - здесь живёт  музыка!!!  Профессиональный уровень,  отличный звук,  возможность записи демо " + \
             "аудио и видео ваших музыкальных композиций! Уютная обстановка и позитивный настрой гарантированы!" + \
             "\n\n" + \
             "Контакты :" + \
             "\n\n" + \
             "+7916-505-02-35 June Chi\n" + \
             "+7926-892-62-66 Евгений Ермоленко\n" + \
             "+7903-515-99-88 Константин Пророков\n" + \
             "+7977-886-60-20 Максим Сергеев\n" + \
             "+7985-396-03-56 Алексей Успанов\n" + \
             "+7967-129-82-04 Даниил Гривков\n" + \
             "+7917-522-76-69 Анастасия Кузнецова")
            greet_bot.send_message(last_chat_id, \
             "Я конечно бот, но будь я человеком я обошел бы все эти десятки репетиционных баз в городе, чтобы в " + \
             "каждой из них улучшить своё мастерство: " + \
            "\n\n" + \
            "http://musbooking.com/" + \
            "\n\n" + \
            "http://www.repal.ru/repbase/moscow/" + \
            "\n\n" + \
            "http://lmgtfy.com/?q=%D1%80%D0%B5%D0%BF%D0%B1%D0%B0%D0%B7%D1%8B")
            answered(last_chat_name, last_chat_id)
            answ = True

        if last_chat_text.lower().find("пэд") != -1:
            greet_bot.send_message(last_chat_id, "Пэды очень важны в жизни барабанщика особенно в периоды долгой разлуки с барабанами. " + \
            "Обязательно купите хотя бы один!" + \
            "\n\n" + \
            "Самая важная часть пэда это ударная поверхность, она бывает из резины, силикона, песка, " + \
            "или кевларового пластика. Выбор поверхности зависит от Вашего вкуса и возможностей " + \
            "репетиционной комнаты или помещения — насколько тонкие стены, насколько добрые соседи, " + \
             "насколько Вашу бесконечную хаотичную «долбежку» любят Ваши родственники и т.д. Нужно " + \
             "помнить о том, что ударные это в любом случае удар, а удар просто по природе не может быть тихим." + \
             "\n\n" + \
             "В любом случае перед приобретением тренировочного пэда попробуйте поиграть и оценить " + \
             "все разновидности и только после этого вы найдете то что по душе." + \
             "\n\n" + \
             "Все познается в сравнении")
            answered(last_chat_name, last_chat_id)
            answ = True


        if last_chat_text.lower().find("ноты") != -1:
            greet_bot.send_message(last_chat_id, "Меня часто спрашивают, где взять ноты популярных песен. Да в этих же Ваших интернетах. " + \
            "И там уж как повезёт. Есть вот сайт: " + \
            "https://www.songsterr.com/a/wsa/metallica-nothing-else-matters-tab-s439171t8" + \
             "\n\n" + \
             "Но нужно быть осторожным, бывают ошибки. " + \
             "\n\n" + \
             "Продвинутые музыканты ставят себе на комп программу GuitarPro (не спрашивайте меня сколько она стоит), качают gtp-файлики и радуются жизни.")

#            bot.send_photo(chat_id=chat_id, photo=open('tests/test.png', 'rb'))

            answered(last_chat_name, last_chat_id)
            answ = True


        if last_chat_text.lower().find("концерт") != -1:
            greet_bot.send_message(last_chat_id, "Каждую неделю ученики школы играют отчетный концерт в клубе Афиша - " + \
            "Комсомольская площадь, 6с1: http://afishaclub.ru/kontaktyi/ " + \
            "Это просто Огооонь! Вход бесплатный! Приводите друзей, для них тоже!")
            answered(last_chat_name, last_chat_id)
            answ = True

        if last_chat_text.lower().find("барабан") != -1:
            greet_bot.send_message(last_chat_id, "Барабаны это круто! Учитесь играть на барабанах в школе Party-Уроки!!!")
            answered(last_chat_name, last_chat_id)
            answ = True


        if last_chat_text.lower() in goodbye :
            greet_bot.send_message(last_chat_id, 'Рад был помочь. Приходите еще, {}'.format(last_chat_name))
            answered(last_chat_name, last_chat_id)
            answ = True

        if last_chat_text.lower().find("/next") != -1 or last_chat_text.lower().find("далее") != -1:
            inctement(last_chat_name, last_chat_id)
            answ = True


        new_offset = last_update_id + 1


#        if not answ:
#            try:
#                forismatic_resp = requests.get("http://api.forismatic.com/api/1.0/?method=getQuote&format=json&lang=ru")
#                forismatic_result_json = forismatic_resp.json()
#                greet_bot.send_message(admin_chat_id, "--- " + last_chat_name + " : " + forismatic_result_json['quoteText'] + "\n" + forismatic_result_json['quoteAuthor'] + '\n')
#                greet_bot.send_message(last_chat_id, forismatic_result_json['quoteText'] + "\n" + forismatic_result_json['quoteAuthor'] + '\n')
#            except:
#                greet_bot.send_message(admin_chat_id, "--- " + last_chat_name + " : NA \n")      



if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        exit()

