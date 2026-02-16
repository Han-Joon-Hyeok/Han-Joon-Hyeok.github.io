---
title: "프로그래머스 Level 1 - 가장 많이 받은 선물 (Java)"
date: 2024-07-08 14:40:00 +0900
categories: [programmers]
tags: [level1, programmers, java]
use_math: true
---
> [프로그래머스 - Level1 가장 많이 받은 선물](https://school.programmers.co.kr/learn/courses/30/lessons/258712)
>

# 문제 설명

문제 설명 생략

# 🙋‍♂️나의 풀이

## 🤔문제 접근

- 서로 주고 받은 선물의 개수와 선물 지수를 구하기 위해 아래와 같은 형식으로 데이터를 정리했다.

    ```json
    {
    	"giver1": {
    		"receiver1": 2,  // giver1 -> receiver1 에게 준 선물 개수
    		"receiver2": 2,  // giver1 -> receiver2 에게 준 선물 개수
    		"index": 4       // 선물 지수
    	},
    	...
    }
    ```

    - `giver` 의 값에 해당하는 객체에서는 `giver` 자신 스스로를 제외한 다른 사람들에게 준 선물의 개수와 선물 지수(index)를 저장했다.
- `friends` 배열을 순회하면서 `giver` 가 다른 사람들과 주고 받은 선물의 개수와 선물 지수를 비교해서 선물을 받아야 하는지 판단한다.
    - 선물을 받아야 한다면 ‘받아야 하는 선물 개수’에 해당하는 변수 `count` + 1 을 한다.

## ✍️작성 코드

```java
import java.util.HashMap;
import java.util.Map.Entry;

class Solution {
    private HashMap<String, HashMap<String, Integer>> initializeData(String[] friends) {
        HashMap<String, HashMap<String, Integer>> data = new HashMap<>();

        for (String name : friends) {
            HashMap<String, Integer> history = new HashMap<>();
            for (String key : friends) {
                history.put(key, 0);
            }
            history.put("index", 0);
            data.put(name, history);
        }

        return data;
    }

    private void calculateGiftExchanges(HashMap<String, HashMap<String, Integer>> data, String[] gifts) {
        for (String log : gifts) {
            String[] split = log.split(" ");
            String giver = split[0];
            String receiver = split[1];
            HashMap<String, Integer> giverHistory = data.get(giver);
            giverHistory.replace(receiver, giverHistory.get(receiver) + 1);
            giverHistory.replace("index", giverHistory.get("index") + 1);

            HashMap<String, Integer> receiverHistory = data.get(receiver);
            receiverHistory.replace("index", receiverHistory.get("index") - 1);
        }
    }

    private int getMaximumCount(HashMap<String, HashMap<String, Integer>> data, String[] friends) {
        int answer = 0;

        for (String giver : friends) {
            int count = 0;
            HashMap<String, Integer> giverHistory = data.get(giver);
            for (String receiver : friends) {
                if (giver == receiver) {
                    continue;
                }

                HashMap<String, Integer> receiverHistory = data.get(receiver);
                int giverCount = giverHistory.get(receiver);
                int receiverCount = receiverHistory.get(giver);
                int giverIndex = giverHistory.get("index");
                int receiverIndex = receiverHistory.get("index");
                if (giverCount > receiverCount) {
                    count += 1;
                } else if (giverCount == receiverCount && giverIndex > receiverIndex) {
                    count += 1;
                }
                answer = Math.max(answer, count);
            }
        }

        return answer;
    }

    public int solution(String[] friends, String[] gifts) {
        HashMap<String, HashMap<String, Integer>> data;
        data = initializeData(friends);
        calculateGiftExchanges(data, gifts);

        return getMaximumCount(data, friends);
    }
}
```

코드가 깔끔하진 않지만, 로직을 함수로 분리해서 다시 코드를 읽더라도 이해하기 쉽게 작성하려고 노력했다.

```java
private HashMap<String, HashMap<String, Integer>> initializeData(String[] friends) {
    HashMap<String, HashMap<String, Integer>> data = new HashMap<>();

    for (String name : friends) {
        HashMap<String, Integer> history = new HashMap<>();
        for (String key : friends) {
            history.put(key, 0);
        }
        history.put("index", 0);
        data.put(name, history);
    }

    return data;
}
```

서로 주고 받은 선물의 개수와 선물 지수에 대한 정보를 담기 위해 HashMap 을 이용했고, 위의 코드는 이를 초기화 하는 함수이다.

`HashMap<String, HashMap<String, Integer>>` 의 Key 는 선물을 준 사람을 의미하고, Value 는 Key 에 해당하는 사람이 다른 사람에게 몇 번 선물을 줬는지 `HashMap<String, Integer>` 에 정보를 저장했다.

그래서 아래와 같이 데이터가 초기화된다.

```json
{
	"a": {
		"b": 0,
		"c": 0,
		"index": 0
	},
	"b": {
		"a": 0,
		"c": 0,
		"index": 0
	},
	"c": {
		"a": 0,
		"b": 0,
		"index": 0
	}
}
```

다만, 과연 선물 지수에 해당하는 `index` 를 키에 포함 시키는 것보다 별도의 배열에 저장하는 것이 조금 더 나았을 것 같다.

만약, 사람 이름이 `index` 인 경우에는 정보가 제대로 반영되지 않을 수도 있다.

그리고 선물을 주고 받은 횟수를 저장하는 변수에 선물 지수가 포함되므로 데이터의 일관성도 부족하다.

데이터 초기화 이후 누가 누구에게 선물을 주었는지 횟수를 기록하고, 선물 지수를 동시에 계산했다.

선물 지수는 `자신이 친구들에게 준 선물의 수에서 받은 선물의 수를 뺀 값` 이기 때문에 다른 사람에게 선물을 주었다면 나의 선물 지수 + 1 을 하고, 받은 사람의 선물 지수를 - 1 을 하면 된다.

```java
private void calculateGiftExchanges(HashMap<String, HashMap<String, Integer>> data, String[] gifts) {
    for (String log : gifts) {
        String[] split = log.split(" ");
        String giver = split[0];
        String receiver = split[1];
        HashMap<String, Integer> giverHistory = data.get(giver);
        giverHistory.replace(receiver, giverHistory.get(receiver) + 1);
        giverHistory.replace("index", giverHistory.get("index") + 1);

        HashMap<String, Integer> receiverHistory = data.get(receiver);
        receiverHistory.replace("index", receiverHistory.get("index") - 1);
    }
}
```

선물을 가장 많이 받은 횟수를 구하기 위해 `friends` 배열을 순회하면서 서로가 서로에게 선물을 주고 받은 횟수를 비교한다.

a, b, c 가 서로 선물을 주고 받았다면, 아래와 같은 순서로 비교하는 것이다.

1. a 가 b, c 와 선물 주고 받은 횟수를 비교
2. b 가 a, c 와 선물 주고 받은 횟수를 비교
3. c 가 b, c 와 선물 주고 받은 횟수를 비교

1~3 과정에서 가장 많이 받은 횟수를 `answer` 변수에 담아서 저장한다.

```java
private int getMaximumCount(HashMap<String, HashMap<String, Integer>> data, String[] friends) {
    int answer = 0;

    for (String giver : friends) {
        int count = 0;
        HashMap<String, Integer> giverHistory = data.get(giver);
        for (String receiver : friends) {
            if (giver == receiver) {
                continue;
            }

            HashMap<String, Integer> receiverHistory = data.get(receiver);
            int giverCount = giverHistory.get(receiver);
            int receiverCount = receiverHistory.get(giver);
            int giverIndex = giverHistory.get("index");
            int receiverIndex = receiverHistory.get("index");

            if (giverCount > receiverCount) {
                count += 1;
            } else if (giverCount == receiverCount && giverIndex > receiverIndex) {
                count += 1;
            }
            answer = Math.max(answer, count);
        }
    }

    return answer;
}
```

# 👀참고한 풀이

```java
import java.util.*;

class Solution {
    public int solution(String[] friends, String[] gifts) {
        Map<String, Integer> map = new HashMap<>();
        for (int i = 0; i < friends.length; i++) {
            map.put(friends[i], i);
        }
        int[] index = new int[friends.length];
        int[][] record = new int[friends.length][friends.length];

        for (String str : gifts) {
            String[] cur = str.split(" ");
            index[map.get(cur[0])]++;
            index[map.get(cur[1])]--;
            record[map.get(cur[0])][map.get(cur[1])]++;
        }

       int ans = 0;
       for (int i = 0; i < friends.length; i++) {
           int cnt = 0;
           for (int j = 0; j < friends.length; j++) {
               if(i == j) continue;
               if (record[i][j] > record[j][i]) cnt++;
               else if (record[i][j] == record[j][i] && index[i] > index[j]) cnt++;
           }
           ans = Math.max(cnt, ans);
       }
        return ans;
    }
}

```

HashMap 을 이용하긴 했지만, 선물 지수와 선물을 주고 받은 횟수를 배열에 저장했다.

초기화, 선물 지수 계산 및 선물 교환 이력 계산, 가장 많은 선물을 받는 횟수 계산의 흐름은 나의 코드와 동일하지만, 선물 지수 계산 및 교환 이력 계산 과정에서 배열을 이용해서 조금 더 깔끔하고 간결하게 표현한 것 같다.