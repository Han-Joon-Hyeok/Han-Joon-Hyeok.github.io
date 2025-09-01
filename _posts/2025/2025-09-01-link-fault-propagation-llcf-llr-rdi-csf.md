---
title: "LLR, CSF, RDI  개념 정리"
date: 2025-09-01 15:45:00 +0900
categories: [Network]
tags: []
use_math: true
---

# LLR(Link Ross Return)

LLR은 한쪽 포트에서 송신부(TX) 신호가 꺼졌을 때, 상대편 포트에도 동일하게 Link Down 상태를 반영해주는 기능이다. 한쪽 방향만 죽어있는 비대칭 링크 상태를 방지하고, 양단이 동시에 링크 다운을 인지하도록 하기 위해서 사용한다.

LLCF와 다른 점은 LLCF는 수신부(RX) 장애를 반대편으로 전달하는 것이고, LLR은 송신부(TX) 장애를 반대편으로 전달하는 것이다.

## 동작 예시

1. 장비 A의 TX를 Shutdown 시킴
2. 장비 B는 RX에서 신호를 받지 못해서 Link Down 인식
3. LLR 기능이 켜져 있다면, 장비 B는 자신의 TX를 끊어 장비 A로 보내는 신호를 내림
4. 양단 모두 Link Down 상태가 되고, 절체와 같은 상위 동작이 수행

# RDI(Remote Defect Indication)

OAM 메시지 수신 측에서 LOC와 같은 장애를 감지했을 때, 그 사실을 OAM 메시지 송신 측에 알리기 위해 사용하는 신호를 의미한다.

## 동작 예시

1. 장애 감지
    - Tail 장비의 RX에서 LOC, LOS, LOF와 같은 장애를 감지
2. RDI 플래그 비트 설정
    - Tail은 자신이 주기적으로 송신하는 OAM 메시지(CCM, BFD 등)의 RDI 플래그 비트를 1로 설정
3. 원격 전파
    - Head는 Tail이 보낸 OAM 메시지에서 RDI 플래그를 보고 원격(Tail)에서 결함이 발생했음을 인지함
4. 양단 장애 인식 동기화
    - 위의 과정을 통해 양쪽 장비가 동시에 장애를 인식하여 절체를 수행할 수 있음

# CSF(Client Signal Fail)

전송 장비(MPLS-TP, Pseudowire, Ethernet OAM 등)에서 클라이언트 측 신호(UNI/AC 포트에서 들어오는 서비스 신호)에 장애가 발생했음을 원격에 알리기 위한 OAM 신호이다. 즉, 물리 계층에서 들어오는 고객/하위 신호에 문제가 생겼을 때, MPLS 패킷망이나 PW를 통해 반대편 장비에 전달하기 위한 신호이다.

## 동작 예시

1. 장애 감지
    - UNI 인터페이스에서 LOS, LOF, LOC 같은 장애를 감지 (CSF)
2. OAM 메시지 생성
    - Head 장비는 CSF 메시지를 OAM 프레임에 담아 전송
3. 원격 전파
    - Tail 장비가 CSF 메시지를 받고 Head 장비의 클라이언트 신호 RX에 문제가 생겼다는 사실을 인지
4. 알람 및 절체
    - Tail 장비는 자신의 UNI 인터페이스에 장애를 반영하거나, 상위 제어/보호 절체 절차를 트리거

# LLCF, LLR 비교

LLCF와 LLR은 비슷해 보이지만, 다음과 같은 차이가 있다.

| 구분 | LLCF (Link Loss Carry Forward) | LLR (Link Loss Return) |
| --- | --- | --- |
| 트리거 | RX(수신부)에서 장애(LOS/LOF/LOC) 감지 | TX(송신부)에서 장애 감지 |
| 동작 | 내 RX가 죽으면 내 TX도 끊어서 반대편이 Link Down 인식 | 내 TX가 죽으면 반대편이 RX에서 Link Down 감지 → 반대편도 자기 TX를 끊음 |
| 알림 방향 | 장애 → 반대편 알림 | 내가 끊음 → 반대편도 끊어서 동기화 |
| 관점 | “내가 문제를 감지했으니 알려준다” | “내가 내렸으니 너도 같이 내려라” |

# RDI, CSF 비교

마찬가지로 RDI와 CSF도 비슷해 보이지만, 다음과 같은 차이가 있다.

| 구분 | RDI (Remote Defect Indication) | CSF (Client Signal Fail) |
| --- | --- | --- |
| 트리거 | RX에서 OAM 메시지(CCM/BFD) 단절(LOC) 감지 | 클라이언트 신호(UNI/AC 쪽)에서 장애 감지 |
| 누가 발생 | Tail/Egress 장비 | Head/Ingress 장비 |
| 알림 방향 | “네가 보낸 걸 내가 못 보고 있어” | “내 쪽 클라이언트 신호가 죽었어” |
| 관점 | Egress에서 알림 반환 | Ingress에서 알림 시작 |