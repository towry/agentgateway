# agentgateway Patch Set

此目录持 `solo-io/agentgateway` 之私有补丁与部署辅助，模式仿 `../litellm/`。

## 布局

- `./` — 本目录 checkout 于 `deploy` 分支（patch-only），仅存 `AGENTS.md`、`patches/`、`scripts/`
- `./agentgateway-main/` — git worktree 跟 `main` 分支（gitignored）；改源码处
- `./patches/` — 部署用之补丁文件 + `series`
- `./scripts/apply.sh` — 通用 patch 施加脚本（与 `../litellm/scripts/apply.sh` 同款）

## remotes

- `origin`：`git@github.com:towry/agentgateway.git`（自有 fork，`deploy` 分支独存于此）
- `upstream`：`git@github.com:agentgateway/agentgateway.git`

## workflow

### 1. 同步 upstream

```bash
cd agentgateway-main
git fetch upstream main
git merge --ff-only upstream/main      # 仅快进，避免与 fork main 偏离
git push origin main                   # 同步到 fork
```

### 2. 改源码

```bash
cd agentgateway-main
# 直接改 ui/src/lib/api.ts 等文件，不必 commit
# 改动保留为 working tree dirty 即可
```

### 3. 生成 patch

```bash
cd agentgateway-main
git diff -- ui/src/lib/api.ts > ../patches/000X-<desc>.patch
echo "000X-<desc>.patch" >> ../patches/series
```

### 4. 校验 patch 可干净 apply

```bash
cd /Users/towry/.dotfiles/agentgateway
./scripts/apply.sh --repo-root /tmp/agentgateway-verify --patches-dir ./patches
```

或经 `nix build` 走 Nix 之 `applyPatches`，让其自校。

### 5. push deploy 分支

```bash
git push origin deploy
```

`deploy` 分支独立演进，永不 merge 入 `main`。

## 规约

- 每枚 patch 只做一事，便于冲突定位与回滚
- patch 命名 `NNNN-<kebab-desc>.patch`，`series` 中按施加序排
- 勿纳本地 agent 之记事、提示、未完之笔记于 `patches/`
- 改 `main` 之私有改动若上游可纳，先开 PR 上游；上游合后此处 patch 删
- Nix 构建（`nix/hm/agentgateway/`）经 `fetchFromGitHub` 拉 `towry/agentgateway` 之 main HEAD（或固定 commit），并 `applyPatches` 此处 `patches/` 之串
