# MC2-Team17-PaPaJOYs
<aside>
💡 [Name] Prefix: Summary

</aside>

- Name, Prefix는 영문으로
    - 시작은 대문자
- Summary는 한영 혼합
    - 끝에 `.` 금지
    - 파일/뷰 단위로
    - 무엇을 했는지 위주로

## Prefix

---

1. `Feat:` - 코드 수정
    1. 요약 중요
    2. import(외부 라이브러리) 사용 경우 → body 작성
2. `Fix:` - 오류 수정
3. `Remove:` - 파일 삭제
4. `Rename:` - 이름 변경
5. `Move:` - (파일 기준) 폴더 이동
6. `Docs:` - README 등 Xcode 파일 외 문서 파일 관련
7. `Style:` - (실제 코드 변화는 X) 개행 등 코드 포맷 변경
8. `Revert:` - 깃 revert 사용
9. `Merge:` - 브랜치 merge, merge를 통해 발생한 conflict 해결
10. `Cleanup:` - 불필요한 코드, 코멘트, 파일 삭제
11. `Build:` - build와 관련된 행위

예시

<aside>
💡 - 코드 추가/제거
[Joy] Feat: ContentView 수정

- Kit 호출 후 코드 추가/제거 (호출 최초 1회만)
[Joy] Feat: ContentView 수정 
import SpriteKit

</aside>

```bash
git commit -m "[Joy] Feat: ContentView 수정
- import Spritekit"
```

```bash
git commit -m "[Joy] Feat: ContentView 수정
- import Spritekit
- import CloudKit"
```