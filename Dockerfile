FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

RUN useradd -m appuser
USER appuser

EXPOSE 8000
HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
  CMD python -c "import http.client as h;c=h.HTTPConnection('127.0.0.1',8000,timeout=2);c.request('GET','/health');r=c.getresponse();exit(0 if r.status==200 else 1)"

CMD ["python", "app.py"]

