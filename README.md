# A Docker EasyAppointments image

## Usage

Note: you need to login to ghcr.io using your GitHub account:

```sh
docker login ghcr.io
```

```yml
version: "2.3"

services:
    easyappointments:
    image: ghcr.io/sudo-bot/docker-easyappointments/docker-easyappointments:latest
    environment:
        BASE_URL: http://easyappointments
        DB_HOST: mariadb.local
        DB_NAME: easyappointments
        DB_USERNAME: easyappointments
        DB_PASSWORD: easyappointments
        # DEBUG_MODE: true
    healthcheck:
        test:
        [
            "CMD",
            "curl",
            "-s",
            "--fail",
            "http://127.0.0.1/.nginx/status",
                ]
        start_period: 5s
        interval: 15s
        timeout: 1s
    networks:
        # The network where mariadb.local resolves to an IP
        mynetwork:
    ports:
        - "127.0.0.36:80:80"
```
