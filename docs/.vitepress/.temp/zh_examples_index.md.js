import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"示例","description":"","frontmatter":{},"headers":[],"relativePath":"zh/examples/index.md","filePath":"zh/examples/index.md","lastUpdated":1787659850000}');
const _sfc_main = { name: "zh/examples/index.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="示例" tabindex="-1">示例 <a class="header-anchor" href="#示例" aria-label="Permalink to &quot;示例&quot;">​</a></h1><p>可直接复制粘贴的完整实用方案，把 ANUI 元素组合成真实可用的菜单。每一个都是独立的脚本，可以直接丢进执行器里运行。</p><h2 id="实用方案" tabindex="-1">实用方案 <a class="header-anchor" href="#实用方案" aria-label="Permalink to &quot;实用方案&quot;">​</a></h2><ul><li><strong><a href="/ANUI/zh/examples/basic-menu">基础菜单</a></strong> —— 一个入门菜单：一个窗口、几个标签页，以及常见元素的组合（Toggle、Slider、Dropdown、Button、Keybind、Paragraph），外加一条通知。</li><li><strong><a href="/ANUI/zh/examples/config-system">配置系统</a></strong> —— 用带 Flag 的元素保存并加载用户设置，从磁盘填充配置选择器，还有一个自动加载开关。</li><li><strong><a href="/ANUI/zh/examples/category-pages">分类页面</a></strong> —— 用 <a href="/ANUI/zh/elements/category">Category</a> 元素在单个标签页内构建可显示/隐藏的&quot;页面&quot;。</li></ul><div class="tip custom-block"><p class="custom-block-title">完整演示脚本</p><p>这些实用方案为了简洁做了精简。完整的官方演示 —— 每个元素与功能都完整接好 —— 位于仓库中的 <code>main_example.lua</code>，见 <a href="https://github.com/ANHub-Script/ANUI" target="_blank" rel="noreferrer">GitHub</a>。</p></div></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("zh/examples/index.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const index = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  index as default
};
