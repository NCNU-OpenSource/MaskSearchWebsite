FROM python:3.6
ENV PYTHONUNBUFFERED 1
LABEL maintainer vincentinttsh
RUN mkdir /run_data
RUN mkdir /api_data
RUN mkdir /log
WORKDIR /api_data
COPY ./api /api_data
RUN pip install -r requirements.txt
ENTRYPOINT [ "python", "./main.py" ]
EXPOSE 8080