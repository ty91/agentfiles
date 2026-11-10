# 엔지니어링 스킬 지도

목표는 호출자가 알아야 할 복잡성을 줄이고, 변경의 정당성을 실제 증거로 확인하며, 반복되는 실수를 구조적으로 막는 것입니다. 스킬은 작업 권한을 새로 부여하지 않습니다. 사용자 요청과 저장소 지침이 수정·실행·위임·커밋·게시 범위를 결정합니다.

## 역할과 연결

| 영역 | 담당 | 발동 조건과 완료 기준 |
|---|---|---|
| 실행 | [implement](../skills/engineering/implement/SKILL.md), [implement-issue](../skills/engineering/implement-issue/SKILL.md) | 할당된 구현 작업의 범위·체크포인트·완료를 관리합니다. 설계는 architect, 검증은 verify, 검토는 autoreview에 연결합니다. |
| 설계 | [architect](../skills/engineering/architect/SKILL.md) | 계약·상태·소유권·모듈 책임을 만들거나 변경할 때 사용합니다. 호출 사례에서 구조를 도출하고 서로 다른 후보를 비교해 계약·선택 이유·검증 방법을 확정합니다. |
| 검증 | [verify](../skills/engineering/verify/SKILL.md) | 행동·불변식·경계의 증거를 선택하고 실행합니다. 변경 검증, 회귀 검증, 명시적으로 요청된 test-first 경로를 소유합니다. 검증됨·실패·미검증을 구분합니다. |
| 리뷰 | [autoreview](../skills/engineering/autoreview/SKILL.md), [code-reviewer](../codex/agents/code-reviewer.toml) | 검토자는 읽기 전용으로 결함과 검증 공백을 판단합니다. 부모가 실행·수정·재검증을 소유합니다. 실행 증거가 없다는 이유만으로 코드 결함을 만들어내지 않습니다. |
| 문서 | [documentation](../skills/engineering/documentation/SKILL.md) | 확정된 계약·용어·운영 제약·선택 이유가 지속돼야 할 때 기존 문서를 갱신합니다. 설계 결정은 architect가 소유합니다. |

새로운 최상위 실행 스킬은 두지 않습니다. 설계만 요청되면 설계에서 끝나며, 구현 요청에서는 설계 후 구현과 검증을 계속합니다. 프로젝트 전체 감사나 관계없는 정리는 이 연결의 권한에 포함되지 않습니다.

## 원칙의 단일 소유

원칙은 독립 등록 스킬이 아닌 참조 문서입니다. 소유 스킬이 본문에서 상대 경로로 읽기를 요구합니다. 다른 스킬은 같은 규칙을 복사하지 않고 소유 스킬을 읽습니다.

| 원칙 | 소유 문서 | 적용 지점 |
|---|---|---|
| Model the Domain | [architect/principles/model-the-domain.md](../skills/engineering/architect/principles/model-the-domain.md) | 로직 전 자료구조·유효 상태·불변식·소유자 결정 |
| Boundary Discipline | [architect/principles/boundary-discipline.md](../skills/engineering/architect/principles/boundary-discipline.md) | 외부 입력의 파싱, 도메인 계약, I/O 경계 |
| Minimize Reader Load | [architect/principles/minimize-reader-load.md](../skills/engineering/architect/principles/minimize-reader-load.md) | 후보의 인터페이스 깊이·호출 계층·가변 상태 평가 |
| Subtract Before You Add | [architect/principles/subtract-before-you-add.md](../skills/engineering/architect/principles/subtract-before-you-add.md) | 구현 순서와 기존 경로 제거, 호환성 판단 |
| Test Behavior, Not Implementation | [verify/principles/test-behavior-not-implementation.md](../skills/engineering/verify/principles/test-behavior-not-implementation.md) | 테스트 작성·수정·유지·삭제 판단 |
| Prove It Works | [verify/principles/prove-it-works.md](../skills/engineering/verify/principles/prove-it-works.md) | 실제 산출물 확인과 증거·공백 보고 |

[소프트웨어 공학 원칙](references/software-engineering-principles.md)과 [테스트 원칙](references/software-testing-principles.md)은 배경 참고자료입니다. 실행 시의 규칙과 적용 조건은 위 소유 문서가 정의합니다.

## 규칙의 강도

- **필수 계약:** 관측하지 않은 검증을 통과라고 보고하지 않습니다. 검사를 통과시키려고 약속을 약화하지 않습니다. 설계 워크플로에서는 구조적으로 다른 후보를 최소 두 개 비교합니다.
- **조건부 의무:** 외부 호환성 의존이 없고 조율된 변경이 가능하면 내부 API 교체 때 호출자 이전과 구형 경로 삭제를 함께 수행합니다. 저렴한 로컬 회귀 테스트 경로가 명확하면 수정 전에 실패를 확인합니다.
- **기본 선택과 예외:** 공유 쓰기는 먼저 분리하며 공유가 필수일 때 구조적으로 직렬화합니다. 검증은 위험을 직접 관측하는 가장 좁은 계층에서 시작하되 실제 경계의 고유한 위험은 별도로 확인합니다.

원칙을 언급하는 것으로 적용을 대신하지 않습니다. 어떤 계약·소유권·구조·검증 선택이 달라졌는지 드러내야 합니다. 후보 수는 설계 방법의 요구이며 병렬 에이전트 실행을 요구하지 않습니다. 위임은 별도 권한과 실제 이점이 있을 때 사용합니다.

## 보존하는 구체적 지침

- architect는 [도메인 용어](../skills/engineering/architect/domain-modeling.md), [비동기 완료·복구](../skills/engineering/architect/async-work.md), [호출자 복잡성](../skills/engineering/architect/reducing-caller-complexity.md), [대안 비교](../skills/engineering/architect/comparing-alternatives.md), [UI 구성](../skills/engineering/architect/compound-components.md)을 포함합니다.
- verify는 [테스트 계층과 의존성](../skills/engineering/verify/test-design.md), [실제 브라우저](../skills/engineering/verify/frontend.md), [DB·작업 복구](../skills/engineering/verify/backend.md), [회귀 검증](../skills/engineering/verify/regression.md), [test-first](../skills/engineering/verify/test-first.md)를 포함합니다.
- 읽기 전용 리뷰의 권한과 기존 실행 스킬의 체크포인트·커밋·최종 검증 의무는 유지합니다. 새 스킬이 이를 완화하지 않습니다.

## 호출과 설치

architect와 verify는 Claude Code의 `disable-model-invocation: true`와 Codex의 `policy.allow_implicit_invocation: false`로 자동 호출을 막습니다. 사용자가 스킬을 명시적으로 호출할 수 있으며, 실행 스킬은 필요한 단계에서 두 SKILL.md를 직접 읽습니다.

`implement`와 `implement-issue`의 명시적 호출 정책은 유지합니다. 테스트 주도 개발 요청은 verify의 test-first 경로로 처리하며 별도의 TDD 진입점은 두지 않습니다.

참조 경로는 저장소와 전역 설치의 형제 스킬 디렉터리에서 모두 해석돼야 합니다. 관련 스킬을 함께 설치하고, 파일 이동 시 호출자와 전역 설치를 함께 갱신합니다. 설치·링크·메타데이터 확인은 행동 효과 평가와 구분합니다.

## 확장 영역

아래 항목은 구현된 스킬이 아닙니다. 필요를 확인하기 전에는 빈 스킬이나 호출 경로를 만들지 않습니다.

| 관찰된 필요 | 확장할 역할 |
|---|---|
| 같은 실수를 반복 교정 | correct: 실제 사례를 모아 아키텍처·타입·린트·테스트로 방지하고, 과거 실수에서 검사 실패 확인 |
| 앱 검증 방법을 매번 재탐색 | 프로젝트별 실행·조작·증거 수집 스킬과 기능 지도 |
| 독립 설계 후보 생성이 필요 | arena 방식의 후보 작성·심사·통합 절차 |
| 정적 리뷰 외에 실제 공격 검증 필요 | 별도의 재현 중심 검토 능력. 읽기 전용 code-reviewer의 권한과 분리 |
| 검증 문서나 모델이 코드에서 이탈 | 검증 스킬 유지보수와 형식 모델 동기화 |
| 긴 작업의 판단·실패가 소실 | 증거를 가진 결정 기록과 인계 절차 |

## 적용 범위

pstack의 설계 후보 비교, 설계 결함 점검, 선별한 여섯 원칙, 회귀 검증 절차를 적용합니다. 전체 실행 체계, 고정 모델 배치, 필수 병렬 실행, 자동 병합, 모든 작업에 대한 대규모 검증은 포함하지 않습니다.
