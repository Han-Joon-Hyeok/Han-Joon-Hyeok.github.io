---
title: 프로그래머스 Level 2 - 오픈 채팅방 (javascript)
date: 2021-11-04 14:00:00 +0900
categories: [programmers]
tags: [level2, programmers]
---

> [프로그래머스 - Level2 오픈채팅방](https://programmers.co.kr/learn/courses/30/lessons/42888)

# 문제 설명

카카오톡 오픈채팅방에서는 친구가 아닌 사람들과 대화를 할 수 있는데, 본래 닉네임이 아닌 가상의 닉네임을 사용하여 채팅방에 들어갈 수 있다.

신입사원인 김크루는 카카오톡 오픈 채팅방을 개설한 사람을 위해, 다양한 사람들이 들어오고, 나가는 것을 지켜볼 수 있는 관리자창을 만들기로 했다. 채팅방에 누군가 들어오면 다음 메시지가 출력된다.

"[닉네임]님이 들어왔습니다."

채팅방에서 누군가 나가면 다음 메시지가 출력된다.

"[닉네임]님이 나갔습니다."

채팅방에서 닉네임을 변경하는 방법은 다음과 같이 두 가지이다.

- 채팅방을 나간 후, 새로운 닉네임으로 다시 들어간다.
- 채팅방에서 닉네임을 변경한다.

닉네임을 변경할 때는 기존에 채팅방에 출력되어 있던 메시지의 닉네임도 전부 변경된다.

예를 들어, 채팅방에 "Muzi"와 "Prodo"라는 닉네임을 사용하는 사람이 순서대로 들어오면 채팅방에는 다음과 같이 메시지가 출력된다.

"Muzi님이 들어왔습니다.""Prodo님이 들어왔습니다."

채팅방에 있던 사람이 나가면 채팅방에는 다음과 같이 메시지가 남는다.

"Muzi님이 들어왔습니다.""Prodo님이 들어왔습니다.""Muzi님이 나갔습니다."

Muzi가 나간후 다시 들어올 때, Prodo 라는 닉네임으로 들어올 경우 기존에 채팅방에 남아있던 Muzi도 Prodo로 다음과 같이 변경된다.

"Prodo님이 들어왔습니다.""Prodo님이 들어왔습니다.""Prodo님이 나갔습니다.""Prodo님이 들어왔습니다."

채팅방은 중복 닉네임을 허용하기 때문에, 현재 채팅방에는 Prodo라는 닉네임을 사용하는 사람이 두 명이 있다. 이제, 채팅방에 두 번째로 들어왔던 Prodo가 Ryan으로 닉네임을 변경하면 채팅방 메시지는 다음과 같이 변경된다.

"Prodo님이 들어왔습니다.""Ryan님이 들어왔습니다.""Prodo님이 나갔습니다.""Prodo님이 들어왔습니다."

채팅방에 들어오고 나가거나, 닉네임을 변경한 기록이 담긴 문자열 배열 record가 매개변수로 주어질 때, 모든 기록이 처리된 후, 최종적으로 방을 개설한 사람이 보게 되는 메시지를 문자열 배열 형태로 return 하도록 solution 함수를 완성하라.

## 제한사항

- record는 다음과 같은 문자열이 담긴 배열이며, 길이는 `1` 이상 `100,000` 이하이다.
- 다음은 record에 담긴 문자열에 대한 설명이다.
  - 모든 유저는 [유저 아이디]로 구분한다.
  - [유저 아이디] 사용자가 [닉네임]으로 채팅방에 입장 - "Enter [유저 아이디] [닉네임]" (ex. "Enter uid1234 Muzi")
  - [유저 아이디] 사용자가 채팅방에서 퇴장 - "Leave [유저 아이디]" (ex. "Leave uid1234")
  - [유저 아이디] 사용자가 닉네임을 [닉네임]으로 변경 - "Change [유저 아이디] [닉네임]" (ex. "Change uid1234 Muzi")
  - 첫 단어는 Enter, Leave, Change 중 하나이다.
  - 각 단어는 공백으로 구분되어 있으며, 알파벳 대문자, 소문자, 숫자로만 이루어져있다.
  - 유저 아이디와 닉네임은 알파벳 대문자, 소문자를 구별한다.
  - 유저 아이디와 닉네임의 길이는 `1` 이상 `10` 이하이다.
  - 채팅방에서 나간 유저가 닉네임을 변경하는 등 잘못 된 입력은 주어지지 않는다.

## 🙋‍♂️나의 풀이

```jsx
function solution(record) {
  const result = [];
  const users = {};

  // 1. 유저의 닉네임 상태 변화 기록
  record.forEach((item) => {
    const arr = item.split(" ");
    const status = arr[0];
    const uid = arr[1];

    if (status === "Enter" || status === "Change") {
      const name = arr[2];
      users[uid] = name;
    }
  });

  // 2. 관리자 메세지 출력
  record.forEach((item) => {
    const arr = item.split(" ");
    const status = arr[0];

    if (status === "Change") return;

    const uid = arr[1];
    const msg = `${users[uid]}님이 `;

    const suffix = status === "Enter" ? "들어왔습니다." : "나갔습니다.";
    result.push(msg + suffix);
  });

  return result;
}
```

- 출력 시에는 최종적으로 설정된 닉네임이 출력되어야 한다.
- 따라서 닉네임이 변경되는 것을 모두 추적하기 위해 `users` HashMap에 상태가 `Enter` 이거나 `Change` 이면, 유저 아이디와 닉네임을 저장한다.
- 다시 기록을 순회하며 `Enter` 와 `Leave` 인 경우에 최종 닉네임과 메세지 내용을 배열에 담는다.

## 👀참고한 풀이

```jsx
function solution(record) {
  const result = [];
  const users = {};
  const stateMapping = {
    Enter: "님이 들어왔습니다.",
    Leave: "님이 나갔습니다.",
  };

  record.forEach((item) => {
    const [state, uid, name] = item.split(" ");

    if (state !== "Change") {
      result.push([state, uid]);
    }

    if (name) {
      users[uid] = name;
    }
  });

  return result.map(([state, uid]) => {
    return `${users[uid]}${stateMapping[state]}`;
  });
}
```

- 상태에 따른 메세지를 미리 객체에 선언한 `stateMapping` 을 사용한 것이 인상적이다.
- `forEach` 를 돌며 배열을 비구조화 할당하여 변수 선언을 깔끔하게 처리했다.
- 결과는 `map` 을 사용해서 반환 했는데, 후반부 테스트 케이스들에서 효율성이 내 코드보다 훨씬 좋게 나왔다. 후반부 테스트 케이스가 자체가 커서 시간이 오래 걸리는 것 같다.

# 배운 점

- 반복문 내에서 객체의 프로퍼티에 접근할 때 아래의 두 개는 구분해서 써야 한다.

```jsx
obj.prop;
obj[prop];
```

```jsx
const arr = ["name", "address"];
const obj = {
  name: "joon",
  address: "Seoul",
};

arr.forEach((prop) => {
  console.log(obj.prop);
  console.log(obj[prop]);
});

// undefined
// joon
// undefined
// Seoul
```

- `obj.prop` 은 obj 객체에 prop 이라는 이름을 가진 속성을 찾는 것이고, `obj[prop]`은 obj 객체에 prop의 값을 가진 속성을 찾는 것이다.

# 느낀 점

- 다른 분들의 풀이를 보고 나니, 나는 절차지향적으로 코드를 작성했다. 비구조화 할당이 아닌 인덱스 번호로 접근한 것이 아쉽다.
- 어찌해서 통과하긴 했지만, 효율성 측면에서 아슬아슬 했다. 문법 공부를 튼튼하게 해야겠다.
