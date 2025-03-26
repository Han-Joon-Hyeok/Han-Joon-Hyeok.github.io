---
title: "[nginx] response header의 Server 항목에서 nginx 버전 제거하기"
date: 2025-03-27 00:10:00 +0900
categories: [nginx]
tags: []
---

# 개요

nginx의 응답 헤더(response header) 중 Server 항목에 nginx 버전 정보가 표시되지 않도록 설정하는 방법을 소개합니다.

# 문제 상황

nginx를 리버스 프록시로 사용하여 백엔드 API 요청을 처리하고 있었습니다. 우연히 클라이언트의 응답 헤더를 확인하던 중, 아래의 이미지와 같이 Server 항목에 nginx의 버전이 노출되고 있는 것을 발견했습니다.

![1.png](/assets/images/2025/2025-03-27-nginx-removing-nginx-version-from-response-header/1.png)

`Server: nginx/1.26.2` 와 같이 버전까지 노출되는 경우, 이는 보안상 위험 요소가 될 수 있습니다. 공격자는 노출된 버전 정보를 바탕으로 해당 버전의 알려진 취약점을 검색하여 시스템을 공격할 수 있기 때문입니다. 예를 들어, 1.26.2 버전에서는 **CVE-2025-23419**([링크](https://www.cve.org/CVERecord?id=CVE-2025-23419)) 라는 취약점이 존재하는데, 이 취약점으로 인해 클라이언트 인증서 없이도 서버와 연결이 가능한 문제가 발생할 수 있습니다.

자세한 nginx 버전별 보안 취약점 목록은 아래의 링크에서 확인할 수 있습니다.

- https://nginx.org/en/security_advisories.html

# 원인

nginx 공식 문서([server_tokens directive](https://nginx.org/en/docs/http/ngx_http_core_module.html#server_tokens))에 따르면, nginx는 기본 설정으로 응답 헤더의 Server 항목에 nginx 버전 정보를 포함합니다.

> **Enables or disables emitting nginx version** on error pages and **in the “Server” response header field.**
>

이 기능은 nginx 설정 파일에서 `server_tokens` directive의 기본값이 on으로 되어있기 때문에 동작합니다.

# 해결 방안

nginx 설정 파일에서 `server_tokens` directive를 off로 설정하면, 응답 헤더에서 버전 정보가 제거됩니다.

## 설정 방법

`server_tokens off;` 를 다음 중 하나에 추가합니다.

- `http` 블록: 모든 서버에 적용하는 경우
- `server` 블록: 특정 도메인(server block)에 적용하는 경우

## 예시: server 블록에 적용한 설정

실제 사용한 설정 파일은 아래와 같습니다.

```bash
upstream blue {
    server blue:8080;
}

upstream green {
    server green:8080;
}

limit_req_zone $binary_remote_addr zone=ddos_limit:10m rate=10r/s;

server {
    listen 80;

    server_name "domain.link";
    server_tokens off; # Server 헤더에서 nginx 버전 정보 제거

    location / {
        limit_req zone=ddos_limit burst=10 nodelay;
        real_ip_header    X-Forwarded-For;
        set_real_ip_from 0.0.0.0/0;

        proxy_pass http://green;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```

## 설정 적용

설정 파일을 수정한 후 nginx를 재시작하거나 reload 합니다.

```bash
nginx -s reload
```

# 결과

설정 적용 후, 아래의 이미지와 같이 응답 헤더에서 nginx 버전이 제거된 것을 확인할 수 있습니다.

![2.png](/assets/images/2025/2025-03-27-nginx-removing-nginx-version-from-response-header/2.png)

# 참고자료

- [nginx version 숨기기 및 header 정보 숨기기 ( nginx remove the server header )](https://xinet.kr/?p=3478) [xinet.kr]