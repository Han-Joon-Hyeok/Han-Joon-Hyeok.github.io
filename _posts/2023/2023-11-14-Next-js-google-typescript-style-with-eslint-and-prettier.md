---
title: "[Next.js] 협업을 위한 Google TyepScript Style 을 ESLint, Prettier 에 간단하게 적용하기"
date: 2023-11-14 09:00:00 +0900
categories: [typescript, next.js]
tags: [typescript, nextjs]
---

# 코드 스타일, 왜 맞춰야 할까?

협업할 때 코드를 각자의 스타일로 작성하다보면 다른 팀원이 작성한 코드를 읽기 어려울 때가 있다.

예를 들어, TypeScript 를 사용하는 팀원 A와 B의 코드 스타일이 아래의 표와 같다고 해보자.

|  | A | B |
| --- | --- | --- |
| 함수 정의 중괄호 개행 여부 | O | X |
| 문자열 따옴표 처리 | 쌍따옴표(”) | 홑따옴표(’) |
| 선언문 끝 세미콜론 여부 | O | X |

이를 토대로 코드를 작성해보면 아래와 같다.

```tsx
// A의 코드 스타일
function AFunction(void) {
	console.log("A Style");
}

// B의 코드 스타일
function BFuntion(void)
{
	console.log('B Style')
}
```

굉장히 사소한 차이처럼 보일 수 있겠지만, 코드가 많아지고 복잡해지면 코드 스타일이 맞지 않으면 코드 리뷰를 하는데 시간도 오래 걸리고, 다른 팀원의 코드를 읽는데 걸리는 시간도 증가할 수 있다.

그렇기 때문에 코드 스타일을 하나로 통일하고, 이에 맞춰서 코드를 작성하는 것은 개발 생산성 향상 뿐만 아니라 가독성을 높이는 효과가 있다.

하지만, 정해진 코드 스타일을 모두 외우고 코드를 작성할 수는 없다.

그래서 코드 스타일에 맞지 않으면 경고 문구를 띄워주거나, 파일 저장 시 자동으로 코드 스타일 형식을 맞춰주는 도구를 사용해보고자 한다.

# ESLint

ESLint 는 JavaScript, JSX 의 정적 분석 도구이다.

문법 오류를 찾거나, 일관된 코드 스타일로 작성하도록 도와준다.

예를 들어, 아래와 같은 코드가 있다고 해보자.

```tsx
const vizzini = (!!sicilian);
```

위의 코드에서 `!!` 는 이중 부정이기 사실상 필요없는 표현이다.

그렇기 때문에 Visual Studio Code 에서 아래의 이미지와 같이 빨간색 줄로 표시해주고, 마우스를 올려서 확인해보면 `Redundant double negation.` 이라는 안내 문구를 띄워준다.

![eslint](/assets/images/2023/2023-11-14-Next-js-google-typescript-style-with-eslint-and-prettier/1.png)

자기만의 스타일로 규칙을 정의하는 것도 가능하고, 다른 사람이 사용하는 스타일을 가져와서 사용할 수도 있다.

대표적으로 Airbnb, Google 에서 사용하는 규칙을 사용할 수 있다.

이 글에서는 Google 의 스타일에 따라서 적용하는 방법을 소개하고자 한다.

# Prettier

Prettier 는 코드 포맷터이다.

ESLint 가 코드 규칙을 검사하는 도구였다면, Prettier 는 규칙에 맞게 코드를 바꿔주는 도구이다.

줄 바꿈, 공백, 들여쓰기 등을 자동으로 고쳐준다.

Prettier 또한 ESLint 처럼 규칙을 커스터마이징 하는 것이 가능하다.

그리고 Visual Studio Code 와 Prettier 를 함께 사용하면 파일 저장 단축키를 누를 때마다 포맷팅을 하도록 설정할 수 있다.

아래의 이미지는 줄 바꿈을 하지 않고서 파일 저장 단축키를 눌렀을 때 Prettier 가 실행되는 화면이다.

![prettier](/assets/images/2023/2023-11-14-Next-js-google-typescript-style-with-eslint-and-prettier/2.gif)

# 설치 방법

## Visual Studio Code 익스텐션 설치

ESLint 와 Prettier 모두 라이브러리이기 때문에 터미널에서 아래의 명령어를 직접 입력해서 실행해야 한다.

```bash
# src 폴더에 있는 모든 파일 규칙 검사
npx eslint src/**

# src 폴더에 있는 모든 파일 포맷팅 규칙 적용
npx prettier src/** --write
```

하지만, 매번 이렇게 터미널에서 입력해서 사용하기는 번거롭다.

그래서 Visual Studio Code 와 연동해서 사용하면 굉장히 편리하게 사용할 수 있다.

아래의 링크를 통해 익스텐션을 각각 설치한다.

- ESLint : https://marketplace.visualstudio.com/items?itemName=dbaeumer.vscode-eslint
- Prettier : https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode

## gts 라이브러리 설치

gts 는 Google TypeScript Style 의 약자로, Google 에서 TypeScript 언어로 작성하는 코드에서 적용하는 ESLint 와 Prettier 규칙을 담은 라이브러리다.

이를 이용하면 ESLint, Prettier 설정 파일을 직접 정의하지 않아도 되는 편리함이 있다.

1. 터미널에 아래의 명령어를 입력한다.

    ```bash
    npx gts init
    ```

2. 자동으로 gts 라이브러리 사용할 수 있도록 여러 파일들을 자동으로 세팅해준다. 이때, Next.js 와 같은 라이브러리를 이용해서 프로젝트를 생성했다면 `tsconfig.json` 이나 `package.json`과 같은 파일이 이미 생성되어 있기 때문에 파일을 덮어쓸 것인지 물어본다. 프로젝트 환경에 맞게 설정해주면 되지만, 가능하면 Next.js 라이브러리에 맞추기 위해 파일은 덮어쓰지 않았다.

    ```bash
    # package.json 파일에 typescript 버전 변경 여부 확인 (No)
    Already have devDependency for typescript:
    -^5
    +~5.2.0
    ? Overwrite No
    # package.json 파일에 @types/node 버전 변경 여부 확인 (No)
    Already have devDependency for @types/node:
    -^20
    +20.8.2
    ? Overwrite No
    # package.json 파일에 lint 명령어 변경 여부 확인 (Yes)
    package.json already has a script for lint:
    -next lint
    +gts lint
    ? Replace Yes
    Writing package.json...
    (node:74320) [DEP0174] DeprecationWarning: Calling promisify on a function that returns a Promise is likely a mistake.
    (Use `node --trace-deprecation ...` to show where the warning was created)
    {
      scripts: {
        dev: 'next dev',
        build: 'next build',
        start: 'next start',
        lint: 'gts lint',
        clean: 'gts clean',
        compile: 'tsc',
        fix: 'gts fix',
        prepare: 'npm run compile',
        pretest: 'npm run compile',
        posttest: 'npm run lint'
      },
      devDependencies: {
        typescript: '^5',
        '@types/node': '^20',
        '@types/react': '^18',
        '@types/react-dom': '^18',
        eslint: '^8',
        'eslint-config-next': '14.0.1',
        gts: '^5.2.0'
      }
    }
    # tsconfig.json 파일 덮어쓰기 여부 (No)
    ./tsconfig.json already exists
    ? Overwrite No
    # .eslintrc.json 파일 덮어쓰기 여부 (No)
    ./.eslintrc.json already exists
    ? Overwrite No
    ```

3. 설치를 완료하면 총 4개의 파일이 생성되고, 2개의 파일이 수정된다.
    - 새롭게 생성되는 파일
        - `.editorconfig` : 서로 다른 IDE 를 사용할 경우, 공통된 포맷을 유지할 수 있도록 설정하는 파일이다. Visual Studio Code 에서 사용하기 위해서는 익스텐션을 설치해야 하지만, 이번 글에서는 별도로 설치하지 않는다.
        - `.eslintignore` : eslint 를 적용하지 않을 파일이나 폴더를 명시한다. 빌드 후 생성되는 `build` 폴더의 파일은 적용하지 않는다.
        - `.prettierrc.js` : gts 의 prettier 규칙을 적용하기 위한 파일을 불러온다.
        - `index.ts` : gts 적용이 잘 되었는 지 확인하기 위해 의도적으로 eslint, prettier 규칙에 맞지 않는 코드를 작성한 테스트용 파일이다. 정상 작동하는 것을 확인하고 삭제하면 된다.
    - 수정되는 파일
        - `package-lock.json`, `package.json` : gts 라이브러리가 devDependencies 에 추가되면서 업데이트가 발생한 것이다.

## tsconfig.json 파일 편집

gts 에서 제공하는 기본 `tsconfig.json` 파일을 적용해야 한다.

`tsconfig.json` 파일은 TypeScript 파일을 JavaScript 로 변환할 때 어떤 규칙을 적용할 것인지 명시해놓은 파일이다.

아래의 코드를 `tsconfig.json` 파일에 추가했다.

```json
"extends": "./node_modules/gts/tsconfig-google.json"
```

전체 파일의 내용은 아래와 같다.

```json
{
  "extends": "./node_modules/gts/tsconfig-google.json",
  "compilerOptions": {
    "target": "es5",
    "lib": ["dom", "dom.iterable", "esnext"],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "bundler",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "incremental": true,
    "plugins": [
      {
        "name": "next"
      }
    ],
    "paths": {
      "@/*": ["./src/*"]
    }
  },
  "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx", ".next/types/**/*.ts"],
  "exclude": ["node_modules"]
}
```

`extends` 속성에 명시된 `tsconfig-google.json` 파일 내부에 있는 속성들과 `tsconfig.json` 파일의 속성들이 겹치는 경우가 있다.

겹치는 속성에 대해서는 `extends` 에 명시된 파일이 아닌 현재 파일인 `tsconfig.json` 에 명시된 속성이 적용된다. 그리고 겹치지 않는 속성들은 각각 적용된다.

## .eslintrc.json 파일 편집

Next.js 를 기준으로 프로젝트 루트 디렉토리에 `.eslintrc.json` 파일이 아래와 같이 기본적으로 생성되어있을 것이다.

```json
// .eslintrc.json
{
  "extends": "next/core-web-vitals"
}
```

이를 아래와 같이 수정한다.

```json
{
  "extends": ["next/core-web-vitals", "./node_modules/gts"]
}
```

참고로 `next/core-web-vitals` 는 next 에서 제공하는 ESLint 옵션이다.

core web vitals 는 구글이 발표한 검색 엔진 최적화에 있어서 중요한 지표들을 의미한다.

next 에서도 이를 지원하기 위해 기본적으로 ESLint 를 제공하고 있다.

프레임워크 차원에서 제공하는 eslint 와 google style 모두 eslint 에 맞춰서 작성하기 위해 배열 형태로 저장했다.

## Visual Studio Code 설정 변경

### Workspace 단위로 설정하기

Visual Studio Code 에서는 Workspace 단위 설정과 User 단위 설정이 가능하다.

- Workspace : 현재 작업 중인 폴더에서만 적용할 Visual Studio Code 설정이 가능하다. 최상단 디렉토리에 `.vscode` 폴더에 `settings.json` 파일로 저장된다.
- User : 모든 폴더에서 전역으로 적용할 Visual Studio Code 설정이 가능하다.

Workspace 단위 설정은 다른 사람들과 함께 작업한다면 공통되는 설정을 적용하고 싶을 때 사용하면 되고, User 단위 설정은 개인 개발 환경을 맞추고 싶을 때 사용한다.

이번 글에서는 Workspace 단위로 적용하는 방법을 소개하고자 한다.

### 파일 저장 시 ESLint, Prettier 적용

파일 저장 단축키 버튼 `cmd+s` (윈도우는 `ctrl+s`)를 눌렀을 때, ESLint 규칙과 prettier 이 적용되도록 설정할 수 있다.

1. `cmd+shift+p` 를 누르고 `Preferences: Open Workspace Settings (JSON)` 을 찾아서 선택한다. 그러면 자동으로 `.vscode` 폴더에 `settings.json` 파일이 생성된다.

    ![settings.json](/assets/images/2023/2023-11-14-Next-js-google-typescript-style-with-eslint-and-prettier/3.png)

2. `settings.json` 파일이 열리면 아래의 코드를 추가한다. 이 코드는 파일 저장 시 자동으로 포맷팅과 ESLint 규칙에 맞게 수정해주는 기능을 명시한 것이다.

    ```json
    {
    	"editor.codeActionsOnSave": {
    	  "source.fixAll.eslint": true
    	},
    	"editor.formatOnSave": true,
    }
    ```


## 적용 여부 확인

`npx gts init` 명령어로 생성되었던 파일인 `src/index.ts` 파일에서 파일 저장 단축키를 입력하고 eslint 와 prettier 가 잘 적용되었는 지 확인한다.

![eslint-prettier](/assets/images/2023/2023-11-14-Next-js-google-typescript-style-with-eslint-and-prettier/4.gif)

위의 이미지와 같이 잘 적용되었다면 해당 파일은 삭제하면 된다.

# 참고자료

- [gts](https://github.com/google/gts) [github]
- [next eslint](https://nextjs.org/docs/pages/building-your-application/configuring/eslint) [nextjs.org]
- [코어 웹 바이탈(Core web Vitals)이란 무엇인가?](https://www.ascentkorea.com/core-web-vitals/) [ascentkorea]
- [EditorConfig란?](https://nesoy.github.io/articles/2019-11/editorconfig) [github.io]
- [Editorconfig](https://blog.woong.io/posts/editorconfig/) [blog.woong.io]