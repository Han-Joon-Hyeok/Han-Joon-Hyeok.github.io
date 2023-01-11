---
title: 프로그래머스 Level 2 - 문자열 압축 (Javascript)
date: 2021-10-31 16:00:00 +0900
categories: [programmers]
tags: [level2, programmers]
---
> [프로그래머스 - Level2 문자열 압축](https://programmers.co.kr/learn/courses/30/lessons/60057)

# 문제 설명

데이터 처리 전문가가 되고 싶은 **어피치**는 문자열을 압축하는 방법에 대해 공부를 하고 있습니다. 최근에 대량의 데이터 처리를 위한 간단한 비손실 압축 방법에 대해 공부를 하고 있는데, 문자열에서 같은 값이 연속해서 나타나는 것을 그 문자의 개수와 반복되는 값으로 표현하여 더 짧은 문자열로 줄여서 표현하는 알고리즘을 공부하고 있습니다.간단한 예로 "aabbaccc"의 경우 "2a2ba3c"(문자가 반복되지 않아 한번만 나타난 경우 1은 생략함)와 같이 표현할 수 있는데, 이러한 방식은 반복되는 문자가 적은 경우 압축률이 낮다는 단점이 있습니다. 예를 들면, "abcabcdede"와 같은 문자열은 전혀 압축되지 않습니다. "어피치"는 이러한 단점을 해결하기 위해 문자열을 1개 이상의 단위로 잘라서 압축하여 더 짧은 문자열로 표현할 수 있는지 방법을 찾아보려고 합니다.

예를 들어, "ababcdcdababcdcd"의 경우 문자를 1개 단위로 자르면 전혀 압축되지 않지만, 2개 단위로 잘라서 압축한다면 "2ab2cd2ab2cd"로 표현할 수 있습니다. 다른 방법으로 8개 단위로 잘라서 압축한다면 "2ababcdcd"로 표현할 수 있으며, 이때가 가장 짧게 압축하여 표현할 수 있는 방법입니다.

다른 예로, "abcabcdede"와 같은 경우, 문자를 2개 단위로 잘라서 압축하면 "abcabc2de"가 되지만, 3개 단위로 자른다면 "2abcdede"가 되어 3개 단위가 가장 짧은 압축 방법이 됩니다. 이때 3개 단위로 자르고 마지막에 남는 문자열은 그대로 붙여주면 됩니다.

압축할 문자열 s가 매개변수로 주어질 때, 위에 설명한 방법으로 1개 이상 단위로 문자열을 잘라 압축하여 표현한 문자열 중 가장 짧은 것의 길이를 return 하도록 solution 함수를 완성해주세요.

## 제한사항

- s의 길이는 1 이상 1,000 이하입니다.
- s는 알파벳 소문자로만 이루어져 있습니다.

## 🙋‍♂️나의 풀이

- 문자열을 자를 수 있는 반복 단위의 모든 조합을 구한 다음, 압축 후 문자열의 길이가 가장 짧은 것을 반환한다.
- 이중 반복문을 사용했는데, 외부 반복문은 반복해서 처리할 문자열의 길이를 관리하고, 내부 반복문은 맨 앞에서부터 길이만큼 자르며 그 다음 문자열과 일치하는 지 확인하는 방식으로 구현했다.
- 최대 반복 단위는 문자열의 길이보다 작거나 **같아야** 한다. 이때, '같다'는 조건이 들어간 이유는 한 글자인 경우에 반복 단위가 문자열의 길이와 같아야 하기 때문이다.
- 처음에 `1a1b` 와 같은 경우에 1을 제거하기 위해 정규식을 `/1/g` 로 설정하고 마지막 결과에 `replace`로 제거해주었다. 하지만, 문자가 10개나 100개 같이 맨 앞에 1이 들어가는 경우에는 `10x2y` 가 아니라 `0x2y` 로 맨 앞의 글자가 잘리는 문제가 있었다.
- 다른 분들의 테스트 케이스 힌트를 참고한 덕분에 정규식을 제거하니 나머지 테스트 케이스들을 풀 수 있었다.

```javascript
function solution(s) {
    
    let answer = ''
    const compressedLength = []
    const MAX_REPETITION = s.length
    
    for(let unit = 1; unit <= MAX_REPETITION; unit++){
        for(let idx = 0, cnt = 1; idx < MAX_REPETITION; idx += unit){
            const pattern = s.slice(idx, idx + unit)
            const nextChars = s.slice(idx + unit, idx + 2*unit)
            if(pattern === nextChars){
                cnt++
                continue
            } else{
                cnt = cnt === 1 ? '' : cnt
                answer += `${cnt}${pattern}`
                cnt = 1
            }
        }
        
        const wordLength = answer.length
        compressedLength.push(wordLength)
        answer = ''
        
    }
    
    return Math.min(...compressedLength);
}
```

## 👀참고한 풀이

```javascript
const solution = s => {
  const range = [...Array(s.length)].map((_, i) => i + 1);
  return Math.min(...range.map(i => compress(s, i).length));
};

const compress = (s, n) => {
  const make = ([a, l, c]) => `${a}${c > 1 ? c : ''}${l}`;
  return make(
    chunk(s, n).reduce(
      ([a, l, c], e) => e === l ? [a, l, c + 1] : [make([a, l, c]), e, 1],
      ['', '', 0]
    )
  );
};

const chunk = (s, n) =>
  s.length <= n ? [s] : [s.slice(0, n), ...chunk(s.slice(n), n)];
```

- 솔직히 어떤 식으로 돌아가는 지 이해가 안된다. 다음에 다시 복습하게 되면 이해해봐야지.