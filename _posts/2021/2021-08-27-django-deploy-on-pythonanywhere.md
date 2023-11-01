---
title: Django 프로젝트를 무료로 배포하는 방법(PythonAnywhere)
date: 2021-08-27 04:00:00 +0900
categories: [python]
tags: [python, django]
---

Django를 사용한 프로젝트를 [PythonAnywhere](https://www.pythonanywhere.com/)통해 무료로 배포하는 방법에 대해 소개하고자 한다.

pythonanywhere는 유료 서비스이지만, beginner account는 제한된 기능 안에서 무료로 사용할 수 있다. 무료 계정이어도 간단한 프로젝트나 포트폴리오를 배포할 때 유용하게 사용할 수 있다.

다만, 배포 후 3달까지만 작동하기 때문에 시간이 지나면 수동으로 서버를 재실행 해줘야 한다.

# 1. 회원 가입

[PythonAnywhere](https://www.pythonanywhere.com/)에 접속하여 회원가입을 진행한다.
가입 시, `username`은 나중에 호스팅할 때 `username.pythonanywhere.com` 배포한 주소에 들어가므로 기억하기 쉬운 이름으로 지어주면 좋다.

# 2. Django 배포 사전 설정

## requirements.txt

Github를 이용해서 배포가 이루어지므로 프로젝트를 Github repository에 업로드 해야 한다.
이때, 프로젝트에서 사용하는 라이브러리들의 정보가 담긴 `requirements.txt` 파일로 만들어 두는 것을 추천한다. 가상환경을 실행시킨 다음 아래의 명령어를 터미널에 입력한다.

```bash
pip freeze > requirements.txt
```

## settings.py

- DEBUG 항목을 `True`에서 `False`로 변경
- ALLOWED_HOSTS에 `"*"` 또는 아래와 같이 본인의 username이 포함된 주소를 입력하여 저장.

```python
DEBUG = False

ALLOWED_HOSTS = [
    '<username>.pythonanywhere.com'
]
```

또한, 기존에 작성한 STATICFILES_DIRS는 주석처리 한다. 배포 시에는 static 파일을 하나의 폴더로 모아서 처리해야 한다.

```python
STATIC_URL = '/static/'
# STATICFILES_DIRS = [
#     os.path.join(BASE_DIR, 'base/static'),
#     os.path.join(BASE_DIR, 'user/static'),
# ]
STATIC_ROOT = os.path.join(BASE_DIR, '.staticfiles')
# .staticfiles 라는 이름의 폴더에 모든 static 파일이 모인다.
```

위와 같이 설정한 뒤, 터미널의 다음의 명령어를 수행한다.

```python
python manage.py collectstatic
```

## Github 업로드

위의 과정을 마쳤다면, 본인의 Github repository에 업로드를 한다.

# 3. pythonanywhere 환경 설정

## 어플리케이션 생성

`Web` 탭으로 이동하여 새로운 어플리케이션을 생성해준다.

![create-new-app](../assets/images/2021/2021-08-27-django-deploy-on-pythonanywhere/create-new-app-1.png)

Django 선택.

![create-new-app](../assets/images/2021/2021-08-27-django-deploy-on-pythonanywhere/create-new-app-2.png)

개발한 파이썬 버전에 맞추어 선택

![create-new-app](../assets/images/2021/2021-08-27-django-deploy-on-pythonanywhere/create-new-app-3.png)

`Project Name` 항목에 프로젝트명을 입력한다. 참고로 아래 Console에서 git clone 시 사용할 폴더명과 동일하게 사용한다.

## Console

하단의 이미지와 같이 `Consoles` 탭으로 이동한 뒤, `Bash`를 클릭하여 콘솔 페이지로 접속한다.

![console-bash](../assets/images/2021/2021-08-27-django-deploy-on-pythonanywhere/console-bash.png)

### git clone

프로젝트 파일을 다운로드 받기 위해 다음과 같은 명령어를 입력한다.

```bash
git clone https://github.com/<github계정>/<repository>.git <프로젝트명>
```

위의 명령어는 `<프로젝트명>`에 프로젝트를 저장한다는 의미이다.
그 다음, 생성된 폴더로 이동한다.

```bash
cd <프로젝트명>
```

### 가상환경 실행 및 라이브러리 설치

가상환경 폴더를 생성하고, `requirements.txt`파일에 담긴 라이브러리를 설치한다.
참고로 윈도우 사용자의 경우 가상환경 실행 시 `source <가상환경>/scripts/activate`를 사용하지만, 서버의 경우 Linux 기반으로 실행이 되기 때문에 `scripts`가 아닌 `bin`으로 입력해야 한다.

```bash
# 가상환경 생성
python -m venv <가상환경이름>
# 가상환경 실행
source venv/bin/activate
# 라이브러리 설치
pip install -r requirements.txt
```

### 마이그레이션 적용

데이터베이스 적용하기 위해 마이그레이션을 실행한다.

```bash
python manage.py migrate
```

### 서버 테스트 실행

위의 과정을 정상적으로 실행했다면, 아래의 명령어를 입력하여 서버를 테스트 구동시킨다.
이 과정에서 오류가 발생한다면, 마이그레이션이나 static 환경 설정을 다시 점검해야 한다.

```bash
python manage.py runserver
```

## Web

Console 창에서 나온 뒤, `Web`탭으로 이동한다.

`Code` 항목에서 아래의 사항을 점검한다.

### Source code

git clone을 진행한 폴더의 경로가 제대로 입력되었는 지 확인한다.
`home/<username>/<폴더명>`

### Working directory

보통 `home/<username>`으로 알아서 설정되어 있다.

### wsgi.py

WSGI configuration file에 해당하는 링크를 클릭하여 이동한다.
`var/www/<username>_pythonanywhere_com_wsgi.py`

그리고 다음의 항목을 수정한다.

- `project_home` : Console에서 git clone을 진행한 폴더명을 맨 끝에 입력한다.
- `DJANGO_SETTINGS_MODULE` : settings.py 파일이 포함된 폴더의 이름을 입력한다.

```python
...
project_home = '/home/<username>/Booklog'
os.environ['DJANGO_SETTINGS_MODULE'] = '<config 폴더>.settings'
...
```

다음으로 `Static files` 항목에서 아래의 사항을 점검한다.

### static

위에서 collectstatic을 실행한 Directory를 입력한다.
본 게시물에서는 `.staticfiles`를 static 폴더로 사용했지만, 각자의 세팅에 맞춰 입력하면 된다.

`/home/<username>/<폴더명>/.staticfiles`

### media

static과 마찬가지로 media 파일을 모으는 Directory를 입력한다.
위에서 이에 대한 설명이 없었지만, static과 비슷한 방식으로 적용하면 된다.

# 4. 서버 새로고침 및 접속

환경설정이 모두 끝났으면 동일한 페이지의 상단에 있는 `Reload` 버튼을 눌러 서버를 새로고침 한다.
그 다음 `<username>.pythonanywhere.com`에 접속하여 서버가 정상적으로 작동하는 지 확인한다.
