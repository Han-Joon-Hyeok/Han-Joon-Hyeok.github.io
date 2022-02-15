---
title: "[Jekyll] Liquid Exception Liquid syntax error Variable '{{a1}' was not properly terminated with regexp"
date: 2022-02-15 15:20:00 +0900
categories: [programmers]
tags: [level2, programmers, JavaScript]
use_math: true
---

# ⚠️오류 메세지

```
{% raw %}
Liquid Exception: Liquid syntax error (line 19): Variable '{{a1}' was not properly terminated with regexp ...
{% endraw %}
```

# 🧐오류 발생 상황

github 블로그에 마크다운으로 작성한 게시물을 push 했지만, 정상적으로 build 가 되지 않았다. ([프로그래머스 Level2 - 튜플](https://han-joon-hyeok.github.io/posts/programmers-tuple/))

# ❓오류 발생 원인

마크다운 본문 내용에 중괄호 (`{`) 가 연속으로 2개 들어가면 Jekyll은 텍스트가 아닌 변수로 인식해서 발생하는 오류다.

## 템플릿 언어 (Template Language)

Jekyll 은 [Liquid](https://shopify.github.io/liquid/) 라는 템플릿 언어(template language)를 사용한다.

템플릿 언어는 중괄호(curly brace)를 사용해서 변수, 제어문을 표현한다.

```markup
{% raw %}
<!-- 변수 표현 -->
{{ variable }}

<!-- 제어문 표현 -->
{% if user %}
	Hello, {{ user.name }}!
{% endif %}
{% endraw %}
```

# 👀오류 상세 분석

{% raw %}`{{a1}, {a1,a2}...`{% endraw %} 에서 중괄호 2개로 시작해서 변수를 인식할 준비를 했으나, 이어지는 값들이 정상적인 변수의 형태로 입력되지 않아 변수를 정상적으로 찾지 못해 오류가 발생했다.

# ✅오류 해결 방법

Jekyll 에서는 다양한 템플릿 태그를 지원하는데, 그 중에서 중괄호를 그대로 표현해주는 `raw` 태그가 있다.

중괄호를 그대로 표현하고 싶은 텍스트 범위에 `{퍼센트_기호 raw 퍼센트_기호} 중괄호가 포함된 텍스트 {퍼센트_기호 endraw 퍼센트_기호}` 로 감싼다.

- `퍼센트_기호`는 `%` 로 바꿔쓰면 된다.

다음과 같이 작성하면 된다.

```markup
{퍼센트_기호 raw 퍼센트_기호} {% raw %} `{{1}, {1,2,3}, {1,2}}` 이 있다면 `{1}`, `{1,2,3}`, `{1,2}` {% endraw %} {퍼센트_기호 endraw 퍼센트_기호}
```

# 참고자료

- [Escaping double curly braces inside a markdown code block in Jekyll](https://stackoverflow.com/questions/24102498/escaping-double-curly-braces-inside-a-markdown-code-block-in-jekyll) [stackoverflow]
- [Jekyll - Liquid](https://jekyllrb.com/docs/liquid/)
