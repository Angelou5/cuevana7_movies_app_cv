FROM ghcr.io/cirruslabs/flutter:3.44.0

USER root

WORKDIR /app_cuevana7_movies_app_cv

COPY . .

RUN chmod -R 777 /app_cuevana7_movies_app_cv

RUN git config --global --add safe.directory '*'

RUN flutter pub get 

CMD ["dart", "run", "lib/start_server.dart"]

