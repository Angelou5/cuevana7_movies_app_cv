FROM ghcr.io/cirruslabs/flutter:3.44.0

USER root

WORKDIR /app_cuevana7_movies_app_cv

COPY . .

RUN chmod -R 777 /app_cuevana7_movies_app_cv

RUN git config --global --add safe.directory '*'

RUN flutter pub get 

RUN flutter build apk --release

CMD ["echo", "Apk en: build/app/outputs/flutter-apk/app-release.apk"]