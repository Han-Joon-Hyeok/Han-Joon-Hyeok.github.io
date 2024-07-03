---
title: "프로그래머스 Level 1 - [PCCE 기출문제] 10번 / 데이터 분석 (Java)"
date: 2024-07-03 13:00:00 +0900
categories: [programmers]
tags: [level1, programmers, Java]
use_math: true
---

> [프로그래머스 - Level1 [PCCE 기출문제] 10번 / 데이터 분석](https://school.programmers.co.kr/learn/courses/30/lessons/250121)
>

# 문제 설명

문제 설명 생략

# 🙋‍♂️나의 풀이

## 🤔문제 접근

- `data` 2중 배열을 순회한다.
    - 데이터를 뽑아낼 기준인 `ext` 에 해당하는 값이 `val_ext` 보다 작은 배열을 찾는다.
    - 정렬을 기준으로 하는 값이 되는 `sort_by` 항목의 값과 해당 배열이 `data` 2중 배열에서 몇 번째 인덱스인지 Key(`sort_by` 값), Value(`index`) 형태로 `TreeMap<Integer, Integer>` 에 저장한다.
    - TreeMap 을 사용하는 이유는 문제의 제한 사항에서 `정렬 기준에 해당하는 값이 서로 같은 경우는 없습니다.` 라고 명시되어 있기에 정렬 기준에 해당하는 값을 Key 로 사용해도 Map 에서 중복되는 경우가 없기 때문이다. 또한, 오름차순으로 정렬해야 하기 때문에 원소들을 Key 값 기준으로 자동으로 정렬하는 TreeMap 을 사용했다.
- TreeMap 원소들을 처음부터 순회하면 Key 값이 작은 값부터 순회하기 때문에 Value 에 해당하는 인덱스 값을 이용해서 `data` 배열에서 `answer` 배열에 담는다.

## ✍️작성 코드

```java
import java.util.TreeMap;
import java.util.HashMap;
import java.util.Map;

class Solution {
    private static final String[] EXT_ARRAY = {"code", "date", "maximum", "remain"};
    private static final Map<String, Integer> EXT_MAP = new HashMap<>();

    static {
        for (int idx = 0; idx < EXT_ARRAY.length; idx += 1) {
            EXT_MAP.put(EXT_ARRAY[idx], idx);
        }
    }

    public static int getIndexByValue(String value) {
        return EXT_MAP.get(value);
    }

    public int[][] solution(int[][] data, String ext, int val_ext, String sort_by) {

        TreeMap<Integer, Integer> selectedMap = new TreeMap<>();
        int extIdx = getIndexByValue(ext);
        int sortIdx = getIndexByValue(sort_by);

        for (int idx = 0; idx < data.length; idx += 1) {
            int conditionValue = data[idx][extIdx];
            if (conditionValue < val_ext) {
                int sortValue = data[idx][sortIdx];
                selectedMap.put(sortValue, idx);
            }
        }

        int answer[][] = new int[selectedMap.size()][];
        int idx = 0;

        for (Map.Entry<Integer, Integer> entry: selectedMap.entrySet()) {
            int value = entry.getValue();
            answer[idx] = data[value];
            idx += 1;
        }

        return answer;
    }
}
```

java 를 이용해서 코딩테스트 문제를 푸는 것은 처음이기도 하고, 그동안 C, C++, JavaScript 를 주로 사용해서 java 문법이 익숙하지 않다보니 코드가 다소 지저분하다.

문자열을 배열 형태로 저장해서 `ext` 변수가 몇 번째 인덱스에 해당하는지 확인하기 위해 enum 을 이용하려고 했는데, 코드가 길어져서 사용하지 않았다.

대신, 문자열 배열을 선언한다음 `Map<String, Integer>` 에 문자열의 인덱스 값을 넣었다. Key 로 접근해야 Value 를 조금 더 빠르게 얻어낼 수 있다고 생각했기 때문이다.

하지만 순회해야 할 배열의 원소가 4개 밖에 되지 않기 때문에 문자열 배열을 이용해서 인덱스를 구해도 괜찮았을 것 같다.

# 👀참고한 풀이

```java
import java.util.*;

class Solution {
    public int[][] solution(int[][] data, String ext, int val_ext, String sort_by) {

        String[] arr = {"code","date","maximum","remain"};
        List<String> columnList = Arrays.asList(arr);
        int extIdx = columnList.indexOf(ext);
        int sortIdx = columnList.indexOf(sort_by);
        int[][] answer = Arrays.stream(data).filter(o1 -> o1[extIdx] < val_ext)
            .sorted((o1 ,o2) -> o1[sortIdx]-o2[sortIdx]).toArray(int[][]::new);

        return answer;
    }
}
```

- 문자열의 인덱스를 찾기 위해 Map 을 사용하지 않고 문자열 배열을 List 로 변환했다.
- 조건에 맞는 배열을 찾고 정렬하기 위해 stream 을 이용했다. 아직 stream 에 익숙하지 않은데, JavaScript 의 메서드 체이닝처럼 사용할 수 있어서 편리할 것 같다.