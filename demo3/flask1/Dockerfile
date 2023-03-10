FROM python
ADD ./app /application
WORKDIR /application
RUN	pip install -r /application/requirements.txt
EXPOSE 5000
VOLUME /application
CMD uwsgi --http :5000  --manage-script-name --mount /myapplication=flask_app:app --enable-threads --processes 5
