from python:3
add . .
EXPOSE 80
ENTRYPOINT ["python", " -m http.server" ]

