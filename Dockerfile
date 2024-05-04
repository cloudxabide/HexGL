from python:latest
add . .
EXPOSE 8080
#ENTRYPOINT ["python", " -m http.server" ]
CMD python -m http.server 8080
