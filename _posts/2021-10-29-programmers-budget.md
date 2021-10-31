---
title: 프로그래머스 Level 1 - 예산 (Javascript)
date: 2021-10-29 22:00:00 +0900
categories: [programmers]
tags: [level1, programmers]
---
> [프로그래머스 - Level 1 예산](https://programmers.co.kr/learn/courses/30/lessons/12939)

# 문제 설명

S사에서는 각 부서에 필요한 물품을 지원해 주기 위해 부서별로 물품을 구매하는데 필요한 금액을 조사했습니다. 그러나, 전체 예산이 정해져 있기 때문에 모든 부서의 물품을 구매해 줄 수는 없습니다. 그래서 최대한 많은 부서의 물품을 구매해 줄 수 있도록 하려고 합니다.

물품을 구매해 줄 때는 각 부서가 신청한 금액만큼을 모두 지원해 줘야 합니다. 예를 들어 1,000원을 신청한 부서에는 정확히 1,000원을 지원해야 하며, 1,000원보다 적은 금액을 지원해 줄 수는 없습니다.

부서별로 신청한 금액이 들어있는 배열 d와 예산 budget이 매개변수로 주어질 때, 최대 몇 개의 부서에 물품을 지원할 수 있는지 return 하도록 solution 함수를 완성해주세요.

## 제한사항

- d는 부서별로 신청한 금액이 들어있는 배열이며, 길이(전체 부서의 개수)는 1 이상 100 이하입니다.
- d의 각 원소는 부서별로 신청한 금액을 나타내며, 부서별 신청 금액은 1 이상 100,000 이하의 자연수입니다.
- budget은 예산을 나타내며, 1 이상 10,000,000 이하의 자연수입니다.

## 입출력 예

|d|budget|result|
|---|---|---|
|[1, 3, 2, 5, 4]|9|3|
|[2, 2, 3, 3]|10|4|

## 🙋‍♂️나의 풀이

- 처음에는 조합으로 문제를 접근했다. 원소들의 조합을 각각 더했을 때, `budget`을 초과하지 않으면 해당 조합의 원소 개수를 배열에 넣는 식으로 구현했다.
- 즉, `budget`을 전부 다 쓸 수 있는 조합을 생각했다.
- 처음 생각한 코드는 다음과 같고, 정확성 87점을 받았다.

```javascript
function solution(d, budget) {
    let combinationArr = [];
    const sumReducer = (acc, cur) => acc + cur

    for(let i = 0; i < d.length; i++){
        for(let j = i+1; j < d.length; j++){
            const tempArr = sortedArr.slice(0, i+1)
            tempArr.push(d[j])
            const sum = tempArr.reduce(sumReducer)

            if(sum <= budget){
                combinationArr.push(tempArr.length)
            }
        }
    }

    if(combinationArr.length > 0){
        return Math.max(...combinationArr);        
    } else {
        return 0;
    }
}
```

- 혹시나 하는 마음에 배열을 오름차순으로 정렬하고, 낮은 금액부터 순서대로 차감하다가 예산이 초과되면 해당 인덱스를 반환하도록 했다. 그랬더니 바로 해결이 됐다.
- 처음 작성한 코드는 모든 조합을 만들어내고 있지는 못한데, 다시 조합 코드를 작성해서 테스트 해봐야 겠다.

```javascript
function solution(d, budget) {
    const compareNumbers = (a, b) => a - b
    const sortedArr = d.sort(compareNumbers)

    for(let i = 0; sortedArr.length; i++){
        const curr = sortedArr[i]
        if(budget - curr >= 0){
            budget -= curr
        } else{
            answer = i
            break;
        }
    }

    return answer
}
```

## 👀참고한 풀이

```javascript
function solution(d, budget) {
	// 만약 [1, 3, 2, 5, 4]가 주어진다면
	d.sort((a, b) => a - b);
	// [1, 2, 3, 4, 5]

  while (d.reduce((a, b) => (a + b), 0) > budget) d.pop();
	// [1, 2, 3, 4, 5]
	// [1, 2, 3, 4]

  return d.length;
	// 4
}
```

- 배열을 오름차순으로 정렬한 뒤, `reduce` 를 사용해서 배열에 있는 값을 더한다.
- 더한 값이 예산보다 크면 배열 원소를 하나씩 제거한다.
- 예산보다 작거나 같아지는 순간이 가장 많은 부서를 지원할 수 있는 개수이므로, 해당 배열의 개수를 반환한다.
