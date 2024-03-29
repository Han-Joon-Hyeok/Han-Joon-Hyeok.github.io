---
title: 프로그래머스 Level 2 - 타겟 넘버 (JavaScript)
date: 2021-12-15 23:40:00 +0900
categories: [programmers]
tags: [level2, programmers, javascript]
use_math: true
---

> [프로그래머스 - Level2 타겟 넘버](https://programmers.co.kr/learn/courses/30/lessons/43165#)

# 문제 설명

---

n개의 음이 아닌 정수가 있습니다. 이 수를 적절히 더하거나 빼서 타겟 넘버를 만들려고 합니다. 예를 들어 [1, 1, 1, 1, 1]로 숫자 3을 만들려면 다음 다섯 방법을 쓸 수 있습니다.

```javascript
-1+1+1+1+1 = 3
+1-1+1+1+1 = 3
+1+1-1+1+1 = 3
+1+1+1-1+1 = 3
+1+1+1+1-1 = 3
```

사용할 수 있는 숫자가 담긴 배열 numbers, 타겟 넘버 target이 매개변수로 주어질 때 숫자를 적절히 더하고 빼서 타겟 넘버를 만드는 방법의 수를 return 하도록 solution 함수를 작성해주세요.

## 제한사항

- 주어지는 숫자의 개수는 2개 이상 20개 이하입니다.
- 각 숫자는 1 이상 50 이하인 자연수입니다.
- 타겟 넘버는 1 이상 1000 이하인 자연수입니다.

## 🙋‍♂️나의 풀이

DFS를 몰라서 다른 분들의 코드를 참고해서 풀었다.

재귀적으로 함수를 호출해서 푸는 방법을 참고해서 정리했다.

트리의 왼쪽 방향은 더하기, 오른쪽 방향은 빼는 것으로 진행한다. 트리 내에서 부분합을 만든다고 생각하면 좋은 것 같다.

루트 노드는 배열의 맨 처음 요소이다. 이는 순서가 바뀐 것을 고려하지 않기 때문이다. 예시에서 배열은 [1, 1, 1, 1, 1] 로 모두 같은 수로 구성된 배열이지만, 만약 요소의 순서들을 바꿔서 타겟 넘버를 구한다고 하면 정답은 25(5 \* 5)가 된다. 따라서 주어진 배열의 순서대로 연산을 적용해야 하므로, 루트 노드는 배열의 맨 처음 요소가 된다.

### 작성 코드

```javascript
function solution(numbers, target) {
  let answer = 0;

  const dfs = (idx, sum) => {
    if (idx === numbers.length) {
      if (sum === target) answer++;
      return;
    }

    dfs(idx + 1, sum + numbers[idx]);
    dfs(idx + 1, sum - numbers[idx]);
  };

  dfs(0, 0);

  return answer;
}
```

작동 방식은 다음과 같다.

- `dfs` 함수에 루트 노드의 인덱스와 연산 결과의 합을 각각 0으로 설정해서 넘겨준다.
- 인덱스가 배열의 길이와 같다는 것은 배열의 맨 마지막 요소까지 모두 순회했다는 의미이다. 만약, 합이 타겟과 같다면 방법의 수를 올려주고, 그렇지 않으면 별도의 수행없이 함수를 빠져나온다.
- 인덱스가 배열을 모두 순회하기 전까지 순서대로 인덱스를 하나씩 올려준다. 처음에는 모든 요소를 더하는 연산을 수행한다.
  ```javascript
  // 작동 순서
  // dfs(0, 0)
  //   -> dfs(1 + 1, 0 + 1)
  //     -> dfs(2 + 1, 1 + 1)
  //       -> dfs(3 + 1, 2 + 1)
  //         -> dfs(4 + 1, 3 + 1)
  //           -> dfs(5, 4 + 1)   // 함수 종료
  ```
- 이때, 인덱스가 배열의 마지막에 도달하면, 이전 인덱스에 해당하는 요소를 뺀 연산을 수행한다.
  ```javascript
  // 작동 순서
  // dfs(0, 0)
  //   -> dfs(1 + 1, 0 + 1)
  //     -> dfs(2 + 1, 1 + 1)
  //       -> dfs(3 + 1, 2 + 1)
  //         -> dfs(4 + 1, 3 + 1)
  //           -> dfs(5, 4 + 1)   // 함수 종료
  //         -> dfs(4 + 1, 3 - 1) // 뺄셈 연산 실행
  //           -> dfs(5, 2 + 1)   // 함수 종료
  ```
- 그리고 다시 인덱스가 마지막에 도달할 때까지 더하는 연산을 수행하다가 종료하면 빼는 연산을 반복한다.
  ```javascript
  // 작동 순서
  // dfs(0, 0)
  //   -> dfs(1 + 1, 0 + 1)
  //     -> dfs(2 + 1, 1 + 1)
  //       -> dfs(3 + 1, 2 + 1)
  //         -> dfs(4 + 1, 3 + 1)
  //           -> dfs(5, 4 + 1)   // 함수 종료
  //         -> dfs(4 + 1, 3 - 1) // 뺄셈 연산 실행
  //           -> dfs(5, 2 + 1)   // 함수 종료
  //       -> dfs(3 + 1, 2 - 1)   // 뺄셈 연산 실행
  //         -> dfs(4 + 1, 1 + 1) // 덧셈 연산 실행
  // ... 반복
  ```

## 참고자료

- [[javascript] 프로그래머스 타겟 넘버](https://jjnooys.medium.com/%ED%94%84%EB%A1%9C%EA%B7%B8%EB%9E%98%EB%A8%B8%EC%8A%A4-%ED%83%80%EA%B2%9F-%EB%84%98%EB%B2%84-javascript-1d7983d423b5)
  - 트리를 그림으로 설명해주셔서 이해하기 쉬웠다.
