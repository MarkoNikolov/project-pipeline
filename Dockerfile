#for smaller image

FROM python:3.11-alpine as base
FROM base as builder

COPY requirements.txt /requirements.txt
RUN pip install --user -r /requirements.txt


FROM base

COPY --from=builder /root/.local /root/.local
COPY . /app
WORKDIR /app

ENV PATH=/root/.local/bin:$PATH

CMD ["python","app.py"]