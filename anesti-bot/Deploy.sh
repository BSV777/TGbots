#heroku login
git add .
git commit -m "added some files"
git push heroku master
#heroku ps:scale web=0
heroku config:add TZ="Europe/Moscow"
heroku ps:scale worker=1
sleep 5s
heroku logs | tail -n 3
