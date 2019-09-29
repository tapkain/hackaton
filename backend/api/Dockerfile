FROM python:3.7.3

WORKDIR /newlife

COPY ./requirements.txt requirements.txt
RUN pip install -r requirements.txt

RUN apt-get update && apt-get install -y supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

COPY ./endpoint endpoint
COPY ./model model
COPY ./repository repository
COPY ./serializer serializer
COPY ./validation validation
COPY ./app.py app.py
COPY ./context.py context.py


CMD ["supervisord", "-n"]