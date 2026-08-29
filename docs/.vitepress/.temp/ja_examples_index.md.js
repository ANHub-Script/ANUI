import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"サンプル","description":"","frontmatter":{},"headers":[],"relativePath":"ja/examples/index.md","filePath":"ja/examples/index.md","lastUpdated":1787760131000}');
const _sfc_main = { name: "ja/examples/index.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="サンプル" tabindex="-1">サンプル <a class="header-anchor" href="#サンプル" aria-label="Permalink to &quot;サンプル&quot;">​</a></h1><p>ANUI のエレメントを組み合わせて実際のメニューを作る、そのままコピーして使えるレシピ集。それぞれエグゼキュータに貼り付けてすぐ動かせる、独立したスクリプトです。</p><h2 id="レシピ" tabindex="-1">レシピ <a class="header-anchor" href="#レシピ" aria-label="Permalink to &quot;レシピ&quot;">​</a></h2><ul><li><strong><a href="/ANUI/ja/examples/basic-menu">基本メニュー</a></strong> —— 出発点となるメニュー。ウィンドウ、いくつかのタブ、よく使うエレメント（Toggle、Slider、Dropdown、Button、Keybind、Paragraph）の組み合わせと通知。</li><li><strong><a href="/ANUI/ja/examples/config-system">設定システム</a></strong> —— Flag 付きエレメントでユーザー設定を保存・読み込みし、ディスクから一覧を作る設定ピッカーと自動読み込みの Toggle を用意します。</li><li><strong><a href="/ANUI/ja/examples/category-pages">カテゴリーページ</a></strong> —— <a href="/ANUI/ja/elements/category">Category</a> エレメントで、1 つのタブの中に表示 / 非表示式の「ページ」を作ります。</li></ul><div class="tip custom-block"><p class="custom-block-title">完全なデモスクリプト</p><p>これらのレシピは分かりやすさのために削ぎ落としてあります。すべてのエレメントと機能を組み込んだ公式の完全なデモは、リポジトリの <code>main_example.lua</code> として <a href="https://github.com/ANHub-Script/ANUI" target="_blank" rel="noreferrer">GitHub</a> にあります。</p></div></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("ja/examples/index.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const index = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  index as default
};
