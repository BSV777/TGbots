#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import requests

token = "519115229:AAGIQaNoA3klOsfmnWIIF_AAHvT9Atr2uWo"
admin_chat_id = 448045688
api_url = "https://api.telegram.org/bot{}/".format(token)

af = open("55.mp3", 'rb').read()
print(len(af))
#method = 'sendAudio'
#params = {'chat_id': admin_chat_id, 'audio' : "4.mp3"}


#method = 'sendAudio'
#params = {'chat_id': admin_chat_id, 'audio' : (" ", af), 'file_id' : "file"}


#files = {'photo': open('/home/sbaykov/Desktop/heroku/abc.jpg', 'rb')}
#data = {'chat_id' : admin_chat_id}
#resp= requests.post(api_url, files=files, data=data)

method = 'sendAudio'

#method = 'sendMessage'
params = {'chat_id': admin_chat_id, 'audio' : (" ", af), "Content-Type": 'audio/x-mpeg-3'}

#headers = {"Content-Type": 'audio/x-mpeg-3'}
#data = open('55.mp3', 'rb')
#data = open('55.mp3', 'rb').read()
#resp = requests.post(api_url + method, headers=headers, data=data)



#method = 'sendFile'
#params = {'chat_id': admin_chat_id, 'file_name': "4.mp3"}

#file=open("/home/sbaykov/Desktop/heroku/anesti-bot/mp3/4.mp3", 'rb')


resp = requests.post(api_url + method, params)

#af.close()
print(resp)
print(resp.status_code, resp.reason, resp.content)
