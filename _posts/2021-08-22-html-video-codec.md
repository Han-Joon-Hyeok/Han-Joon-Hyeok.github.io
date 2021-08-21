---
title: HTML video 영상이 보이지 않고 소리만 나오는 현상
date: 2021-08-22 01:00:00 +0900
categories: [HTML]
tags: [HTML]
---

# 현상
HTML에 `<video>` 태그를 사용해서 영상을 삽입하고자 했으나, 소리는 나오고 영상이 나오지 않았다.
```
<video>
	<source src="video.mp4"/>
</video>
```
# 원인
아이폰으로 촬영한 영상은 `H.265` 비디오 코덱을 사용하는데, [웹 비디오 코덱 가이드](https://developer.mozilla.org/ko/docs/Web/Media/Formats/Video_codecs)에 따르면 해당 코덱은 지원하지 않기 때문에 화면은 나오지 않는 것이다.

# 해결방법
비디오 코덱을 H.264로 변환해주면 된다. 구글에 `H264 변환`을 검색하면 다양한 변환 사이트가 나오기 때문에 어느 사이트를 이용해도 된다.
https://anyconv.com/ko/h264-to-mp4-byeonhwangi/

## 참고
- [Django HTML Video streaming에서 소리만 나오는 문제](https://binux.tistory.com/16)