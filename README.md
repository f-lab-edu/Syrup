## Syrup
###  AI 챗 서비스 앱

## 개요
- AI 챗 서비스는 사용자가 다양한 인공지능과 상호 작용할 수 있는 혁신적인 앱입니다. 이 앱은 현재 GeminiAI를 지원하며, 상호 작용적인 AI 채팅 경험을 제공합니다.

## 기술 스택
- Swift Concurrency Async/Await
- MVVM Design pattern
- Combine for data binding
- Firebase
- UIKit (Code-based)

## 주요 기능
- 소셜 로그인: 구글 및 애플 계정을 이용한 소셜 로그인 기능.
- 채팅방 리스트: AI와의 채팅을 위한 채팅방을 조회, 생성, 삭제 기능.
- 채팅: Google의 GeminiAI와 메시지를 주고받으며 채팅 기능.
- Firebase Auth 사용: 사용자 인증을 위해 Firebase Auth를 사용.
- Firestore (DB) 사용: 데이터베이스로 Firestore를 사용하여 데이터(메세지, 유저정보) 관리.

## 앱 사진
<img width="394" alt="image" src="https://github.com/f-lab-edu/Syrup/assets/84483515/1e087196-0465-41bf-a4ff-78dde21fd467">


## 진행하면서 배운 것들 (troubleshooting)
- Multi-layer 구조에서의 Data Flow 관리 (단방향 데이터 흐름 (Delegate 패턴), Combine)
- 소셜 로그인: 구글 및 애플 로그인을 통해 소셜 로그인 인증 과정 이해.
- MVVM 디자인 패턴: MVVM 패턴을 통해 
- 팩토리 디자인 패턴: 객체 생성을 보다 유연하게 처리하는 방법을 배웠습니다.
