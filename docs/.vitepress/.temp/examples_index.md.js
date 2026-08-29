import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Examples","description":"","frontmatter":{},"headers":[],"relativePath":"examples/index.md","filePath":"examples/index.md","lastUpdated":1787644471000}');
const _sfc_main = { name: "examples/index.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="examples" tabindex="-1">Examples <a class="header-anchor" href="#examples" aria-label="Permalink to &quot;Examples&quot;">​</a></h1><p>Complete, copy-paste recipes that combine ANUI elements into real menus. Each one is a self-contained script you can drop into your executor and run.</p><h2 id="recipes" tabindex="-1">Recipes <a class="header-anchor" href="#recipes" aria-label="Permalink to &quot;Recipes&quot;">​</a></h2><ul><li><strong><a href="/ANUI/examples/basic-menu">Basic Menu</a></strong> — A starter menu: a window, a couple of tabs, and a mix of common elements (Toggle, Slider, Dropdown, Button, Keybind, Paragraph) with a notification.</li><li><strong><a href="/ANUI/examples/config-system">Config System</a></strong> — Save and load user settings with flagged elements, a config picker populated from disk, and an auto-load toggle.</li><li><strong><a href="/ANUI/examples/category-pages">Category Pages</a></strong> — Build show/hide &quot;pages&quot; inside a single tab with the <a href="/ANUI/elements/category">Category</a> element.</li></ul><div class="tip custom-block"><p class="custom-block-title">Full demo script</p><p>These recipes are trimmed for clarity. The complete, official demo — every element and feature wired up — lives in the repository as <code>main_example.lua</code> on <a href="https://github.com/ANHub-Script/ANUI" target="_blank" rel="noreferrer">GitHub</a>.</p></div></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("examples/index.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const index = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  index as default
};
