---
title: 프로그래머스 Level 0 - 저주의 숫자 3 (C++)
date: 2023-10-31 18:00:00 +0900
categories: [programmers]
tags: [level0, programmers, c++]
use_math: true
---
> [프로그래머스 - Level0 저주의 숫자 3](https://school.programmers.co.kr/learn/courses/30/lessons/120871?language=cpp)
>

# 문제 설명

3x 마을 사람들은 3을 저주의 숫자라고 생각하기 때문에 3의 배수와 숫자 3을 사용하지 않습니다. 3x 마을 사람들의 숫자는 다음과 같습니다.

| 10진법 | 3x 마을에서 쓰는 숫자 | 10진법 | 3x 마을에서 쓰는 숫자 |
| --- | --- | --- | --- |
| 1 | 1 | 6 | 8 |
| 2 | 2 | 7 | 10 |
| 3 | 4 | 8 | 11 |
| 4 | 5 | 9 | 14 |
| 5 | 7 | 10 | 16 |

정수 `n`이 매개변수로 주어질 때, `n`을 3x 마을에서 사용하는 숫자로 바꿔 return하도록 solution 함수를 완성해주세요.

## 제한사항

• 1 ≤ `n` ≤ 100

# 🙋‍♂️나의 풀이

## 🤔문제 접근

문제를 풀다가 40분 이상 해결책이 생각나지 않아서 다른 분의 코드를 확인해서 풀었다.

- 3x 마을에서 사용하는 숫자 체계에는 3의 배수와 숫자 3이 들어간 수를 사용하지 않는다.
    - 3의 배수 : 3, 6, 9, 12 …
    - 숫자 3이 들어간 수 : 3, 13, 23, 30, 31, 32, …, 130
- 10진법 9가 3x 마을에서 14가 되는 이유는 아래와 같다.
    - 11 + 1 = 12 : 3의 배수니까 1을 한번 더 더해서 13이 된다.
    - 13 : 3이 들어간 수이기 때문에 한번 더 더해서 14가 된다.

3의 배수를 찾는 건 단순히 나머지를 확인하면 된다.

한편, 숫자에 3이 포함되었는지 확인하는 방법은 크게 2가지로 나뉜다.

1. 숫자를 문자열로 변환해서 3이 포함되었는지 확인한다.

    ```cpp
    #include <string>

    using namespace std;

    bool isCharIncluded(int n) {
    	string str_num = to_string(n)
    	if (str_num.find('3') != string::npos) {
    		return true;
    	}
    	return false;
    }
    ```

    - string 클래스의 메서드인 find 는 문자열 안에서 문자 또는 문자열을 검색한다. 이 메서드는 찾고자 하는 값이 없다면 string::npos 를 반환하고, 찾았다면 해당 값이 시작하는 인덱스의 값을 반환한다.
    - 이 방법은 직관적인 장점이 있다. 하지만, 반복문 안에서 계속 문자열을 생성하고, 숫자의 값이 커질 수록 차지하는 메모리 공간이 커질 수 있다는 단점이 있다.
2. 숫자를 10으로 계속 나누어서 마지막 1의 자리 수를 확인한다.

    ```cpp
    using namespace std;

    bool isCharIncluded(int n) {
    	while (n > 0) {
    		if (n % 10 == 3) {
    			return (true);
    		}
    		n /= 10;
    	}
    	return (false);
    }
    ```

    - n 을 10으로 나누어서 0이 되지 않을 때까지 계속 10으로 나눈다. 그리고 이 값을 10으로 나눈 나머지가 3인지 확인하면 된다.
    - 이 방법은 string 클래스를 사용하지 않기 때문에 문자열을 별도로 메모리에 생성하지 않는 장점이 있다. 단점으로는 숫자가 커질 수록 반복문을 많이 돌아야 한다는 것이다.

2가지 방법 중 어떤 방법이 효율적인지는 정확하게 말할 수 없다.

개인적으로는 적은 메모리 공간을 사용해야 하는 경우라면 2번을 사용해야 할 것이고, 그렇지 않다면 1번이 훨씬 직관적인 방법인 것 같다.

## ✍️작성 코드

1번 방법에 따라 작성한 코드는 아래와 같다.

```cpp
#include <string>

using namespace std;

bool isCharIncluded(int n) {
    string str;

    str = to_string(n);
    if (str.find('3') == string::npos) {
        return (false);
    }
    return (true);
}

int solution(int n) {
    int answer = 0;

    for (int idx = 1; idx <= n; idx++) {
        answer += 1;

        while (answer % 3 == 0 || isCharIncluded(answer)) {
            answer += 1;
        }
    }

    return answer;
}
```

- 2중 반복문을 사용해서 현재 숫자가 3x 마을의 숫자 규칙에 위배되는 값이라면 규칙을 만족하는 값이 될 때까지 계속 값을 증가시켰다. 2중 반복문을 사용해야 한다는 접근을 떠올리지 못해서 쉽게 풀지 못했다.

# 👀참고한 풀이

문제를 처음 풀기 위해 들어가면 vector 가 include 되어 있는 것을 확인할 수 있다.

즉, vector 를 이용해서 풀 수도 있다는 것을 의미하는 것이다.

vector 를 이용한 풀이 코드는 아래와 같다.

그리고 숫자에서 3을 찾는 로직은 위에서 언급한 2번 방법을 사용했다.

```cpp
#include <string>
#include <vector>

using namespace std;

bool isCharIncluded(int n) {
	while (n > 0) {
		if (n % 10 == 3) {
			return (true);
		}
		n /= 10;
	}
	return (false);
}

int solution(int n) {
		vector<int> arr;

    for (int idx = 1; arr.size() < n; idx++) {
        if (idx % 3 > 0 || isCharIncluded(idx) == false) {
					arr.push_back(idx);
				}
    }

    return (*arr.rbegin());
}
```

n=3 일 때, 위 코드의 실행 결과는 아래의 표와 같다.

| n | idx | arr.push_back(idx) | arr.size() |
| --- | --- | --- | --- |
| 3 | 1 | 1 | 1 |
|  | 2 | 2 | 2 |
|  | 3 |  | 2 |
|  | 4 | 4 | 3 |

vector 에 숫자를 넣는 것은 3의 배수가 아니거나 숫자에 3이 들어가지 않는 경우에만 수행한다.

즉, 배열에는 마을의 규칙에 따라 변환한 숫자의 결과값만 존재하는 것이다.

매개변수로 주어진 n 만큼 배열을 채우고, n 이 변환된 값은 vector 의 마지막 요소이므로 arr.rbegin() 을 사용해서 역참조를 했다.

## emplace_back 과 push_back 의 차이

vector 의 요소를 추가하는 메서드에는 emplace_back 과 push_back 이 존재한다.

두 메서드는 어떤 차이를 가지고 있을까?

### push_back

```cpp
class Item {
	private:
		int num_;

	public:
	 Item(const int& num) : num_(num){ cout << "기본 생성자 호출" << endl; }
	 Item(const Item& rhs) : num_(rhs.num_) { cout << "복사 생성자 호출" << endl; }
	 Item(const Item&& rhs) : num_(std::move(rhs.num_)) { cout << "이동 생성자 호출" << endl; }
	 ~Item() { cout << "소멸자 호출" << endl; }
};

int main(void) {
	std::vector<Item> vec;

	vec.push_back(Item(2));
}
```

실행 결과는 아래와 같다.

```
기본 생성자 호출
이동 생성자 호출
소멸자 호출
소멸자 호출
```

push_back 함수를 통해 객체를 삽입하기 위해서 아래와 같은 과정을 거친다.

1. `vec.push_back(Item(2))` 에서 `Item(2)` 를 위한 임시 객체 생성(기본 생성자 호출)
2. 1번에서 생성한 임시 객체를 이동 생성자를 통해 push_back 함수 내부에서 임시 객체 생성
3. 2번에서 생성한 임시 객체를 vector 에 삽입
4. push_back 함수를 끝내면서 1번에서 생성한 임시 객체 소멸
5. main 문이 끝나면서 2번에서 생성한 객체 소멸(vector 에 삽입된 객체)

### emplace_back

```cpp
class Item {
	private:
		int num_;

	public:
	 Item(const int& num) : num_(num){ cout << "기본 생성자 호출" << endl; }
	 Item(const Item& rhs) : num_(rhs.num_) { cout << "복사 생성자 호출" << endl; }
	 Item(const Item&& rhs) : num_(std::move(rhs.num_)) { cout << "이동 생성자 호출" << endl; }
	 ~Item() { cout << "소멸자 호출" << endl; }
};

int main(void) {
	std::vector<Item> vec;

	vec.emplace_back(2);
}
```

emplace_back 함수의 매개변수로 Item 클래스의 객체 대신 객체로 만들 수 있는 값을 넣었다.

실행 결과는 아래와 같다.

```
기본 생성자 호출
소멸자 호출
```

emplace_back 함수를 통해 객체를 삽입하기 위해서 아래와 같은 과정을 거친다.

1. `vec.emplace_back(2)` 에서 `Item` 객체를 만들 수 있는 매개변수 (2) 를 전달.
2. emplace_back 함수 내부에서 임시 객체 생성
3. vector 에 2번에서 생성한 객체 삽입
4. main 문이 끝나고 3번에서 vector 삽입한 객체 소멸

### 비교

**공통점**

- push_back, emplace_back 은 vector 의 요소를 추가하기 위한 메서드이다.

**차이점**

- push_back 은 객체를 하나 더 생성한다. 하지만, push_back 이 emplace_back 보다 비효율적이라고 말할 수는 없다고 한다.

자세한 비교 결과를 아직 전부 이해 못해서 기회가 되면 다시 정리할 예정입니다.

# 참고자료

- [emplace_back 과 push_back 의 차이](https://openmynotepad.tistory.com/10) [티스토리]