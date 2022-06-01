# TODO

- [TODO](#todo)
  - [TODO List](#todo-list)
  - [Templates](#templates)
    - [EGE TEMPLATE. PPE. AVS](#ege-template-ppe-avs)
      - [Item. AVS Stream](#item-avs-stream)
      - [Item. AVS Stream Record](#item-avs-stream-record)
  - [Scripts](#scripts)
    - [Docker Start](#docker-start)
    - [Docker Stop](#docker-stop)
    - [Docker restart](#docker-restart)
    - [AVS Media Clean](#avs-media-clean)
    - [AVS RestartFailedRecord](#avs-restartfailedrecord)
    - [IP-cam Full Configure](#ip-cam-full-configure)
    - [Chrome Restart](#chrome-restart)
    - [Reboot](#reboot)
    - [Switch PoE disable](#switch-poe-disable)
    - [Switch PoE enable](#switch-poe-enable)

## TODO List

дло

## Templates

### EGE TEMPLATE. PPE. AVS

#### Item. AVS Stream

`logrt[/opt/mcs/var/log/avs/avs__cam__status.log, ERROR|WARNING|CRITICAL|OK]`

Triggers:

1. AVS Stream: AVS Server is not responsible!!!
2. AVS Stream: Camera status is not responsible!!!
3. AVS Stream: Examing. Camera is not in AVS config!!!
4. AVS Stream: Examing. Interface. Broadcasting is not running!!!
5. AVS Stream: Examing. Interface. Camera is not running!!!
6. AVS Stream: Examing. Interface. Recording is not running!!!
7. AVS Stream: Examing. Stream. Broadcasting could not start running!!!
8. AVS Stream: Examing. Stream. Camera could not Start running!!!
9. AVS Stream: Examing. Stream. Recording could not start running!!!
10. AVS Stream: Monitoring. Camera is not in AVS config!!!
11. AVS Stream: Monitoring. Interface. Broadcasting is not running!!!
12. AVS Stream: Monitoring. Interface. Camera is not running!!!
13. AVS Stream: Monitoring. Stream. Broadcasting could not start running!!!
14. AVS Stream: Monitoring. Stream. Camera could not Start running!!!
15. AVS Stream: Monitoring. Stream. Recording could not start running!!!

#### Item. AVS Stream Record

`logrt[/opt/mcs/var/log/avs/avs__rec__status.log,ERROR|WARNING|CRITICAL|INFO]`

Triggers:

1. AVS Stream: Monitoring. Stream. Recording could not start running!!!
2. AVS Stream Record: Examing. The previous 'Stream Rec Info' is absent!!!
3. AVS Stream Record: Examing. The Stream is decreasing!!!
4. AVS Stream Record: Examing. The Stream is not recording now!!!
5. AVS Stream Record: Examing. The Stream possible not stable now!!!
6. AVS Stream Record: Monitoring. The previous 'Rec' data is absent, new created!!!
7. AVS Stream Record: Monitoring. The previous 'Stream Rec Info' is absent!!!
8. AVS Stream Record: Monitoring. The Stream is decreasing!!!
9. AVS Stream Record: Monitoring. The Stream is not recording now!!!
10. AVS Stream Record: Unexpected error in 'Stream Record Info'!!!

## Scripts

### Docker Start

```sh
cd /opt/avs && sudo docker-compose up -d
```

### Docker Stop

```sh
cd /opt/avs && sudo docker rm -f `sudo docker ps -qa` && sudo docker-compose up -d
```

### Docker restart

```sh
cd /opt/avs && sudo docker rm -f `sudo docker ps -qa` && sudo docker-compose up -d
```

### AVS Media Clean

```sh
sudo rm -rf /opt/avs/media/*
```

### AVS RestartFailedRecord

```sh
sudo /opt/msc/bin/avs/avs__rec__restart_fail.py
```

### IP-cam Full Configure

```sh
sudo /opt/mcs/bin/cam/cam__cfg.py
```

### Chrome Restart

```sh
sudo ps -aux | grep chrom | awk '{print $2'} | sudo xargs kill -9
```

### Reboot

```sh
sudo reboot
```

### Switch PoE disable

```sh
sudo /opt/mcs/bin/net/net__switch_poe__control.py --poe=off
```

### Switch PoE enable

```sh
sudo /opt/mcs/bin/net/net__switch_poe__control.py --poe=on
```
