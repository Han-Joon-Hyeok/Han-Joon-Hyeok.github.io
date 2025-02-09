---
title: "[nginx] rate limit 설정으로 인한 503 Service Unavailable 오류 해결 과정"
date: 2025-02-09 18:00:00 +0900
categories: [nginx]
tags: []
---

# 개요

nginx를 이용해 API 요청을 백엔드로 리버스 프록싱했지만, 프론트엔드에서 백엔드로 보낸 요청의 응답으로 `503 Service Unavailable`오류를 반환하는 문제가 발생했습니다. 이 글에서는 해당 오류의 원인과 해결 과정을 정리했습니다.

결론부터 말하자면, 문제의 원인은 DDoS 공격을 방지하기 위해 사용했던 nginx의 rate limit 기능과 프론트엔드의 API 요청 횟수로 인해 발생한 문제였습니다. nginx가 일정 시간 안에 처리할 수 있는 요청보다 프론트엔드에서 더 많은 요청을 보낸 것이 원인이었습니다.

# 개발 환경

- OS: Amazon Linux 2023 (AWS EC2)
- Frontend: Next.js (14.0.4) + TypeScript
- Backend: Spring Boot (3.2.3) + Java17
- nginx: 1.26.2

# 문제 상황

배포된 서비스에서 프론트엔드 화면을 확인하던 중, 본인이 작성한 게시물에 ‘게시물 수정’ 버튼이 표시되지 않거나 간헐적으로 표시되는 현상을 발견했습니다.

![1.png](/assets/images/2025/2025-02-09-nginx-rate-limit-503-error/1.png)

로컬 개발 환경에서는 정상적으로 표시되었지만, 운영 서버에서만 해당 현상이 발생했습니다.

# 문제 원인 분석

## 1. response 분석

![2.png](/assets/images/2025/2025-02-09-nginx-rate-limit-503-error/2.png)

프론트엔드 도메인(`habitpay.link`)과 백엔드 도메인(`api.habitpay.link`)은 도메인이 다르기 때문에 브라우저는 CORS 정책을 확인하기 위해 OPTIONS 요청을 먼저 보냅니다. 하지만 백엔드에서는 `503 Service Unavailable` 응답을 반환했습니다.

## 2. 프론트엔드 코드 분석

해당 API 요청은 게시물을 조회하는 API였고, 프론트엔드에서는 아래와 같이 API 요청을 보내고 있었습니다.

```tsx
// postItem.tsx

const PostItem = ({ challengeId, contentDTO }: PostsFeedProps) => {
  // 게시물 작성자에게만 수정 버튼을 보여주기 위한 state
  const [isPostAuthor, setIsPostAuthor] = useState(false);

  useEffect(() => {
    const getPostInfo = async () => {
      try {
        const res = await apiManager.get(`/posts/${contentDTO.id}`);
        const data: ContentDTO = res.data.data;
        setIsPostAuthor(data.isPostAuthor);
      } catch (error) {
        console.error("Failed to fetch post info:", error);
      }
    };
    getPostInfo();
  }, [contentDTO.id]);

  // 하략
};
```

로컬 환경에서는 모든 OPTIONS 요청에 대해 아래의 이미지와 같이 정상적인 응답을 받았습니다.

![3.png](/assets/images/2025/2025-02-09-nginx-rate-limit-503-error/3.png)

이를 통해 프론트엔드 코드 자체에는 문제가 없으며, 운영 서버에서만 발생하는 문제라고 판단했습니다.

로컬 환경과 운영 서버 환경의 유일한 차이는 nginx 사용 여부였으며, 각 환경을 그림으로 표현하면 아래와 같습니다.

![4.png](/assets/images/2025/2025-02-09-nginx-rate-limit-503-error/4.png)

## 3. nginx 설정 파일

기존에 nginx 로그에서 `.env`, `.pem` 등의 파일을 탈취하려는 악의적인 요청이 다수 발생하는 것을 확인하고, 이러한 공격과 더불어 DDoS 공격을 방지하기 위해 nginx의 rate limit 기능을 추가한 적이 있었습니다.

nginx 설정 파일은 아래와 같았습니다.

```bash
limit_req_zone $binary_remote_addr zone=ddos_limit:10m rate=10r/s;

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
```

nginx의 rate limit 기능은 DDoS 공격과 같이 짧은 시간에 과도하게 많은 요청을 보내는 공격을 방지하기 위해 사용하며, 설정 파일에서 이 기능을 사용하기 위한 부분은 아래와 같습니다.

```bash
limit_req_zone $binary_remote_addr zone=ddos_limit:10m rate=10r/s;
limit_req zone=ddos_limit burst=10 nodelay;
```

### rate=10r/s

`rate=10r/s`는 동일한 IP에 대해 0.1초에 1개의 요청을 처리해서 1초에 총 10개 요청을 처리한다는 의미입니다. 만약, `rate=20r/s` 라면 0.05초에 1개의 요청을 처리해서 1초에 총 20개 요청을 처리한다는 의미입니다.

`rate=10r/s` 일 때, 0.1초 안에 2개의 요청이 순차적으로 도착했다고 가정하겠습니다. 그러면 가장 먼저 도착한 요청은 처리하지만, 두 번째로 도착한 요청은 처리하지 않습니다.

### burst=10

`limit_req_zone`에서 명시한 rate보다 순간적으로 많은 트래픽이 들어오는 것을 허용하기 위해 사용합니다.

`burst=10` 은 `rate=10r/s` 에서 0.1초에 1개의 요청을 허용하지만, 0.1초 안에 최대 10개 요청을 추가로 처리하겠다는 의미입니다. 예를 들어, 0.1초 안에 11개의 요청이 들어오면, 첫 요청은 처리하고, `burst=10` 옵션으로 인해 나머지 10개 요청은 크기가 10인 큐에 저장됩니다. 그리고 큐에 저장된 요청은 0.1초마다 pop해서 요청을 처리합니다. 하지만 마지막 요청은 큐의 모든 요청이 처리되고 나서 처리되기 때문에 1초 후에 응답을 받게 되며, 클라이언트 입장에서는 응답을 늦게 받는 단점이 있습니다.

### nodelay

이를 보완하기 위해 `nodelay` 옵션을 함께 사용할 수 있습니다. `rate=10r/s`, `burst=10` 인 상황에서 `nodelay` 옵션을 사용한 상황이라면, 0.1초 안에 11개의 요청이 들어와도 11개의 요청을 0.1초 안에 모두 처리해서 응답합니다. 다만, 첫 요청은 바로 처리하는 대신 나머지 10개의 요청은 큐에 넣습니다. 큐에 들어간 요청들은 `taken` 으로 마킹되어 들어가며, `nodelay` 옵션을 사용하지 않을 때와 동일하게 0.1초 간격으로 큐에서 pop 됩니다. 다만, pop 할 때 요청을 실제로 처리하지 않습니다. 만약, 0.1초 안에 12개의 요청이 오면 11개 요청은 처리되지만, 마지막 1개의 요청은 큐에 자리가 부족하기 때문에 처리할 수 없습니다.

`nodelay` 옵션을 사용해도 0.1초 간격으로 큐에서 요청을 pop 하는 이유는 동일한 속도로 요청을 처리하는 것을 보장하기 위함입니다. 0.1초에 11개의 요청이 도착했다면 큐에는 10개의 요청이 들어가지만, 0.1초가 지나면 큐에 1자리가 생기며 이때 다른 요청 1개가 도착한다면 이 요청을 큐에 넣음과 동시에 요청을 처리합니다. 만약, 0.1초 뒤에 2개의 요청이 도착하면 첫 요청은 큐에 넣고, 다른 요청은 큐에 자리가 없으므로 처리할 수 없습니다.

### nginx 로그 확인

nginx 공식 문서에 따르면 일정 시간 동안 처리할 수 요청 수 제한을 초과하면 503 오류를 반환한다고 나와있습니다.

![5.png](/assets/images/2025/2025-02-09-nginx-rate-limit-503-error/5.png)

운영 서버에서 실패한 요청에 대해 nginx 로그를 확인해보니 아래와 같았습니다.

> 2025/02/03 12:52:44 [error] 447#447: \*3992 limiting requests, excess: 10.350 by zone "ddos_limit", client: 218.50.111.206, server: api.habitpay.link, request: "OPTIONS /api/posts/69 HTTP/1.1", host: "api.habitpay.link", referrer: "https://habitpay.link/"
> 218.50.111.206 - - [03/Feb/2025:12:52:44 +0000] "OPTIONS /api/posts/69 HTTP/1.1" 503 599 "https://habitpay.link/" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36" "218.50.111.206"

`excess: 10.350 by zone "ddos_limit"`를 통해 큐의 크기(burst) 10을 초과한 10.350개가 들어왔고, 0.1초 안에 약 12개 요청이 들어왔다는 것을 알 수 있습니다.

운영 서버 페이지에서 발생한 오류와 nginx 오류를 비교해보니 동일한 것을 확인했습니다.

![6.png](/assets/images/2025/2025-02-09-nginx-rate-limit-503-error/6.png)

## 4. 문제 원인 결론

- 프론트엔드의 `postsFeed` 컴포넌트에서 게시물 목록 조회 API(`api/challenges/[challengeId]/posts?size=10&page=1`)는 한 번의 요청으로 10개의 게시물을 가져옵니다.
- 하지만 `postsFeed` 컴포넌트의 하위 컴포넌트인 `postItem` 컴포넌트에서 상위 컴포넌트에서 전달한 게시물 10개에 대해 중복된 게시물 조회 요청(`/api/posts/[postId]`)을 보냈습니다. 이때, OPTIONS 요청은 10개가 동시에 발생하는데, 페이지를 불러올 때 공지사항 조회, 챌린지 정보 조회와 같은 다른 API도 호출되었습니다.
- nginx는 0.1초에 최대 11개 요청을 처리할 수 있지만, 12개 이상 요청이 nginx에 도착했기에 처리하지 못한 요청에 대해서는 503 오류를 반환했습니다.
- 그러다보니 `postItem` 컴포넌트 내부에서 게시물 조회 요청이 성공한 글의 `isPostAuthor` 상태는 `true`가 되었지만, 요청이 실패한 글의 상태는 초기값인 `false`로 유지되었습니다. 그래서 본인이 작성한 게시물 중에서도 일부만 게시물 수정 버튼이 보였고, 마치 간헐적으로 게시물 수정 버튼이 표시되는 것으로 보였던 것입니다.

# 문제 해결

`postItem` 컴포넌트에서 개별 게시물 조회 API 요청을 제거했습니다. 부모 컴포넌트인 `postsFeed`컴포넌트에서 게시물 10개에 대한 정보를 자식 컴포넌트인 `postItem`에 `contentDTO` props로 내려주기 때문에 `postItem` 컴포넌트에서 개별 게시물 조회 API를 요청할 필요가 없었습니다.

# 결과물

운영 서버에서도 정상적으로 본인이 작성한 게시물에 대해 수정 버튼이 표시되었습니다.

![7.png](/assets/images/2025/2025-02-09-nginx-rate-limit-503-error/7.png)

# 교훈

1. 로컬 개발 환경과 운영 서버 환경의 차이로 인해 사전에 문제를 발견하지 못했던 것이 가장 큰 원인이었습니다. 따라서 로컬 개발 환경을 운영 서버 환경과 최대한 동일하게 구성하는 것이 중요합니다.
2. nginx의 rate limit 설정을 적용할 때, 프론트엔드 요청 횟수를 고려해야 합니다.
3. 불필요한 API 요청을 줄이면 성능 최적화와 함께 예상치 못한 오류를 방지할 수 있습니다.

# 참고자료

- [nginx로 악의적인 다수의 request 방지하기(limit_req)](https://velog.io/@moonseok/NGINX-limitreq-%EC%A0%81%EC%9A%A9%ED%95%98%EA%B8%B0) [velog]
- [Module ngx_http_limit_req_module](https://nginx.org/en/docs/http/ngx_http_limit_req_module.html) [nginx]
- [[nginx] 요청 제한을 위한 ratelimit](https://m.blog.naver.com/pjt3591oo/223219393491) [네이버 블로그]
- [Rate Limiting with NGINX](https://blog.nginx.org/blog/rate-limiting-nginx) [nginx blog]
