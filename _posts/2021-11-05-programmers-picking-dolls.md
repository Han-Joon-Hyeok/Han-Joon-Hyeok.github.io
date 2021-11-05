---
title: 프로그래머스 Level 1 - 크레인 인형뽑기 게임 (javascript)
date: 2021-11-05 14:00:00 +0900
categories: [programmers]
tags: [level1, programmers]
---

> [프로그래머스 - Level1 크레인 인형뽑기 게임](https://programmers.co.kr/learn/courses/30/lessons/64061)

❗️**설명이 길게 서술 되어 있습니다. 페이지 압박에 주의하시기 바랍니다.**

# 문제 설명

게임개발자인 "죠르디"는 크레인 인형뽑기 기계를 모바일 게임으로 만들려고 합니다.

( ...상세 설명 생략... )

게임 화면의 격자의 상태가 담긴 2차원 배열 board와 인형을 집기 위해 크레인을 작동시킨 위치가 담긴 배열 moves가 매개변수로 주어질 때, 크레인을 모두 작동시킨 후 터트려져 사라진 인형의 개수를 return 하도록 solution 함수를 완성해주세요.

## 제한사항

- board 배열은 2차원 배열로 크기는 "5 x 5" 이상 "30 x 30" 이하입니다.
- board의 각 칸에는 0 이상 100 이하인 정수가 담겨있습니다.
  - 0은 빈 칸을 나타냅니다.
  - 1 ~ 100의 각 숫자는 각기 다른 인형의 모양을 의미하며 같은 숫자는 같은 모양의 인형을 나타냅니다.
- moves 배열의 크기는 1 이상 1,000 이하입니다.
- moves 배열 각 원소들의 값은 1 이상이며 board 배열의 가로 크기 이하인 자연수입니다.

## 🙋‍♂️나의 풀이

```javascript
function solution(board, moves) {
  let answer = 0;
  const picks = [];
  const moves_idx = moves.map((move) => move - 1);

  moves_idx.forEach((move) => {
    let isPicked = false;

    board.forEach((row) => {
      if (isPicked) return;

      const target = row[move];

      if (target === 0) return;

      const lastPick = picks[picks.length - 1];

      if (picks.length < 1 || target !== lastPick) {
        picks.push(target);
        row[move] = 0;
        isPicked = true;
        return;
      }

      if (target === lastPick) {
        picks.pop();
        row[move] = 0;
        answer += 2;
        isPicked = true;
        return;
      }
    });
  });

  return answer;
}
```

- 나름 깔끔하게 만든다고는 했지만, 코드가 깔끔하지 않아서 아쉽다. 특히, `board` 배열의 요소를 직접 수정하기 때문에 원본 데이터가 의도하는 방향과 달리 수정될 수 있다는 위험이 있다. 2차원 배열의 복사본을 만들어도 괜찮을 것 같다.
- `moves` 배열은 크레인이 가로로 움직이는 범위인 자연수로 구성되어 있다. `board`의 각 줄과 인덱스를 동일하게 하기 위해 `map`을 사용해서 `moves` 배열 요소들 모두 -1을 해준다.
- 크레인이 움직이는 것을 외부 반복문으로 설정하고, 가로 줄에서 크레인이 뽑아야 하는 세로 줄로 값을 뽑아내도록 내부 반복문을 설정한다.

```javascript
// 예시

   0 1 2 3 4 -> moves
0 [0,0,0,0,0]
1 [0,0,1,0,3]
2 [0,2,5,0,1]
3 [4,2,4,4,2]
4 [3,5,1,3,1]
⬇️
row
```

- 가로 줄(`row`)을 위에서부터 아래까지 전부 훑어보는 구조이기 때문에 이전에 인형을 뽑았다는 것을 확인하기 위한 `isPicked` 라는 boolean 변수를 선언했다. 만약, 인형을 이전 줄에서 뽑았으면 다음 줄을 뽑지 않는 식으로 작동한다.
- 뽑아야 하는 자리가 비어 있다면 바로 루프를 빠져 나와서 다음 줄로 넘어간다.
- 바구니에 담긴 인형이 없거나, 뽑은 인형이 바구니에 마지막에 담긴 인형과 같지 않으면 바구니에 인형을 넣고, 뽑은 인형 자리는 비운다.
- 바구니에 담긴 인형과 뽑은 인형이 같다면, 위의 과정과 동일하게 하고, 인형이 2개 사라졌으니 정답에 2씩 추가한다.

## 👀참고한 풀이

```javascript
const transpose = (matrix) =>
  matrix.reduce(
    (result, row) => row.map((_, i) => [...(result[i] || []), row[i]]),
    []
  );

const solution = (board, moves) => {
  const stacks = transpose(board).map((row) =>
    row.reverse().filter((el) => el !== 0)
  );
  const basket = [];
  let result = 0;

  for (const move of moves) {
    const pop = stacks[move - 1].pop();
    if (!pop) continue;
    if (pop === basket[basket.length - 1]) {
      basket.pop();
      result += 2;
      continue;
    }
    basket.push(pop);
  }

  return result;
};
```

- 코드를 이해하기 위해서 굉장히 많은 시간이 들었다. 코드 전체의 논리적인 순서는 다음과 같이 정리할 수 있다.
  - 2차원 배열의 행과 열을 바꾸면 크레인이 내려가는 위치에 있는 모든 인형들을 하나의 배열 안에서 접근할 수 있다.
  - 비어있는 공간은 별도의 처리를 하지 않으므로 배열에서 0은 모두 제거한다.
  - 빈 공간을 모두 제거한 배열을 앞, 뒤로 순서를 뒤집으면 가장 앞에 있는 요소가 맨 밑바닥에 있는 요소가 된다.
  - 가장 위에 쌓여있는 인형은 `pop` 메소드를 사용해서 뽑아낸다.
  - 만약, 해당 줄에 인형이 모두 뽑혔다면 다음 순서로 넘어간다.
  - 뽑은 인형이 바구니 맨 위에 담긴 인형과 같다면, 바구니에 있는 인형을 빼고, 인형 개수를 +2 한다.
  - 뽑은 인형이 바구니 맨 위에 담긴 인형과 다르다면, 인형을 바구니에 담는다.

```javascript
// 설명
- 원본 데이터는 다음과 같다.
[
	[0, 0, 0, 0, 0],
	[0, 0, 1, 0, 3],
	[0, 2, 5, 0, 1],
	[4, 2, 4, 4, 2],
	[3, 5, 1, 3, 1]
  1번 2번 3번 4번 5번
]
- 행과 열을 바꾸면 각 배열에서 크레인이 이동하는 경로에 있는
  모든 인형을 선택할 수 있다.
[
	[0, 0, 0, 4, 3], -> 1번
	[0, 0, 2, 2, 5], -> 2번
	[0, 1, 5, 4, 1], -> 3번
	[0, 0, 0, 4, 3], -> 4번
	[0, 3, 1, 2, 1]  -> 5번
]
- 배열에서 빈 공간인 0은 삭제하고, 배열을 거꾸로 뒤집는다.
- 그러면 바닥에 있는 인형들부터 순서대로 쌓인 배열이 된다.
[
	[4, 3],
	[5, 2, 2],
	[1, 4, 5, 1],
	[3, 4],
	[1, 2, 1, 3]
]
```

- 이 코드의 장점은 원본 데이터를 직접 참조해서 수정하지 않고 별도의 배열을 생성하기 때문에 데이터가 의도와는 달리 변경될 위험이 없다. 그리고 모든 배열을 돌지 않아도, 인덱스 번호만으로도 원하는 데이터에 빠르게 접근할 수 있다.
- 그럼, 코드를 순서대로 해석해보자.

### 2차원 배열의 행과 열을 바꾸기 (transpose)

- 행렬에서 주 대각선을 기준으로 행과 열을 바꾼 것을 전치행렬이라고 한다. ( 참고자료 : [전치행렬 개념](https://ko.wikipedia.org/wiki/%EC%A0%84%EC%B9%98%ED%96%89%EB%A0%AC))
- 행과 열을 바꾸는 이유는 우리가 접근하고자 하는 데이터가 열을 기준으로 움직이기 때문이다. 그러면 조금 더 직관적이고 빠르게 원하는 데이터에 접근할 수 있다.

---

> [2차원 배열의 행과 열 바꾸기(JS)](https://velog.io/@dyongdi/JS-2%EC%B0%A8%EC%9B%90-%EB%B0%B0%EC%97%B4%EC%9D%98-%ED%96%89%EA%B3%BC-%EC%97%B4-%EB%B0%94%EA%BE%B8%EA%B8%B0-Transposing-a-2D-array-in-JavaScript) 글을 참고해서 작성했습니다.

- 위의 코드에서는 `map` 과 `reduce` 를 이용해서 행과 열을 바꾸었다.

```javascript
const transpose => matrix =>
	matrix.reduce(
			(result, row) => row.map( (_, i) => [ ...( result[i]) || [] ), row[i] ] ),
			[]
	);
```

1. 2차원 배열을 `matrix` 를 인자로 받아서 `reduce` 를 실행한다.
2. `reduce` 는 콜백함수와 초기값을 인자로 받는다. 이때, 초기값을 빈 배열로 넣는 이유는 0번째 인덱스부터 accumulator에 저장하기 위함이다. (참고자료 : [배열의 reduce() 파헤치기](https://sustainable-dev.tistory.com/38))
3. `reducer` 는 인자로 받은 `row` 를 대상으로 `map` 을 실행한다. `row`의 각 원소는 `[ result 원소들, row[i] ]` 구조로 다시 `result` 에 2차원 배열로 저장된다.

---

- `map` 에서 다시 배열을 반환하는 `[ ...( result[i] || [] ), row[i] ]` 코드에 집중해서 보자.
- 스프레드 연산자 `...` 는 배열의 요소를 펼처서 저장하는 기능을 한다. 만약, 배열이 비어있으면 별도의 값이 반환되지 않는다.

```javascript
const arr = [...[1, 2, 3], 4];
const arr2 = [...[], 5];

console.log(arr); // [1, 2, 3, 4]
console.log(arr2); // [5]
```

- 따라서 `...( result[i] || [] )` 의 기능은 누산기인 `result` 의 i번째 요소인 배열이 있으면 해당 배열을 모두 펼쳐서 저장하고, 없다면 빈 배열을 반환해서 아무런 값도 저장되지 않도록 한다.
- 이때, 논리 연산자인 `||` (or)은 `null`, `NaN`, `0`, 빈 문자열(`""`, `''`, ````), `undefined`일때`false` 에 해당하는 값을 반환한다. (참고자료 : [Logical OR(||)](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Logical_OR))
- `result[i]` 는 첫 번째 루프에서 아무런 값이 존재하지 않으므로, `||` 연산에 의해 `[]` 을 반환한다. 그 다음 루프부터는 값이 존재하므로 저장된 배열 뒤에 `row[i]` 에 해당하는 값을 순차적으로 추가한다.

---

### 빈 공간 제거 및 배열 앞뒤 바꾸기

- 위의 과정을 거친 다음 빈 공간에 해당하는 `0` 을 `filter` 로 제거한다음, 스택의 형태로 만들기 위해서 `reverse` 로 배열의 순서를 바꾸어 준다.

```javascript
const stacks = transpose(board).map((row) =>
  row.reverse().filter((el) => el !== 0)
);
```

---

### 크레인의 움직임에 따라 인형 뽑기

- `for ... of` 문을 사용해서 크레인이 움직이는 경로에 있는 인형들을 뽑아낸다.

```javascript
const pop = stacks[move - 1].pop();
```

- 만약, 경로에 인형이 다 빠져서 아무 것도 존재하지 않는다면 `undefined` 를 반환할 것이다. 그럼 다음 움직임으로 넘어간다.

```javascript
const arr = [];
const pop = arr.pop();
console.log(pop); // undefined
```

- 뽑은 인형이 바구니의 최근에 쌓인 인형과 같으면 바구니에서 인형을 빼고, 결과 + 2를 한다. 그렇지 않으면, 바구니에 뽑은 인형을 넣는다.

```javascript
if (pop === basket[basket.length - 1] {
	basket.pop();
	result += 2;
	continue;
}
basket.push(pop)
```

# 배운 점

- 바구니에 담긴 마지막 인형을 찾기 위해서 `splice` 를 사용했는데, 바구니에 이전에 뽑은 인형이 사라지는 문제가 있었다. 잘라낸 값을 따로 저장하려면 변수에 할당 해주어야 하며, `splice`를 실행하면 원본 배열에서도 설정한 만큼 삭제된다.

```javascript
const arr = [1, 2, 3];
arr.splice(-1, 1);

console.log(arr);
// [1, 2]
```

```javascript
const arr = [1, 2, 3];
const arr2 = arr.splice(-1, 1);

console.log(arr);
// [1, 2]
console.log(arr2);
// [3]
```

- 원본 배열을 복사하는 방법에 대해서 찾아보다가 얕은 복사와 깊은 복사에 대해 알게 되었다. 해당 개념은 다시 다루어 볼 예정이다.
  - [[JavaScript] 얕은 복사(Shallow Copy)와 깊은 복사(Deep Copy)](https://velog.io/@recordboy/JavaScript-%EC%96%95%EC%9D%80-%EB%B3%B5%EC%82%ACShallow-Copy%EC%99%80-%EA%B9%8A%EC%9D%80-%EB%B3%B5%EC%82%ACDeep-Copy)
  - [[JavaScript] 2차원배열의 복사는 어떻게 할까?](https://woomin.netlify.app/Posts/2020-07-02-javascript-array-reference/)
- 선형대수학이나 이산수학을 배워야 할 필요성을 느꼈다.
