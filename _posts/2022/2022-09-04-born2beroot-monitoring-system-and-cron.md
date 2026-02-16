---
title: "[Born2beroot] 7. 시스템 정보 출력(monitoring.sh)과 cron"
date: 2022-09-04 22:50:00 +0900
categories: [l42seoul]
tags: [born2beroot]
use_math: true
---

# monitoring.sh

과제에서는 가상머신 실행 후 10분마다 터미널에 다음과 같은 정보를 출력할 것을 요구하고 있다.

```bash
1. 운영 체제의 아키텍처 및 커널 버전
2. 물리적 프로세서의 수
3. 가상 프로세서 수
4. 서버의 현재 사용 가능한 RAM과 활용률
5. 서버의 현재 가용 메모리와 활용률
6. 프로세서의 현재 활용률
7. 마지막으로 재부팅한 날짜 및 시간
8. LVM의 활성 여부
9. 활성 연결 수
10. 서버를 사용하는 사용자 수
11. 서버의 IPv4 주소와 MAC(Media Access Control) 주소
12. sudo 프로그램으로 실행된 명령의 수
```

## 스크립트 내용

```bash
printf "#Architecture: "
uname -a

printf "#CPU physical : "
nproc --all

printf "#vCPU : "
cat /proc/cpuinfo | grep processor | wc -l

printf "#Memory Usage: "
free -m | grep Mem | awk '{printf"%d/%dMB (%.2f%%)\n", $3, $2, $3/$2 * 100}'

printf "#Disk Usage: "
df -a -BM | grep /dev/map | awk '{sum+=$3}END{print sum}' | tr -d '\n'
printf "/"
df -a -BM | grep /dev/map | awk '{sum+=$4}END{print sum}' | tr -d '\n'
printf "MB ("
df -a -BM | grep /dev/map | awk '{sum1+=$3 ; sum2+=$4 }END{printf "%d", sum1 / sum2 * 100}' | tr -d '\n'
printf "%%)\n"

printf "#CPU load: "
mpstat | grep all | awk '{printf "%.2f%%\n", 100-$13}'

printf "#Last boot: "
who -b | awk '{printf $3" "$4"\n"}'

printf "#LVM use: "
if [ "$(lsblk | grep lvm | wc -l)" -gt 0 ] ; then printf "yes\n" ; else printf "no\n" ; fi

printf "#Connections TCP : "
ss | grep -i tcp | wc -l | tr -d '\n'
printf " ESTABLISHED\n"

printf "#User log: "
who | wc -l

printf "#Network: IP "
hostname -I | tr -d '\n'
printf "("
ip link | awk '$1 == "link/ether" {print $2}' | sed '2, $d' | tr -d '\n'
printf ")\n"

printf "#Sudo : "
journalctl _COMM=sudo | wc -l | tr -d '\n'
printf " cmd\n"
```

위의 내용을 편하게 복사해서 붙여넣으려면 로컬 컴퓨터에서 ssh 로 가상머신에 접속하면 된다.

## 명령어 분석

### 1. 운영체제의 아키텍쳐와 커널 버전

`uname` 명령어는 시스템 정보를 출력하는 명령어이다.

`-a` 옵션(all)을 사용하면 운영체제의 아키텍쳐와 커널 버전까지 모두 출력할 수 있다.

### 2. 프로세서 개수

CPU는 크게 3가지 주요 용어로 설명할 수 있다.

- Processor : 메인보드 소켓에 장착되는 물리적인 칩을 의미한다. CPU와 동일한 의미로 사용되고 있다. 하나의 프로세서에는 다수의 Core 가 존재할 수 있다.
- Core : 각종 연산을 수행하는 핵심 요소이다. 하나의 코어에는 다수의 Hardware thread 가 존재할 수 있다. (일꾼)
- Hardware thread : 하나의 코어 안에서 실질적으로 연산을 수행하는 논리적인 작업이다. (일꾼의 손)

그림으로 살펴보면 다음과 같다.

![processor](/assets/images/2022/2022-09-04-born2beroot-monitoring-system-and-cron/processor.jpeg)

출처: [링크드인](https://www.linkedin.com/pulse/understanding-physical-logical-cpus-akshay-deshpande/)

왼쪽의 그림은 물리적인 프로세서와 내부 구조를 표현한 것이고, 오른쪽의 그림은 실제 운영체제에서 인식하는 논리적인 프로세서(logical processor)의 개수를 의미한다.

위의 그림을 수치로 표현하면 1 Processor, 4 Physical core, 8 Logical core 가 있는 것이다.

과제에서 요구하는 물리적 프로세서(Physical processor)가 의미하는 바는 물리적인 CPU의 개수(프로세서)를 의미하는 것이다.

```bash
# 설치된 모든 프로세서의 개수를 표시
nproc --all
```

그 다음 가상 프로세서(virtual processor)는 가상 머신에 할당되는 프로세서를 의미한다. 가상 머신을 실행하면 로컬 컴퓨터의 RAM, 하드 디스크, 네트워크 일부를 가상 머신에 할당해서 사용하는 것인데, CPU도 일부 할당해서 주는 것이다.

```bash
# CPU 정보를 담고 있는 파일에서 프로세서의 개수 세기
# wc -l 는 개행문자를 기준으로 몇 개의 줄이 있는지 센다.
cat /proc/cpuinfo | grep processor | wc -l
```

`/proc/cpuinfo` 는 CPU 정보를 담고 있는 파일인데, 만약 2개의 프로세서가 존재한다면 다음과 같이 표시된다. (프로세서는 0번부터 시작)

```bash
joonhan@joonhan42:~$ cat /proc/cpuinfo | grep processor
processor       : 0
processor       : 1
```

### 3. 사용가능한 RAM 및 사용률

RAM이란 Random Access Memory 의 약자로 사용자가 자유롭게 내용을 읽고 쓰고 지울 수 있는 기억장치이다. 컴퓨터가 켜지는 순간부터 부팅에 필요한 프로그램을 RAM에 적재한다.

비유하자면, 마트에서 생선을 사와서 냉장고(하드 디스크)에 보관하고, 요리할 때는 싱크대(RAM)에서 하는 것과 같다. 그래서 하드 디스크를 보조 기억 장치, RAM을 주기억 장치라고 한다.

Random Access 라는 말은 어느 위치든 똑같은 속도로 접근하여 읽고 쓸 수 있다는 의미이며, 하드 디스크처럼 데이터의 물리적 위치에 따라 읽고 쓰는 시간의 차이가 발생하는 기억장치들은 Direct Access Memory 라 한다.

```bash
free
```

`free` 명령어는 리눅스 시스템에서 메모리의 전체적인 현황을 표시하는 명령어이다. 실행하면 다음과 같이 출력된다.

```bash
							total        used        free      shared  buff/cache   available
Mem:          999900       79752      696536         588      223612      779948
Swap:         974844           0      974844
```

각 항목에 대한 설명은 다음과 같다.

- `total` : 전체 메모리 용량
- `used` : 사용되고 있는 메모리 용량
- `free` : 사용되지 않는 메모리 용량
- `shared` : 임시 파일 스토리지인 tmpfs(Temporary File Storage) 이 사용하는 공간으로, 파일을 임시로 저장했다가 지울 수 있는 공간을 의미한다.
- `buff/cache` : 커널의 버퍼와 캐시(동적 할당)로 사용하는 공간

여기서 `Swap` 메모리는 RAM에 공간이 없을 경우 예비로 사용하는 메모리 공간이다. 실제로는 하드 디스크의 공간 일부를 사용하기 때문에 가상 메모리 개념에 가깝다. 속도는 실제 RAM 이 아닌 하드디스크를 이용하기 때문에 현저히 떨어진다. `Swap` 메모리의 반대 개념으로는 램을 하드 디스크처럼 사용하는 램 디스크가 있다.

```bash
# -m : MB 단위로 출력
free -m | grep Mem | awk '{printf"%d/%dMB (%.2f%%)\n", $3, $2, $3/$2 * 100}'
```

`awk` 명령어는 데이터를 가공해서 출력하기 위한 명령어이다.

- `{ action }` : action 으로 입력한 명령어를 실행한다.
- `$N` : 0은 전체 열, 1부터는 첫 번째 열에 대응한다. (공백문자를 기준으로 구분)
  ```bash
  free -m | grep Mem | awk '{ print $0 }'
  Mem:             976          78         679           0         218         761
  free -m | grep Mem | awk '{ print $1 }'
  Mem:
  free -m | grep Mem | awk '{ print $2 }'
  976
  ```

### 4. 가용 메모리

가용 메모리는 사용 가능한 하드 디스크의 용량을 의미한다.

`df` 명령어는 하드 디스크의 저장 공간 현황을 보여주는 명령어다.

```bash
# -a  : 전체 디스크 보여줌
# -BM : Block size 를 MB 단위로 표시함
df -a -BM
```

실행 결과는 다음과 같다.

```bash
Filesystem                    1M-blocks  Used Available Use% Mounted on
sysfs                                0M    0M        0M    - /sys
proc                                 0M    0M        0M    - /proc
udev                               471M    0M      471M   0% /dev
devpts                               0M    0M        0M    - /dev/pts
tmpfs                               98M    1M       98M   1% /run
/dev/mapper/LVMGroup-root         1837M 1163M      563M  68% /
securityfs                           0M    0M        0M    - /sys/kernel/security
tmpfs                              489M    0M      489M   0% /dev/shm
tmpfs                                5M    0M        5M   0% /run/lock
cgroup2                              0M    0M        0M    - /sys/fs/cgroup
pstore                               0M    0M        0M    - /sys/fs/pstore
none                                 0M    0M        0M    - /sys/fs/bpf
systemd-1                             -     -         -    - /proc/sys/fs/binfmt_misc
debugfs                              0M    0M        0M    - /sys/kernel/debug
mqueue                               0M    0M        0M    - /dev/mqueue
hugetlbfs                            0M    0M        0M    - /dev/hugepages
tracefs                              0M    0M        0M    - /sys/kernel/tracing
configfs                             0M    0M        0M    - /sys/kernel/config
fusectl                              0M    0M        0M    - /sys/fs/fuse/connections
/dev/sda1                          451M   86M      338M  21% /boot
/dev/mapper/LVMGroup-srv           919M    1M      856M   1% /srv
/dev/mapper/LVMGroup-home          919M    1M      856M   1% /home
/dev/mapper/LVMGroup-tmp           919M    1M      856M   1% /tmp
/dev/mapper/LVMGroup-var           919M  210M      646M  25% /var
/dev/mapper/LVMGroup-var--log      982M   75M      840M   9% /var/log
tmpfs                               98M    0M       98M   0% /run/user/1000
binfmt_misc                          0M    0M        0M    - /proc/sys/fs/binfmt_misc
```

```bash
awk '{ sum += $3 }END{ print sum }'
```

3번째 열에 있는 모든 값을 `sum` 이라는 변수에 모두 더한 다음, `sum` 의 값을 출력한다.

```bash
tr -d '\n'
```

개행 문자를 삭제한다.

### 5. 프로세서 사용률

프로세서(CPU)의 사용 가능 용량과 Core 별 사용량을 출력하는 명령어는 `mpstat` 이다. 이 명령어를 사용하기 위해서는 `sysstat` 설치가 필요하다.

`sysstat` 은 리눅스에서 자원에 대한 모니터링을 도와주는 프로그램이다.

```bash
sudo apt install sysstat
```

`mpstat` 실행 결과는 다음과 같다.

```bash
Linux 5.10.0-16-amd64 (joonhan42) 	07/19/2022 	_x86_64_	(1 CPU)

03:13:20 PM  CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest  %gnice   %idle
03:13:20 PM  all    0.03    0.00    0.06    0.02    0.00    0.19    0.00    0.00    0.00   99.69
```

`%idle` 은 cpu 사용량의 남은 용량을 의미하므로 100 에서 해당 값을 빼면 현재 사용량을 구할 수 있다.

### 6. 마지막 부팅 시간과 날짜

`last` 명령어는 사용자가 언제 마지막으로 로그인하고 부팅을 종료했는지 보여주는 명령어이다. 실행 결과는 다음과 같다.

```bash
joonhan  pts/0        10.0.2.2         Tue Jul 19 13:57   still logged in
joonhan  pts/0        10.0.2.2         Mon Jul 18 14:16 - 11:05  (20:48)
joonhan  pts/0        10.0.2.2         Mon Jul 18 13:03 - 13:05  (00:02)
joonhan  pts/0        10.0.2.2         Mon Jul 18 12:59 - 13:03  (00:03)
joonhan  tty1                          Mon Jul 18 12:49    gone - no logout
reboot   system boot  5.10.0-16-amd64  Mon Jul 18 12:48   still running
joonhan  tty1                          Tue Jul 12 17:16 - crash (5+19:32)
reboot   system boot  5.10.0-16-amd64  Tue Jul 12 17:16   still running
joonhan  tty1                          Tue Jul 12 17:14 - crash  (00:01)
joonhan  tty1                          Mon Jul 11 23:13 - 17:14  (18:00)
reboot   system boot  5.10.0-16-amd64  Mon Jul 11 23:13   still running
```

`last reboot` 를 입력하면 재부팅된 기록들만 내림차순으로 표시한다.

```bash
reboot   system boot  5.10.0-16-amd64  Mon Jul 18 12:48   still running
reboot   system boot  5.10.0-16-amd64  Tue Jul 12 17:16   still running
reboot   system boot  5.10.0-16-amd64  Mon Jul 11 23:13   still running

wtmp begins Mon Jul 11 23:13:20 2022
```

또는 `who` 명령어를 사용할 수 있다. 해당 명령어는 호스트에 로그인한 사용자의 정보를 출력해준다. 실행 결과는 다음과 같다.

```bash
joonhan  tty1         Jul 18 12:49
joonhan  pts/0        Jul 19 13:57 (10.0.2.2)
```

옵션 `-b` 를 사용하면 마지막 시스템 부팅 시간을 출력한다.

```bash
system boot  Jul 18 12:48
```

### 7. LVM 활성화 여부

`lsblk` 명령어는 현재 장착된 디스크의 현황을 보여주는 명령어다. 실행 결과는 다음과 같다.

```bash
NAME                    MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
sda                       8:0    0    8G  0 disk
|-sda1                    8:1    0  476M  0 part  /boot
|-sda2                    8:2    0    1K  0 part
`-sda5                    8:5    0  7.5G  0 part
  `-sda5_crypt          254:0    0  7.5G  0 crypt
    |-LVMGroup-root     254:1    0  1.9G  0 lvm   /
    |-LVMGroup-swap     254:2    0  952M  0 lvm   [SWAP]
    |-LVMGroup-home     254:3    0  952M  0 lvm   /home
    |-LVMGroup-var      254:4    0  952M  0 lvm   /var
    |-LVMGroup-srv      254:5    0  952M  0 lvm   /srv
    |-LVMGroup-tmp      254:6    0  952M  0 lvm   /tmp
    `-LVMGroup-var--log 254:7    0    1G  0 lvm   /var/log
sr0                      11:0    1 1024M  0 rom
```

LVM으로 추출했을 때, LVM 파티셔닝이 되어 있다면 활성화된 것으로 판단할 수 있다.

```bash
lsblk | grep LVM | wc -l | awk '{if ($1 > 0) print "yes"; else print "no"}'
```

### 8. 활성 연결 수

`ss` 명령어는 소켓 상태를 조회한다.

소켓이란 프로그램이 네트워크에서 데이터를 통신할 수 있도록 연결해주는 부분이다.

```bash
joonhan@joonhan42:~$ ss
Netid State Recv-Q Send-Q                 Local Address:Port    Peer Address:Port                                 Process
u_str ESTAB 0      0                                  * 12227              * 12228
u_str ESTAB 0      0        /run/dbus/system_bus_socket 12182              * 12181
u_str ESTAB 0      0                                  * 12098              * 12099
u_str ESTAB 0      0                                  * 12181              * 12182
u_str ESTAB 0      0                                  * 12176              * 12177
u_str ESTAB 0      0                                  * 12177              * 12176
u_str ESTAB 0      0        /run/systemd/journal/stdout 12099              * 12098
u_str ESTAB 0      0                                  * 12522              * 12523
u_str ESTAB 0      0                                  * 12131              * 12132
u_str ESTAB 0      0        /run/systemd/journal/stdout 12132              * 12131
u_str ESTAB 0      0                                  * 12046              * 12047
u_str ESTAB 0      0        /run/dbus/system_bus_socket 12178              * 11974
u_str ESTAB 0      0                                  * 11090              * 11137
u_str ESTAB 0      0        /run/systemd/journal/stdout 11137              * 11090
u_str ESTAB 0      0        /run/systemd/journal/stdout 12476              * 12475
u_str ESTAB 0      0                                  * 11842              * 11843
u_str ESTAB 0      0        /run/dbus/system_bus_socket 12523              * 12522
u_str ESTAB 0      0        /run/systemd/journal/stdout 12049              * 12048
u_str ESTAB 0      0        /run/systemd/journal/stdout 11843              * 11842
u_str ESTAB 0      0                                  * 12475              * 12476
u_str ESTAB 0      0                                  * 17076              * 17075
u_str ESTAB 0      0        /run/systemd/journal/stdout 12342              * 12341
u_str ESTAB 0      0        /run/systemd/journal/stdout 12047              * 12046
u_str ESTAB 0      0                                  * 12341              * 12342
u_str ESTAB 0      0                                  * 12048              * 12049
u_str ESTAB 0      0                                  * 11974              * 12178
u_str ESTAB 0      0                                  * 17075              * 17076
u_str ESTAB 0      0        /run/dbus/system_bus_socket 12228              * 12227
u_str ESTAB 0      0                                  * 11981              * 12179
u_str ESTAB 0      0                                  * 17033              * 0
u_str ESTAB 0      0        /run/dbus/system_bus_socket 12179              * 11981
tcp   ESTAB 0      0                          10.0.2.15:4242        10.0.2.2:57087
```

- `u_str` : unix stream 의 약자로, 입출력 장치를 연결하는 소켓으로 이해할 수 있다.
- `ESTAB` : 연결이 지속되고 있는 상태를 의미한다.

`-t` 옵션을 사용하면 tcp 네트워크 정보를 확인할 수 있다.

TCP 란 Transmission Control Protocol 의 약자로, 클라이언트와 서버가 연결된 상태에서 데이터를 주고 받는 프로토콜을 의미한다.

위의 실행 결과에서 SSH 연결이 되어 있기 때문에 `tcp` 항목이 표시되고 있는 것이다.

```bash
tcp   ESTAB 0      0                          10.0.2.15:4242        10.0.2.2:57087
```

### 9. 서버를 사용하는 사용자 수

`who` 명령어를 사용해서 출력할 수 있다.

```bash
who | wc -l
```

### 10. 네트워크 IP 및 MAC 주소

`hostname` 은 호스트 서버의 이름을 표시하는 명령어이다. `-I` 옵션을 사용하면 호스트 서버의 IPv4 주소를 표시한다.

```bash
# IPv4 주소를 확인하는 명령어. IPv6 는 확인할 수 없음
hostname -I
```

IPv4 는 네트워크 상에서 개별 호스트를 인식하기 위한 주소이다. 32비트 길이로 이루어져있으며, `000.000.000.000` 형태로 사용한다.

`ip` 명령어는 네트워크 장비에 대한 정보를 보여주는 명령어이다. `ip link` 를 입력하면 MAC 주소를 조회할 수 있다.

```bash
ip link
```

MAC 주소란 Media Access Control Address 의 약자로 컴퓨터 간 데이터를 전송하기 위해 존재하는 고유한 물리적 주소이다. IP 주소는 네트워크 상황에 따라 다른 번호를 할당 받을 수도 있지만, MAC 주소는 이더넷 장비는 각각 고유한 주소를 할당받기 때문에 변하지 않는다. 심지어 스마트폰이나 블루투스 이어폰에도 고유 주소가 할당되어 있다.

위의 명령어를 실행한 결과는 다음과 같다.

```bash
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
    link/ether 0X:00:XX:XX:XX:XX brd ff:ff:ff:ff:ff:ff
```

`link/ether` 부분에 MAC 주소가 출력되는데, 이를 편집해서 출력한다.

```bash
ip link | awk '$1 == "link/ether" {print $2}' | sed '2, $d' | tr -d '\n'
```

`sed '2, $d'` 명령어는 2행부터 마지막 줄은 삭제(`$d`)한다는 명령이다.

### 11. sudo로 실행한 명령어 수

`journalctl` 는 리눅스용 시스템 매니저인 systemd 가 저장한 로그 데이터 journal 에서 검색할 수 있는 명령어이다.

`_COMM` 옵션을 사용하면 특정 명령어를 사용한 로그를 확인할 수 있다.

```bash
journalctl _COMM=sudo | wc -l | tr -d '\n'
```

# cron

특정 시간마다 특정 작업을 자동으로 수행하고 싶을 때 사용하는 데몬이다.

- 데몬 : 메모리에 상주하면서 특정 요청이 들어오면 즉시 수행하는 프로그램

cron 작업을 설정하는 파일을 crontab 파일이라 하며, `/etc/crontab` 로 접근할 수 있다.

## 설치 여부 확인

아래의 명령어를 입력한다.

```bash
ps -ef | grep cron
```

만약 설치되어 있다면 다음과 같이 표시된다.

```bash
root         530       1  0 07:51 ?        00:00:00 /usr/sbin/cron -f
joonhan     3528    3214  0 17:37 pts/1    00:00:00 grep cron
```

## crontab 편집

아래의 명령어를 입력한다.

```bash
crontab -e
```

아래의 내용을 추가하고 저장한다.

```bash
#분  시 일 달 일 [실행시킬 명령어]
*/10 * * * * /home/monitoring.sh | wall
```

`wall` 명령어는 모든 로그인된 사용자에게 터미널로 메세지를 보내는 명령어이다.

`*/10` 은 매 10분마다 실행한다는 의미이다.

`monitoring.sh` 파일은 `/home` 디렉토리에 저장한다.

## monitoring.sh 권한 편집

`chmod +x monitoring.sh` 을 입력하여 실행 권한을 부여한다.

## cron 실행

아래의 명령어를 입력하면 cron 서비스를 시작한다.

```bash
sudo systemctl start cron
```

부팅 시 자동으로 실행하기 위해서는 아래의 명령어를 입력한다.

```bash
sudo systemctl enable cron
```

# 참고자료

- [[리눅스(Linux)] 비밀번호(패스워드) 정책 설정](https://jmoon417.tistory.com/36) [티스토리]
- [[Linux] PAM 파일 상세 설명 및 설정 방법](https://sysops.tistory.com/125) [티스토리]
- [리눅스 PAM 모듈의 이해](http://www.igloosec.co.kr/BLOG_%EB%A6%AC%EB%88%85%EC%8A%A4%20PAM%20%EB%AA%A8%EB%93%88%EC%9D%98%20%EC%9D%B4%ED%95%B4?searchItem=&searchWord=&bbsCateId=49&gotoPage=1) [IGLOO]
- [Why is this random password flagged saying it is too simplistic/systematic?](https://unix.stackexchange.com/questions/121087/why-is-this-random-password-flagged-saying-it-is-too-simplistic-systematic) [stackexchange]
- [Physical CPU와 Logical CPU의 차이 (processor, cpu, thread 개념)](https://etloveguitar.tistory.com/62) [티스토리]
- [Understanding Physical and Logical CPUs](https://www.linkedin.com/pulse/understanding-physical-logical-cpus-akshay-deshpande/) [Linkedin]
- [[OS] CPU, Processor, Core, Process, Thread 그리고 관계 정리](https://dmzld.tistory.com/18) [티스토리]
- [What is the difference between Virtual CPU and Logical CPU?](https://www.quora.com/What-is-the-difference-between-Virtual-CPU-and-Logical-CPU) [quora]
- [How to Display the Number of Processors (vCPU) on Linux VPS](https://webhostinggeeks.com/howto/how-to-display-the-number-of-processors-vcpu-on-linux-vps/) [webhostinggeeks]
- [CPU 코어와 쓰레드](https://sc-iwrwh.tistory.com/26) [CPU 코어와 쓰레드]
- [램(RAM)이란 무엇인가?](https://bskyvision.com/entry/%EB%9E%A8RAM%EC%9D%B4%EB%9E%80-%EB%AC%B4%EC%97%87%EC%9D%B8%EA%B0%80) [bskyvision]
- [RAM](https://namu.wiki/w/RAM) [나무위키]
- [리눅스 : Swap 메모리란?](https://jw910911.tistory.com/122) [티스토리]
- [리눅스 tmpfs 란 무엇인가](https://sidepower.tistory.com/119) [티스토리]
- [리눅스 awk 명령어 사용법. (Linux awk command) - 리눅스 파일 텍스트 데이터 검사, 조작, 출력.](https://recipes4dev.tistory.com/171) [티스토리]
- [How to Check CPU Utilization in Linux with Command Line](https://phoenixnap.com/kb/check-cpu-usage-load-linux) [phoenixNAP]
- [STREAMS](https://en.wikipedia.org/wiki/STREAMS) [wikipedia]
- [[Network] TCP / UDP의 개념과 특징, 차이점](https://coding-factory.tistory.com/614) [티스토리]
- [IPv4주소란?](https://xn--3e0bx5euxnjje69i70af08bea817g.xn--3e0b707e/jsp/resources/ipv4Info.jsp) [한국인터넷정보센터]
- [맥 어드레스란 무엇인가? IP주소와 맥주소(MAC address) 차이, 맥 주소 확인하는 법 - 네트워크 기초](https://jhnyang.tistory.com/404) [티스토리]
- [[리눅스/유닉스] 유용 명령어 sed를 살펴보자! sed 명령어 사용법과 예시, 패턴 스페이스와 홀드 스페이스, 유용 표현](https://jhnyang.tistory.com/287) [티스토리]
- [Linux journalctl 사용법](https://www.lesstif.com/system-admin/linux-journalctl-82215080.html) [lessif]
- [[linux]데몬(daemon) 이란?](https://valuefactory.tistory.com/229) [티스토리]
