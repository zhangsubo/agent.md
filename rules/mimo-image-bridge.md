# MIMO Image Bridge

仅在当前使用的主模型是 `xiaomi/mimo-2.5-pro`，且用户请求包含图片、截图、界面图、图表或任何需要视觉理解的内容时读取并执行本规则。

## Rule

- 必须先调用 MCP 工具 `mimo-image-bridge.analyze_image_with_mimo`。
- 该工具会把图片转发给 `xiaomi/mimo-2.5` 解析。
- 拿到解析文本后，再由 `xiaomi/mimo-2.5-pro` 继续完成用户任务。
- 不要让 `xiaomi/mimo-2.5-pro` 直接猜测图片内容。
- 如果工具返回错误，先向用户说明可能原因，例如缺少 API Key、图片路径不可读或上游模型返回失败。
