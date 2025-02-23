---
title: "[Java] 문자열 클래스 String, StringBuffer, StringBuilder 정리"
date: 2025-02-23 18:55:00 +0900
categories: [Java]
tags: []
---

# 개요

Java에서 문자열을 다루기 위해 사용하는 클래스 3가지(String, StringBuffer, StringBuilder)에 대해 정리했습니다.

# String

String 객체는 불변(Immutable) 객체입니다. Heap 메모리 영역 안에서 관리되며, String Constant Pool 또는 Heap 영역에 생성됩니다.

```java
String str = "hello"; // String Constant Pool에 생성
String str = new String("hello"); // Heap에 생성
```

위의 코드에서 할당한 문자열이 메모리 상에서 관리되는 위치를 그림으로 표현하면 아래와 같습니다.

![1.png](/assets/images/2025/2025-02-23-java-string-stringbuffer-stringbuilder/1.png)

출처: https://deveric.tistory.com/123

## String 클래스는 왜 필요했을까?

문자열을 다루기 위해 Primitive Type인 int, double, char가 아닌 String 클래스를 사용하는 이유가 뭘까요? String은 왜 Primitive Type이 아닌걸까요? 이를 이해하기 위해서는 Java 이전에 어떻게 문자열을 다루었는지 살펴볼 필요가 있습니다.

### C언어에서 문자열을 다루는 방법

Java가 등장하기 이전에 사용했던 C언어에서는 문자열을 저장하기 위해 `char` 자료형의 배열 형태인 `char[]` 또는 포인터형 `char*` 을 사용합니다. C언어에서는 문자열 크기를 조절하기 위해 포인터를 사용하지만, 개발자가 매번 메모리를 직접 할당하고 해제해야 하는 번거로움이 있습니다. 그리고 실수로 메모리 해제를 하지 않으면 메모리 누수로 이어지기 때문에 문자열을 다룰 때는 더욱 신경을 써야 합니다.

아래의 코드는 malloc을 이용해서 Heap 영역에 동적으로 메모리를 할당하는 예시입니다.

```c
// C언어로 문자열 생성하기

// 문자열을 저장하기 위한 동적 메모리 할당
char *str = (char *) malloc(sizeof(char) * 3);

// 배열에 문자열 할당
str[0] = 'h';
str[1] = 'i';
str[2] = '\0'; // 문자열의 끝을 알리는 NULL 문자

// 문자열 출력
printf("%s", str); // hi

// 할당한 동적 메모리를 해제하지 않으면 메모리 누수 발생
free(str);
```

고정 크기 배열을 사용하면 malloc이나 free를 사용하지 않아도 됩니다. 이 경우에는 Stack 영역에 문자열이 생성됩니다.

```c
// C언어로 문자열 생성하기

// 문자열을 저장하기 위한 고정 크기 배열 생성
char str[3] = "hi";

// 문자열 출력
printf("%s", str); // hi
```

하지만 코드를 작성하다보면 문자열을 저장하기 위해 고정 크기 배열을 생성하는 것보다 malloc을 이용해서 동적으로 메모리를 할당하는 경우가 많습니다. 만약, 문자열의 길이를 미리 예측할 수 없어서 배열의 크기를 넉넉하게 10,000으로 설정해두었는데, 실제로는 길이가 1인 문자열만 들어온다면 9,999 만큼의 공간을 낭비하는 것입니다. 그렇기 때문에 C언어에서는 메모리를 효율적으로 사용하기 위해 개발자가 직접 동적 메모리를 관리해야 하는 부담이 있습니다.

### Java에서 String 클래스가 문자열을 다루는 방법

이처럼 C언어에서 문자열을 다룰 때 개발자가 동적 메모리를 관리하는 번거로움을 해결하기 위해 Java에서는 편리하게 문자열을 다룰 수 있도록 String 클래스를 제공합니다.

```java
// Java에서 문자열 생성하기

String str = "hi";
```

C언어와 비교했을 때 Java로 작성하면 코드의 양이 감소하고, String 클래스 내부에서 생성자와 소멸자를 통해 객체의 생명주기를 관리하기 때문에 개발자는 비즈니스 로직에 집중할 수 있게 되었습니다.

실제로 String 클래스의 생성자를 타고 들어가면 `new` 키워드를 이용해서 동적으로 메모리를 할당하는 것을 확인할 수 있습니다. String 객체를 생성할 때 `char[]` 자료형을 매개변수로 받은 경우에 아래와 같이 `StringUTF16.toBytes()` 메서드를 호출합니다.

```java
// String 클래스
public final class String
    implements java.io.Serializable, Comparable<String>, CharSequence,
               Constable, ConstantDesc {

   // 문자열을 저장하기 위한 멤버 변수
   @Stable
   private final byte[] value;

   // ...생략...

   // 1. char[] 배열을 매개변수로 받는 생성자
   public String(char value[]) {
    this(value, 0, value.length, null);
   }

   // 2. 1번에서 호출한 생성자 this(value, 0, value.length, null)
   String(char[] value, int off, int len, Void sig) {
      // ...생략

      this.coder = UTF16;
      // 3. 동적으로 메모리 할당 받는 부분
      this.value = StringUTF16.toBytes(value, off, len);
    }
 }
```

StringUTF16 클래스에 정의된 `toBytes()` 메서드의 구현을 살펴보면 `newBytesFor()` 라는 메서드를 호출합니다.

```java
// StringUTF16 클래스
final class StringUTF16 {

    // 1. String 클래스의 생성자가 호출한 메서드
    @IntrinsicCandidate
    public static byte[] toBytes(char[] value, int off, int len) {
        byte[] val = newBytesFor(len); // 동적 메모리 할당 메서드
        // ...생략...
        return val;
    }

    // 2. 동적 메모리 할당 메서드
    public static byte[] newBytesFor(int len) {
      // ...생략...

      // 3. new 키워드로 heap 영역에 메모리 할당
      return new byte[len << 1];
    }
}

```

이를 통해 String 객체가 Heap 영역에서 관리되는 이유를 알 수 있습니다. 즉, String 객체는 Primitive Type가 아니며, 주소 값을 참조하는 Reference Type 입니다.

## String은 왜 불변(Immutable)인가?

위에서 String 객체는 불변 객체라고 설명했습니다. 불변은 변하지 않는다는 의미인데, 정확히 무슨 의미일까요?

### 리터럴로 선언한 문자열

불변의 의미를 이해하기 위해 예시 코드를 함께 살펴보겠습니다.

아래와 같이 변수 2개에 동일한 문자열을 할당하고, 객체의 고유한 주소 값에 해당하는 hashCode를 출력하면 동일한 값이 출력됩니다.

```java
String str = "hello";
String str2 = "hello";

System.out.println(str.hashCode());  // 113318802
System.out.println(str2.hashCode()); // 113318802
```

메모리 구조를 그림으로 표현하면 아래와 같습니다.

![2.png](/assets/images/2025/2025-02-23-java-string-stringbuffer-stringbuilder/2.png)

String Constant Pool 영역의 메모리 주소 0x42에 문자열 `hello` 이 할당되어 있습니다. 그리고 str 변수와 str2는 동일한 주소를 참조하고 있습니다.

만약, 코드가 아래와 같이 변경되었다고 해보겠습니다.

```java
String str = "hello";
System.out.println(str.hashCode());  // 99162322

str = "world";
System.out.println(str.hashCode());  // 113318802
```

처음에는 str 변수는 문자열 `hello` 가 선언된 주소를 참조했지만, 문자열 `world`의 주소를 참조합니다. 그림으로 표현하면 아래와 같습니다.

![3.png](/assets/images/2025/2025-02-23-java-string-stringbuffer-stringbuilder/3.png)

즉, 변수에 다른 문자열을 할당한다고 해서 0x42 주소가 갖고 있는 값 `hello` 문자열이 `world` 로 바뀌는 것이 아니라 `world` 문자열을 갖고 있는 다른 메모리 주소(0x24)를 참조하는 것입니다. 이처럼 String 객체는 한번 생성되면 내부적으로 값을 바꾸지 않습니다.

또한, String 클래스는 문자열을 저장하기 위한 멤버 변수 value가 final 키워드로 선언되어 있습니다.

```java
// String 클래스
public final class String
    implements java.io.Serializable, Comparable<String>, CharSequence,
               Constable, ConstantDesc {

   // 문자열을 저장하기 위한 멤버 변수
   @Stable
   private final byte[] value;
}
```

이는 객체 생성 시에 할당된 배열은 다른 배열로 대체될 수 없다는 의미입니다.

```java
final byte[] value = new byte[10];

// ❌ Cannot assign a value to final variable 'value'
value = new byte[20];
```

정리하면, String 객체가 불변이라는 것은 2가지 관점으로 바라볼 수 있습니다.

1. 변수에 새로운 문자열을 재할당해도 기존에 할당했던 문자열 자체가 바뀌는 것이 아닌 참조하는 메모리 주소 값이 바뀌는 것이다.
2. String 클래스 내부에서 문자를 저장하기 위한 배열은 final 키워드로 선언되어있으며, 초기화 이후에는 재할당이 불가능하다.

### String이 불변이라서 좋은 점은?

String이 불변이라서 좋은 점은 무엇이 있을까요? 아래와 같이 3가지로 정리할 수 있습니다.

1. 동일한 문자열은 같은 메모리 주소를 참조함으로써 Runtime에서 Heap 영역의 메모리를 절약할 수 있습니다.
2. 멀티 스레딩 환경에서 값이 변경될 가능성이 없으므로 동기화 문제에서 자유롭습니다.
3. hashcode가 객체 생성 단계에서 계산되어 저장되기 때문에 hashcode를 key로 갖는 HashMap, HashSet을 사용할 때 다른 객체를 key로 했을 때보다 빠르게 사용할 수 있습니다. 예컨대, ArrayList 클래스의 `hashCode()` 구현 코드를 살펴보면, 모든 원소에 대해 `hashCode()` 를 호출해서 새롭게 계산합니다. 즉, 새로운 원소가 추가되면 `hashCode()` 호출 결과가 달라집니다.

   ```java
   List<Integer> list = new ArrayList<>();
   System.out.println(list.hashCode()); // 1

   list.add(1);
   System.out.println(list.hashCode()); // 32
   ```

> 다른 글을 찾아보면 String이 불변이기 때문에 보안상 안전한다는 내용이 있지만, 왜 안전한지 정확한 이유를 찾지 못해서 이 부분은 정리하지 않았습니다.

# StringBuffer와 StringBuilder

String 이 외에도 문자열을 다루기 위해 사용하는 StringBuffer와 StringBuilder 클래스를 알아보겠습니다. String은 불변이지만, StringBuffer와 StringBuilder는 가변이라는 차이가 있습니다.

## 왜 가변(Mutable)인가?

String 클래스는 내부적으로 문자를 저장하기 위해 사용하는 멤버 변수에 final 키워드를 사용했지만, 두 클래스는 그렇지 않습니다. 이는 두 클래스가 공통으로 상속 받는 AbstractStringBuilder 클래스에 선언된 멤버 변수를 살펴보면 알 수 있습니다.

```java
abstract class AbstractStringBuilder implements Appendable, CharSequence {
  /**
   * The value is used for character storage.
   */
  byte[] value;
}
```

final 키워드가 없기 때문에 문자열의 길이가 변경되어도 새로운 길이의 배열을 할당하는 것이 가능합니다. String과는 달리 Heap 영역에 하나의 객체만으로도 문자열을 자유롭게 바꾸는 것이 가능하며, 이를 가변적이라고 합니다.

값이 바뀔 때마다 새로운 객체를 만드는 String보다 훨씬 빠르기 때문에 문자열 수정이 빈번하게 발생한다면 StringBuffer나 StringBuilder를 사용하는 것이 권장됩니다.

## StringBuffer

StringBuffer는 멀티 스레드 환경에서 사용하는 것이 권장됩니다. 이는 메서드에서 synchronized 키워드를 사용하기 때문입니다. 예시로 `append()` 메서드의 구현은 다음과 같이 되어 있습니다.

```java
@Override
@IntrinsicCandidate
public synchronized StringBuffer append(String str) {
    toStringCache = null;
    super.append(str);
    return this;
}
```

synchronized 키워드는 여러 스레드가 동시에 같은 자원에 대해 접근하는 것을 방지해주는데, 이를 위해 자원을 사용할 수 있는지 지속적으로 확인합니다. 그래서 싱글 스레드 환경에서는 오버헤드가 발생하기 때문에 StringBuilder에 비해 미세하게 속도가 느립니다.

## StringBuilder

StringBuilder는 싱글 스레드 환경에서 사용하는 것이 권장됩니다. 이는 앞서 살펴본 것처럼 StringBuilder는 synchronized 키워드를 사용하지 않기 때문입니다. 마찬가지로 `append()` 메서드의 구현을 살펴보면 다음과 같습니다.

```java
@Override
@IntrinsicCandidate
public StringBuilder append(String str) {
    super.append(str);
    return this;
}
```

그렇기에 싱글 스레드 환경에서는 StringBuilder가 가장 빠른 연산 속도를 보여줍니다.

### String도 StringBuilder를 사용한다

String 변수가 `+` 연산과 함께 사용될 때 컴파일러는 StringBuilder를 사용해서 String으로 변환합니다.

3개의 문자열을 합치는 상황을 살펴보겠습니다.

```java
String str = "hello";
String str2 = " world";
String str3 = "!";
String result = str + str2 + str3;
```

`+` 연산을 사용하면 새로운 문자열이 Heap 영역에 계속 생성됩니다. 예를 들어, `"hello" + " world" + "!"` 을 수행하면 `"hello world"` 와 `"hello world"` 가 각각 새롭게 생성되어 불필요한 메모리 낭비가 발생합니다. 간단한 문자열을 합치는 경우에는 괜찮겠지만, 여러 문자열을 합치는 상황에서는 새로운 String 객체가 생성되어 메모리 공간을 많이 차지하는 문제가 발생합니다.

이러한 문제를 해결하기 위해 컴파일러는 `+` 연산이 있으면 StringBuilder로 변환해서 메모리 공간을 절약합니다. 위의 코드는 실제로 아래와 같이 변환됩니다.

```java
String result = new StringBuilder()
                    .append(str)
                    .append(str2)
                    .append(str3)
                    .toString();
```

만약, StringBuilder를 사용하지 않았다면 Heap 영역에 객체 2개(`hello world`, `hello world!`)가 있을 것입니다. StringBuilder는 내부적으로 `byte[] value` 변수에 할당된 객체 1개만 사용하기 때문에 메모리 공간을 효율적으로 사용할 수 있습니다.

그래서 여러 문자열을 합치는 경우에는 `+` 연산보다 StringBuffer나 StringBuilder를 사용하는 것이 속도 향상과 메모리 관리에 유리합니다.

## 멀티 스레드 환경에서 비교

문자를 10,000번 추가하는 스레드 2개를 실행하면 StringBuffer 객체에는 정확하게 2만 개의 문자가 저장되지만, StringBuilder는 동기화되지 않아 일부 문자가 추가되지 않을 수 있습니다.

```java
import java.util.*;

public class Main extends Thread{
    public static void main(String[] args) {
        StringBuffer stringBuffer = new StringBuffer();
        StringBuilder stringBuilder = new StringBuilder();

        new Thread(() -> {
            for(int i=0; i<10000; i++) {
                stringBuffer.append(1);
                stringBuilder.append(1);
            }
        }).start();

        new Thread(() -> {
            for(int i=0; i<10000; i++) {
                stringBuffer.append(1);
                stringBuilder.append(1);
            }
        }).start();

        new Thread(() -> {
            try {
                Thread.sleep(2000);

                System.out.println("StringBuffer.length: "+ stringBuffer.length()); // thread safe 함
                System.out.println("StringBuilder.length: "+ stringBuilder.length()); // thread unsafe 함
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }).start();
    }
}
```

출력 결과는 다음과 같습니다.

```
StringBuffer.length: 20000
StringBuilder.length: 19792
```

따라서 멀티 스레드 환경에서는 StringBuffer를 사용해야 안전하게 문자열을 처리할 수 있습니다.

# 성능 비교

각 클래스마다 연산 횟수에 따른 수행 시간을 비교한 그래프는 아래와 같습니다.

![4.png](/assets/images/2025/2025-02-23-java-string-stringbuffer-stringbuilder/4.png)

출처: [https://inpa.tistory.com/entry/JAVA-☕-String-StringBuffer-StringBuilder-차이점-성능-비교](https://inpa.tistory.com/entry/JAVA-%E2%98%95-String-StringBuffer-StringBuilder-%EC%B0%A8%EC%9D%B4%EC%A0%90-%EC%84%B1%EB%8A%A5-%EB%B9%84%EA%B5%90)

StringBuilder가 가장 빠르며, String이 가장 느린 것을 확인할 수 있습니다.

# 정리

|               | **String**                                  | **StringBuffer**                            | **StringBuilder**                       |
| ------------- | ------------------------------------------- | ------------------------------------------- | --------------------------------------- |
| 가변 여부     | 불변                                        | 가변                                        | 가변                                    |
| 스레드 세이프 | O                                           | O                                           | X                                       |
| 연산 속도     | 느림                                        | 빠름                                        | 아주 빠름                               |
| 사용 시점     | 문자열 추가 연산이 적고, 스레드 세이프 환경 | 문자열 추가 연산이 많고, 스레드 세이프 환경 | 문자열 추가 연산이 많고, 빠른 연산 필요 |

# 참고자료

- [Java의 String 이야기(1) - String은 왜 불변(Immutable)일까?](https://readystory.tistory.com/139) [티스토리]
- [[Java] 많이 헷갈려하는 String constant pool과 Runtime Constant pool, Class file constant pool](https://deveric.tistory.com/123) [티스토리]
- [☕ 자바 String / StringBuffer / StringBuilder 차이점 & 성능 비교](https://inpa.tistory.com/entry/JAVA-%E2%98%95-String-StringBuffer-StringBuilder-%EC%B0%A8%EC%9D%B4%EC%A0%90-%EC%84%B1%EB%8A%A5-%EB%B9%84%EA%B5%90) [티스토리]
