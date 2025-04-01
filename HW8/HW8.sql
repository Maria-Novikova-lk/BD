--Домашнее задание
--Делаем физическую и логическую репликации

--Цель:
--Настраивать физическую и логическую репликации.


--Описание/Пошаговая инструкция выполнения домашнего задания:

--Физическая репликация:
--Весь стенд собирается в Docker образах или ВМ. Необходимо:
--Настроить физическую репликации между двумя кластерами базы данных
--Репликация должна работать использую "слот репликации"
--Реплика должна отставать от мастера на 5 минут

--Логическая репликация:
--В стенд добавить еще один кластер Postgresql. Необходимо:
--Создать на первом кластере базу данных, таблицу и наполнить ее данными (на ваше усмотрение)
--На нем же создать публикацию этой таблицы
--На новом кластере подписаться на эту публикацию
--Убедиться что она среплицировалась. Добавить записи в эту таблицу на основном сервере и убедиться, что они видны на логической реплике

hostname HOME-PC

1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 00:15:5d:05:c7:40 brd ff:ff:ff:ff:ff:ff
    inet 172.26.112.152/20 brd 172.26.127.255 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::215:5dff:fe05:c740/64 scope link
       valid_lft forever preferred_lft forever
       
       --main
       sudo pg_createcluster 17 phys_main -p 5441 && sudo pg_createcluster 17 phys_repl -p 5442
       sudo pg_ctlcluster 17 phys_main start && sudo pg_ctlcluster 17 phys_repl start

       sudo pg_ctlcluster 17 phys_main restart && sudo pg_ctlcluster 17 phys_repl restart
       
       sudo -u postgres psql -p 5441

       sudo nano /etc/postgresql/17/phys_main/postgresql.conf
       sudo nano /etc/postgresql/17/phys_main/pg_hba.conf
       
       sudo -u postgres psql -p 5441

       select pg_is_in_recovery();

       create database replica;
       select * from pg_create_physical_replication_slot('new_slot');

       sudo pg_ctlcluster 17 phys_main restart

       sudo -u postgres psql -p 5441

       --replica
       sudo -u postgres psql -p 5442
       sudo pg_ctlcluster 17 phys_repl stop
       sudo rm -rf /var/lib/postgresql/17/phys_repl

       --chown postgres:postgres -R /var/lib/postgresql/17/phys_repl
       sudo -u postgres pg_basebackup -h 127.0.0.1 -p 5441 -R -D /var/lib/postgresql/17/phys_repl -U replicator -W
       sudo pg_ctlcluster 17 phys_repl start
       sudo nano /etc/postgresql/17/phys_repl/postgresql.conf
       sudo pg_dropcluster 17 phys_main && sudo pg_dropcluster 17 phys_repl




       sudo -u postgres psql -p 5442
       sudo pg_ctlcluster 17 phys_repl stop
       sudo rm -rf /var/lib/postgresql/17/phys_repl/
       sudo -u postgres pg_basebackup -h 127.0.0.1 -p 5441 -R -D /var/lib/postgresql/17/phys_main -U postgres -W



       ==== Logical

       --main
       sudo pg_createcluster 17 logic_main -p 5450 && sudo pg_createcluster 17 logic_repl -p 5451
       sudo pg_ctlcluster 17 logic_main start && sudo pg_ctlcluster 17 logic_repl start

       sudo -u postgres psql -p 5450
       ALTER SYSTEM SET wal_level = logical;

       sudo pg_ctlcluster 17 logic_main restart
       CREATE PUBLICATION test_pub2 FOR TABLE test;

       --repl
       sudo pg_ctlcluster 17 logic_repl start;

       CREATE SUBSCRIPTION tmp_sub
       CONNECTION 'host=127.0.0.1 port=5450 user=postgres password=456852 dbname=replica' 
       PUBLICATION tmp_pub;

       sudo pg_dropcluster 17 logic_main --stop && sudo pg_dropcluster 17 logic_repl --stop
       