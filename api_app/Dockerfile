FROM python:3.12.2-slim-bookworm

RUN groupadd -r akrish && useradd -r -g akrish akrish

# RUN apt update && \
#     apt upgrade -y && \
#     rm -rf /var/lib/apt/lists/*

WORKDIR /home/akrish
COPY /app_dir ./app
RUN pip install --no-cache-dir -r app/requirements.txt && \
    chown -R akrish:akrish /home/akrish

USER akrish
EXPOSE 5000

CMD ["python", "app/main.py"]
