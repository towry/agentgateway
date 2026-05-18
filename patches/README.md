# agentgateway Patch Set

部署所需、相对 `main` 施加之私有补丁。

## Files

- `series`：patch 施行顺序
- `0001-ui-fallback-binds-to-configdump.patch`：UI 在 `/config` 无 `binds[]` 时（顶层 `llm:` 形）回落至 `/config_dump` + mapper，使 UI 可正确 render 高级 LLM 配置

## Rules

- 勿纳本地 agent 之记事、提示、未完之笔记
- 每枚 patch 只做一事，便于冲突定位与回滚

## Regenerate

在 `agentgateway-main/` 完成改动后：

```bash
cd agentgateway-main
git diff -- <relative-paths...> > ../patches/NNNN-<desc>.patch
```

并按需更新 `series`。
