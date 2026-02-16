---
title: HackerRank - Counting Valleys (JavaScript)
date: 2021-11-09 11:24:00 +0900
categories: [hackerrank]
tags: [hackerrank, javascript]
use_math: true
---

> [HackerRank - Counting Valleys](https://www.hackerrank.com/challenges/counting-valleys/problem)

# Problem

An avid hiker keeps meticulous records of their hikes. During the last hike that took exactly  steps, for every step it was noted if it was an *uphill*, , or a *downhill*,  step. Hikes always start and end at sea level, and each step up or down represents a  unit change in altitude. We define the following terms:

- A *mountain* is a sequence of consecutive steps *above* sea level, starting with a step *up* from sea level and ending with a step *down* to sea level.
- A *valley* is a sequence of consecutive steps *below* sea level, starting with a step *down* from sea level and ending with a step *up* to sea level.

Given the sequence of *up* and *down* steps during a hike, find and print the number of *valleys* walked through.

## Constraints

- $2 \leq steps \leq 10^6$
- $path[i] \in \{U D\}$

## 🙋‍♂️ Solution

```javascript
function countingValleys(n, path) {
  // Write your code here
  let isInValley = false;
  let valleyCount = 0;
  let currentAltitude = 0;
  const steps = path.split("");

  steps.map((step) => {
    if (step === "D") currentAltitude--;
    if (step === "U") currentAltitude++;

    if (currentAltitude < 0 && !isInValley) {
      isInValley = true;
      valleyCount++;
    }
    if (currentAltitude >= 0) {
      isInValley = false;
    }
  });

  return valleyCount;
}
```

- 현재 고도가 0보다 낮고, 협곡에 처음 들어갔을 때만 `valleyCount` 를 + 1 한다.
- 현재 고도가 0보다 같거나 크면 `isInValley` 를 false 로 바꾼다.

## 👀 Other Solution

```javascript
function countingValleys(n, s) {
  let steps = s.split("");
  let valleyCount = 0;
  let currentSeaLevel = 0;
  let valleyStatus = false;
  steps.forEach((step) => {
    step === "U" ? currentSeaLevel++ : currentSeaLevel--;
    if (currentSeaLevel < 0 && !valleyStatus) {
      valleyCount++;
      valleyStatus = true;
    } else if (currentLevel >= 0 && valleyStatus) {
      valleyStatus = false;
    }
  });
  return valleyCount;
}
```

- 풀이는 비슷하지만, 변수명을 이해하기 쉽게 짓는 방법을 참고했다.
