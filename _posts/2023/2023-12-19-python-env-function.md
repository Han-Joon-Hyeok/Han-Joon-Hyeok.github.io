---
title: "[Python] os.environ.get 과 os.getenv 는 다른 걸까?"
date: 2023-12-19 01:20:00 +0900
categories: [python]
tags: []
---

# 결론

둘 다 똑같이 환경변수를 불러오는 기능을 한다.

`os.getenv` 는 `os.environ.get` 을 감싸는 함수에 불과하다.

`os.py` 를 열어서 살펴보면 `getenv` 함수는 아래와 같이 정의되어 있다.

```python
def getenv(key, default=None):
    """Get an environment variable, return None if it doesn't exist.
    The optional second argument can specify an alternate default.
    key, default and the result are str."""
    return environ.get(key, default)
```

# 참고자료

- [Difference between os.getenv and os.environ.get](https://stackoverflow.com/questions/16924471/difference-between-os-getenv-and-os-environ-get) [stackoverflow]