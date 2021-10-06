FROM python:3
COPY app /app
COPY data.db /data.db
COPY requirements.txt /requirements.txt
RUN pip install -r /requirements.txt
CMD ["python", "/app/main.py"]
