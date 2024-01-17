---
title: "[Dart] 변수(variables) 종류 정리"
date: 2024-01-17 10:08:00 +0900
categories: [dart]
tags: []
---

> 자료 : Dart 시작하기(#1.0 ~ #1.7)


# 변수의 종류

## var

var 는 자료형을 명시적으로 선언하지 않아도 알아서 자료형을 추론해준다.

한 번 값을 할당한 변수는 그 이후에 동일한 자료형을 선언해주어야 한다.

예를 들어, String 값을 할당한 var 변수에는 String 자료형의 값만 재할당 할 수 있다.

```dart
void main() {
	var name;

	name = 'joon';
	// name = 12; // 할당 불가
	name = 'han';
}
```

함수 내부에서 지역 변수를 선언할 때는 var 를 권장하고 있다.

## 명시적 선언

명시적으로 변수의 형식을 선언해줄 수 있다.

```dart
void main() {
	String name;

	name = 'joon';
	// name = 12; // 할당 불가
	name = 'han';
}
```

이 방법은 class 의 property 를 정의할 때 사용하는 것을 권장하고 있다.

## final

final 은 단 1번만 변수에 값을 할당할 수 있다. 변하지 않는 값을 저장할 때 사용한다.

```dart
void main() {
	final String name;

	name = 'joon';
	// name = 'han'; // 할당 불가
}
```

Dart 내부적으로는 final 보다 const 변수 사용을 권장하고 있다.

final 은 런타임에 값이 할당되며, 할당된 이후에 변경되지 않아야 하는 상황에서 쓰인다.

## const

const 도 final 과 마찬가지로 값을 1번만 할당할 수 있다.

하지만, final 과는 달리 컴파일 시점에 값을 아는 경우에 사용하며, 선언과 동시에 초기화를 해주어야 한다.

주로 리터럴 값(문자열, 숫자, 리스트 등)에 사용된다.

```dart
void main() {
	const String name = 'joon';

	// name = 'han'; // 할당 불가
}
```

## dynamic

어떤 타입의 값이 들어올 지 모를 때 사용한다.

```dart
void main() {
	dynamic temp;

	temp = 1;
	if (temp is int) {
		temp.isOdd;
	}

}
```

dynamic 은 타입이 언제든 바뀔 수 있기 때문에 조건문을 사용해서 원하는 동작을 할 수 있도록 해야 한다.

## null safety

dart 의 모든 변수는 nullable 이 아니다. 즉, 모든 변수에 null 을 할당할 수 없다는 것이다.

언어 자체적으로 null 을 참조해서 발생하는 오류를 방지하기 위해 null 을 할당하는 것을 막았다.

하지만 필요에 따라서는 null 값을 할당해야 하는 경우가 있다.

그럴 때는 아래와 같이 자료형 옆에 `?` 를 붙여서 변수를 선언하면 된다.

```dart
void main() {
	String? name; // null safety

	name = null;
	if (name == null) {
		print(name.isEmpty); // true
	}
}
```

조건문을 아래와 같이 축약해서 사용하는 것도 가능하다.

```dart
void main() {
	String? name; // null safety

	name = null;
	print(name?.isEmpty); // null
}
```

만약 name 변수에 null 이 할당되었다면, isEmpty 메서드는 호출하지 않고 name 의 값인 null 만 출력한다.

## late

변수를 사용하기 전에 반드시 값을 할당 해주어야 하는 키워드이다.

데이터가 없는 상태에서 변수를 만들어 주게 한다.

데이터가 없는 상태에서 변수를 참조하고자 한다면 사용할 수 없도록 언어 차원에서 막는다.

즉, 아래와 같이는 사용할 수 없다.

```dart
void main() {
	late final String name;

  print(name); // Late variable 'name' without initializer is definitely unassigned.
}
```

late 를 사용하려면 아래와 같이 사용해야 한다.

```dart
void main() {
	late final String name;

	name = 'joon';
  print(name);
}
```