---
title: "[AWS] IAM Role(역할) 과 Policy(정책) 의 차이"
date: 2023-12-19 20:20:00 +0900
categories: [aws]
tags: []
---
# 결론

Policy 는 IAM 사용자 또는 그룹의 접근 권한을 정의하는 것이다. 정책을 부여하고 나서 별도로 회수하지 않는다면 영구적으로 부여받은 권한에 따라 AWS 내의 자원(Resource)에 접근할 수 있다. 

반면, Role 은 Policy 와 달리 일시적으로 AWS 내의 자원에 접근할 수 있는 권한을 얻고, 권한을 유지할 수 있는 시간이 지나면 그 이후에는 권한이 사라진다. 만약, 다시 권한을 얻고자 한다면 임시 보안 자격 증명을 통해 발급 받아야 한다. Role 은 Policy 연결이 되어야 하는데, Policy 에 정의된 접근 권한에 따라 일시적으로 권한을 얻는 것이다.

# Policy(정책)

Policy 의 종류에는 AWS 에서 기본적으로 제공하는 것과 사용자가 정의해서 사용하는 총 2가지 종류가 있다.

AWS 에서 기본적으로 제공하는 대표적인 정책으로는 모든 권한을 획득하는 AdministratorAccess 가 있다. 

사용자가 정의하는 정책은 최소권한 원칙에 따라 사용자에게 필요한 권한만 부여하고, 접근할 필요가 없는 자원에 접근하는 것을 제한하는 효과가 있다.

## 실습으로 이해하기

Policy 를 직접 만들어보며 이해해보자.

IAM 사용자를 이미 생성한 상황이며, 해당 사용자에게는 어떤 권한도 주어져있지 않은 상태이다.

IAM 사용자에게는 S3 버킷 목록만 조회할 수 있는 권한을 부여하고 싶다고 해보자.

![1.png](/assets/images/2023/2023-12-19-aws-iam-role-and-policy/1.png)

루트 사용자의 계정으로 접속해서 [IAM - 액세스 관리 - 정책]으로 이동해서 `정책 생성` 을 클릭한다.

![2.png](/assets/images/2023/2023-12-19-aws-iam-role-and-policy/2.png)

[서비스]에서 [S3]를 선택한다.

![3.png](/assets/images/2023/2023-12-19-aws-iam-role-and-policy/3.png)

[액세스 수준] 에서 [나열] 항목을 펼친 다음 `ListAllMyBuckets` 를 선택하고 [다음]을 선택한다.

`ListAllMyBuckets` 작업은 S3 의 모든 버킷을 조회할 수 있는 권한이다. 

![4.png](/assets/images/2023/2023-12-19-aws-iam-role-and-policy/4.png)

정책 이름은 원하는 대로 입력해준 다음 [정책 생성]을 클릭한다.

![5.png](/assets/images/2023/2023-12-19-aws-iam-role-and-policy/5.png)

[액세스 관리 - 사용자]를 선택하고, 생성한 IAM 유저를 선택한다.

![6.png](/assets/images/2023/2023-12-19-aws-iam-role-and-policy/6.png)

[권한] 탭에서 [권한 추가]를 클릭하고 [권한 추가]를 클릭한다.

![7.png](/assets/images/2023/2023-12-19-aws-iam-role-and-policy/7.png)

[권한 옵션]에서 [직접 정책 연결]을 선택하고 [권한 정책] 검색 필드에서 아까 만들었던 정책의 이름을 입력하고 선택 후 [다음]을 클릭한다.

![8.png](/assets/images/2023/2023-12-19-aws-iam-role-and-policy/8.png)

[권한 추가]를 클릭한다.

![9.png](/assets/images/2023/2023-12-19-aws-iam-role-and-policy/9.png)

권한을 부여하기 전에는 생성한 IAM 사용자가 [S3]에 접속하면 위와 같이 버킷을 표시할 권한이 없다는 경고창이 뜨지만, 정책을 연결하고 나면 아래와 같이 변경된다.

![10.png](/assets/images/2023/2023-12-19-aws-iam-role-and-policy/10.png)

이렇게 부여받은 Policy 는 루트 사용자가 정책을 해제하지 않는 이상 영구적인 권한을 부여 받는다.

# Role(역할)

위에서 언급했듯이 Role 은 일시적으로 권한을 부여 받는 것을 의미한다.

Role 은 Policy 와 연결되어야 사용할 수 있으며, Role 을 부여 받을 대상을 명시적으로 정의해주어야 한다.

## 실습으로 이해하기

![11.png](/assets/images/2023/2023-12-19-aws-iam-role-and-policy/11.png)

루트 계정에서 [IAM - 액세스 관리 - 역할]을 클릭하고, [역할 생성]을 클릭한다.

![12.png](/assets/images/2023/2023-12-19-aws-iam-role-and-policy/12.png)

[신뢰할 수 있는 엔터티 유형]에서 [AWS 서비스]를 클릭하고 [서비스 또는 사용 사례]에서 [S3]를 선택한다.

![13.png](/assets/images/2023/2023-12-19-aws-iam-role-and-policy/13.png)

위에서 생성했던 Policy 이름을 검색해서 선택하고 [다음]을 클릭한다.

![14.png](/assets/images/2023/2023-12-19-aws-iam-role-and-policy/14.png)

[역할 이름]에 원하는 이름을 작성하고 밑으로 내려서 [역할 생성]을 클릭한다.

![15.png](/assets/images/2023/2023-12-19-aws-iam-role-and-policy/15.png)

생성한 역할을 찾아서 클릭하고 [신뢰 관계] 탭으로 이동하여 [신뢰 정책 편집]을 클릭한다.

![16.png](/assets/images/2023/2023-12-19-aws-iam-role-and-policy/16.png)

[보안 주체 추가]의 오른쪽에 있는 [추가] 버튼 클릭

![17.png](/assets/images/2023/2023-12-19-aws-iam-role-and-policy/17.png)

[보안 주체 유형]은 [IAM users]를 선택하고, {Account} 대신 계정 ID 를 입력하고, {UserName} 대신 IAM 사용자를 입력한다.

![18.png](/assets/images/2023/2023-12-19-aws-iam-role-and-policy/18.png)

계정 ID 는 우측 상단에 계정 이름을 클릭하면 확인할 수 있는 12자리 숫자를 의미한다.

위의 이미지와 같이 입력하면 된다.

그 다음 [정책 업데이트] 버튼을 클릭한다.

![19.png](/assets/images/2023/2023-12-19-aws-iam-role-and-policy/19.png)

[액세스 관리 - 사용자]으로 이동해서 아까 연결했던 정책은 제거해준다.

![20.png](/assets/images/2023/2023-12-19-aws-iam-role-and-policy/20.png)

그리고 IAM 사용자 화면으로 돌아와서 S3 버킷을 조회하려고 하면 위와 같이 권한이 없다는 경고창이 뜬다.

![21.png](/assets/images/2023/2023-12-19-aws-iam-role-and-policy/21.png)

우측 상단에 계정 이름을 클릭하면 표시되는 리스트 목록에서 [역할 전환]을 클릭한다.

![22.png](/assets/images/2023/2023-12-19-aws-iam-role-and-policy/22.png)

[계정] 항목에는 [계정 ID]를 입력하고, [역할]에는 위에서 생성한 역할의 이름을 “정확하게” 입력해야 한다.

![23.png](/assets/images/2023/2023-12-19-aws-iam-role-and-policy/23.png)

역할 이름을 정확하게 입력하지 않으면 위와 같이 “하나 이상의 필드에 잘못된 정보가 있습니다. 정보를 확인하거나 관리자에게 문의하십시오.”라는 문구가 표시되면서 역할 전환이 제대로 이루어지지 않는다.

![24.png](/assets/images/2023/2023-12-19-aws-iam-role-and-policy/24.png)

정상적으로 입력했다면 우측 상단에 역할 이름과 함께 색깔이 변한다.

그리고 정상적으로 S3 버킷 목록을 조회할 수 있게 된다.

웹 페이지에서 역할 전환하고 나서 1시간 후에는 다시 역할 전환 버튼을 클릭해서 권한을 얻어야 한다.

AWS CLI 에서도 1시간 후에는 다시 역할에 대한 권한을 발급 받아야 한다.

# 참고자료

- [AWS IAM 정책(policy) 과 역할(role) 의 차이](https://going-to-end.tistory.com/entry/AWS-IAM-%EC%A0%95%EC%B1%85policy-%EC%99%80-%EC%97%AD%ED%95%A0role-%EC%9D%98-%EC%B0%A8%EC%9D%B4) [티스토리]
- [AWS IAM 역할(Role)은 정확히 무엇인가요? 어떻게 써야 할까요](https://jonnung.dev/posts/2021-01-28-aws-iam-role/#gsc.tab=0) [jonnung.dev]