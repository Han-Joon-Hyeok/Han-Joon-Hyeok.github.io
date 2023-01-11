---
title: 프로그래머스 Level 2 - 뉴스 클러스터링 (JavaScript)
date: 2022-03-13 23:30:00 +0900
categories: [programmers]
tags: [level2, programmers, JavaScript]
use_math: true
---

> [프로그래머스 - Level2 뉴스 클러스터링](https://programmers.co.kr/learn/courses/30/lessons/17677#)

# 문제 설명

여러 언론사에서 쏟아지는 뉴스, 특히 속보성 뉴스를 보면 비슷비슷한 제목의 기사가 많아 정작 필요한 기사를 찾기가 어렵다. Daum 뉴스의 개발 업무를 맡게 된 신입사원 튜브는 사용자들이 편리하게 다양한 뉴스를 찾아볼 수 있도록 문제점을 개선하는 업무를 맡게 되었다.

개발의 방향을 잡기 위해 튜브는 우선 최근 화제가 되고 있는 "카카오 신입 개발자 공채" 관련 기사를 검색해보았다.

- 카카오 첫 공채..'블라인드' 방식 채용
- 카카오, 합병 후 첫 공채.. 블라인드 전형으로 개발자 채용
- 카카오, 블라인드 전형으로 신입 개발자 공채
- 카카오 공채, 신입 개발자 코딩 능력만 본다
- 카카오, 신입 공채.. "코딩 실력만 본다"
- 카카오 "코딩 능력만으로 2018 신입 개발자 뽑는다"

기사의 제목을 기준으로 "블라인드 전형"에 주목하는 기사와 "코딩 테스트"에 주목하는 기사로 나뉘는 걸 발견했다. 튜브는 이들을 각각 묶어서 보여주면 카카오 공채 관련 기사를 찾아보는 사용자에게 유용할 듯싶었다.

유사한 기사를 묶는 기준을 정하기 위해서 논문과 자료를 조사하던 튜브는 "자카드 유사도"라는 방법을 찾아냈다.

자카드 유사도는 집합 간의 유사도를 검사하는 여러 방법 중의 하나로 알려져 있다. 두 집합 `A`, `B` 사이의 자카드 유사도 `J(A, B)`는 두 집합의 교집합 크기를 두 집합의 합집합 크기로 나눈 값으로 정의된다.

예를 들어 집합 `A` = {1, 2, 3}, 집합 `B` = {2, 3, 4}라고 할 때, 교집합 `A ∩ B` = {2, 3}, 합집합 `A ∪ B` = {1, 2, 3, 4}이 되므로, 집합 `A`, `B` 사이의 자카드 유사도 `J(A, B)` = 2/4 = 0.5가 된다. 집합 A와 집합 B가 모두 공집합일 경우에는 나눗셈이 정의되지 않으니 따로 `J(A, B)` = 1로 정의한다.

자카드 유사도는 원소의 중복을 허용하는 다중집합에 대해서 확장할 수 있다. 다중집합 `A`는 원소 "1"을 3개 가지고 있고, 다중집합 `B`는 원소 "1"을 5개 가지고 있다고 하자. 이 다중집합의 교집합 `A ∩ B`는 원소 "1"을 min(3, 5)인 3개, 합집합 `A ∪ B`는 원소 "1"을 max(3, 5)인 5개 가지게 된다. 다중집합 `A` = {1, 1, 2, 2, 3}, 다중집합 `B` = {1, 2, 2, 4, 5}라고 하면, 교집합 `A ∩ B` = {1, 2, 2}, 합집합 `A ∪ B` = {1, 1, 2, 2, 3, 4, 5}가 되므로, 자카드 유사도 `J(A, B)` = 3/7, 약 0.42가 된다.

이를 이용하여 문자열 사이의 유사도를 계산하는데 이용할 수 있다. 문자열 "FRANCE"와 "FRENCH"가 주어졌을 때, 이를 두 글자씩 끊어서 다중집합을 만들 수 있다. 각각 {FR, RA, AN, NC, CE}, {FR, RE, EN, NC, CH}가 되며, 교집합은 {FR, NC}, 합집합은 {FR, RA, AN, NC, CE, RE, EN, CH}가 되므로, 두 문자열 사이의 자카드 유사도 `J("FRANCE", "FRENCH")` = 2/8 = 0.25가 된다.

## 입력 형식

- 입력으로는 `str1`과 `str2`의 두 문자열이 들어온다. 각 문자열의 길이는 2 이상, 1,000 이하이다.
- 입력으로 들어온 문자열은 두 글자씩 끊어서 다중집합의 원소로 만든다. 이때 영문자로 된 글자 쌍만 유효하고, 기타 공백이나 숫자, 특수 문자가 들어있는 경우는 그 글자 쌍을 버린다. 예를 들어 "ab+"가 입력으로 들어오면, "ab"만 다중집합의 원소로 삼고, "b+"는 버린다.
- 다중집합 원소 사이를 비교할 때, 대문자와 소문자의 차이는 무시한다. "AB"와 "Ab", "ab"는 같은 원소로 취급한다.

## 출력 형식

입력으로 들어온 두 문자열의 자카드 유사도를 출력한다. 유사도 값은 0에서 1 사이의 실수이므로, 이를 다루기 쉽도록 65536을 곱한 후에 소수점 아래를 버리고 정수부만 출력한다.

---

# 🙋‍♂️나의 풀이

## 🤔문제 접근

### 1. 요구사항 정리

1. 문자열을 두 글자씩 끊는다.
   - 영문자로 된 글자 쌍만 유효함.
   - 공백, 숫자, 특수 문자가 포함되면 해당 글자 쌍은 버린다.
2. 다중집합 원소를 비교할 때 대소문자 차이는 없음.
3. 유사도 값을 구하고 나서 65536 을 곱하고, 소수점 아래를 버리고 정수부만 반환.

### 2. 예외 처리

1. 두 집합 모두 공집합이면 자카드 유사도는 0

### 3. 구현 함수 정리

1. 문자열 파싱 함수 (parse_string)

   - 문자열을 두 글자씩 끊는 함수 (split_word)
   - 유효한 글자 쌍을 검사하는 함수 (validate_word)

2. 자카드 유사도를 구하는 함수 (get_jaccard_coefficient)
   - 교집합을 구하는 함수 (get_intersection)
   - 합집합을 구하는 함수 (get_union)

### 4. 테스트 케이스

| str1    | str2    | 교집합       | 합집합                   | answer |
| ------- | ------- | ------------ | ------------------------ | ------ |
| “aaaaa” | “”      | {}           | {aa, aa, aa, aa}         | 0      |
| “aaaaa” | "aaaab” | {aa, aa, aa} | {aa, aa, aa, aa, ab}     | 39321  |
| “aaaaa” | "aaabc” | {aa, aa}     | {aa, aa, aa, aa, ab, bc} | 21845  |

## ✍️작성 코드

```javascript
function solution(str1, str2) {
  const str1_set = parse_string(str1);
  const str2_set = parse_string(str2);
  const jaccard_coefficient = get_jaccard_coefficient(str1_set, str2_set);

  return Math.floor(jaccard_coefficient * 65536);
}

const parse_string = (str) => {
  const arr = [];
  const str_len = str.length;

  for (let i = 0; i < str_len - 1; i++) {
    const word = str.slice(i, i + 2).toLowerCase();

    if (validate_word(word) === false) continue;

    arr.push(word);
  }

  return arr;
};

const validate_word = (word) => {
  const regex = /[^a-z]/g;
  const found = word.match(regex);

  if (found === null) return true;
  else return false;
};

const get_jaccard_coefficient = (set1, set2) => {
  const intersection = get_intersection(set1, set2);
  const intersection_length = intersection.length;

  const union = get_union(set1, set2, intersection);
  const union_length = union.length;

  if (intersection_length === 0 && union_length === 0) return 1;

  return intersection_length / union_length;
};

const get_intersection = (set1, set2) => {
  const intersection = [];

  set1.forEach((curr) => {
    if (intersection.includes(curr)) return false;

    let count_in_common = 0;
    const count_in_set1 = set1.filter((elem) => curr === elem).length;
    const count_in_set2 = set2.filter((elem) => curr === elem).length;

    if (count_in_set1 > count_in_set2) count_in_common = count_in_set2;
    else count_in_common = count_in_set1;

    for (let i = 0; i < count_in_common; i++) intersection.push(curr);
  });

  return intersection;
};

const get_union = (set1, set2, intersection) => {
  const union = [];

  set1.forEach((elem) => union.push(elem));
  set2.forEach((elem) => union.push(elem));
  intersection.forEach((elem) => {
    if (union.indexOf(elem) !== -1) union.splice(union.indexOf(elem), 1);
  });

  return union;
};
```

이번 문제를 풀면서 집합을 구하는 것에 가장 많은 시간을 썼다.

두 집합이 있을 때,

- 교집합은 두 집합의 공통된 원소로 이루어진 집합이다.
- 합집합은 두 집합을 모두 더한 다음에 교집합을 뺀 것과 동일하다.

교집합을 구할 때, 원소의 중복을 허용하는 다중집합에 대한 처리가 중요했다.

- 두 집합에 공통된 원소 A가 있을 때, 교집합에 들어갈 원소의 개수는 두 집합 중에서 원소 A의 개수가 적은 집합이 기준으로 한다.

이를 위해 다음과 같은 논리로 코드를 구현했다.

- 집합 S1, S2이 있을 때, S1의 원소를 모두 순회한다.
  - 교집합에 이미 S1의 원소가 있다면 다음 원소로 넘어간다. (continue)
- 없다면 현재 원소가 S1, S2에 각각 몇 개 있는지 센다.
  - 원소의 개수가 S1 > S2 라면 S2 가 기준이 된다.
  - 원소의 개수가 S1 ≤ S2 라면 S1 이 기준이 된다.
- 기준이 되는 집합에 포함된 원소의 개수만큼 교집합에 원소를 추가한다.

## ⚙️리팩토링

- 두 집합이 공집합인 경우는 자카드 유사도를 구하기 전에 예외처리를 수행함으로써 실행 속도를 높일 수 있다.

  ```javascript
  function solution(str1, str2) {
      const str1_set = parse_string(str1);
      const str2_set = parse_string(str2);

      // 예외 처리 추가
      if (str1_set.length === 0 && str2_set.length === 0)
          return (65536);

      ...
  }

  // 주석으로 처리한 부분 삭제
  const get_jaccard_coefficient = (set1, set2) => {
      const intersection = get_intersection(set1, set2);
      // const intersection_length = intersection.length;

      const union = get_union(set1, set2, intersection);
      // const union_length = union.length;

      // if (intersection_length === 0 && union_length === 0)
      //    return (1);

      return (intersection.length / union.length);
  }

  ```

---

# 👀참고한 풀이

```javascript
function solution(str1, str2) {
  function explode(text) {
    const result = [];
    for (let i = 0; i < text.length - 1; i++) {
      const node = text.substr(i, 2);
      if (node.match(/[A-Za-z]{2}/)) {
        result.push(node.toLowerCase());
      }
    }
    return result;
  }

  const arr1 = explode(str1);
  const arr2 = explode(str2);
  const set = new Set([...arr1, ...arr2]);
  let union = 0;
  let intersection = 0;

  set.forEach((item) => {
    const has1 = arr1.filter((x) => x === item).length;
    const has2 = arr2.filter((x) => x === item).length;
    union += Math.max(has1, has2);
    intersection += Math.min(has1, has2);
  });
  return union === 0 ? 65536 : Math.floor((intersection / union) * 65536);
}
```

- `Set` 를 활용해서 교집합과 합집합을 쉽게 구했다.
  - `Set` 은 중복된 값이 없는 객체이다.
- 예를 들어, S1 = {1, 1, 2, 3}, S2 = {1, 2, 4} 라고 하자.
  - `Set`는 {1, 2, 3, 4} 이다.
  - `Set` 의 원소를 하나씩 순회하며 S1과 S2의 원소와 비교한다.

| Set | S1  | 결과   | S2  | 결과   |
| --- | --- | ------ | --- | ------ |
| 1   | 1   | 일치   | 1   | 일치   |
|     | 1   | 일치   | 2   | 불일치 |
|     | 2   | 불일치 | 4   | 불일치 |
|     | 3   | 불일치 |     |        |

- 원소 A에 대해 합집합은 두 집합 중 원소 A를 더 많이 가지고 있는 집합이, 교집합에는 원소 A를 적게 가지고 있는 집합이 원소의 개수를 결정한다.

  - 위의 예시에서는 1에 대해 S1이 2개를, S2는 1개를 가지고 있다. 따라서 합집합에는 S1에 포함된 1의 개수만큼, 교집합에는 S2에 포함된 원소의 개수만큼 포함된다.
  - 위의 과정을 `Set` 의 모든 원소에 대해 진행한다.
  - 즉, 각각의 집합이 가지고 있는 원소의 개수 중 최댓값은 합집합에, 최솟값은 교집합에 개수를 추가한다.

- 코드로 표현하면 다음과 같다.
  ```javascript
  set.forEach((item) => {
    const has1 = arr1.filter((x) => x === item).length;
    const has2 = arr2.filter((x) => x === item).length;
    union += Math.max(has1, has2);
    intersection += Math.min(has1, has2);
  });
  ```
