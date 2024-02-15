---
title: "[JavaScript] UTC 를 한국시간으로 변환하기 (moment.js)"
date: 2024-02-15 14:47:00 +0900
categories: [javascript]
tags: []
---

# 문제 상황

오늘의 날짜를 한국 기준(KST)으로 출력해주는 코드를 작성했다.

라이브러리는 `date-fns` 를 이용했다.

```jsx
import { format, setDefaultOptions } from "date-fns";
import { ko } from "date-fns/locale";

setDefaultOptions({ locale: ko });

export const getFormatTodayDate = (formatStr) => {
  const utc = new Date();
  return format(utc, formatStr);
};
```

Github Actions 를 사용해서 해당 코드를 실행하면 한국 시간이 아닌 UTC 시간이 출력되었다.

그래서 한국 시간보다 9시간 느린 시간이 출력되었다.

# 시행 착오

`date-fns` 도 시간대를 변환해주는 `date-fns-tz` 라이브러리가 있어서 아래와 같이 작성했다.

```jsx
import { formatInTimeZone } from "date-fns-tz";

const utc = new Date();
const kst = formatInTimeZone(utc, "yyyy-MM-dd HH:mm:ss", "Asia/Seoul");

console.log(kst);
```

하지만 실행하면 아래와 같은 오류가 발생했다.

```bash
node:internal/errors:490
    ErrorCaptureStackTrace(err);
    ^

Error [ERR_PACKAGE_PATH_NOT_EXPORTED]: Package subpath './format/index.js' is not defined by "exports" in /Users/user/workspace/date-fns-tz/node_modules/date-fns/package.json imported from /Users/user/workspace/date-fns-tz/node_modules/date-fns-tz/esm/format/index.js
    at new NodeError (node:internal/errors:399:5)
    at exportsNotFound (node:internal/modules/esm/resolve:266:10)
    at packageExportsResolve (node:internal/modules/esm/resolve:602:9)
    at packageResolve (node:internal/modules/esm/resolve:777:14)
    at moduleResolve (node:internal/modules/esm/resolve:843:20)
    at defaultResolve (node:internal/modules/esm/resolve:1058:11)
    at nextResolve (node:internal/modules/esm/loader:163:28)
    at ESMLoader.resolve (node:internal/modules/esm/loader:835:30)
    at ESMLoader.getModuleJob (node:internal/modules/esm/loader:416:18)
    at ModuleWrap.<anonymous> (node:internal/modules/esm/module_job:76:40) {
  code: 'ERR_PACKAGE_PATH_NOT_EXPORTED'
}

Node.js v19.6.0
```

`package.json` 에서 `type: "module"` 키를 추가했는데도 해결되지 않았다.

# 문제 해결

오류를 해결하는데 많은 시간을 쓸 수는 없어서 결국 다른 라이브러리를 사용하기로 했다.

그 중에서도 `moment-timezone` 라이브러리를 선택했는데, 사용법이 `date-fns` 와 유사하게 쉬웠기 때문이다.

## moment-timezone 라이브러리

`moment-timezone` 라이브러리는 원하는 지역의 시간대 표시를 지원해준다.

npm 또는 yarn 을 이용해서 설치할 수 있다.

```bash
# npm
npm install moment-timezone --save

# Yarn
yarn add moment-timezone
```

## 사용법

`moment-timezone` 라이브러리 사용법은 아래와 같다.

```jsx
import moment from "moment-timezone";

const timezone = "Asia/Seoul";
const utc = moment().tz(timezone);

console.log(utc.format("YYYY년 MM월 DD일"); // 2024년 02월 15일
console.log(utc.format("YYYY-MM-DD HH:mm:ss"); // 2024-02-15 14:29:48

```

### timezone

`timezone` 이라는 변수에 입력한 `Asia/Seoul` 이라는 값은 표준 시간대를 참고했다.

IANA(Internet Assigned Numbers Authority; 인터넷 할당 번호 관리기관)에서 인터넷에서 사용되는 다양한 식별자 및 매개변수를 관리하고 있다. IP 주소, 최상위 도메인, 시간대를 관리하고 있다. (현재는 이 기관을 ICANN 이 관리하고 있다.)

moment.js 에서 특정 지역의 시간대를 사용하고자 한다면 이 기관에서 표준으로 정한 시간대를 이용하면 된다.

**[List of tz database time zones](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)** 에서 `List` 에 항목 아래의 표에서 원하는 시간대를 찾고 `TZ Identifier` 를 입력하면 된다.

예를 들어, 호주 시드니의 시간대를 출력하고 싶다면 `Australia/Sydney` 를 입력하면 된다.

### format

시간을 원하는 포맷으로 출력하기 위해 사용하는 `format()` 함수에는 인자로 문자열을 전달한다.

대표적으로는 아래와 같은 포맷을 제공한다.

더욱 많은 포맷 형태는 아래의 링크를 통해 찾을 수 있다.

- [String + Format](https://momentjs.com/docs/#/parsing/string-format/) [moment.js]

# 참고자료

- [moment timezone](https://momentjs.com/timezone/) [momentjs.com]
- [IANA](https://ko.wikipedia.org/wiki/IANA) [위키백과]