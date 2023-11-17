---
title: "TypeScript Code Convention"
date: 2023-11-02 09:00:00 +0900
categories: [TypeScript]
tags: [TypeScript]
---

# Code Convention

코드 컨벤션은 [Google TypeScript Style Guide](https://google.github.io/styleguide/tsguide.html) 를 따릅니다.

## 변수명

변수명은 아래의 분류에 따라 작성합니다.

| 표기법 | 종류 |
| --- | --- |
| UpperCamelCase | 클래스, 인터페이스, 타입, enum, 데코레이터, 타입 파라미터 |
| lowerCamelCase | 일반 변수, 파라미터, 함수이름, 메소드, property, 모듈 등등 |
| CONSTANT_CASE | 전역 constant 변수, enum values 를 포함한 변수 |
| #ident | private identifiers are never used. |

예시는 아래와 같습니다.

```tsx
// 상수는 전부 대문자로 작성
const PI: number = 3.14;

// 클래스 이름은 UpperCamelCase
class Greeter {
  greeting: string;

	// 매개변수는 lowerCamelCase
  constructor(message: string) {
    this.greeting = message;
  }

	// 함수 이름은 lowerCamelCase
  greet() {
    return "Hello, " + this.greetingMessage;
  }
}

// 일반 변수는 lowerCamelCase
let greeterObj = new Greeter("world");
```

### 기타

- 변수명은 너무 짧은 것보다 너무 긴 변수명이 낫습니다. 최대한 이해하기 쉽게 풀어서 작성해주세요.

    ```tsx
    // Bad
    for (let i = 0; i < 100; i += 1) {
      ...
    }

    // Good
    const MAX_REPETITION = 100;

    for (let idx = 0; idx < MAX_REPETITION; idx += 1) {
      ...
    }
    ```


## Formatting & Linting

코드 포맷터인 Prettier 를 사용하면 파일 저장 시 자동으로 해당 컨벤션에 맞게 포맷팅을 해주므로 이 부분은 크게 신경 쓰지 않아도 됩니다.

또한, 코드 품질을 관리하는 ESLint 를 사용하기 때문에 GUI 에서 컨벤션을 위배하는 코드를 실시간으로 확인하고 수정할 수 있습니다.

ESLint 의 대표적인 예시로는 사용하지 않은 변수는 지우라고 알려주는 것이 있습니다.

## Naming Styles

- 타입스크립트는 기본적으로 타입이 제공됩니다. 따라서 변수 이름에 타입에 대한 정보를 넣을 필요가 없습니다.

    ```tsx
    // Bad
    let nameString: string = 'Jay';

    // Good
    let name: string = 'Jay';
    ```

- 과한 상세내용은 담지 않습니다.

    ```tsx
    // Bad
    let finalBattleBossMonster: Monster;

    // Good
    let boss: Animal;
    ```


# Clean Code for TypeScript

클린 코드를 작성하기 위해 아래의 링크를 참고했습니다.

- 링크 : [clean-code-typescript](https://738.github.io/clean-code-typescript/) [github.io]

모든 내용을 기억할 수 없으니 조금씩 코드에 적용해보면 자연스럽게 익히고자 합니다.

# 참고자료

- [린트(ESLint)와 프리티어(Prettier)로 협업 환경 세팅하기](https://youtu.be/Y3kjHM7d3Zo) [youtube]