import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Примеры","description":"","frontmatter":{},"headers":[],"relativePath":"ru/examples/index.md","filePath":"ru/examples/index.md","lastUpdated":1787651014000}');
const _sfc_main = { name: "ru/examples/index.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="примеры" tabindex="-1">Примеры <a class="header-anchor" href="#примеры" aria-label="Permalink to &quot;Примеры&quot;">​</a></h1><p>Готовые рецепты, которые можно вставить как есть: они собирают элементы ANUI в настоящие меню. Каждый из них — самостоятельный скрипт, который можно закинуть в свой исполнитель и запустить.</p><h2 id="рецепты" tabindex="-1">Рецепты <a class="header-anchor" href="#рецепты" aria-label="Permalink to &quot;Рецепты&quot;">​</a></h2><ul><li><strong><a href="/ANUI/ru/examples/basic-menu">Базовое меню</a></strong> — стартовое меню: окно, пара вкладок и набор часто используемых элементов (Toggle, Slider, Dropdown, Button, Keybind, Paragraph) плюс уведомление.</li><li><strong><a href="/ANUI/ru/examples/config-system">Система конфигурации</a></strong> — сохраняйте и загружайте настройки пользователя через элементы с флагами, выбор конфигурации из списка на диске и toggle авто-загрузки.</li><li><strong><a href="/ANUI/ru/examples/category-pages">Страницы категорий</a></strong> — соберите «страницы» с показом/скрытием внутри одной вкладки с помощью элемента <a href="/ANUI/ru/elements/category">Category</a>.</li></ul><div class="tip custom-block"><p class="custom-block-title">Полный демо-скрипт</p><p>Эти рецепты урезаны для наглядности. Полная официальная демонстрация — со всеми элементами и возможностями — лежит в репозитории как <code>main_example.lua</code> на <a href="https://github.com/ANHub-Script/ANUI" target="_blank" rel="noreferrer">GitHub</a>.</p></div></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("ru/examples/index.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const index = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  index as default
};
