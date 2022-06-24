FROM python:3.10-slim
WORKDIR /app/

COPY requirements.txt ./
RUN pip install -r requirements.txt
COPY ./ /app/

EXPOSE 80 

CMD [ "gunicorn", "-b", "0.0.0.0:80", "app:app", "--timeout", "600" ]