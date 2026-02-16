---
title: "[Spring/Next.js] AWS S3 Presigned URL 이용해서 이미지 업로드 및 조회 구현하기"
date: 2024-05-29 16:20:00 +0900
categories: [java, spring, typescript, nextjs]
tags: []
---

# 실행 환경

- OS: MacOS Sonoma 14.5
- Java: 17
- Spring Boot: 3.2.3
- Spring AWS S3: 3.0.0
- Next.js: 14.0.4

# 개요

프론트는 Next.js, 백엔드는 Java Spring 을 이용한 웹 프로젝트에서 AWS S3 Presigned URL 을 이용한 이미지 업로드를 구현한 과정을 정리했다.

백엔드 서버의 디스크(AWS EBS 등)에 이미지를 저장할 수도 있지만, S3 를 이용하는 것이 훨씬 장점이 많았다.

특히 Presigned URL 을 이용하면 프론트에서 백엔드 서버로 이미지 파일을 보낸 다음, 백엔드에서 S3 에 업로드 하는 과정을 거치지 않고, 프론트에서 직접 S3 에 이미지를 업로드 할 수 있다.

즉, 백엔드는 프론트에 S3 에 이미지를 업로드 할 수 있는 임시 자격 권한을 위임한 것이다.

전체 과정을 요약해서 이미지로 표현하면 아래와 같다.

![1.png](/assets/images/2024/2024-05-29-aws-s3-presigned-url-upload-with-java-spring-and-next-js/1.png)

# 이미지 저장을 AWS S3 에 하는 이유

구현에 앞서 이미지 파일을 AWS S3 에 저장하는 이유를 살펴보자.

AWS S3 를 선택한 이유는 크게 3가지로 정리할 수 있다.

## 1. 확장성

S3 를 이용하면 하드 디스크의 용량 제한 걱정 없이 이미지를 업로드 할 수 있다.

백엔드 서버는 EC2 인스턴스 에 실행하려고 하는데, 이미지 파일을 EC2 인스턴스에 연결된 EBS 볼륨(쉽게 생각하면 하드 디스크)에 저장한다면 용량이 부족할 때마다 용량을 확장 해주어야 한다.

용량을 확장하려면 직접 작업을 하는 건 어렵진 않지만, 꽤나 번거로운 작업이다.

이에 비해 S3 는 EBS 처럼 필요에 따라 용량을 늘리거나 줄일 필요가 없다.

사실상 S3 의 저장 공간은 사실상 무제한이라 생각하면 된다.

대신 S3 에는 실행 파일과 같은 바이너리 파일은 저장할 수 없고, 정적 파일(이미지, 동영상, HTML 등)을 업로드 하는 용도로 많이 사용한다.

## 2. 가격

S3 는 EBS 에 비해 훨씬 저렴하다.

EBS 는 이미지 파일 뿐만 아니라 운영체제에 필요한 파일이나 라이브러리 파일들도 저장하기 때문에 가격이 높을 수 밖에 없다.

S3 와 EBS 의 저장 공간 요금 차이는 아래와 같다. (2024년 5월 기준)

| 항목 | 가격(1GB) | 가격(30GB) |
| ---- | --------- | ---------- |
| EBS  | $0.114    | $3         |
| S3   | $0.025    | $0.75      |

물론 S3 는 HTTP 요청(GET, PUT, DELETE) 빈도에 따라 요금이 추가로 부과되지만, EBS 를 사용하는 것에 비해 훨씬 저렴하다.

## 3. 백엔드 서버의 부담 줄이기

S3 를 이용하면 이미지 저장을 처리하는 백엔드 서버의 부담을 줄일 수 있다.

만약 백엔드 서버에 이미지를 저장했다면 서버는 이미지도 저장하면서 동시에 다른 API 요청도 번갈아가면서 처리해야 한다.

이미지를 업로드 하는 사용자가 적으면 큰 문제가 없겠지만, 사용자가 많아진다면 하드 디스크에 파일 쓰기를 하느라 API 응답 속도도 느려질 것이다.

작은 규모로 만드는 프로젝트이기 때문에 백엔드 서버에 큰 부하가 있지는 않겠지만, 서비스가 커졌을 때 부하를 어떻게 관리할 것인지를 고려하면 S3 가 파일 저장만 담당하는 것이 괜찮은 선택이라 판단했다.

그래서 백엔드 서버는 비즈니스 로직만 담당하고, 파일 저장의 책임은 S3 가 나눠 갖도록 했다.

# Presigned URL

Presigned URL 을 직역하면 ‘미리 서명된 URL’이다.

여기서 미리 서명되었다는 것의 의미는 ‘특정 자원에 접근할 수 있는 권한을 가진다는 것을 미리 인증했다는 것’을 의미한다.

Presigned URL 은 S3 뿐만 아니라 AWS 의 다른 서비스에서도 많이 쓰이는 개념이다.

Presigned URL 을 사용하는 이유는 프론트엔드에서 S3 버킷에 직접 파일을 업로드 할 수 있는 권한을 주기 위해서다.

Presigned URL 을 발급 받기 위해서는 AWS S3 버킷에 접근할 수 있다는 권한이 있어야 한다는 걸 증명해야 하는데, 이는 백엔드가 담당한다.

아무나 S3 버킷에 접근해서 파일을 업로드 하거나 파일을 읽으면 나의 소중한 돈이 새어 나가는 참사가 벌어지기 때문에 정해진 사람만 Presigned URL 을 이용해서 S3 에 접근할 수 있도록 제한을 걸어둔 것이다.

이미지 업로드 기능의 흐름은 아래와 같다.

1. 프론트엔드가 웹 브라우저에서 이미지 업로드
2. 프론트엔드에서 백엔드로 이미지와 관련된 정보 전송(이미지 크기, 확장자, 파일 이름)
3. 백엔드는 프론트엔드에서 보낸 정보를 바탕으로 AWS 로부터 Presigned URL 발급
4. 백엔드는 발급 받은 Presigned URL 을 프론트엔드에 전달
5. 프론트엔드는 4번에서 받은 링크로 PUT 메서드를 이용해서 이미지를 전송

2번에서 이미지와 관련된 정보를 백엔드에 같이 보내는 이유는 프론트엔드에서 AWS S3 로 사용자가 마음대로 다른 파일을 업로드 하는 상황을 방지하기 위해서다.

백엔드가 AWS Presigned URL 을 발급 받을 때, 업로드 할 파일의 크기와 파일 확장자의 정보를 함께 보낼 수 있는데, 이 정보는 AWS S3 에서도 인식하고 있다.

그래서 S3 입장에서는 발급한 Presigned URL 로 업로드 요청이 들어왔을 때, Presigned URL 을 발급 했을 때 받은 파일의 크기와 다르거나, 파일의 확장자가 다르다면 업로드를 거부한다.

이를 통해 프론트엔드가 5MB 크기 이미지를 업로드 할 것처럼 백엔드에 요청해놓고, 1GB 크기 이미지를 S3 에 업로드 하는 일을 막을 수 있게 된다.

또한, Presigned URL 를 사용할 수 있는 유효 시간을 백엔드에서 정할 수 있기 때문에 아무 때나 S3 버킷에 파일을 업로드 하는 일을 막을 수도 있다.

이처럼 보안 측면에서도 이미지 업로드에 AWS S3 를 이용하면 장점이 있기 때문에 S3 를 이용해서 이미지 업로드 기능을 구현했다.

# AWS 설정

## S3 버킷 생성

Admin 권한이 있는 AWS 계정으로 접속한다.

S3 페이지로 이동해서 [버킷 만들기]를 클릭한다.

버킷 이름을 작성하고 나서 모든 옵션은 그대로 둔 채로 [버킷 만들기]를 클릭해서 버킷을 생성한다.

참고했던 자료에서는 퍼블릭 액세스 차단을 해제하도록 했는데, Presigned URL 을 이용하기 때문에 퍼블릭 액세스를 허용할 필요는 없다.

## CORS 설정

버킷이 생성되면 해당 버킷으로 접속해서 [권한] 탭으로 이동한다.

맨 마지막에 CORS 항목을 [편집] 버튼을 클릭해서 아래와 같이 작성한다.

```yaml
[
  {
    "AllowedHeaders": ["*"],
    "AllowedMethods": ["HEAD", "GET", "PUT", "POST"],
    "AllowedOrigins": ["*"],
    "ExposeHeaders": ["ETag"],
  },
]
```

![2.png](/assets/images/2024/2024-05-29-aws-s3-presigned-url-upload-with-java-spring-and-next-js/2.png)

## S3 전용 계정 생성

백엔드에서 S3 에 접근하기 위한 계정을 하나 만들 것이다.

해당 계정은 S3 와 관련된 기능만 수행할 수 있도록 제한할 것이다.

IAM 서비스로 이동해서 [액세스 관리] - [사용자] 탭으로 들어간 후 [사용자 생성]을 클릭한다.

![3.png](/assets/images/2024/2024-05-29-aws-s3-presigned-url-upload-with-java-spring-and-next-js/3.png)

사용자 이름은 원하는 대로 작성한다.

![4.png](/assets/images/2024/2024-05-29-aws-s3-presigned-url-upload-with-java-spring-and-next-js/4.png)

[권한 옵션]에서 [직접 정책 연결]을 선택하고 `AmaazonS3FullAccess` 를 검색해서 선택한다.

![5.png](/assets/images/2024/2024-05-29-aws-s3-presigned-url-upload-with-java-spring-and-next-js/5.png)

마지막 페이지에서 [사용자 생성]을 클릭해서 사용자를 생성한다.

## 액세스 키 발급

방금 생성한 계정을 통해 S3 에 접근하기 위해 액세스 키를 발급 받아야 한다.

[액세스 관리] - [사용자] 탭에서 방금 생성한 계정을 클릭해서 [보안 자격 증명] 탭으로 이동한다.

[액세스 키] 항목에서 [액세스 키 만들기]를 클릭한다.

![6.png](/assets/images/2024/2024-05-29-aws-s3-presigned-url-upload-with-java-spring-and-next-js/6.png)

[사용 사례] 페이지에서 [로컬 코드] 선택 후 하단에 체크박스를 선택하고 다음으로 넘어간다.

![7.png](/assets/images/2024/2024-05-29-aws-s3-presigned-url-upload-with-java-spring-and-next-js/7.png)

두 번째 페이지는 태그 설정인데, 이 부분은 생략해도 된다.

[액세스 키 만들기] 버튼을 클릭하면 액세스 키가 발급된다.

발급 받은 비밀 액세스 키는 두 번 다시 볼 수 없기 때문에 반드시 별도로 저장한다.

![8.png](/assets/images/2024/2024-05-29-aws-s3-presigned-url-upload-with-java-spring-and-next-js/8.png)

# 백엔드 구현

## 의존성 추가

AWS S3 를 백엔드에서 이용하기 위해 `build.gradle` 파일에 아래와 같이 의존성을 추가한다.

```groovy
dependencies {
    ...
    implementation 'io.awspring.cloud:spring-cloud-aws-starter-s3:3.0.0'
    ...
}
```

버전은 3.0.0 을 이용했는데, 시간이 지나면서 버전이 업데이트 되기 때문에 아래의 링크를 확인해서 최신 버전을 꼭 확인하자.

- https://spring.io/projects/spring-cloud-aws#learn

Spring 에서 제공하는 AWS S3 공식 문서는 아래의 링크를 참고했다.

- https://docs.awspring.io/spring-cloud-aws/docs/3.0.0/reference/html/index.html#spring-cloud-aws-s3

## AWS credentials 설정

AWS SDK 를 이용하기 위해서 위에서 입력한 사용자 인증 정보(액세스 키, 시크릿 키)가 필요하다.

[AWS 공식 문서](https://docs.awspring.io/spring-cloud-aws/docs/3.0.0/reference/html/index.html#defaultcredentialsprovider)에 따르면 아래와 같은 순서로 인증 정보를 찾는다고 하는데, 3가지 정도만 정리했다.

1. Java System Properties: `aws.accessKeyId` 와 `aws.secretAccessKey` 에 저장된 값을 불러온다.

   - System Properties 를 설정하는 방법은 2가지가 있다.
   - 첫 번째는 빌드한 애플리케이션을 실행할 때 설정하는 것이다.

   ```bash
   java -Daws.accessKeyId=YOUR_ACCESS_KEY -Daws.secretAccessKey=YOUR_SECRET_KEY -Daws.region.static=ap-northeast-2 -jar yourapp.jar
   ```

   - 두 번째는 `System.setProperty()` 메서드를 이용하는 것이다. (참고자료: [how to set system property in spring boot application](https://stackoverflow.com/questions/51867161/how-to-set-system-property-in-spring-boot-application) [stackoverflow]

   ```java
   @Profile("production")
   @Component
   public class ProductionPropertySetter {
       @PostConstruct
       public void setProperty() {
          System.setProperty("aws.accessKeyId", "...");
          System.setProperty("aws.secretAccessKey", "...");
       }
   }
   ```

2. 시스템 환경 변수: 로컬 환경에 환경 변수로 설정한 `AWS_ACCESS_KEY_ID` 와 `AWS_SECRET_ACCESS_KEY` 의 값을 불러온다.
3. Credentials Profiles: 로컬 환경의 `~/.aws/credentials` 파일은 AWS SDK 와 AWS CLI 에서 자격 증명을 저장하는데, 이 파일에 저장된 값을 불러온다.

이 글에서는 위의 3가지 방법이 아닌 `application.yaml` 파일에 설정하는 방법을 소개하고자 한다.

### application.yaml 파일 설정

`application.yaml` 파일에 AWS 계정과 관련한 정보를 입력한다.

```yaml
spring:
	cloud:
	  aws:
	    s3:
	      bucket: ${BUCKET_NAME}
	    stack:
	      auto: false
	    region:
	      static: ${AWS_REGION}
	    credentials:
	      access-key: ${AWS_ACCESS_KEY}
	      secret-key: ${AWS_SECRET_KEY}
```

속성에 대한 설명은 아래와 같다.

- cloud.aws.s3.bucket: 저장에 사용할 S3 버킷 이름
- cloud.aws.stack.auto: AWS CloudFormation 의 Stack 에 연동을 자동으로 할 것인지 결정
  - 정확한 의미는 잘 모르겠지만, 사용하지 않을 것이므로 `false` 로 설정 ([공식문서 링크](https://docs.awspring.io/spring-cloud-aws/docs/current/reference/html/index.html#cloudformation-configuration-in-spring-boot))
- cloud.aws.region.static: AWS 서비스를 사용한 리전 이름
- cloud.aws.credentials.access-key, secret-key: AWS IAM 에서 발급한 액세스 키와 시크릿 키

`${KEY}` 형태로 입력한 것들은 `.env` 파일에 저장한 값들을 가져오기 위한 것이다.

`.env` 파일에 위에서 발급 받은 IAM 사용자의 액세스 키와 시크릿 키 값을 입력한다.

```
BUCKET_NAME="my-bucket"
AWS_REGION="ap-northeast-2"
AWS_ACCESS_KEY="AKIAT3UTX3E2CSZBAYRH"
AWS_SECRET_KEY="my-secret"
```

IntelliJ 의 `EnvFile` 이라는 플러그인을 별도로 설치해서 환경변수 파일을 불러오고 있다.

해당 플러그인 설치 및 사용법은 아래의 링크를 참고하자.

- https://github.com/Ashald/EnvFile

![9.png](/assets/images/2024/2024-05-29-aws-s3-presigned-url-upload-with-java-spring-and-next-js/9.png)

AWS 서비스를 이용하기 위한 속성에 대한 자세한 정보는 아래의 링크를 참고했다. (3.0.0 버전 기준)

- https://docs.awspring.io/spring-cloud-aws/docs/3.0.0/reference/html/appendix.html

## S3 서비스 코드 작성

### S3FileService.java

S3 와 관련한 비즈니스 로직을 처리하는 클래스인 `S3FileService` 를 생성했다.

```java
@Slf4j
@RequiredArgsConstructor
@Service
public class S3FileService {
    private final S3Client s3Client;
    private final S3Presigner presigner;

    @Value("${spring.cloud.aws.s3.bucket}")
    private String bucket;
}
```

- `@Service` 어노테이션을 사용해서 Bean 객체로 등록한다.
- `@RequiredArgsConstructor` 를 통해 final 멤버 변수로 등록한 `S3Client` 와 `S3Presigner` 객체를 Spring 컨테이너로부터 주입받는다.
- `spring.cloud.aws.s3.bucket` 은 공식적으로 지원하는 속성이 아니기 때문에 `@Value` 어노테이션을 통해 값을 가져오도록 했다.

### HTTP PUT 요청 Presigned URL 발급

S3 에 파일을 업로드 할 때는 POST 가 아닌 PUT 메서드를 사용한다.

이는 S3 가 동일한 이름을 가진 파일의 버전 관리를 지원하기 때문이다.

앞에서 생성한 `S3FileService` 클래스에 S3 에 HTTP PUT 요청을 보낼 수 있는 Presigned URL 을 받는 메서드를 작성했다.

```java
public String getPutPreSignedUrl(String prefix, String fileName, String extension, Long contentLength) {
    String filePath = String.format("%s/%s", prefix, fileName);
    String contentType = String.format("image/%s", extension);
    PutObjectRequest objectRequest = PutObjectRequest.builder()
            .bucket(bucket)
            .key(filePath)
            .contentType(contentType)
            .contentLength(contentLength)
            .build();

    PutObjectPresignRequest presignRequest = PutObjectPresignRequest.builder()
            .signatureDuration(Duration.ofMinutes(2))
            .putObjectRequest(objectRequest)
            .build();

    PresignedPutObjectRequest presignedRequest = presigner.presignPutObject(presignRequest);
    log.info("[S3FileService] getPutPreSignedUrl: {}", presignedRequest.url().toString());
    return presignedRequest.url().toString();
}
```

S3 버킷에 폴더가 존재하지 않더라도 폴더도 파일이기 때문에 PUT 요청을 보내면 새롭게 폴더가 생성된다.

주목할 부분은 `PutObjectRequest` 객체를 생성할 때 `contentType` 과 `contentLength` 를 매개변수로 받는다는 점이다.

만약 이 정보들이 없다면 프론트에서는 마음대로 용량이 지나치게 큰 파일이나, 사진이 아닌 동영상을 올릴 가능성이 있다.

그래서 프론트는 이미지 파일의 확장자와 이미지 파일의 크기를 백엔드로 전송하고, 백엔드는 이 정보를 바탕으로 AWS 에 Presigned URL 을 요청하도록 했다.

프론트는 백엔드에서 받은 Presigned URL 를 이용해서 이미지 파일을 전송하는데, 이때 백엔드에서 AWS 에 Presigned URL 을 발급 받을 때 입력했던 정보인 `contentType` 과 `contentLength` 와 프론트에서 보내는 `contentType` 과 `contentLength` 정보가 다르다면 업로드를 거절한다.

그리고 발급 받은 Presigned URL 의 유효시간을 짧게 설정함으로써 링크가 탈취당한 경우에는 업로드 시도를 최소화하고, 의도적으로 다른 파일을 올리려고 시도하는 경우도 최소화하고자 했다.

### HTTP GET 요청 Presigned URL 발급

S3 에 저장한 이미지 파일의 이름은 사용자 정보와 함께 DB 에 저장했다.

이미지 파일을 아무나 받아가게 하는 것은 비용의 증가로 이어지기 때문에 S3 버킷에 저장한 이미지를 불러올 때도 Presigned URL 을 이용해서 받아오도록 했다.

아래의 메서드도 `S3FileService` 클래스에 정의했다.

```java
public String getGetPreSignedUrl(String prefix, String fileName) {
    String filePath = String.format("%s/%s", prefix, fileName);
    GetObjectRequest objectRequest = GetObjectRequest.builder()
            .bucket(bucket)
            .key(filePath)
            .build();

    GetObjectPresignRequest presignRequest = GetObjectPresignRequest.builder()
            .signatureDuration(Duration.ofMinutes(2))
            .getObjectRequest(objectRequest)
            .build();

    PresignedGetObjectRequest presignedRequest = presigner.presignGetObject(presignRequest);
    log.info("[S3FileService] getGetPreSignedUrl: {}", presignedRequest.url().toString());
    return presignedRequest.url().toExternalForm();
}
```

## 컨트롤러 작성

### 이미지 업로드 컨트롤러

프론트가 보낸 이미지 업로드 요청을 받는 컨트롤러에서는 이미지 파일 확장자와 이미지 파일의 크기를 받도록 아래의 DTO 클래스를 만들었다.

```java
// domain/member/dto/MemberRequest.java

@Getter
public class MemberRequest {
    private String nickname;
    private String imageExtension;
    private Long contentLength;
}
```

컨트롤러를 담당하는 API 클래스에는 `S3FileService` 클래스의 의존성을 주입한다.

```java
// domain/member/api/MemberApi.java

@RestController
@RequiredArgsConstructor
@Slf4j
public class MemberApi {
    private final MemberService memberService;
    private final MemberProfileService memberProfileService;
    private final TokenService tokenService;
    private final S3FileService s3FileService;
}
```

Authorization Header 에 담긴 JWT 토큰의 정보를 기반으로 사용자의 정보를 찾고, 이미지 파일과 관련한 예외처리를 추가해서 아래와 같이 컨트롤러를 작성했다.

```java
// domain/member/api/MemberApi.java

@PatchMapping("/member")
@ResponseStatus(HttpStatus.OK)
public ResponseEntity<String> patchMember(@RequestBody MemberRequest memberRequest,
                                          @RequestHeader("Authorization") String authorizationHeader) {
    Optional<String> optionalToken = tokenService.getTokenFromHeader(authorizationHeader);
    if (optionalToken.isEmpty()) {
        String message = ErrorResponse.UNAUTHORIZED.getMessage();
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(message);
    }

    String nickname = memberRequest.getNickname();
    String imageExtension = memberRequest.getImageExtension();
    log.info("[PATCH /member] nickname: {}, imageExtension: {}", nickname, imageExtension);

    String token = optionalToken.get();
    String email = tokenService.getEmail(token);
    Member member = memberService.findByEmail(email);
    Long contentLength = memberRequest.getContentLength();

    // 1. 이미지 크기 제한이 넘을 경우
    if (ImageUtil.isValidFileSize(contentLength) == false) {
        String message = ErrorResponse.IMAGE_CONTENT_TOO_LARGE.getMessage();
        return ResponseEntity.status(HttpStatus.PAYLOAD_TOO_LARGE).body(message);
    }

    // 2. 이미지 확장자가 허용되지 않은 경우
    if (ImageUtil.isValidImageExtension(imageExtension) == false) {
        String message = ErrorResponse.UNSUPPORTED_IMAGE_EXTENSION.getMessage();
        return ResponseEntity.status(HttpStatus.UNSUPPORTED_MEDIA_TYPE).body(message);
    }

    // 3. 닉네임 규칙이 맞지 않은 경우
    if (memberProfileService.isValidNickname(nickname) == false) {
        String message = ErrorResponse.INVALID_NICKNAME_RULE.getMessage();
        return ResponseEntity.status(HttpStatus.UNPROCESSABLE_ENTITY).body(message);
    }

    // 4. 닉네임만 변경
    if (imageExtension.isEmpty()) {
        member.updateProfile(nickname, member.getImageFileName());
        memberService.save(member);
        String message = Response.PROFILE_UPDATE_SUCCESS.getMessage();
        return ResponseEntity.status(HttpStatus.OK).body(message);
    }

    // 5. 프로필 이미지가 이미 존재하고, 새롭게 업로드 하는 경우
    s3FileService.deleteImage("profiles", member.getImageFileName());

    String randomFileName = UUID.randomUUID().toString();
    String savedFileName = String.format("%s.%s", randomFileName, imageExtension);
    log.info("[PATCH /member] savedFileName: {}", savedFileName);

    member.updateProfile(memberRequest.getNickname(), savedFileName);
    memberService.save(member);

    String preSignedUrl = s3FileService.getPutPreSignedUrl("profiles", savedFileName, imageExtension, contentLength);

    return ResponseEntity.status(HttpStatus.OK).body(preSignedUrl);
}
```

### 이미지 GET 컨트롤러

사용자 정보를 조회하면서 사용자가 업로드한 이미지 링크를 받아오기 위한 컨트롤러는 아래와 같이 작성했다.

```java
// domain/member/api/MemberApi.java

@GetMapping("/member")
@ResponseStatus(HttpStatus.OK)
public ResponseEntity<?> getMember(@RequestHeader("Authorization") String authorizationHeader) {
    Optional<String> optionalToken = tokenService.getTokenFromHeader(authorizationHeader);
    if (optionalToken.isEmpty()) {
        String message = ErrorResponse.UNAUTHORIZED.getMessage();
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(message);
    }

    String token = optionalToken.get();
    log.info("[GET /member] token: {}", token);

    String email = tokenService.getEmail(token);
    log.info("[GET /member] email: {}", email);

    Member member = memberService.findByEmail(email);
    String nickname = member.getNickname();
    Optional<String> optionalImageFileName = Optional.ofNullable(member.getImageFileName());
    MemberResponse memberResponse;

    if (optionalImageFileName.isEmpty()) {
        memberResponse = new MemberResponse(nickname, "");
    } else {
        String imageFileName = optionalImageFileName.get();
        log.info("[GET /member] imageFileName: {}", imageFileName);
        String preSignedGetUrl = s3FileService.getGetPreSignedUrl("profiles", imageFileName);
        memberResponse = new MemberResponse(nickname, preSignedGetUrl);
    }

    return ResponseEntity.status(HttpStatus.OK).body(memberResponse);
}
```

`MemberResponse` DTO 는 아래와 같다.

```java
// domain/member/dto/MemberApi.java

@Getter
@AllArgsConstructor
public class MemberResponse {
    private String nickname;
    private String imageUrl;
}
```

# 프론트 구현

## 이미지 업로드

프론트는 이미지를 업로드 하기 위해 백엔드에 S3 에 이미지를 저장할 수 있는Presigned URL 을 받아야 한다.

그리고 이 링크를 통해 S3 에 이미지를 업로드한다.

이미지와 닉네임을 입력받기 때문에 [react-hook-form](https://react-hook-form.com/) 라이브러리를 이용해서 form 의 유효성 검증을 처리했다.

### form 인터페이스

```tsx
interface IForm {
  nickname: string;
  profileImage: FileList | File | null;
}
```

form 에서 input 태그를 통해 이미지 파일을 받기 때문에 `FileList` 나 `File` 자료형을 받을 수 있도록 인터페이스를 정의했다.

### DTO 인터페이스

백엔드로 전송할 데이터는 이미지 바이너리 파일이 아닌 이미지의 메타데이터에 해당하는 이미지 확장자와 이미지 파일 크기이다.

그래서 아래와 같이 인터페이스를 정의했다.

```tsx
interface IProfileDTO {
  nickname: string;
  imageExtension: string;
  contentLength: number;
}
```

### PUT 요청 Presigned URL 요청

백엔드에 S3 에 업로드 할 수 있는 Presigned URL 을 요청하기 위해 아래와 같은 코드를 작성했다.

백엔드에는 `IForm` 인터페이스가 아닌 `IProfileDTO` 로 보내야 하기 때문에 `IForm` 에 담긴 정보를 `IProfileDTO` 로 옮긴 다음 백엔드로 API 요청을 보낸다.

```tsx
const onSubmitWithValid = async (validForm: IForm) => {
  const data: IProfileDTO = {
    nickname: validForm.nickname ? validForm.nickname : nickname,
    imageExtension: "",
    contentLength: 0,
  };

  if (
    validForm.profileImage instanceof FileList &&
    validForm.profileImage.length == 1
  ) {
    const file = validForm.profileImage[0];
    validForm.profileImage = file;
    data.imageExtension = imageExtension;
    data.contentLength = file.size;
  }

  try {
    // PUT 요청 Presigend URL 요청
    const res = await apiManager.patch("/member", data);
  } catch (error) {
    console.log(error);
  }
};
```

### S3 이미지 업로드

백엔드에서 Presigned URL 을 발급 받으면 이 링크를 통해 S3 로 이미지 파일을 보내기만 하면 끝난다.

백엔드에서 `Content-Type` 과 `Content-Length` 를 검증하도록 설정해놨기 때문에 header 에 `Content-Type` 만 추가해서 보내주기만 하면 된다.

`Content-Length` 는 자동으로 계산되어 header 에 추가된다.

```tsx
try {
  // PUT 요청 Presigend URL 요청
  const res = await apiManager.patch("/member", data);

	// Presigned URL 를 이용해서 S3 에 이미지 업로드
	if (res.status === HttpStatusCode.Ok && previewImage) {
		const preSignedUrl: string = res.data;
		const res2 = await axios.put(preSignedUrl, validForm.profileImage, {
		  headers: {
		    "Content-Type": "image/" + imageExtension,
		  },
		});
	}
}
```

## 이미지 조회 요청

이미지를 받아오는 과정은 백엔드에서 알아서 가져오기 때문에 프론트에서는 백엔드로 요청을 보내기만 하면 된다.

```tsx
const getProfile = async () => {
  try {
    const res = await apiManager.get("/member");
    console.log(res);
    const { nickname, imageUrl }: { nickname: string; imageUrl: string } =
      res.data;

    if (imageUrl.length > 0) {
      setProfileImageUrl(imageUrl);
    }
    setNickname(nickname);
  } catch (error) {
    console.log(error);
  }
};
```

## 전체 코드

코드에는 이미지 업로드 후 이미지 미리보기 기능도 함께 구현되어있다.

```tsx
"use client";

import { useEffect, useState } from "react";
import Image from "next/image";

import { useForm } from "react-hook-form";
import axios, { HttpStatusCode } from "axios";

import Layout from "@app/components/layout";
import Button from "@app/components/button";
import profilePic from "@public/default-profile.jpeg";
import apiManager from "@api/apiManager";
import { removeJwtFromSessionStorage } from "@libs/jwt";

interface IForm {
  nickname: string;
  profileImage: FileList | File | null;
}

interface IProfileDTO {
  nickname: string;
  imageExtension: string;
  contentLength: number;
}

const MB = 1024 * 1024;

const Page = () => {
  const {
    register,
    setError,
    handleSubmit,
    formState: { errors },
  } = useForm<IForm>({});

  const [nickname, setNickname] = useState<string>("");
  const [imageExtension, setImageExtension] = useState<string>("");
  const [profileImageUrl, setProfileImageUrl] = useState<string | null>(null);
  const [previewImage, setPreviewImage] = useState<string | null>(null);

  const onSubmitWithValid = async (validForm: IForm) => {
    const data: IProfileDTO = {
      nickname: validForm.nickname ? validForm.nickname : nickname,
      imageExtension: "",
      contentLength: 0,
    };

    if (
      validForm.profileImage instanceof FileList &&
      validForm.profileImage.length == 1
    ) {
      const file = validForm.profileImage[0];
      validForm.profileImage = file;
      data.imageExtension = imageExtension;
      data.contentLength = file.size;
      console.log(data);
    }
    try {
      console.log(validForm);
      const res = await apiManager.patch("/member", data);
      console.log(res);
      if (res.status === HttpStatusCode.Ok && previewImage) {
        const preSignedUrl: string = res.data;
        const res2 = await axios.put(preSignedUrl, validForm.profileImage, {
          headers: {
            "Content-Type": "image/" + imageExtension,
          },
        });
        console.log(res2);
      }
    } catch (error) {
      console.log(error);
    }
  };

  const onProfileNicknameChange = (
    event: React.ChangeEvent<HTMLInputElement>
  ) => {
    setNickname(event.target.value);
    console.log(event.target.value);
  };

  const onProfileImageChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    const files = event.target.files;
    if (!files || files.length <= 0) return;

    const file = files[0];
    const fileType = file.type;

    const validExtensions = [
      "image/jpeg",
      "image/jpg",
      "image/png",
      "image/gif",
    ];
    if (!validExtensions.includes(fileType)) {
      setError("profileImage", {
        message: "지원되는 파일 형식은 JPEG, JPG, PNG, GIF입니다.",
      });
      return;
    }

    if (file.size > 1 * MB) {
      setError("profileImage", {
        message: "파일 크기는 1MB를 초과할 수 없습니다.",
      });
    } else {
      setError("profileImage", { message: "" });

      const extension: string = file.type.slice(file.type.indexOf("/") + 1);
      setImageExtension(extension);

      const reader = new FileReader();
      reader.onload = () => {
        setPreviewImage(reader.result as string);
      };
      reader.readAsDataURL(file);
    }
  };

  const getProfile = async () => {
    try {
      const res = await apiManager.get("/member");
      console.log(res);
      const { nickname, imageUrl }: { nickname: string; imageUrl: string } =
        res.data;

      if (imageUrl.length > 0) {
        setProfileImageUrl(imageUrl);
      }
      setNickname(nickname);
    } catch (error) {
      console.log(error);
    }
  };

  useEffect(() => {
    getProfile();
  }, []);

  return (
    <Layout title="프로필" hasTabBar>
      <div className="flex flex-col items-center space-y-10">
        <form
          className="static flex flex-col items-center w-full px-4 space-y-4"
          onSubmit={handleSubmit(onSubmitWithValid)}
        >
          <Image
            className="rounded-full size-32"
            src={previewImage || profileImageUrl || profilePic}
            alt="Picture of me"
            width={300}
            height={300}
          />
          <label className="absolute inline-flex items-center justify-center w-6 h-6 text-sm font-semibold text-gray-600 bg-gray-100 rounded-full top-40 left-64 me-2">
            <input
              className="hidden"
              type="file"
              accept="image/jpeg, image/jpg, image/png, image/gif"
              {...register("profileImage", { onChange: onProfileImageChange })}
            />
          </label>
          <div className="flex flex-col w-full space-y-6">
            <div className="flex flex-col w-full space-y-2">
              <span className="text-sm">닉네임</span>
              <input
                type="text"
                value={nickname}
                {...register("nickname", { onChange: onProfileNicknameChange })}
                className="w-full px-3 py-2 placeholder-gray-400 appearance-none rounded-2xl focus:outline-none focus:ring-green-500 focus:border-green-500"
              />
            </div>
            <Button text="저장" />
          </div>
          {errors.nickname && <span>{errors.nickname.message}</span>}
          {errors.profileImage && <span>{errors.profileImage.message}</span>}
        </form>
        </div>
      </div>
    </Layout>
  );
};

export default Page;

```

# 참고자료

- [[Springboot] AWS S3 버킷을 이용한 PresignedUrl로 이미지 업로드 구현하기](https://vanillacreamdonut.tistory.com/365) [티스토리]
- [[Spring Boot] 서버리스 기반 S3 Presigned URL 적용하기](https://velog.io/@jmjmjmz732002/Spring-Boot-%EC%84%9C%EB%B2%84%EB%A6%AC%EC%8A%A4-%EA%B8%B0%EB%B0%98-S3-Presigned-URL-%EC%A0%81%EC%9A%A9%ED%95%98%EA%B8%B0) [velog]
- [[SpringBoot] AWS S3로 이미지 업로드](https://velog.io/@mingsound21/SpringBoot-AWS-S3%EB%A1%9C-%EC%9D%B4%EB%AF%B8%EC%A7%80-%EC%97%85%EB%A1%9C%EB%93%9C) [velog]
- [S3 Presigned Url 도입하기 (+Java로 파일 크기 제한[content-length] 추가)](https://velog.io/@invidam/S3-Presigned-Url-%EB%8F%84%EC%9E%85%ED%95%98%EA%B8%B0) [velog]
- [Spring boot 3.0 + S3 서비스 적용 By Spring Cloud for AWS](https://white-developer.tistory.com/75) [티스토리]
- [Create a presigned URL for Amazon S3 using an AWS SDK](https://docs.aws.amazon.com/AmazonS3/latest/userguide/example_s3_Scenario_PresignedUrl_section.html) [aws docs]
