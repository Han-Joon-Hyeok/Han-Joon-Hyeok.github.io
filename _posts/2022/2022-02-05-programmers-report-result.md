---
title: 프로그래머스 Level 1 - 신고 결과 받기 (JavaScript)
date: 2022-02-05 21:15:00 +0900
categories: [programmers]
tags: [level1, programmers, javascript]
use_math: true
---

> [프로그래머스 - Level1 신고 결과 받기](https://programmers.co.kr/learn/courses/30/lessons/92334)

# 문제 설명

---

문제 설명 생략

## 제한사항

- 2 ≤ `id_list`의 길이 ≤ 1,000
  - 1 ≤ `id_list`의 원소 길이 ≤ 10
  - `id_list`의 원소는 이용자의 id를 나타내는 문자열이며 알파벳 소문자로만 이루어져 있습니다.
  - `id_list`에는 같은 아이디가 중복해서 들어있지 않습니다.
- 1 ≤ `report`의 길이 ≤ 200,000
  - 3 ≤ `report`의 원소 길이 ≤ 21
  - `report`의 원소는 "이용자id 신고한id"형태의 문자열입니다.
  - 예를 들어 "muzi frodo"의 경우 "muzi"가 "frodo"를 신고했다는 의미입니다.
  - id는 알파벳 소문자로만 이루어져 있습니다.
  - 이용자id와 신고한id는 공백(스페이스)하나로 구분되어 있습니다.
  - 자기 자신을 신고하는 경우는 없습니다.
- 1 ≤ `k` ≤ 200, `k`는 자연수입니다.
- return 하는 배열은 `id_list`에 담긴 id 순서대로 각 유저가 받은 결과 메일 수를 담으면 됩니다.

## 🙋‍♂️나의 풀이

### 🤔문제 접근

최종적으로 유저마다 다음과 같은 정보를 갖도록 했다.

- 신고한 다른 유저 목록
- 신고 받은 횟수
- 활동 정지 여부

작성한 코드는 크게 다음의 논리를 따르도록 했다.

1. 변수 초기화
   - 유저마다 위의 정보를 담는 해시 테이블을 초기화했다.
   - 유저의 수만큼 최종 반환 배열을 0 으로 초기화 했다.
2. 신고 기록 처리
   - 다른 사람에게 신고를 받았다면 신고 받은 횟수를 + 1 한다.
   - 유저가 같은 사람을 여러 번 신고하더라도 신고 받은 횟수는 더 이상 증가시키지 않는다.
3. 메일 받는 횟수 계산
   - 2번에서 처리한 신고 기록 통계를 바탕으로 각 유저가 신고한 사람이 활동 정지되었는지 확인한다.
   - 활동 정지가 되었다면 메일 받는 횟수를 + 1 한다.

### ✍️작성 코드

```javascript
function solution(id_list, report, k) {
  const report_table = {};
  const result = new Array(id_list.length).fill(0);

  init_hash_table(id_list, report_table);
  sum_report_logs(report, report_table, k);
  count_report_mails(report_table, id_list, result);

  return result;
}

const init_hash_table = (id_list, table) => {
  id_list.forEach((id) => {
    if (!(id in table)) {
      table[id] = {
        report_users: [],
        reported_cnt: 0,
        is_banned: false,
      };
    }
  });
  return table;
};

const sum_report_logs = (report, table, report_limit) => {
  report.forEach((log) => {
    const [user, reported_user] = log.split(" ");
    if (!table[user].report_users.includes(reported_user)) {
      table[user].report_users.push(reported_user);
      table[reported_user].reported_cnt += 1;
    }
    if (table[reported_user].reported_cnt >= report_limit) {
      table[reported_user].is_banned = true;
    }
  });
};

const count_report_mails = (table, id_list, result) => {
  id_list.forEach((id, idx) => {
    table[id].report_users.forEach((user) => {
      if (table[user].is_banned) {
        result[idx] += 1;
      }
    });
  });
};
```

모든 기능들을 함수로 최대한 잘게 쪼개서 쓰고 싶었지만, 그렇게 하기에는 너무 구조가 복잡해지는 것 같아서 함수를 3개만 사용해서 구현했다.

### 👀자체 코드 리뷰

해시 테이블을 초기화하는 `init_hash_table` 함수에서 `id` 가 존재하는지 확인하는 부분은 없어도 된다. 제한 사항에서 `id_list` 에는 중복된 `id` 가 없다고 나와있기 때문이다.

```javascript
const init_hash_table = (id_list, table) => {
  id_list.forEach((id) => {
    // if 문은 없어도 된다.
    if (!(id in table)) {
      table[id] = {
        report_users: [],
        reported_cnt: 0,
        is_banned: false,
      };
    }
  });
  return table;
};
```
