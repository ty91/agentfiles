---
name: pr
description: Create a GitHub pull request for the current branch.
allowed-tools: Bash(git:*), Bash(gh:*), AskUserQuestion
---

## Context

- Current branch: !`git branch --show-current`
- Default branch: !`gh repo view --json defaultBranchRef --jq '.defaultBranchRef.name' 2>/dev/null || echo "main"`
- Commits on this branch: !`git log --oneline main..HEAD 2>/dev/null || echo "Could not determine commits"`
- Diff summary: !`git diff --stat main...HEAD 2>/dev/null || echo "Could not determine diff"`
- Remote tracking: !`git rev-parse --abbrev-ref @{upstream} 2>/dev/null || echo "No upstream set"`

## Your task

Create a GitHub pull request for the current branch.

### 1. Validate

- If the current branch is `main` or `master`, ask the user how to proceed: create a new branch or abort. Do NOT create a PR from main to main.
- If there are no commits ahead of the base branch, inform the user and stop.

### 2. Push

- If the branch has no upstream (`No upstream set`), push it with `git push -u origin HEAD`.
- If the branch is behind the remote, push first.

### 3. Create PR

- Create a pull request using `gh pr create` with `--assignee @me`.
- Use the following PR template. Fill in the relevant sections based on the commits and diff:

```markdown
## 📋 Summary
<!-- 이 PR이 무엇을 하는지 간단히 설명해주세요 -->


## 🔗 Related Issue
<!-- 관련 이슈 링크 (예: Fixes #123, Closes #456) -->


## 🔄 Type of Change
- [ ] 🐛 Bug fix
- [ ] ✨ New feature
- [ ] 💥 Breaking change
- [ ] 📝 Documentation update
- [ ] ♻️ Refactoring
- [ ] 🧪 Test update

## 📝 Changes
<!-- 주요 변경 사항을 나열해주세요 -->
-
-

## 🧪 How to Test
<!-- 테스트 방법을 설명해주세요 -->
1.
2.

## ✅ Checklist
- [ ] 코드가 프로젝트 스타일 가이드를 따름
- [ ] Self-review 완료
- [ ] 필요한 문서 업데이트 완료
- [ ] 테스트 추가/수정 완료
- [ ] 로컬에서 테스트 통과 확인
```

### 4. Done

- Return the PR URL to the user.
