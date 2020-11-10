#!/bin/bash

user=dolphin

echo "[Unit]" > /etc/init.d/DolphinSE.service
echo "Description=DolphinSE" >> /etc/init.d/DolphinSE.service
echo "[Service]" >> /etc/init.d/DolphinSE.service
echo "ExecStart=/opt/DolphinSE" >> /etc/init.d/DolphinSE.service
echo "Restart=on-failure" >> /etc/init.d/DolphinSE.service
echo "[Install]" >> /etc/init.d/DolphinSE.service
echo "WantedBy=multi-user.target" >> /etc/init.d/DolphinSE.service

systemctl enable /etc/init.d/DolphinSE.service
service DolphinSE start